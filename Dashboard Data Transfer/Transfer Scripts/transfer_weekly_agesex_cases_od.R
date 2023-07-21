# Open data transfer for Geography
# Sourced from ../dashboard_data_transfer.R



#open data date to read in combined file
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1


##### create populations by age group #############################################

# enter latest population year
 # use to filter through entire script, only need to update 1 line when Pop ESt files updated

pop_year= 2021

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



##### create cases outputs ###################

i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )

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
         flag_episode = ifelse(episode_number_deduplicated>0,1,0),
         # flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
         # flag_reinfection = ifelse(episode_number_deduplicated>1,1,0)
         )%>%
  #filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday))


##### Create  cases by age groups ##############################
g_cases_age_data <- g_cases_raw %>%
  group_by(Date, age, Sex)%>% 
  summarise(daily_positive = sum(flag_episode)) %>% 
  ungroup()%>% 
  mutate(agegroup = case_when(is.na(age) ~ "unknown",
                              age >= 0 & age < 15 ~ '0 to 14',
                              age > 14 & age < 45 ~ '15 to 44',
                              age > 44 & age < 65 ~ '45 to 64',
                              age > 64 & age < 75 ~ '65 to 74',
                              age > 74 & age < 85 ~ '75 to 84',
                              age > 84 ~ '85+',
                              TRUE ~ "unknown"),
         agegroup_scotland = case_when(is.na(age) ~ "unknown",
                                       age >= 0 & age < 15 ~ '0 to 14',
                                       age > 14 & age < 20 ~ '15 to 19',
                                       age > 19 & age < 25 ~ '20 to 24',
                                       age > 24 & age < 45 ~ '25 to 44',
                                       age > 44 & age < 65 ~ '45 to 64',
                                       age > 64 & age < 75 ~ '65 to 74',
                                       age > 74 & age < 85 ~ '75 to 84',
                                       age > 84 ~ '85+',
                                       TRUE ~ "unknown"),
         agegroup_scotland_60plus = case_when(is.na(age) ~ "unknown",
                                              age >= 0 & age < 60 ~ '0 to 59',
                                              age > 59 ~ '60+',
                                              TRUE ~ "unknown"),
         sex=case_when(is.na(Sex)~"unknown", Sex=="NotSpecified"~"unknown",
                       Sex=="Unknown"~"unknown",
                       Sex=="U"~"unknown", Sex=="FEMALE"~"Female",
                       Sex=="MALE"~"Male",TRUE ~ Sex)) %>% 
  filter(agegroup!='NA', agegroup!='unknown', sex!='NA', sex!='unknown') 
  

##############Cumulatives############################

# 1 cumulative by age and sex using age_group_scotland grouping
g_agegroup_sex_cases_cumulative<-g_cases_age_data  %>% 
  group_by(agegroup_scotland, sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() %>% 
  rename(agegroup=agegroup_scotland) %>% 
  left_join(pop_agegroup_sex, by=(c("agegroup", "sex")))

#  2 cumulative by age and COMBINED SEX using age_group_scotland grouping
g_agegroup_cases_cumulative<-g_agegroup_sex_cases_cumulative  %>% 
  group_by(agegroup) %>% 
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>% 
  #rename(agegroup=agegroup_scotland) %>%
  mutate(sex="Total")%>% 
  left_join(pop_agegroup_total, by=(c("agegroup", "sex")))

#  3 cumulative by age and sex using age_group_scotland_60plus grouping
g_agegroup_60plus_sex_cases_cumulative<-g_cases_age_data  %>% 
  group_by(agegroup_scotland_60plus, sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() %>% 
  rename(agegroup=agegroup_scotland_60plus) %>% 
  left_join(pop_60plus_sex, by=(c("agegroup", "sex")))

#  4 cumulative by age and COMBINED SEX using age_group_scotland_60plus grouping
g_agegroup_60plus_cases_cumulative<-g_agegroup_60plus_sex_cases_cumulative  %>% 
  group_by(agegroup) %>%
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>% 
  #rename(agegroup=agegroup_scotland_60plus) %>%
  mutate(sex="Total")%>% 
  left_join(pop_60plus_total, by=(c("agegroup", "sex")))

# 5 cumulative total cases by combined age, both sexes
g_total_age_sex_cases_cumulative<-g_cases_age_data %>% 
  group_by(sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup %>% 
  mutate(agegroup="Total") %>% 
  left_join(pop_total_sex, by=(c("agegroup", "sex")))

# 6 cumulative total cases by combined age, combined sexes
g_total_age_total_sex_cases_cumulative<-g_total_age_sex_cases_cumulative  %>%
   group_by(location_code) %>%
  summarise(TotalPositive=sum(TotalPositive)) %>%
   ungroup() %>%
   mutate(agegroup="Total",
          sex="Total") %>% 
   left_join(pop_total_total, by=(c("agegroup", "sex", "location_code")))

#combine all cumulative by aga-group and sex combinations and format for open data
g_age_sex_cases_cummulative_od<-bind_rows(g_agegroup_sex_cases_cumulative, g_agegroup_cases_cumulative,
                               g_agegroup_60plus_sex_cases_cumulative, g_agegroup_60plus_cases_cumulative,
                               g_total_age_sex_cases_cumulative,g_total_age_total_sex_cases_cumulative) %>% 
  rename(Sex=sex,
         AgeGroup=agegroup) %>% 
  mutate(CrudeRatePositive=round_half_up((TotalPositive/pop)*100000),#  round to 0 d.p.
         Date= format(strptime(od_sunday, format = "%Y-%m-%d"), "%Y%m%d"),
         Country="S92000003",
         SexQF= if_else(Sex=="Total","d", ""),
         AgeGroupQF=if_else(SexQF=="d","d","") ) %>% 
 arrange(Sex, AgeGroup)%>% 
  mutate(AgeGroup = recode(AgeGroup, "60+" = "60plus"),
         AgeGroup = recode(AgeGroup, "85+" = "85plus"))%>% 
 select(Date, Country, Sex, SexQF, AgeGroup,AgeGroupQF,
        TotalPositive, CrudeRatePositive) 

write_csv(g_age_sex_cases_cummulative_od, glue("{output_folder}TEMP_age_sex_cummulative.csv"), na = "")

rm(g_agegroup_sex_cases_cumulative, g_agegroup_cases_cumulative,
   g_agegroup_60plus_sex_cases_cumulative, g_agegroup_60plus_cases_cumulative,
   g_total_age_sex_cases_cumulative,g_total_age_total_sex_cases_cumulative)

# remove pop_lookups
rm(base_hb_population, pop_60plus_sex, pop_60plus_total,
   pop_agegroup_sex,pop_agegroup_total,
   pop_total_sex, pop_total_total) 


###### weekly cases by age and sex #########################################################

# create age, sex, weekending  data frame template 
# needed to ensure no blank lines no cases for particular age sex week
Dates <- data.frame(SpecimenDate=seq(as.Date("2020-02-23"), as.Date(od_date-1), "week"))

Agegroups<- data.frame(agegroup = c('0 to 14','15 to 19','20 to 24','25 to 44',
                                    '45 to 64','65 to 74','75 to 84','85+','0 to 59','60+','Total'))%>%
  mutate(agegroup=as.character(agegroup))
Sex <- data.frame(sex = c('Female','Male','Total')) %>% 
  mutate(sex=as.character(sex))


df_agesex <- expand.grid(week_ending=unique(Dates$SpecimenDate), location_code="Scotland",
                         agegroup=unique(Agegroups$agegroup),
                         sex=unique(Sex$sex), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>% 
  arrange(week_ending, sex)

rm(Dates,Agegroups, Sex) #remove building blocks

# cases on a weekly basis 
g_cases_age_data_weekly<-g_cases_age_data %>% 
filter(Date>as.Date("2020-02-27") & Date<as.Date(od_date-1)) %>% 
  group_by(Date) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
  ungroup()

# 1 weekly cases by main age group and sex
g_cases_agegroup_sex_weekly<-g_cases_age_data_weekly%>% 
 group_by(week_ending, agegroup_scotland,sex )%>% 
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
     ungroup() %>% 
  rename(agegroup=agegroup_scotland)%>% 
  group_by(agegroup, sex) %>% 
  mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
  ungroup 

# 2 weekly cases by main age group combined sex
g_cases_agegroup_weekly<-g_cases_age_data_weekly %>% 
  group_by(week_ending, agegroup_scotland)%>% 
  summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
  ungroup() %>%  
  rename(agegroup=agegroup_scotland)%>% 
  group_by(agegroup) %>% 
  mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
  ungroup %>% 
  mutate(sex="Total")
 
#  3  weekly cases  by age and sex using age_group_scotland_60plus grouping
  g_agegroup_60plus_sex_cases_weekly<-g_cases_age_data_weekly  %>% 
   group_by(week_ending, agegroup_scotland_60plus, sex) %>% 
    summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
    ungroup() %>%  
    rename(agegroup=agegroup_scotland_60plus) %>% 
    group_by(agegroup, sex) %>% 
    mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
    ungroup 
  
#  4  weekly cases by age and COMBINED SEX using age_group_scotland_60plus grouping
  g_agegroup_60plus_cases_weekly<-g_cases_age_data_weekly  %>% 
    group_by(week_ending, agegroup_scotland_60plus) %>% 
    summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
    ungroup()%>%  
    rename(agegroup=agegroup_scotland_60plus) %>%
  group_by(agegroup) %>% 
    mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
    ungroup %>% 
    mutate(sex="Total")
  
# 5 weekly  cases by combined age, both sexes
  g_total_age_sex_cases_weekly<-g_cases_age_data_weekly %>%
     group_by(week_ending, sex) %>% 
    summarise(PositiveLastSevenDays=sum(daily_positive)) %>% 
    ungroup() %>% 
    mutate(agegroup="Total") %>% 
    group_by(agegroup) %>% 
    mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
    ungroup 
  
#    6 weekly cases by combined age, combined sexes
   g_total_age_total_sex_cases_weekly <-g_cases_age_data_weekly  %>%
     group_by(week_ending) %>%
     summarise(PositiveLastSevenDays=sum(daily_positive)) %>%
     ungroup()%>% 
     mutate(agegroup="Total", sex="Total") %>% 
     group_by(agegroup) %>% 
     mutate(CumulativePositive=(cumsum(PositiveLastSevenDays))) %>% 
     ungroup 
   
# combine weekly age group and sex combinations together  
   g_age_sex_cases_weekly<-bind_rows(g_cases_agegroup_sex_weekly, g_cases_agegroup_weekly,
                                          g_agegroup_60plus_sex_cases_weekly, g_agegroup_60plus_cases_weekly,
                                          g_total_age_sex_cases_weekly, g_total_age_total_sex_cases_weekly) 
# reformat for open data
   g_age_sex_cases_weekly_all_od<-df_agesex %>% 
     left_join(g_age_sex_cases_weekly, by =c("week_ending","agegroup","sex")) %>% 
          mutate(Date= format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d"),
            Country="S92000003",
            SexQF= if_else(sex=="Total","d", ""),
            AgeGroupQF=if_else(SexQF=="d","d","") ) %>%   
     mutate(AgeGroup = recode(agegroup, "60+" = "60plus","85+" = "85plus"))%>% 
     arrange(desc(Date), sex, agegroup)%>% 
                select(Date, Country, Sex=sex, SexQF, AgeGroup, AgeGroupQF,
           PositiveLastSevenDays, CumulativePositive) 
   
   # remove intermediate files
   rm(g_cases_agegroup_sex_weekly, g_cases_agegroup_weekly,
     g_agegroup_60plus_sex_cases_weekly, g_agegroup_60plus_cases_weekly,
     g_total_age_sex_cases_weekly, g_total_age_total_sex_cases_weekly, df_agesex) 
   
   rm(g_cases_age_data,g_age_sex_cases_weekly, 
     g_cases_age_data_weekly, g_cases_raw, i_combined_pcr_lfd_tests)
        
   
   write_csv(g_age_sex_cases_weekly_all_od, glue("{output_folder}TEMP_age_sex_weekly.csv"), na = "")
   
   
   
