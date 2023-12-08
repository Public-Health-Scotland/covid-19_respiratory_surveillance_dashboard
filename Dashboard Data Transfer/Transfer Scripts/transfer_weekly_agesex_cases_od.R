# Open data transfer for Age & Sex cases
# Sourced from ../dashboard_data_transfer.R


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
         flag_episode = ifelse(episode_number_deduplicated>0,1,0))%>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday)) 

##### Create  cases by age groups ##############################

# only used to obtain the unknown age and or sex cases  
# i.e intermediate age/sex profile no 7

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

# used to obtain cases with known age and sex  
#i.e intermediate age/sex profiles  1- 6

g_cases_age_filtered <- g_cases_age_sex_all %>%
  filter(agegroup!='NA', agegroup!='Unknown', sex!='NA', sex!='Unknown')

##### Cumulative cases by age and sexs############################
# create intermediate cumulative age/sex profiles 

# 1 cumulative by age and sex using age_group_scotland grouping
g_agegroup_sex_cumulative<-g_cases_age_filtered  %>% 
  group_by(agegroup_scotland, sex) %>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  ungroup() %>% 
  rename(agegroup=agegroup_scotland) %>% 
  arrange(agegroup, sex) %>% 
  filter(sex!="Unknown"& agegroup!="Unknown") %>% 
      left_join(pop_agegroup_sex, by=(c("agegroup", "sex")))%>% 
  mutate(location_code=("Scotland")) 

#  2 cumulative by age and COMBINED SEX using age_group_scotland grouping
g_agegroup_cumulative<-g_agegroup_sex_cumulative  %>% 
  group_by(agegroup) %>% 
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>% 
  mutate(sex="Total")%>% 
  left_join(pop_agegroup_total, by=(c("agegroup", "sex")))

#1 & 2  combine age groups together
g_agegroup_cumulative_combined <-bind_rows(g_agegroup_sex_cumulative,
                                           g_agegroup_cumulative) %>% 
  filter(sex!="Unknown" & agegroup!="Unknown") %>% 
  arrange(agegroup)
  
#  3 cumulative by age and sex using age_group_scotland_60plus grouping
g_60plus_sex_cumulative<-g_cases_age_filtered   %>% 
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
                                          g_60plus_cumulative)%>% 
  filter(sex!="Unknown" & agegroup!="Unknown") %>% 
  arrange(agegroup)

# 5 cumulative total cases by combined age, both sexes
g_total_age_sex_cases_cumulative<-g_60plus_sex_cumulative %>% 
  group_by(sex) %>% 
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup %>% 
  mutate(agegroup = if_else(sex=="Unknown", "Unknown", "Total")) %>% 
  filter(agegroup!="Unknown") %>% 
  left_join(pop_total_sex, by=(c("agegroup", "sex"))) %>% 
  mutate(location_code="Scotland")

# 6 cumulative total cases by combined age, combined sexes
g_total_cumulative<-g_60plus_sex_cumulative %>% 
  mutate(location_code="Scotland") %>% 
   group_by(location_code) %>%
  summarise(TotalPositive=sum(TotalPositive)) %>% 
  ungroup() %>%
   mutate(agegroup="Total",
          sex="Total") %>% 
   left_join(pop_total_total, by=(c("agegroup", "sex", "location_code"))) 

#7 calculate unknown age and/or sex
g_unknown_agesex_total_cases <-g_cases_age_sex_all %>% 
  filter(agegroup=='Unknown'| sex=='Unknown')%>% 
  summarise(TotalPositive=sum(daily_positive)) %>% 
  mutate(location_code="Scotland",agegroup="Unknown", sex="Unknown") 

#combine all cumulative by aga-group and sex combinations and format for open data
g_age_sex_cumulative_od <- bind_rows(g_agegroup_cumulative_combined,
                                     g_60_plus_cumulative_combined,
                                     g_total_age_sex_cases_cumulative, 
                                     g_unknown_agesex_total_cases,
                                     g_total_cumulative   ) %>% 
  rename(Sex=sex, AgeGroup=agegroup,TotalCases=TotalPositive) %>% 
  mutate(CrudeRateCases=round_half_up((TotalCases/pop)*100000),#  round to 0 d.p.
         Date= format(strptime(od_sunday, format = "%Y-%m-%d"), "%Y%m%d"),
         Country="S92000003",
         SexQF= if_else(Sex=="Total"|Sex=="Unknown","d", ""),
         AgeGroupQF=if_else(AgeGroup=="Total"|AgeGroup=="Unknown","d", ""),
         CrudeRateCasesQF=if_else(is.na(CrudeRateCases),":","")) %>% 
arrange(Sex)%>% 
  mutate(AgeGroup = recode(AgeGroup, "60+" = "60plus"),
         AgeGroup = recode(AgeGroup, "85+" = "85plus")) %>% 
  select(LatestDate= Date,
         Country, Sex, SexQF, AgeGroup,AgeGroupQF,
         CumulativeCases= TotalCases, 
         CrudeRateCumulativeCases= CrudeRateCases,
         CrudeRateCumulativeCasesQF= CrudeRateCasesQF) 


write_csv(g_age_sex_cumulative_od, glue(od_folder, "cumulative_cases_age_sex_{od_report_date}.csv"), na = "")


##### Weekly cases by age and sex  #########################################################
#rinse and repeat but add weekly date split & remove pop elements for weekly equivalent
# create age, sex, weekending  data frame template 
# needed to ensure no blank lines no cases for particular age sex week

Dates <- data.frame(SpecimenDate=seq(as.Date("2020-02-23"), as.Date(od_date-1), "week"))

Agegroups<- data.frame(agegroup = c('0 to 14','15 to 19','20 to 24','25 to 44',
                                    '45 to 64','65 to 74','75 to 84','85+','0 to 59','60+','Total','Unknown'))%>%
  mutate(agegroup=as.character(agegroup))

Sex <- data.frame(sex = c('Female','Male','Total', 'Unknown')) %>% 
  mutate(sex=as.character(sex))

df_agesex <- expand.grid(week_ending=unique(Dates$SpecimenDate), location_code="Scotland",
                         agegroup=unique(Agegroups$agegroup),
                         sex=unique(Sex$sex), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>% 
 mutate(unknown_check=paste(agegroup,sex)) %>% 
 filter(unknown_check!="0 to 14 Unknown", 
        unknown_check!="15 to 19 Unknown", 
        unknown_check!="20 to 24 Unknown",
        unknown_check!="25 to 44 Unknown",
        unknown_check!="45 to 64 Unknown",
        unknown_check!="65 to 74 Unknown", 
        unknown_check!="75 to 84 Unknown", 
        unknown_check!="85+ Unknown", 
        unknown_check!="0 to 59 Unknown",
        unknown_check!="60+ Unknown",
        unknown_check!="Total Unknown",
        unknown_check!="Unknown Total", 
        unknown_check!="Unknown Male", 
        unknown_check!="Unknown Female") %>% 
  arrange(week_ending, sex)

 rm(Dates,Agegroups, Sex) #remove building blocks
##################################
# cases on a weekly basis 
g_cases_age_filtered_weekly<-g_cases_age_filtered %>% 
filter(Date>as.Date("2020-02-27") & Date<as.Date(od_date-1)) %>% 
  group_by(Date) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  ungroup()

# 1 weekly cases by main age group and sex 
# using df with unknowns removed
g_cases_agegroup_sex_weekly<-g_cases_age_filtered_weekly %>% 
 group_by(week_ending, agegroup_scotland,sex )%>% 
     summarise(CasesLastSevenDays=sum(daily_positive)) %>% 
     ungroup() %>% 
  rename(agegroup=agegroup_scotland) 

# 2 weekly cases by main age group combined sex
g_cases_agegroup_weekly<- g_cases_age_filtered_weekly %>% 
  group_by(week_ending, agegroup_scotland)%>% 
  summarise(CasesLastSevenDays=sum(daily_positive)) %>% 
  ungroup() %>%  
  rename(agegroup=agegroup_scotland)%>% 
    mutate(sex="Total")

# 1 and 2 combined 
g_agegroup_weekly_combined<- bind_rows(g_cases_agegroup_sex_weekly,
                                       g_cases_agegroup_weekly) %>% #
  arrange(week_ending, agegroup)

#  3  weekly cases  by age and sex using age_group_scotland_60plus grouping
  g_agegroup_60plus_sex_cases_weekly<- g_cases_age_filtered_weekly %>% 
   group_by(week_ending, agegroup_scotland_60plus, sex) %>% 
    summarise(CasesLastSevenDays=sum(daily_positive)) %>% 
    ungroup() %>%  
    rename(agegroup=agegroup_scotland_60plus)  
   
#  4  weekly cases by age and COMBINED SEX using age_group_scotland_60plus grouping
  g_agegroup_60plus_cases_weekly<-g_cases_age_filtered_weekly %>% 
    group_by(week_ending, agegroup_scotland_60plus) %>% 
    summarise(CasesLastSevenDays=sum(daily_positive)) %>% 
    ungroup()%>%  
    rename(agegroup=agegroup_scotland_60plus) %>%
    mutate(sex="Total")
  
  # 3 & 4 combine age groups together
  g_60_plus_weekly_combined <-bind_rows(g_agegroup_60plus_sex_cases_weekly,
                                        g_agegroup_60plus_cases_weekly)%>% 
    arrange(week_ending, agegroup)
  
  # 5 weekly  cases by combined age, both sexes
  g_total_age_sex_cases_weekly<- g_agegroup_60plus_sex_cases_weekly %>%
    group_by(week_ending, sex) %>% 
    summarise(CasesLastSevenDays=sum(CasesLastSevenDays)) %>% 
    ungroup() %>% 
    mutate(agegroup="Total") 

  # 6 cumulative total cases by combined age, combined sexes
  g_total_age_total_sex_cases_weekly<-g_agegroup_60plus_sex_cases_weekly %>% 
   # mutate(location_code="Scotland") %>% 
    group_by(week_ending) %>% #, location_code) %>%
    summarise(CasesLastSevenDays=sum(CasesLastSevenDays)) %>% 
    ungroup() %>%
    mutate(agegroup="Total", sex="Total")
          
  #7  calculate unknown age and/or sex
   g_unknown_agesex_weekly_cases <-g_cases_age_sex_all %>% 
     filter(agegroup=='Unknown'| sex=='Unknown')%>% 
     filter(Date>as.Date("2020-02-27") & Date<as.Date(od_date-1)) %>% 
     group_by(Date) %>%
     mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
     ungroup() %>% 
     group_by(week_ending) %>% 
     summarise(CasesLastSevenDays=sum(daily_positive))  %>% 
     ungroup() %>% 
      mutate(agegroup="Unknown", sex="Unknown")  

# combine weekly age group and sex combinations together  
   g_age_sex_cases_weekly<-bind_rows(g_agegroup_weekly_combined, 
                                     g_60_plus_weekly_combined,
                                     g_total_age_sex_cases_weekly,
                                     g_total_age_total_sex_cases_weekly,
                                     g_unknown_agesex_weekly_cases   ) 
# reformat for open data
   g_age_sex_cases_weekly_od<-df_agesex %>% 
     left_join(g_age_sex_cases_weekly, by =c("week_ending","agegroup","sex"), multiple="all")  %>% 
     mutate(CasesLastSevenDays=if_else(is.na(CasesLastSevenDays),0,CasesLastSevenDays)) %>% # add 0 to NULL rows so allows cumulative calc
     group_by(unknown_check) %>%
     mutate(CumulativeCases=(cumsum(CasesLastSevenDays))) %>%
     ungroup () %>% 
     mutate(week_ending= format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d"),
          Country="S92000003",
          SexQF= if_else(sex=="Total"|sex=="Unknown","d", ""),
          AgeGroup = recode(agegroup, "60+" = "60plus","85+" = "85plus"),
          AgeGroupQF=if_else(AgeGroup=="Total"|AgeGroup=="Unknown","d", ""))%>% 
     select(WeekEnding=week_ending, Country, Sex=sex, SexQF, AgeGroup, AgeGroupQF,
            WeeklyCases=CasesLastSevenDays, 
            CumulativeCases) 
   
 write_csv(g_age_sex_cases_weekly_od, glue(od_folder, "weekly_cases_age_sex_{od_report_date}.csv", na=""))
 
# remove intermediate files
rm(g_cases_raw, i_combined_pcr_lfd_tests) 

rm(g_agegroup_cumulative_combined, g_agegroup_sex_cumulative,g_agegroup_cumulative,
   g_60_plus_cumulative_combined, g_60plus_sex_cumulative,g_60plus_cumulative,
   g_total_age_sex_cases_cumulative, g_unknown_agesex_total_cases,
   g_total_cumulative,  g_age_sex_cumulative_od )

rm(g_cases_agegroup_sex_weekly, g_cases_agegroup_weekly,
   g_agegroup_60plus_sex_cases_weekly, g_agegroup_60plus_cases_weekly,
   g_total_age_sex_cases_weekly, g_total_age_total_sex_cases_weekly, df_agesex,
   g_age_sex_cases_weekly_od, g_unknown_agesex_weekly_cases,
   g_60_plus_weekly_combined,g_cases_age_filtered, g_age_sex_cases_weekly, 
   g_agegroup_weekly_combined, g_cases_age_filtered_weekly,
   g_cases_age_sex_all)

