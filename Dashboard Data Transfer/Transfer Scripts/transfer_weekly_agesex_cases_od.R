#### create populations by age group ######

# enter latest population year
pop_year= 2021# use to filter through entire script, only need to update 1 line when Pop Est files updated

gpd_base_path<-"/conf/linkage/output/lookups/Unicode/"

# update when Pop Estimates updated
base_hb_population <- readRDS(glue(gpd_base_path,"Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_2021.rds"))%>% 
  mutate(sex=if_else(sex_name=="F", "Female", "Male"))


pop_agegroup_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" ~ "0 to 14",
                              age_group_name == "15-19" ~ "15 to 19",
                              age_group_name == "20-24" ~ "20 to 24",
                              age_group_name == "25-29" | age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" ~ "25 to 44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45 to 64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65 to 74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75 to 84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex, agegroup) %>% 
  summarise(pop = sum(pop))

pop_agegroup_total<-pop_agegroup_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop = sum(pop)) %>% 
  mutate(sex="Total")

pop_60plus_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                                age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                                age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                                age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex, agegroup) %>% 
  summarise(pop = sum(pop))

#group without sex to obtain total pop 0-60 and plus 60 
pop_60plus_total<-pop_60plus_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop = sum(pop))  %>% 
  mutate(sex="Total")

# Total population of Scotland by sex
pop_total_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(location_code = "Scotland", 
         agegroup="Total")%>% 
  group_by(location_code,sex) %>% 
  summarise(pop = sum(pop)) %>% 
  mutate(agegroup="Total")

# Total population of Scotland combined sex
pop_total_total<- pop_total_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop=sum(pop)) %>% 
  mutate(sex="Total")

##### wrangle input data for age and sex  #####
# open data dates to read in combined file
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1
i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )
# development version if cases has not run
#i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_2023-08-22.rds") )



g_cases_raw<- i_combined_pcr_lfd_tests %>% 
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex)) %>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))  %>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source)) %>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar)) %>% 
  select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date,
         test_result, Sex, age, date_reporting, date_test_received_at_bi,
         test_result_record_source, laboratory_code, pillar, flag_covid_case,
         derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type) %>% 
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0))%>%
  #filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday)) 

##### Create  cases by age groups ##############################
g_cases_age_sex_all <- g_cases_raw %>%
  group_by(Date, age, Sex)%>%
  summarise(daily_positive = sum(flag_episode)) %>%
  ungroup()%>%
  mutate(agegroup = case_when(is.na(age) ~ "Unknown",
                              age >= 0 & age < 15 ~ '0 to 14',
                              age > 14 & age < 45 ~ '15 to 44',
                              age > 44 & age < 65 ~ '45 to 64',
                              age > 64 & age < 75 ~ '65 to 74',
                              age > 74 & age < 85 ~ '75 to 84',
                              age > 84 ~ '85+',
                              TRUE ~ "Unknown"),
         agegroup_scotland = case_when(is.na(age) ~ "Unknown",
                                       age >= 0 & age < 15 ~ '0 to 14',
                                       age > 14 & age < 20 ~ '15 to 19',
                                       age > 19 & age < 25 ~ '20 to 24',
                                       age > 24 & age < 45 ~ '25 to 44',
                                       age > 44 & age < 65 ~ '45 to 64',
                                       age > 64 & age < 75 ~ '65 to 74',
                                       age > 74 & age < 85 ~ '75 to 84',
                                       age > 84 ~ '85+',
                                       TRUE ~ "Unknown"),
         agegroup_scotland_60plus = case_when(is.na(age) ~ "Unknown",
                                              age >= 0 & age < 60 ~ '0 to 59',
                                              age > 59 ~ '60+',
                                              TRUE ~ "Unknown"),
         sex=case_when(is.na(Sex)~"Unknown", Sex=="NotSpecified"~"Unknown",
                       Sex=="Unknown"~"Unknown",
                       Sex=="U"~"Unknown", Sex=="FEMALE"~"Female",
                       Sex=="MALE"~"Male",TRUE ~ Sex)) %>% 
  ungroup()


unknown_age_check<-g_cases_age_sex_all %>% 
  filter(agegroup=='Unknown') %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() 

unknown_sex_check<-g_cases_age_sex_all %>% 
  filter(sex=='Unknown') %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() 

unknown_agesex_check <-g_cases_age_sex_all %>% 
  filter(agegroup=='Unknown'| sex=='Unknown')%>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() 

# g_known_age_sex <-g_cases_age_sex_all %>%
# filter( agegroup!='Unknown', sex!='Unknown')
  
#remove checks
rm(unknown_age_check, unknown_agesex_check, unknown_sex_check)
# remove large input and process files
rm(g_cases_raw, i_combined_pcr_lfd_tests)

##### Cumulative cases by age and sexs############################
# create intermediate cumulative age/sex profiles 

# 1 cumulative by age and sex using age_group_scotland grouping
g_agegroup_sex_cumulative<-g_cases_age_sex_all  %>% 
  group_by(agegroup_scotland, sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() %>% 
  rename(agegroup=agegroup_scotland) %>% 
  arrange(agegroup, sex) %>% 
    left_join(pop_agegroup_sex, by=(c("agegroup", "sex")))%>% 
  mutate(location_code=("Scotland")) 

#  2 cumulative by age and COMBINED SEX using age_group_scotland grouping
g_agegroup_cumulative<-g_agegroup_sex_cumulative  %>% 
  group_by(agegroup) %>% 
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>% 
  #rename(agegroup=agegroup_scotland) %>%
  mutate(sex="Total")%>% 
  left_join(pop_agegroup_total, by=(c("agegroup", "sex")))

#1 & 2  combine age groups together
g_agegroup_cumulative_combined <-bind_rows(g_agegroup_sex_cumulative,
                                           g_agegroup_cumulative)

#  3 cumulative by age and sex using age_group_scotland_60plus grouping
g_60plus_sex_cumulative<-g_cases_age_sex_all %>% 
  group_by(agegroup_scotland_60plus, sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() %>% 
 filter(agegroup_scotland_60plus!="Unknown") %>% #remove unknown age_group to avoid double count as these are captured in section 1
 rename(agegroup=agegroup_scotland_60plus) %>% 
 arrange(agegroup, sex)   %>% 
 left_join(pop_60plus_sex, by=(c("agegroup", "sex"))) 

#  4 cumulative by age and COMBINED SEX using age_group_scotland_60plus grouping
g_60plus_cumulative<-g_60plus_sex_cumulative  %>% 
  group_by(agegroup) %>%
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>% 
  mutate(sex="Total")%>% 
  left_join(pop_60plus_total, by=(c("agegroup", "sex")))

# 3 & 4 combine age groups together
g_60_plus_cumulative_combined <-bind_rows(g_60plus_sex_cumulative,
                                          g_60plus_cumulative)

# 5 cumulative total cases by combined age, both sexes
g_total_age_sex_cumulative<-g_cases_age_sex_all %>% 
  group_by(sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup %>% 
  mutate(agegroup="Total")%>% 
  arrange(agegroup, sex)   %>% 
  left_join(pop_total_sex, by=(c("agegroup", "sex")))%>% 
  mutate(location_code=("Scotland")) 

# 6 cumulative total cases by combined age, combined sexes
g_total_cumulative<-g_total_age_sex_cumulative  %>%
   group_by(location_code) %>%
  summarise(TotalPositive=sum(TotalPositive)) %>%
   ungroup() %>%
   mutate(agegroup="Total",
          sex="Total") %>% 
   left_join(pop_total_total, by=(c("agegroup", "sex", "location_code")))

#combine all cumulative by age-group and sex combinations and format for open data
g_age_sex_cumulative_od <- bind_rows(g_agegroup_cumulative_combined,
                                     g_60_plus_cumulative_combined,
                                     g_total_age_sex_cumulative,
                                     g_total_cumulative) %>%
    rename(Sex = sex, AgeGroup = agegroup) %>%
    mutate(
    CrudeRatePositiveCases = round_half_up((TotalPositive / pop) * 100000),#  round to 0 d.p.
    Date = format(strptime(od_sunday, format = "%Y-%m-%d"), "%Y%m%d"),
    Country = "S92000003",
    SexQF = if_else(Sex == "Total"| Sex=="Unknown", "d", ""),
    AgeGroupQF = if_else(AgeGroup == "Total"| AgeGroup=="Unknown", "d", "")  ,
    CrudeRatePositiveCasesQF= if_else(is.na(CrudeRatePositiveCases),":", "d"), 
    AgeGroup = recode(AgeGroup, "60+" = "60plus"),
    AgeGroup = recode(AgeGroup, "85+" = "85plus")  ) %>%
    select(Date, Country, Sex, SexQF,
          AgeGroup,AgeGroupQF,
          CumulativePositiveCases=TotalPositive,
          CrudeRatePositiveCases,CrudeRatePositiveCasesQF)
    
# checks#
# The sum of  all cases in Table 1 (male/female/unknown sex )= total cases (table 6)
# Table 2 all cases = total cases (table 6)
# Table 4 60plus cases and cases from unknown age_check (df) = total cases (table 6)

# cumulative output
write_csv(g_age_sex_cumulative_od, glue("{output_folder}TEMP_age_sex_cumulative_v2.csv"), na = "")

#remove intermediate cumulative dataframes   
rm(g_agegroup_sex_cumulative, g_agegroup_cumulative, g_agegroup_cumulative_combined, #1, #2, #1&#2 combined
   g_60plus_sex_cumulative, g_60_plus_cumulative_combined,g_60plus_cumulative, #3, #4, #3&#4 combined
     g_total_age_sex_cumulative, g_total_cumulative ) #5 #6
   
# remove pop_lookups,
rm(base_hb_population, pop_60plus_sex, pop_60plus_total,
   pop_agegroup_sex,pop_agegroup_total,
   pop_total_sex, pop_total_total)

##### Weekly cases by age and sex  #########################################################
#rinse and repeat but add weekly date split & remove pop elements for weekly equivalent
# create age, sex, weekending  data frame template 
# needed to ensure no blank lines no cases for particular age sex week

Dates <- data.frame(SpecimenDate=seq(as.Date("2020-02-23"), as.Date(od_date-1), "week"))
#Dates <- data.frame(SpecimenDate=seq(as.Date("2020-02-23"), as.Date("2023-08-20"), "week")) #  for development use when cases haven't been run
# frame work to match age aggregations as close as possible
Agegroups<- data.frame(agegroup = c('0 to 14','15 to 19','20 to 24','25 to 44',
                                    '45 to 64','65 to 74','75 to 84','85+','Unknown','0 to 59','60+','Total'))%>%
  mutate(agegroup=as.character(agegroup))
Sex <- data.frame(sex = c('Female','Male', 'Unknown','Total')) %>% 
  mutate(sex=as.character(sex))

df_agesex <- expand.grid(week_ending=unique(Dates$SpecimenDate), location_code="Scotland",
                         agegroup=unique(Agegroups$agegroup),
                         sex=unique(Sex$sex), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>% 
  arrange(week_ending)  #this will influence how the final output will look, set in chronological order earliest to latest

rm(Dates,Agegroups, Sex) #remove building blocks
# 
# cases on a weekly basis
g_cases_age_data_weekly<-g_cases_age_sex_all %>%
  #filter(Date>as.Date("2020-02-27") & Date<as.Date("2023-08-20")) %>% #  for development use when cases haven't been run
  filter(Date>as.Date("2020-02-27") & Date<as.Date(od_date-1)) %>%
  group_by(Date) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  ungroup()

# create intermediate weekly age/sex profiles 
# 1 Weekly by age and sex using age_group_scotland grouping
   g_agegroup_sex_weekly<- g_cases_age_data_weekly %>%  #g_age_sex_cases_weekly #_df   %>% 
     group_by(week_ending,agegroup_scotland, sex) %>% 
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
     ungroup() %>% 
     #arrange(desc(week_ending), agegroup, sex) #%>% 
     rename(agegroup=agegroup_scotland) 
     
#  2 Weekly by age and COMBINED SEX using age_group_scotland grouping
   g_agegroup_weekly <- g_agegroup_sex_weekly %>%  #
     group_by(week_ending, agegroup) %>% 
     summarise(PositiveLastSevenDays=sum(PositiveLastSevenDays)) %>% 
     ungroup() %>% 
     #arrange(desc(week_ending), agegroup) %>% 
     mutate(sex="Total")
   
#1 & 2  combine age groups together
   g_agegroup_weekly_combined <-bind_rows(g_agegroup_sex_weekly, g_agegroup_weekly)
   
#  3 cumulative by age and sex using age_group_scotland_60plus grouping
   g_60plus_sex_weekly<- g_cases_age_data_weekly %>% 
     group_by(week_ending, agegroup_scotland_60plus, sex) %>% 
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
     ungroup() %>% 
     filter(agegroup_scotland_60plus!="Unknown") %>% #remove unknown age_group to avoid double count as these are captured in section 1
     #arrange(desc(week_ending), agegroup, sex) %>% 
     rename(agegroup=agegroup_scotland_60plus) 

#  4 cumulative by age and COMBINED SEX using age_group_scotland_60plus grouping
   g_60plus_weekly<-g_60plus_sex_weekly %>%  
     group_by(week_ending, agegroup) %>%
     summarise(PositiveLastSevenDays=sum(PositiveLastSevenDays)) %>% 
     ungroup() %>% 
    # arrange(desc(week_ending), agegroup) %>% 
     mutate(sex="Total")
 
# 3 & 4 combine age groups together
   g_60_plus_weekly_combined <-bind_rows(g_60plus_sex_weekly, g_60plus_weekly)
   
# 5 cumulative total cases by combined age, both sexes
   g_total_age_sex_weekly<- g_cases_age_data_weekly %>%
     group_by(week_ending, sex) %>% 
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
     ungroup %>% 
   #  arrange(desc(week_ending), sex)%>% 
     mutate(agegroup="Total")
     
# 6 cumulative total cases by combined age, combined sexes
   g_total_weekly<- g_cases_age_data_weekly %>%  
     group_by(week_ending) %>%
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>%
     ungroup() %>%  
  #   arrange(desc(week_ending), sex) %>% 
     mutate(agegroup="Total", sex="Total")
    
# combine weekly age group and sex combinations together  
   g_weekly_combined<-bind_rows(g_agegroup_weekly_combined,  
                                g_60_plus_weekly_combined,
                                g_total_age_sex_weekly,  
                                g_total_weekly)

# join to age/sex df so have missing agesex rows in final output
   # then reformat for open data
   g_age_sex_weekly_od<-df_agesex %>% 
     left_join(g_weekly_combined, by =c("week_ending","agegroup","sex"), multiple="all")  %>% 
    mutate(PositiveLastSevenDays=if_else(is.na(PositiveLastSevenDays),0,PositiveLastSevenDays)) %>% 
    group_by(agegroup, sex) %>% 
    mutate(CumulativePositiveCases=(cumsum(PositiveLastSevenDays) ) ) %>% 
    ungroup() %>% 
    mutate(Date = format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d"),
       Country = "S92000003",
       SexQF = if_else(sex == "Total"| sex=="Unknown", "d", ""),
       AgeGroupQF = if_else(agegroup == "Total"| agegroup=="Unknown", "d", "")  ,
       agegroup = recode(agegroup, "60+" = "60plus"),
       agegroup = recode(agegroup, "85+" = "85plus") ) %>% 
    select(Date, Country, Sex=sex, SexQF, AgeGroup=agegroup, AgeGroupQF,
           WeeklyPositiveCases= PositiveLastSevenDays, 
           CumulativePositiveCases)  

# Output# 
write_csv(g_age_sex_weekly_od, glue("{output_folder}TEMP_age_sex_weekly_v2.csv"), na = "")

# remove intermediate files
rm(g_agegroup_sex_weekly, g_agegroup_weekly, g_agegroup_weekly_combined, #1, #2, #1 and #2 combined
      g_60plus_sex_weekly, g_60plus_weekly,g_60_plus_weekly_combined, #3, #4, #3 and 4 combined
      g_total_age_sex_weekly, g_total_weekly,#5 #6#
      df_agesex, g_weekly_combined, #the combined output prior to joining to df_agesex #
      g_cases_age_sex_all, g_cases_age_data_weekly ) # large intermediate dataframes
      
##### end ####