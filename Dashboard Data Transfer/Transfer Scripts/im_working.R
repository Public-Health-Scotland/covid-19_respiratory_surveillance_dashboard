#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RStudio Workbench is strictly for use by Public Health Scotland staff and     
# authorised users only, and is governed by the Acceptable Usage Policy https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md.
#
# This is a shared resource and is hosted on a pay-as-you-go cloud computing
# platform.  Your usage will incur direct financial cost to Public Health
# Scotland.  As such, please ensure
#
#   1. that this session is appropriately sized with the minimum number of CPUs
#      and memory required for the size and scale of your analysis;
#   2. the code you write in this script is optimal and only writes out the
#      data required, nothing more.
#   3. you close this session when not in use; idle sessions still cost PHS
#      money!
#
# For further guidance, please see https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



################ lookups and values  #######################################
#  geography_lookups  #
SPD <- readRDS("/conf/linkage/output/lookups/Unicode/Geography/Scottish Postcode Directory/Scottish_Postcode_Directory_2023_1.rds")

CA_lookup <-SPD %>%
  select(ca2019,ca2019name)%>%
  distinct(ca2019,ca2019name)%>%
  rename(local_authority=ca2019name)

HB_lookup<- SPD %>%
  select(hb2019,hb2019name)%>%
  distinct(hb2019,hb2019name)%>%
  mutate(reporting_health_board=str_replace_all(string=hb2019name, pattern="NHS ", repl=""))

IZ_pc_lookup <- SPD %>%
  select(pc7,ca2019,ca2019name,intzone2011) %>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl="")) %>%
  select(PostCode,intzone2011)

HBnames <- HB_lookup %>%
  select(hb2019,hb2019name)%>%
  rename(location_code=hb2019,location_name=hb2019name)

LAnames <- CA_lookup %>%
  rename(location_code=ca2019,location_name=local_authority)

location_names <- bind_rows(HBnames,LAnames)

rm(HBnames,LAnames,SPD)



# Reporting Dates 
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1
od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
od_sunday_minus_14 <- today() - 17
od_suppression_date <- "2023-05-31"


################# Cases #################################################################



i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

g_daily_cases_od <- i_cases$`Cumulative confirmed cases`

g_daily_cases_od %<>%
  rename(DailyCases="Number of cases per day",
         CumulativeCases=Cumulative)



############## load testing RTE dataset##################

#Flat file back up
#combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{date_to_use}.rds"))%>%

#Time_Series_Test_data <- readRDS("/PHI_conf/Real_Time_Epi/Data/PCR_Data/Time_Series_Test_data_2023-06-27.rds")


i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )
 
g_daily_tests<- i_combined_pcr_lfd_tests %>% 
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex))%>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab")) %>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source))%>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1")) %>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar))%>%
  select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date,
         test_result, Sex, age, date_reporting, date_test_received_at_bi,
         test_result_record_source, laboratory_code, pillar, flag_covid_case,
         derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)




############### tests and pillars######################

  # combined_pcr_lfd_tests<-combined_pcr_lfd_tests %>% 
  # mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex))%>%
  # mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
  #                                test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))%>%
  # mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
  #                                (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
  #                                TRUE~test_source))%>%
  # mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  # mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar))%>%
  # select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date, 
  #        test_result, Sex, age, date_reporting, date_test_received_at_bi,
  #        test_result_record_source, laboratory_code, pillar, flag_covid_case, 
  #        derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)

#Read in postcode lookup and keep postcode and CA2019 columns


# match testing data to local authority and health board codes
g_daily_tests_geog <- g_daily_tests%>%
  left_join(CA_lookup,by="local_authority")%>%
  left_join(HB_lookup,by="reporting_health_board")%>%
  mutate(Date = as.Date(specimen_date)) %>%
  arrange(desc(Date)) %>% 
  filter(Date <= as.Date(od_sunday)) #remove  -7 on Tues


#Cumulative figures for Scotland by pillar
cumulatives_pillar_scotland <- g_daily_tests_geog%>%
  group_by(pillar)%>%
  summarise(positive_tests=n())%>%
  mutate(location_code="Scotland")%>%
  mutate(Date=od_sunday)%>% #remove minus seven
  select(Date,location_code,pillar,positive_tests)

#Cumulative figures by Board and pillar
cumulatives_pillar_board <-  g_daily_tests_geog%>%
  group_by(pillar,hb2019)%>%
  summarise(positive_tests=n())%>%
  mutate(Date=od_sunday)%>% #remove minus seven
  rename(location_code=hb2019)%>%
  select(Date,location_code,pillar,positive_tests)

#Cumulative figures by LA and pillar
cumulatives_pillar_LA <- g_daily_tests_geog%>%
  group_by(pillar,ca2019)%>%
  summarise(positive_tests=n())%>%
  mutate(Date=od_sunday)%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests)

#Combine Scotland, Board and LA cumulative data
cumulatives <- bind_rows(cumulatives_pillar_scotland,cumulatives_pillar_board,cumulatives_pillar_LA)%>%
  mutate(Data_type="Cumulatives")

#Scotland trend by specimen date and pillar
trend_pillar_scotland <- g_daily_tests_geog%>%
  group_by(Date,pillar)%>%
  summarise(positive_tests=n())%>%
  mutate(location_code="Scotland")%>%
  select(Date,location_code,pillar,positive_tests)

#g_Scotland trend by specimen date and pillarg_
g_trend_pillar_scotland <- g_daily_tests_geog%>%
  group_by(Date,pillar)%>%
  summarise(positive_tests=n())%>%
  mutate(location_code="Scotland")%>%
  select(Date,location_code,pillar,positive_tests) %>% 
  ungroup %>% 
  arrange(desc(Date))

g_trend_pilar1_scotland<-g_trend_pillar_scotland

##Board trend by specimen date and pillar
trend_pillar_board <- g_daily_tests_geog%>%
  group_by(Date,pillar,hb2019)%>%
  summarise(positive_tests=n())%>%
  rename(location_code=hb2019)%>%
  select(Date,location_code,pillar,positive_tests)

##LA trend by specimen date and pillar
trend_pillar_LA <- g_daily_tests_geog%>%
  group_by(Date,pillar,ca2019)%>%
  summarise(positive_tests=n())%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests)


#Combine Scotland, Board and LA trends
trend <- bind_rows(trend_pillar_scotland,trend_pillar_board,trend_pillar_LA)%>%
  mutate(Data_type="Trend")%>%
  filter (Date<od_sunday,Date>(as.Date("2020-02-27")))

#calculate 7 day figures with 3 day lag (eg. for 27 Oct, 7 day period is 18-24 Oct)
seven_day <- trend %>%
  filter(Date > od_sunday_minus_7, Date <= od_sunday)%>%
  ungroup()%>%
  group_by(location_code,pillar)%>%
  summarise(positive_7day=sum(positive_tests))

cumulatives <- cumulatives %>%
  left_join(seven_day, by=c("location_code","pillar"))

combined_data <- bind_rows(cumulatives,trend)%>%
  ungroup()%>%
  mutate(Data_type  = as.character(Data_type), Date = as.Date(Date),location_code = as.character(location_code))%>%
  select(Data_type,Date,location_code,pillar,positive_tests,positive_7day)

pillar1 <- combined_data %>%
  filter(pillar=="Pillar 1")%>%
  rename(pillar1_positive_tests=positive_tests, pillar1_positive_tests_7day=positive_7day)%>%
  select(Data_type,Date,location_code,pillar1_positive_tests,pillar1_positive_tests_7day)

pillar2 <- combined_data %>%
  filter(pillar=="Pillar 2")%>%
  rename(pillar2_positive_tests=positive_tests, pillar2_positive_tests_7day=positive_7day)%>%
  select(Data_type,Date,location_code,pillar2_positive_tests,pillar2_positive_tests_7day)

lfd_tests <- combined_data %>%
  filter(pillar=="LFD")%>%
  rename(lfd_positive_tests=positive_tests, lfd_positive_tests_7day=positive_7day)%>%
  select(Data_type,Date,location_code,lfd_positive_tests,lfd_positive_tests_7day)

Final_data <- pillar1 %>%
  left_join(pillar2, by=c("Data_type","Date","location_code"))%>%
  left_join(lfd_tests, by=c("Data_type","Date","location_code"))%>%
  mutate(pillar1_positive_tests = replace(pillar1_positive_tests, is.na(pillar1_positive_tests), 0),
         pillar2_positive_tests = replace(pillar2_positive_tests, is.na(pillar2_positive_tests), 0),
         lfd_positive_tests = replace(lfd_positive_tests, is.na(lfd_positive_tests), 0),
         pillar1_positive_tests_7day = replace(pillar1_positive_tests_7day, is.na(pillar1_positive_tests_7day), 0),
         pillar2_positive_tests_7day = replace(pillar2_positive_tests_7day, is.na(pillar2_positive_tests_7day), 0),
         lfd_positive_tests_7day = replace(lfd_positive_tests_7day, is.na(lfd_positive_tests_7day), 0))%>%
  mutate(total_positive_tests = pillar1_positive_tests + pillar2_positive_tests + lfd_positive_tests,
         total_positive_tests_7day = pillar1_positive_tests_7day + pillar2_positive_tests_7day + lfd_positive_tests_7day)%>%
  select(-pillar1_positive_tests_7day,-pillar2_positive_tests_7day,-lfd_positive_tests_7day)


# #remove files not needed
# rm(cumulatives,cumulatives_pillar_scotland,cumulatives_pillar_board,cumulatives_pillar_LA,combined_data,
#    seven_day,pillar1,pillar2,trend,trend_pillar_scotland,trend_pillar_board,trend_pillar_LA, lfd_tests)

###Newly reported

Newly_reported <- g_daily_tests_geog %>%
  filter(Date > od_sunday_minus_7, Date <= od_sunday)

#Cumulative figures for Scotland by pillar
cumulatives_pillar_scotland <- Newly_reported%>%
  group_by(pillar)%>%
  summarise(positive_tests_new=n())%>%
  mutate(location_code="Scotland")%>%
  mutate(Date=od_sunday)%>%
  select(Date,location_code,pillar,positive_tests_new)

#Cumulative figures by Board and pillar
cumulatives_pillar_board <-  Newly_reported%>%
  group_by(pillar,hb2019)%>%
  summarise(positive_tests_new=n())%>%
  mutate(Date=od_sunday)%>%
  rename(location_code=hb2019)%>%
  select(Date,location_code,pillar,positive_tests_new)

#Cumulative figures by LA and pillar
cumulatives_pillar_LA <-  Newly_reported%>%
  group_by(pillar,ca2019)%>%
  summarise(positive_tests_new=n())%>%
  mutate(Date=od_sunday)%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests_new)

#Combine Scotland, Board and LA cumulative data
cumulatives <- bind_rows(cumulatives_pillar_scotland,cumulatives_pillar_board,cumulatives_pillar_LA)%>%
  mutate(Data_type="Cumulatives")

pillar1 <- cumulatives %>%
  filter(pillar=="Pillar 1")%>%
  rename(pillar1_positive_tests_new = positive_tests_new)%>%
  select(Data_type,Date,location_code,pillar1_positive_tests_new)

pillar2 <- cumulatives %>%
  filter(pillar=="Pillar 2")%>%
  rename(pillar2_positive_tests_new = positive_tests_new)%>%
  select(Data_type,Date,location_code,pillar2_positive_tests_new)

lfd_tests <- cumulatives %>%
  filter(pillar=="LFD")%>%
  rename(lfd_positive_tests_new = positive_tests_new)%>%
  select(Data_type,Date,location_code,lfd_positive_tests_new)


###Reported previous week

Previously_reported <- g_daily_tests_geog %>%
  filter(Date > od_sunday_minus_14 , Date <=od_sunday_minus_7)

#Cumulative figures for Scotland by pillar
cumulatives_pillar_scotland_previous <- Previously_reported%>%
  group_by(pillar)%>%
  summarise(positive_tests_previous=n())%>%
  mutate(location_code="Scotland")%>%
  mutate(Date=od_sunday)%>%
  select(Date,location_code,pillar,positive_tests_previous)

#Cumulative figures by Board and pillar
cumulatives_pillar_board_previous <-  Previously_reported%>%
  group_by(pillar,hb2019)%>%
  summarise(positive_tests_previous=n())%>%
  mutate(Date=od_sunday)%>%
  rename(location_code=hb2019)%>%
  select(Date,location_code,pillar,positive_tests_previous)

#Cumulative figures by LA and pillar
cumulatives_pillar_LA_previous <-  Previously_reported%>%
  group_by(pillar,ca2019)%>%
  summarise(positive_tests_previous=n())%>%
  mutate(Date=od_sunday)%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests_previous)

#Combine Scotland, Board and LA cumulative data
cumulatives_previous <- bind_rows(cumulatives_pillar_scotland_previous,
                                  cumulatives_pillar_board_previous,cumulatives_pillar_LA_previous)%>%
  mutate(Data_type="Cumulatives")

pillar1_previous <- cumulatives_previous %>%
  filter(pillar=="Pillar 1")%>%
  rename(pillar1_positive_tests_previous = positive_tests_previous)%>%
  select(Data_type,Date,location_code,pillar1_positive_tests_previous)

pillar2_previous <- cumulatives_previous %>%
  filter(pillar=="Pillar 2")%>%
  rename(pillar2_positive_tests_previous = positive_tests_previous)%>%
  select(Data_type,Date,location_code,pillar2_positive_tests_previous)

lfd_tests_previous <- cumulatives_previous %>%
  filter(pillar=="LFD")%>%
  rename(lfd_positive_tests_previous = positive_tests_previous)%>%
  select(Data_type,Date,location_code,lfd_positive_tests_previous)


Data_combined <- Final_data %>%
  left_join(pillar1, by=c("Data_type","Date","location_code"))%>%
  left_join(pillar2, by=c("Data_type","Date","location_code"))%>%
  left_join(lfd_tests, by=c("Data_type","Date","location_code"))%>%
  left_join(pillar1_previous, by=c("Data_type","Date","location_code"))%>%
  left_join(pillar2_previous, by=c("Data_type","Date","location_code"))%>%
  left_join(lfd_tests_previous, by=c("Data_type","Date","location_code"))%>%
  mutate(pillar1_positive_tests_new = replace(pillar1_positive_tests_new, is.na(pillar1_positive_tests_new), 0),
         pillar2_positive_tests_new = replace(pillar2_positive_tests_new, is.na(pillar2_positive_tests_new), 0),
         lfd_positive_tests_new = replace(lfd_positive_tests_new, is.na(lfd_positive_tests_new), 0),
         pillar1_positive_tests_previous = replace(pillar1_positive_tests_previous, is.na(pillar1_positive_tests_previous), 0),
         pillar2_positive_tests_previous = replace(pillar2_positive_tests_previous, is.na(pillar2_positive_tests_previous), 0),
         lfd_positive_tests_previous = replace(lfd_positive_tests_previous, is.na(lfd_positive_tests_previous), 0))%>%
  mutate(total_positive_tests_new = pillar1_positive_tests_new + pillar2_positive_tests_new + lfd_positive_tests_new,
         total_positive_tests_previous = pillar1_positive_tests_previous + pillar2_positive_tests_previous + lfd_positive_tests_previous)

#remove previous file.
#file.remove(glue("{svt_filepath}/Interim files/Testing data.rds"))

#save out rds file for script 5.
#saveRDS(Data_combined,glue("{svt_filepath}/Interim files/Testing data.rds"))


############## start of  of cases script ###############

############# cases pop lookups ####################### 
# Population lookup rds
pop_lookup1 <- read_rds("/conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/Populations.rds")%>%
  ungroup() %>%
  mutate(location_code=as.character(location_code))%>%
  mutate(sex=case_when(sex=="F"~"Female",sex=="M"~"Male",sex=="Total"~"Total"))

#Create age and sex totals for populations
pop_lookup_agetotals <- pop_lookup1 %>%
  filter(agegroup!="Total",agegroup!="0 to 59", agegroup!="60+")%>%
  group_by(location_code,sex)%>%
  summarise(Pop=sum(Pop))%>%
  mutate(agegroup="Total")

pop_lookup_sextotals <- pop_lookup1 %>%
  filter(sex!="Total")%>%
  group_by(location_code,agegroup)%>%
  summarise(Pop=sum(Pop))%>%
  mutate(sex="Total")

#Add population files together
pop_lookup <- bind_rows(pop_lookup1, pop_lookup_agetotals, pop_lookup_sextotals)

#SIMD lookup
simd_lookup <- read_rds("/conf/linkage/output/lookups/Unicode/Deprivation/postcode_2023_1_simd2020v2.rds")%>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl=""),
         simd=as.character(simd2020v2_sc_quintile))%>%
  select(PostCode,simd)


# SIMD population lookup rds
simd_pop_lookup <- read_rds("/conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/SIMD_populations.rds")%>%
  ungroup() %>%
  mutate(location_code=as.character(location_code),simd=as.character(SIMD))%>%
  select(location_code,simd,Pop)


#Intermediate Zone population lookup rds
IZ_pop_lookup <- read_rds("/conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/IntZone_populations.rds")%>%
  ungroup() %>%
  mutate(intzone2011=as.character(IntZone2011))%>%
  select(intzone2011,Pop)

########### cases and case poitives  trends_ lookups ###############
#Create trend look ups with all combinations of variables for all dates.
#Age/sex trend, SIMD trend and IZ trend.
######################################################################

# geography look ups

SPD <- readRDS("/conf/linkage/output/lookups/Unicode/Geography/Scottish Postcode Directory/Scottish_Postcode_Directory_2023_1.rds")

CA_lookup <-SPD %>%
  select(ca2019,ca2019name)%>%
  distinct(ca2019,ca2019name)%>%
  rename(local_authority=ca2019name)

HB_lookup<- SPD %>%
  select(hb2019,hb2019name)%>%
  distinct(hb2019,hb2019name)%>%
  mutate(reporting_health_board=str_replace_all(string=hb2019name, pattern="NHS ", repl=""))

IZ_pc_lookup <- SPD %>%
  select(pc7,ca2019,ca2019name,intzone2011) %>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl="")) %>%
  select(PostCode,intzone2011)

HBnames <- HB_lookup %>%
  select(hb2019,hb2019name)%>%
  rename(location_code=hb2019,location_name=hb2019name)

LAnames <- CA_lookup %>%
  rename(location_code=ca2019,location_name=local_authority)

location_names <- bind_rows(HBnames,LAnames)

rm(HBnames,LAnames,SPD)



# Reporting Dates 
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1
od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
od_sunday_minus_14 <- today() - 17
od_suppression_date <- "2023-05-31"


################# Cases #################################################################


#bring in the most up to date version
# i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

# use until lab data new generated on a Tues
i_cases <- read_all_excel_sheets(glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Data Folders/2023-06-28/Data/","Lab_Data_New_2023-06-27.xlsx"))

 
g_daily_cases_od <- i_cases$`Cumulative confirmed cases`

g_daily_cases_od %<>%
  rename(DailyCases="Number of cases per day",
         CumulativeCases=Cumulative)



############## load testing RTE dataset##################

#Flat file back up
#combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{date_to_use}.rds"))%>%

#Time_Series_Test_data <- readRDS("/PHI_conf/Real_Time_Epi/Data/PCR_Data/Time_Series_Test_data_2023-06-27.rds")

#use until RTE refreshed
i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_2023-06-27.rds") )

#i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )

g_daily_raw<- i_combined_pcr_lfd_tests %>% 
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex)) %>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))  %>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source)) %>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar)) 
# select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date, pillar) %>% 
#group_by(specimen_date) 


# match testing data to local authority and health board codes
g_daily_tests_geog <- g_daily_raw%>%
  left_join(CA_lookup,by="local_authority")%>%
  left_join(HB_lookup,by="reporting_health_board")%>%
  mutate(Date = as.Date(specimen_date)) %>%
  filter(Date <= as.Date(od_sunday))



Dates <- data.frame(SpecimenDate=seq(as.Date("2019/12/08"), as.Date(Sys.Date()), "day"))
Location_codes <- read.csv("//conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/location_codes.csv")%>%
  mutate(location_code=as.character(location_code))
SIMD <- data.frame(SIMD=seq(1,5,1))
Agegroups_Scotland <- data.frame(agegroup = c('0 to 14','15 to 19','20 to 24','25 to 44','45 to 64','65 to 74','75 to 84','85+','0 to 59','60+','Total'))%>%
  mutate(agegroup=as.character(agegroup))
Sex <- data.frame(sex = c('Female','Male','Total')) %>% mutate(sex=as.character(sex))
IZ_lookup <- read.csv(glue("//conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/Intermediate zones.csv"))%>%
  rename(intzone2011=IntZone, intzone2011name=IntZoneName, ca2019=CA, ca2019name=CAName)


#SIMD trend lookup
df_simd <- expand.grid(Date=unique(Dates$SpecimenDate) , simd=unique(SIMD$SIMD),
                       KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  mutate(location_code="Scotland", simd=as.character(simd))

#Age sex trend lookups for Boards and Local Authorities
df_agesex_all <- expand.grid(Date=unique(Dates$SpecimenDate) , location_code=unique(Location_codes$location_code),
                             KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  filter(location_code!="Scotland")%>%
  mutate(agegroup="Total", sex="Total")

#Age sex trend lookup for Scotland
df_agesex_scotland <- expand.grid(Date=unique(Dates$SpecimenDate), location_code="Scotland",
                                  agegroup=unique(Agegroups_Scotland$agegroup),
                                  sex=unique(Sex$sex), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)

#Combine Boards, Local Authorities and Scotland age sex trend lookups
df_agesex <- bind_rows(df_agesex_all,df_agesex_scotland)%>%
  distinct(Date,location_code,sex,agegroup)

#IZ trend lookups
df_iz <- expand.grid(Date=unique(Dates$SpecimenDate) , intzone2011=unique(IZ_lookup$intzone2011),
                     KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  filter(Date>as.Date("2020/02/27"))%>%
  left_join(IZ_lookup,by=c("intzone2011"))


#Remove files no longer needed
rm(SIMD, Agegroups_Scotland, Sex, df_agesex_all, df_agesex_scotland, IZ_lookup)



################### Cases data & positives  #####################

#Read in cases data, match on local authority, simd and filter deduped
g_cases_data <- g_daily_tests_geog %>%
  mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
  left_join(IZ_pc_lookup,by="PostCode") %>%
  left_join(simd_lookup,by="PostCode")%>%
  #left_join(CA_lookup,by="local_authority")%>%
  #left_join(HB_lookup,by="reporting_health_board") %>%
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0),
         flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
         flag_reinfection = ifelse(episode_number_deduplicated>1,1,0))%>%
  #filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday))

#Create age groups and hb codes
g_cases_data <- g_cases_data %>%
  mutate(agegroup = case_when(is.na(age) ~ "unknown",
                              age >= 0 & age < 15 ~ '0 to 14',
                              age > 14 & age < 45 ~ '15 to 44',
                              age > 44 & age < 65 ~ '45 to 64',
                              age > 64 & age < 75 ~ '65 to 74',
                              age > 74 & age < 85 ~ '75 to 84',
                              age > 84 ~ '85+',
                              TRUE ~ "unknown"),
         agegroup_Scotland = case_when(is.na(age) ~ "unknown",
                                       age >= 0 & age < 15 ~ '0 to 14',
                                       age > 14 & age < 20 ~ '15 to 19',
                                       age > 19 & age < 25 ~ '20 to 24',
                                       age > 24 & age < 45 ~ '25 to 44',
                                       age > 44 & age < 65 ~ '45 to 64',
                                       age > 64 & age < 75 ~ '65 to 74',
                                       age > 74 & age < 85 ~ '75 to 84',
                                       age > 84 ~ '85+',
                                       TRUE ~ "unknown"),
         agegroup_Scotland_60plus = case_when(is.na(age) ~ "unknown",
                                              age >= 0 & age < 60 ~ '0 to 59',
                                              age > 59 ~ '60+',
                                              TRUE ~ "unknown"),
         sex=case_when(is.na(Sex)~"unknown", Sex=="NotSpecified"~"unknown",
                       Sex=="Unknown"~"unknown",
                       Sex=="U"~"unknown", Sex=="FEMALE"~"Female",
                       Sex=="MALE"~"Male",TRUE ~ Sex))

#############################################################
########## cases & positives Age/sex ##############
#############################################################

Scotland_agesex <- g_cases_data %>%
  group_by(sex,agegroup_Scotland)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",geography="Scotland")%>%
  rename(agegroup=agegroup_Scotland)

Scotland_agesex_60plus <- g_cases_data %>%
  group_by(sex,agegroup_Scotland_60plus )%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",geography="Scotland", test_type="Combined")%>%
  rename(agegroup=agegroup_Scotland_60plus)

HB_agesex <- g_cases_data %>%
  group_by(hb2019,sex,agegroup)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  rename(location_code=hb2019)%>%
  mutate(geography="Health Board")

LA_agesex <- g_cases_data %>%
  group_by(ca2019,sex,agegroup)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  rename(location_code=ca2019)%>%
  mutate(geography="Local Authority")


#add files together - 60plus age groups will be added on after totals have been calculated.
Agesex <- bind_rows(Scotland_agesex, HB_agesex, LA_agesex)%>%
  mutate(test_type="Combined")

Totals <- Agesex %>%
  group_by(location_code,geography)%>%
  summarise(total_positive = sum(total_positive), first_infections = sum(first_infections),
            reinfections = sum(reinfections))%>%
  mutate(sex="Total", agegroup="Total", test_type="Combined")%>%
  select(sex,agegroup, total_positive, location_code, geography, test_type, first_infections, reinfections)

test_type_scotland <- g_cases_data %>%
  group_by(episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total", agegroup="Total", test_type=episode_derived_case_type,
         geography="Scotland", location_code="Scotland")%>%
  select(sex,agegroup, total_positive, location_code, geography, test_type, first_infections, reinfections)

test_type_hb <- g_cases_data %>%
  group_by(hb2019,episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total", agegroup="Total", test_type=episode_derived_case_type,
         geography="Health Board")%>%
  rename(location_code=hb2019)%>%
  select(sex,agegroup, total_positive, location_code, geography, test_type, first_infections, reinfections)

test_type_ca <- g_cases_data %>%
  group_by(ca2019,episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total", agegroup="Total", test_type=episode_derived_case_type,
         geography="Local Authority")%>%
  rename(location_code=ca2019)%>%
  select(sex,agegroup, total_positive, location_code, geography, test_type, first_infections, reinfections)

Agesex_all <- bind_rows(Agesex, Totals, Scotland_agesex_60plus, test_type_scotland,
                        test_type_hb, test_type_ca) %>%
  left_join(pop_lookup,by=c("location_code", "sex", "agegroup")) %>%
  mutate(crude_rate_positive=(total_positive/Pop)*100000) %>%
  filter(location_code!='NA', agegroup!='NA', agegroup!='unknown', sex!='NA', sex!='unknown') %>%
  mutate(Date= od_date) %>%
  left_join(location_names, by=c("location_code"))%>%
  mutate(location_name=case_when(is.na(location_name)~"Scotland", TRUE ~ location_name))%>%
  select(Date, geography, location_code, location_name, test_type, sex, agegroup, total_positive, Pop,
         crude_rate_positive, first_infections, reinfections)


###Newly reported since 1 week ago

Newly_reported <- g_cases_data %>%
  #filter(Date > week_ago & Date <= nearest_sunday)%>%
  #replace week ago with od_sunday-7 and nearest_sunday with od_sunday
  filter(Date > od_sunday_minus_7 & Date <=od_sunday)%>%
      mutate(Date=od_date) #replaced  Date_today with od_date


Scotland_new <- Newly_reported %>%
  group_by(Date, episode_derived_case_type)%>%
  summarise(new_positive = sum(flag_episode), new_first_infections = sum(flag_first_infection),
            new_reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland")

HB_new <- Newly_reported %>%
  group_by(Date, hb2019, episode_derived_case_type)%>%
  summarise(new_positive = sum(flag_episode), new_first_infections = sum(flag_first_infection),
            new_reinfections = sum(flag_reinfection))%>%
  rename(location_code=hb2019)

LA_new <- Newly_reported %>%
  group_by(Date,ca2019, episode_derived_case_type)%>%
  summarise(new_positive = sum(flag_episode), new_first_infections = sum(flag_first_infection),
            new_reinfections = sum(flag_reinfection))%>%
  rename(location_code=ca2019)

Combined_new <- bind_rows(Scotland_new, HB_new, LA_new)%>%
  mutate(sex="Total", agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)

Combined_totals <- Combined_new %>%
  group_by(Date, location_code, sex, agegroup)%>%
  summarise(new_positive=sum(new_positive), new_first_infections = sum(new_first_infections),
            new_reinfections = sum(new_reinfections))%>%
  mutate(test_type="Combined")

Combined_new <- Combined_new %>%
  rbind(Combined_totals)

###Previously reported in week before

Previously_reported <- g_cases_data %>%
  filter(Date > od_sunday_minus_14, Date <=od_sunday_minus_7)%>%
  #filter(Date > two_weeks_ago, Date <= week_ago)%>%
    mutate(Date=od_date) #previously Date_today


Scotland_previous <- Previously_reported %>%
  group_by(Date, episode_derived_case_type)%>%
  summarise(previous_positive = sum(flag_episode), previous_first_infections = sum(flag_first_infection),
            previous_reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland")

HB_previous <- Previously_reported %>%
  group_by(Date, hb2019, episode_derived_case_type)%>%
  summarise(previous_positive = sum(flag_episode), previous_first_infections = sum(flag_first_infection),
            previous_reinfections = sum(flag_reinfection))%>%
  rename(location_code=hb2019)

LA_previous <- Previously_reported %>%
  group_by(Date,ca2019, episode_derived_case_type)%>%
  summarise(previous_positive = sum(flag_episode), previous_first_infections = sum(flag_first_infection),
            previous_reinfections = sum(flag_reinfection))%>%
  rename(location_code=ca2019)

Combined_previous <- bind_rows(Scotland_previous, HB_previous, LA_previous)%>%
  mutate(sex="Total", agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)

Combined_totals_previous <- Combined_previous %>%
  group_by(Date, location_code, sex, agegroup)%>%
  summarise(previous_positive=sum(previous_positive), previous_first_infections = sum(previous_first_infections),
            previous_reinfections = sum(previous_reinfections))%>%
  mutate(test_type="Combined")

Combined_previous <- Combined_previous %>%
  rbind(Combined_totals_previous)

###New since last update

Newly_reported_last_update <- g_cases_data %>%
  filter(Date > od_sunday_minus_7 & Date <=od_sunday)%>%
  mutate(Date=od_date)

Scotland_last_update <- Newly_reported_last_update %>%
  group_by(Date, episode_derived_case_type)%>%
  summarise(new_positive_sincelastupdate = sum(flag_episode))%>%
  mutate(location_code="Scotland")

HB_last_update <- Newly_reported_last_update %>%
  group_by(Date, hb2019, episode_derived_case_type)%>%
  summarise(new_positive_sincelastupdate = sum(flag_episode))%>%
  rename(location_code=hb2019)

LA_last_update <- Newly_reported_last_update %>%
  group_by(Date,ca2019, episode_derived_case_type)%>%
  summarise(new_positive_sincelastupdate = sum(flag_episode))%>%
  rename(location_code=ca2019)

Combined_last_update <- bind_rows(Scotland_last_update, HB_last_update, LA_last_update)%>%
  mutate(sex="Total", agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)

Combined_totals_last_update <- Combined_last_update %>%
  group_by(Date, location_code, sex, agegroup)%>%
  summarise(new_positive_sincelastupdate=sum(new_positive_sincelastupdate))%>%
  mutate(test_type="Combined")

Combined_last_update<- Combined_last_update %>%
  rbind(Combined_totals_last_update)

#Match newly reported on to age sex data

Agesex_all <- Agesex_all%>%
  left_join(Combined_new, by=c("Date","location_code","test_type","sex","agegroup"))%>%
  left_join(Combined_previous, by=c("Date","location_code","test_type","sex","agegroup"))%>%
  left_join(Combined_last_update, by=c("Date","location_code","test_type","sex","agegroup"))

Combined_agesex <- Agesex_all %>%
  filter(test_type=="Combined")%>%
  select(-test_type)%>%
  rename(total_crude_rate_positive=crude_rate_positive, total_new_positive=new_positive,
         total_previous_positive=previous_positive)%>%
  mutate(percentage_reinfections = 100*reinfections/total_positive,
         percentage_new_reinfections = 100*new_reinfections/total_new_positive)

pcr_agesex <- Agesex_all %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive, -first_infections, -new_first_infections,
         -reinfections, -new_reinfections, -previous_first_infections, -previous_reinfections,
         -previous_positive, -new_positive_sincelastupdate)%>%
  rename(pcr_positive=total_positive, pcr_new_positive=new_positive)

lfd_agesex <- Agesex_all %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive, -first_infections, -new_first_infections,
         -reinfections, -new_reinfections, -previous_first_infections, -previous_reinfections,
         -previous_positive, -new_positive_sincelastupdate)%>%
  rename(lfd_positive=total_positive, lfd_new_positive=new_positive)

pcr_and_lfd_agesex <- Agesex_all %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive, -first_infections, -new_first_infections,
         -reinfections, -new_reinfections, -previous_first_infections, -previous_reinfections,
         -previous_positive, -new_positive_sincelastupdate)%>%
  rename(pcr_and_lfd_positive=total_positive, pcr_and_lfd_new_positive=new_positive)

Agesex_all <- Combined_agesex%>%
  left_join(pcr_agesex, by=c("Date","geography","location_name","location_code","sex","agegroup"))%>%
  left_join(lfd_agesex, by=c("Date","geography","location_name","location_code","sex","agegroup"))%>%
  left_join(pcr_and_lfd_agesex, by=c("Date","geography","location_name","location_code","sex","agegroup"))%>%
  select(Date,location_code,location_name,geography,sex,agegroup, Pop, new_positive_sincelastupdate,
         total_new_positive, total_previous_positive, total_positive,
         total_crude_rate_positive, first_infections, new_first_infections, reinfections, new_reinfections,
         percentage_reinfections, percentage_new_reinfections,
         pcr_new_positive, pcr_positive, lfd_new_positive, lfd_positive, pcr_and_lfd_new_positive, pcr_and_lfd_positive)

#Delete current rds file
#file.remove(glue("{svt_filepath}/Interim files/Agesex_latest.rds"))

# #save out rds file.
# saveRDS(Agesex_all,glue("{svt_filepath}/Interim files/Agesex_latest.rds"))
# 
# #Delete current csv file in open data folder
# file.remove(glue("{svt_filepath}/Data/Files for open data/Age_sex_latest_disclosure.csv"))
# 
# #save out csv file for open data.
# write_csv(Agesex_all,glue("{svt_filepath}/Data/Files for open data/Age_sex_latest_disclosure.csv"), na = "")
# 
# #save out dated csv file to archive folder.
# # write_csv(Agesex_all,glue("{svt_filepath}/Data/Archive/{Date_today}_Age_sex_latest.csv"), na = "")
# 
# 
# #Remove files no longer needed
# rm(Scotland_agesex, HB_agesex, LA_agesex, Totals, Agesex_all, Agesex, Scotland_new, HB_new, LA_new, Combined_new, Combined_totals,
#    Combined_previous, Combined_totals_previous, Combined_last_update, Combined_totals_last_update,
#    test_type_scotland, test_type_hb, test_type_ca, Combined_agesex, pcr_agesex, lfd_agesex, pcr_and_lfd_agesex)


#Save out a date reporting trend to interim files for checking

# date_reporting_trend <- g_cases_data %>%
#   group_by(date_reporting)%>%
#   summarise(positive = sum(flag_episode))%>%
#   mutate(date_reporting=as.Date(date_reporting))%>%
#   filter(date_reporting>as.Date(od_date)%m-% months(1))

# #Delete current  file in folder
# file.remove(glue("{svt_filepath}/Interim files/Date_reporting_trend.csv"))
# 
# write_csv(date_reporting_trend,glue("{svt_filepath}/Interim files/Date_reporting_trend.csv", na = ""))

# 
# #Remove files no longer needed
# rm(Scotland_agesex, HB_agesex, LA_agesex, Totals, Agesex_all, Agesex, Scotland_new, HB_new, LA_new, Combined_new, Combined_totals,
#    test_type_scotland, test_type_hb, test_type_ca, Combined_agesex, pcr_agesex, lfd_agesex, pcr_and_lfd_agesex, date_reporting_trend)



############## SIMD - Scotland only #####################

simd <- g_cases_data %>%
  group_by(simd)%>%
  summarise(total_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(percentage_reinfections = 100*reinfections/total_positive)%>%
  mutate(location_code="Scotland",geography="Scotland",location_name = "Scotland")%>%
  left_join(simd_pop_lookup,by=c("location_code","simd"))%>%
  mutate(crude_rate_positive=(total_positive/Pop)*100000)%>%
  filter(location_code!='NA',simd!='NA')%>%
  mutate(Date=od_date)%>%
  mutate(simd_analysis = case_when(simd == "1" ~"1 - most deprived",
                                   simd == "2" ~ "2",
                                   simd == "3" ~ "3",
                                   simd == "4" ~ "4",
                                   simd == "5" ~ "5 - least deprived"))%>%
  select(Date, geography, location_code, location_name, simd_analysis, total_positive,
         Pop, crude_rate_positive, first_infections, reinfections, percentage_reinfections)


# #Delete current rds file
# file.remove(glue("{svt_filepath}/Interim files/simd_latest.rds"))
# 
# #save out rds file.
# saveRDS(simd,glue("{svt_filepath}/Interim files/simd_latest.rds"))
# 
# #Delete current csv file in open data folder
# file.remove(glue("{svt_filepath}/Data/Files for open data/SIMD_latest_disclosure.csv"))
# 
# #save out csv file.
# write_csv(simd,glue("{svt_filepath}/Data/Files for open data/SIMD_latest_disclosure.csv"), na = "")
# 
# #save out dated csv file to archive folder.
# write_csv(simd,glue("{svt_filepath}/Data/Archive/{Date_today}_SIMD_latest.csv"), na = "")




####################### Age/sex trend   ##################

Scotland_agesex <- g_cases_data %>%
  group_by(Date,sex,agegroup_Scotland)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland")%>%
  rename(agegroup=agegroup_Scotland)

Scotland_age_total <- g_cases_data %>%
  group_by(Date,agegroup_Scotland)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total")%>%
  rename(agegroup=agegroup_Scotland)

Scotland_sex_total <- g_cases_data %>%
  group_by(Date,sex)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",agegroup="Total")

Scotland_total <- g_cases_data %>%
  group_by(Date)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total",agegroup="Total")

Scotland_agesex_60plus <- g_cases_data %>%
  filter(agegroup_Scotland_60plus!="")%>%
  group_by(Date,sex,agegroup_Scotland_60plus)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland")%>%
  rename(agegroup=agegroup_Scotland_60plus)

Scotland_age_60plus <- g_cases_data %>%
  filter(agegroup_Scotland_60plus!="")%>%
  group_by(Date,agegroup_Scotland_60plus)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total")%>%
  rename(agegroup=agegroup_Scotland_60plus)

HB_total <- g_cases_data %>%
  group_by(Date,hb2019)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  rename(location_code=hb2019)%>%
  mutate(agegroup="Total",sex="Total")

LA_total <- g_cases_data %>%
  group_by(Date,ca2019)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  rename(location_code=ca2019)%>%
  mutate(agegroup="Total",sex="Total")


#add files together
Agesex_all <- bind_rows(Scotland_agesex, Scotland_age_total, Scotland_sex_total, Scotland_total, Scotland_agesex_60plus, Scotland_age_60plus, HB_total, LA_total )%>%
  distinct(Date, location_code, sex, agegroup, daily_positive, first_infections, reinfections)%>%
  rename(total_daily_positive=daily_positive)


############ test type section ############


Scotland_test_type <- g_cases_data %>%
  group_by(Date,episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total",agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)

HB_test_type <- g_cases_data %>%
  group_by(Date, hb2019, episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total",agegroup="Total")%>%
  rename(test_type=episode_derived_case_type, location_code=hb2019)

LA_test_type <- g_cases_data %>%
  group_by(Date, ca2019, episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total", agegroup="Total")%>%
  rename(test_type=episode_derived_case_type, location_code=ca2019)

Test_type_trend <- rbind(Scotland_test_type,HB_test_type,LA_test_type)

pcr_trend <- Test_type_trend %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(pcr_daily_positive=daily_positive)

lfd_trend <- Test_type_trend %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(lfd_daily_positive=daily_positive)

pcr_and_lfd_trend <- Test_type_trend %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(pcr_and_lfd_daily_positive=daily_positive)


#Match data to trend lookup with all variables for all dates, calculate cumulatives, match on populations and calculate rates
Agesex_trend <- df_agesex %>%
  left_join(Agesex_all, by=c("Date","location_code","sex","agegroup"))%>%
  left_join(pcr_trend, by=c("Date","location_code","sex","agegroup"))%>%
  left_join(lfd_trend, by=c("Date","location_code","sex","agegroup"))%>%
  left_join(pcr_and_lfd_trend, by=c("Date","location_code","sex","agegroup"))%>%
  mutate_if(is.numeric, ~replace_na(., 0))%>%
  arrange(agegroup, sex, location_code, Date)%>%
  group_by(agegroup, sex, location_code)%>%
  mutate(total_cumulative_positive=cumsum(total_daily_positive), pcr_cumulative_positive=cumsum(pcr_daily_positive),
         lfd_cumulative_positive=cumsum(lfd_daily_positive), pcr_and_lfd_cumulative_positive=cumsum(pcr_and_lfd_daily_positive),
         first_infections_cumulative=cumsum(first_infections), reinfections_cumulative=cumsum(reinfections))%>%
  rename(first_infections_daily = first_infections, reinfections_daily = reinfections)%>%
  mutate(percentage_reinfections_daily = 100*reinfections_daily/total_daily_positive,
         percentage_reinfections_cumulative = 100*reinfections_cumulative/total_cumulative_positive)%>%
  filter(total_cumulative_positive!=0)%>%
  left_join(pop_lookup,by=c("location_code","sex","agegroup"))%>%
  mutate(total_cumulative_crude_rate_positive=(total_cumulative_positive/Pop)*100000,
         total_daily_crude_rate_positive=(total_daily_positive/Pop)*100000 )%>%
  left_join(location_names, by=c("location_code"))%>%
  mutate(location_name=case_when(is.na(location_name)~"Scotland", TRUE ~ location_name))%>%
  mutate(geography=case_when(location_code=="Scotland"~"Scotland",
                             substr(location_code,1,3)=="S08"~ "Health Board",
                             substr(location_code,1,3)=="S12"~"Local Authority"))%>%
  filter(Date>as.Date("2020/02/27") & Date<as.Date(od_sunday))%>% #making this go to sunday
  select(Date, location_code, location_name, geography, sex, agegroup,
         Pop, total_daily_positive, total_cumulative_positive, total_daily_crude_rate_positive, total_cumulative_crude_rate_positive,
         pcr_daily_positive, pcr_cumulative_positive,
         lfd_daily_positive, lfd_cumulative_positive,
         pcr_and_lfd_daily_positive, pcr_and_lfd_cumulative_positive,
         first_infections_daily, first_infections_cumulative, reinfections_daily, reinfections_cumulative,
         percentage_reinfections_daily, percentage_reinfections_cumulative)

###### Iain play with age sex trend ###########

##### change date equation to od_sunday+1 this gets data from the last Sunday. not clear if this what whas causing the problem

od_suppress_value <- function(data, col_name) {
  
  needs_suppressed = data[[col_name]] == "" | (data[[col_name]]<5)
  
  data %>% 
    mutate(data[col_name] == if_else(
      needs_suprressed, 0, ""
    ))
  
}


# # hackneyed attempt at a rounding function
# round_rate<-function(dataset){
#   dataset <- dataset %>%
#     mutate(rate=(as.numeric(rate)),
#            rate=(round_half_up(rate)))}









########################################################################
########### cases and case positives  trends_ lookups ###############
#Create trend look ups with all combinations of variables for all dates.
#Age/sex trend, SIMD trend and IZ trend.
######################################################################

# geography look ups

SPD <- readRDS("/conf/linkage/output/lookups/Unicode/Geography/Scottish Postcode Directory/Scottish_Postcode_Directory_2023_1.rds")

CA_lookup <-SPD %>%
  select(ca2019,ca2019name)%>%
  distinct(ca2019,ca2019name)%>%
  rename(local_authority=ca2019name)

HB_lookup<- SPD %>%
  select(hb2019,hb2019name)%>%
  distinct(hb2019,hb2019name)%>%
  mutate(reporting_health_board=str_replace_all(string=hb2019name, pattern="NHS ", repl=""))

IZ_pc_lookup <- SPD %>%
  select(pc7,ca2019,ca2019name,intzone2011) %>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl="")) %>%
  select(PostCode,intzone2011)

HBnames <- HB_lookup %>%
  select(hb2019,hb2019name)%>%
  rename(location_code=hb2019,location_name=hb2019name)

LAnames <- CA_lookup %>%
  rename(location_code=ca2019,location_name=local_authority)

location_names <- bind_rows(HBnames,LAnames)

rm(HBnames,LAnames,SPD)



# Reporting Dates 
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1
od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
od_sunday_minus_14 <- today() - 17
od_suppression_date <- "2023-05-31"


################# Cases #################################################################


#bring in the most up to date version
# i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

# use until lab data new generated on a Tues
i_cases <- read_all_excel_sheets(glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Data Folders/2023-06-28/Data/","Lab_Data_New_2023-06-27.xlsx"))


g_daily_cases_od <- i_cases$`Cumulative confirmed cases`

g_daily_cases_od %<>%
  rename(DailyCases="Number of cases per day",
         CumulativeCases=Cumulative)



############## load testing RTE dataset##################

#Flat file back up
#combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{date_to_use}.rds"))%>%

#Time_Series_Test_data <- readRDS("/PHI_conf/Real_Time_Epi/Data/PCR_Data/Time_Series_Test_data_2023-06-27.rds")

#use until RTE refreshed
i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_2023-06-27.rds") )

#i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )

g_daily_raw<- i_combined_pcr_lfd_tests %>% 
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex)) %>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))  %>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source)) %>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar)) 
# select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date, pillar) %>% 
#group_by(specimen_date) 


# match testing data to local authority and health board codes
g_daily_tests_geog <- g_daily_raw%>%
  left_join(CA_lookup,by="local_authority")%>%
  left_join(HB_lookup,by="reporting_health_board")%>%
  mutate(Date = as.Date(specimen_date)) %>%
  filter(Date <= as.Date(od_sunday))



Dates <- data.frame(SpecimenDate=seq(as.Date("2019/12/08"), as.Date(Sys.Date()), "day"))
Location_codes <- read.csv("//conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/location_codes.csv")%>%
  mutate(location_code=as.character(location_code))
SIMD <- data.frame(SIMD=seq(1,5,1))
Agegroups_Scotland <- data.frame(agegroup = c('0 to 14','15 to 19','20 to 24','25 to 44','45 to 64','65 to 74','75 to 84','85+','0 to 59','60+','Total'))%>%
  mutate(agegroup=as.character(agegroup))
Sex <- data.frame(sex = c('Female','Male','Total')) %>% mutate(sex=as.character(sex))
IZ_lookup <- read.csv(glue("//conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups/Intermediate zones.csv"))%>%
  rename(intzone2011=IntZone, intzone2011name=IntZoneName, ca2019=CA, ca2019name=CAName)


#SIMD trend lookup
df_simd <- expand.grid(Date=unique(Dates$SpecimenDate) , simd=unique(SIMD$SIMD),
                       KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  mutate(location_code="Scotland", simd=as.character(simd))

#Age sex trend lookups for Boards and Local Authorities
df_agesex_all <- expand.grid(Date=unique(Dates$SpecimenDate) , location_code=unique(Location_codes$location_code),
                             KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  filter(location_code!="Scotland")%>%
  mutate(agegroup="Total", sex="Total")

#Age sex trend lookup for Scotland
df_agesex_scotland <- expand.grid(Date=unique(Dates$SpecimenDate), location_code="Scotland",
                                  agegroup=unique(Agegroups_Scotland$agegroup),
                                  sex=unique(Sex$sex), KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)

#Combine Boards, Local Authorities and Scotland age sex trend lookups
df_agesex <- bind_rows(df_agesex_all,df_agesex_scotland)%>%
  distinct(Date,location_code,sex,agegroup)

#IZ trend lookups
df_iz <- expand.grid(Date=unique(Dates$SpecimenDate) , intzone2011=unique(IZ_lookup$intzone2011),
                     KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  filter(Date>as.Date("2020/02/27"))%>%
  left_join(IZ_lookup,by=c("intzone2011"))


#Remove files no longer needed
rm(SIMD, Agegroups_Scotland, Sex, df_agesex_all, df_agesex_scotland, IZ_lookup)



################### Cases data & positives  #####################

#Read in cases data, match on local authority, simd and filter deduped
g_cases_data <- g_daily_tests_geog %>%
  mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
  left_join(IZ_pc_lookup,by="PostCode") %>%
  left_join(simd_lookup,by="PostCode")%>%
  #left_join(CA_lookup,by="local_authority")%>%
  #left_join(HB_lookup,by="reporting_health_board") %>%
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0),
         flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
         flag_reinfection = ifelse(episode_number_deduplicated>1,1,0))%>%
  #filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday))


############ test type section############


Scotland_test_type <- g_cases_data %>%
  group_by(Date,episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total",agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)

HB_test_type <- g_cases_data %>%
  group_by(Date, hb2019, episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total",agegroup="Total")%>%
  rename(test_type=episode_derived_case_type, location_code=hb2019)

LA_test_type <- g_cases_data %>%
  group_by(Date, ca2019, episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(sex="Total", agegroup="Total")%>%
  rename(test_type=episode_derived_case_type, location_code=ca2019)

Test_type_trend <- rbind(Scotland_test_type,HB_test_type,LA_test_type)

pcr_trend <- Test_type_trend %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(pcr_daily_positive=daily_positive)

lfd_trend <- Test_type_trend %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(lfd_daily_positive=daily_positive)

pcr_and_lfd_trend <- Test_type_trend %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(pcr_and_lfd_daily_positive=daily_positive)

g_scotland_test_type_trend<- g_cases_data %>%
  group_by(Date,episode_derived_case_type)%>%
  summarise(daily_positive = sum(flag_episode), first_infections = sum(flag_first_infection),
            reinfections = sum(flag_reinfection))%>%
  mutate(location_code="Scotland",sex="Total",agegroup="Total")%>%
  rename(test_type=episode_derived_case_type)


########################## make daily file  ################# 

## functions ##

od_suppress_value <- function(data, col_name) {
  
  needs_suppressed = data[[col_name]] == "" | (data[[col_name]]<5)
  
  data %>% 
    mutate(data[col_name] == if_else(
      needs_suprressed, 0, data[col_name]
    ))
  
}

od_qualifiers <- function(data, col_name, symbol) {
  
  needs_symbol = data[[col_name]] == "" | is.na(data[[col_name]])
  
  data %>% 
    mutate("{col_name}QF" := if_else(
      needs_symbol, symbol, ""
    ))
  
}


#### 

g_scotland_pcr_trend <- g_scotland_test_type_trend %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(PCROnly=daily_positive)

g_scotland_lfd_positve_trend <- g_scotland_test_type_trend %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections)%>%
  rename(LFDOnly=daily_positive)

g_scotland_lfdpcr_positve_trend <- g_scotland_test_type_trend %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type, -first_infections, -reinfections, )%>%
  rename(LFDAndPCR =daily_positive, )
  
g_daily_scotland_test_trend<- df_agesex %>%
  filter(location_code=="Scotland", sex=="Total", agegroup=="Total") %>% 
 # select(-sex, -agegroup) %>% 
  #  left_join(Agesex_all, by=c("Date","location_code","sex","agegroup"))%>% #adds daily positives and reinfections
  left_join(g_scotland_pcr_trend, by=c("Date","location_code", "sex", "agegroup")) %>%  # add PCR positives
  left_join(g_scotland_lfd_positve_trend , by=c("Date","location_code", "sex", "agegroup")) %>% # add LDD positives
  left_join(g_scotland_lfdpcr_positve_trend, by=c("Date","location_code", "sex", "agegroup")) %>% 
    filter(Date>as.Date("2020/02/27") & Date<as.Date(od_sunday+1)) %>% 
  select(-sex, -agegroup) %>% 
 # mutate(LFDAndPCR_orig= LFDAndPCR) %>% 
#  od_suppress_value(., "LFDAndPCR") %>% 
  left_join(g_daily_cases_od, by="Date") %>%  
  # mutate(DailyCases= ifelse (Date > as.Date(od_suppression_date) & DailyCases <5, 0,LFDAndPCR),
  #        PCROnly= ifelse (Date > as.Date(od_suppression_date) & PCROnly <5, 0,LFDAndPCR),
  #        LFDOnly= ifelse (Date > as.Date(od_suppression_date) & LFDOnly <5, 0,LFDAndPCR),
  #        LFDAndPCR= ifelse (Date > as.Date(od_suppression_date) & LFDAndPCR <5, 0,LFDAndPCR)) %>%
  mutate_if(is.numeric, ~replace_na(., 0)) %>%
  # od_qualifiers(., "DailyCases", "c") %>% 
  # od_qualifiers(., "PCROnly", "c") %>% 
  # od_qualifiers(., "LFDOnly", "c") %>% 
  # od_qualifiers(., "LFDAndPCR", "c") 
  #filter(Date>as.Date("2023/06/20") & Date<as.Date(od_sunday+1)) %>%  # change date equation to od_sunday+1 this gets data from the last Sunday. not clear if this what what's causing the problem 
    arrange(Date) %>%
  group_by(location_code)%>%
  mutate(#total_cumulative_positive=cumsum(total_daily_positive), 
    PCROnlyCummualtive= cumsum(PCROnly),
    LFDOnlyCummualtive= cumsum(LFDOnly), 
    LFDAndPCRCummualtive= cumsum(LFDAndPCR) ) %>%
  #first_infections_cumulative=cumsum(first_infections),
  #reinfections_cumulative=cumsum(reinfections)
    ungroup() %>% 
  select(Date,
         PCROnly,  PCROnlyCummualtive,
         LFDOnly, LFDOnlyCummualtive,
         LFDAndPCR, LFDAndPCRCummualtive,
       DailyCases,CumulativeCases # add in QFs for each test type e.g. DailyCasesQF,
       )
  
  
  




############################




# #save out csv file.
# #write_csv(Agesex_trend,glue("{svt_filepath}/Data/{Date_today}_Agesex_trend.csv"))
# 
# #Delete current rds file
# file.remove(glue("{svt_filepath}/Interim files/Agesex_trend.rds"))
# 
# #save out rds file.
# saveRDS(Agesex_trend,glue("{svt_filepath}/Interim files/Agesex_trend.rds"))
# 
# 
# #Remove files no longer needed
# rm(Scotland_agesex, Scotland_age_total, Scotland_sex_total, Scotland_total, Scotland_agesex_60plus, Scotland_age_60plus,
#    HB_total, LA_total, Agesex_all, df_agesex, Scotland_test_type, HB_test_type, LA_test_type)



##############################################################
#Seven Day rates
#############################################################

Seven_day <- Agesex_trend %>%
  filter(sex=="Total" & agegroup=="Total")%>%
  filter(Date > as.Date(od_date-10) & Date < as.Date(od_date-2))%>% # previously date_today-10 and date today-2
  group_by(location_code, location_name)%>%
  summarise(total_positive=sum(total_daily_positive), Pop=mean(Pop))%>%
  mutate(crude_rate_positive=(total_positive/Pop)*100000)

# #Delete current csv file in Data folder
# file.remove(glue("{svt_filepath}/Data/Seven_day_counts.csv"))
# 
# #save out csv file
# write_csv(Seven_day,glue("{svt_filepath}/Data/Seven_day_counts.csv"))
# 
# #save out dated csv file to archive folder
# write_csv(Seven_day,glue("{svt_filepath}/Data/Archive/{Date_today}_Seven_day_counts.csv"))

#Remove files no longer needed
#rm(Seven_day)


#############################################################
#SIMD trend - Scotland only
#############################################################

simd_scotland_trend <- g_cases_data %>%
  group_by(Date,simd)%>%
  summarise(daily_positive = sum(flag_episode), first_infections_daily = sum(flag_first_infection),
            reinfections_daily = sum(flag_reinfection))%>%
  mutate(location_code="Scotland")

simd_trend <- df_simd %>%
  left_join(simd_scotland_trend, by=c("Date","location_code","simd"))%>%
  mutate_if(is.numeric, ~replace_na(., 0))%>%
  arrange(simd, location_code, Date)%>%
  group_by(simd, location_code)%>%
  mutate(cumulative_positive=cumsum(daily_positive),
         first_infections_cumulative = cumsum(first_infections_daily),
         reinfections_cumulative = cumsum(reinfections_daily))%>%
  mutate(percentage_reinfections_daily = 100*reinfections_daily/daily_positive,
         percentage_reinfections_cumulative = 100*reinfections_cumulative/cumulative_positive)%>%
  filter(cumulative_positive!=0)%>%
  left_join(simd_pop_lookup,by=c("location_code","simd"))%>%
  mutate(cumulative_crude_rate_positive=(cumulative_positive/Pop)*100000,
         daily_crude_rate_positive=(daily_positive/Pop)*100000)%>%
  mutate(location_name="Scotland", geography="Scotland")%>% 
  filter(Date>as.Date("2020/02/27") & Date<as.Date(od_date-1))%>% # check what original 2nd date filter  pointed to : Date<as.Date(yesterday)
  select(Date, location_code, location_name, geography, simd, Pop, daily_positive, cumulative_positive,
         daily_crude_rate_positive, cumulative_crude_rate_positive,
         first_infections_daily, first_infections_cumulative, reinfections_daily, reinfections_cumulative,
      percentage_reinfections_daily, percentage_reinfections_cumulative)
# 
# #Delete current rds file
# file.remove(glue("{svt_filepath}/Interim files/simd_trend.rds"))
# 
# #save out rds file.
# saveRDS(simd_trend,glue("{svt_filepath}/Interim files/simd_trend.rds"))
# 
# #Remove files no longer needed
# rm(simd_scotland_trend, df_simd)


#############################################################
#Cases by Neighbourhood
#############################################################

# Intzone <- cases_data %>%
#   group_by(Date,intzone2011)%>%
#   summarise(daily_positive = sum(flag_episode))
# 
# Intzone_trend <- df_iz %>%
#   left_join(Intzone, by=c("Date","intzone2011"))%>%
#   mutate(daily_positive = replace(daily_positive, is.na(daily_positive), 0))%>%
#   left_join(IZ_pop_lookup, by=c("intzone2011")) %>%
#   mutate(positive_7day=ifelse(intzone2011==lag(intzone2011,6),
#                               daily_positive + lag(daily_positive,1)+ lag(daily_positive,2) + lag(daily_positive,3) +
#                                 lag(daily_positive,4)  + lag(daily_positive,5) + lag(daily_positive,6),NA))%>%
#   mutate(positive_crude_rate_7day = (positive_7day/Pop)*100000)%>%
#   filter(Date>as.Date("2020/03/04") & Date<as.Date(Date_today-2))%>%
#   mutate(intzone_flag = case_when(positive_crude_rate_7day == 0 ~ "0",
#                                   positive_crude_rate_7day >0 & positive_crude_rate_7day < 50 ~ "1 to 49",
#                                   positive_crude_rate_7day >=50 & positive_crude_rate_7day < 100 ~ "50 to 99",
#                                   positive_crude_rate_7day >=100 & positive_crude_rate_7day < 200 ~ "100 to 199",
#                                   positive_crude_rate_7day >=200 & positive_crude_rate_7day < 400 ~ "200 to 399",
#                                   positive_crude_rate_7day >=400 & positive_crude_rate_7day < 800 ~ "400 to 799",
#                                   positive_crude_rate_7day >=800 ~ "800+"))
# 
# Intzone_trend_suppressed <- Intzone_trend %>%
#   group_by(Date,ca2019)%>%
#   mutate(positive_7day_la=sum(positive_7day))%>%
#   mutate(positive_7day_supressed = ifelse(positive_7day>=3, as.character(positive_7day), ""))%>%
#   mutate(intzone_flag_supressed = ifelse(positive_7day>=3, intzone_flag, ""))%>%
#   filter(positive_7day_la>=5)%>%
#   select(Date, intzone2011, intzone2011name, ca2019, ca2019name,	positive_7day_supressed, Pop, intzone_flag_supressed)%>%
#   rename(positive_7day=positive_7day_supressed, intzone_flag=intzone_flag_supressed)

# #Delete current IZ file in open data folder
# file.remove(glue("{svt_filepath}/Data/Files for open data/IntZone_7day_full_trend.csv"))
# 
# #save out full trend csv file for open data.
# write_csv(Intzone_trend_suppressed,glue("{svt_filepath}/Data/Files for open data/IntZone_7day_full_trend.csv", na = ""))
# 
# #Unsuppressed IZ data
# Intzone_trend <- Intzone_trend %>%
#   select(Date, intzone2011, intzone2011name, ca2019, ca2019name, positive_7day, Pop, intzone_flag)
# 
# #save out unsuppressed csv file - used in community testing.
# write_csv(Intzone_trend,glue("{svt_filepath}/Data/Archive/{Date_today}_IntZone_7day_unsuppressed.csv", na = ""))
# 
# #Delete current IZ file in Data folder
# file.remove(glue("{svt_filepath}/Data/IntZone_7day.csv"))
# 
# #Save out 6 month version of file for Dashboard
# Intzone_trend_suppressed <- Intzone_trend_suppressed %>%
#   filter(Date>as.Date(Date_today-4)%m-% months(6))
# 
# write_csv(Intzone_trend_suppressed,glue("{svt_filepath}/Data/IntZone_7day.csv", na = ""))
# 
# #Remove files no longer needed
# rm(Intzone_trend_suppressed,Intzone_trend,df_iz)


#############################################################
#Monitoring Local Authorities
#############################################################

LA_trend <- Agesex_trend %>%
  filter(agegroup=="Total", sex=="Total", geography!="Health Board") %>%
  select(Date,	geography,	location_code,	location_name, total_daily_positive, Pop)%>%
  rename(daily_positive=total_daily_positive)%>%
  ungroup()%>%
  arrange(location_code, Date) %>%
  mutate(positive_7day=ifelse(location_code==lag(location_code,6),
                              daily_positive + lag(daily_positive,1)+ lag(daily_positive,2) + lag(daily_positive,3) +
                                lag(daily_positive,4)  + lag(daily_positive,5) + lag(daily_positive,6),NA))%>%
  mutate(positive_crude_rate_7day = (positive_7day/Pop)*100000) %>%
  filter(Date>as.Date("2020/03/04") & Date<as.Date(od_date-2))%>% #previously Date_today-2
  mutate(Status_Label = case_when(positive_crude_rate_7day == 0 ~ "0",
                                  positive_crude_rate_7day >0 & positive_crude_rate_7day < 50 ~ "1 to 49",
                                  positive_crude_rate_7day >=50 & positive_crude_rate_7day < 100 ~ "50 to 99",
                                  positive_crude_rate_7day >=100 & positive_crude_rate_7day < 200 ~ "100 to 199",
                                  positive_crude_rate_7day >=200 & positive_crude_rate_7day < 400 ~ "200 to 399",
                                  positive_crude_rate_7day >=400 & positive_crude_rate_7day < 800 ~ "400 to 799",
                                  positive_crude_rate_7day >=800 ~ "800+",
                                  location_code=="Scotland" ~ ""))%>%
  select(Date,	geography,	location_code,	location_name,	Status_Label,	Pop,	positive_7day, positive_crude_rate_7day)





# 
# 
# #############################################################
# #CREATE DAILY UPDATE FILE
# #############################################################
# 
# g_daily_update <- Agesex_all %>%
#   filter(location_code== "Scotland",sex=="Total", agegroup=="Total")
# 
# 
# ################ create Scotland daily cases for Daily file#################
# 
# # g_scotland_cases <- g_cases_data  %>%
# #   filter(location_code== "Scotland",sex=="Total", agegroup_Scotland=="Total") %>% 
# #   group_by(Date,sex,agegroup_Scotland)%>%
# #   summarise(DailyCases = sum(flag_episode), first_infections = sum(flag_first_infection),
# #             reinfections = sum(flag_reinfection)) %>%
# #   mutate(location_code="Scotland")%>%
# #  # filter(location_code== "Scotland",sex=="Total", agegroup_Scotland=="Total") %>% 
# # rename(agegroup=agegroup_Scotland)
# 
# 
# # g_scotland_daily_cases <- g_cases_data %>%
# #   group_by(Date)%>% 
# #   summarise(total_positive = sum(flag_episode)) %>% 
# #             #, first_infections = sum(flag_first_infection),
# #             #reinfections = sum(flag_reinfection))%>%
# #   mutate(location_code="Scotland",geography="Scotland")
# #  # rename(agegroup=agegroup_Scotland)
# 
# Daily_update <- Daily_update %>%
#   mutate(positive_7day_average = total_new_positive/7,
#          pcr_positive_7day_average  = pcr_new_positive/7,
#          lfd_positive_7day_average  = lfd_new_positive/7,
#          pcr_and_lfd_positive_7day_average  = pcr_and_lfd_new_positive/7,
#          first_infections_7day_average  = new_first_infections/7,
#          reinfections_7day_average  = new_reinfections/7,
#          percentage_reinfections_7day_average  = percentage_new_reinfections)%>%
#   mutate(positive_cases_7day_percentage_change = (100*(total_new_positive - total_previous_positive)/total_previous_positive))%>%
#   select(-total_new_positive, -total_previous_positive, -pcr_new_positive, -lfd_new_positive, -pcr_and_lfd_new_positive,
#          -new_first_infections, -new_reinfections, -percentage_new_reinfections)
# 
# #Read in testing data and match on to daily update
# TestingData <- readRDS(glue("{svt_filepath}/Interim files/Testing data.rds"))%>%
#   filter(Data_type=="Cumulatives")%>%
#   select(-Data_type,-Date) %>%
#   mutate(total_positive_tests_7day_average = total_positive_tests_new/7,
#          pillar1_positive_tests_7day_average = pillar1_positive_tests_new/7,
#          pillar2_positive_tests_7day_average = pillar2_positive_tests_new/7,
#          lfd_positive_tests_7day_average = lfd_positive_tests_new/7)%>%
#   mutate(positive_tests_7day_percentage_change = (100*(total_positive_tests_new - total_positive_tests_previous)/total_positive_tests_previous))%>%
#   select(-total_positive_tests_new, -pillar1_positive_tests_new, -pillar2_positive_tests_new, -lfd_positive_tests_new,
#          -total_positive_tests_previous, -pillar1_positive_tests_previous, -pillar2_positive_tests_previous, -lfd_positive_tests_previous,
#          -total_positive_tests_7day)
# 
# Daily_update <- Daily_update %>%
#   left_join(TestingData, by=c("location_code"))%>%
#   left_join(hospital_admissions_latest, by=c("location_code"))%>%
#   left_join(ICU_admissions_latest, by=c("location_code"))%>%
#   ungroup()%>%
#   mutate(hospital_admissions_7day_average = hospital_admissions_7day/7,
#          ICU_admissions_7day_average = ICU_admissions_7day/7,
#          hospital_admissions_7day_total = hospital_admissions_7day,
#          ICU_admissions_7day_total = ICU_admissions_7day)%>%
#   select(-hospital_admissions_7day, -ICU_admissions_7day)%>%
#   arrange(Date,location_code,location_name,geography) %>%
#   left_join(hospital_occupancy_latest, by=c("location_name")) %>%
#   left_join(ONS_survey_latest, by=c("location_code"))%>%
#   arrange(desc(location_code))



#Delete current csv file in Data folder
# file.remove(glue("{svt_filepath}/Data/Daily_update.csv"))
# 
# #save out csv file.
# write_csv(Daily_update,glue("{svt_filepath}/Data/Daily_update.csv"), na = "")
# 
# #save out dated csv file to archive.# write_csv(Daily_update,glue("{svt_filepath}/Data/Archive/{Date_today}_Daily_update.csv"), na = "")
# 
# 
# daily_update_part <- daily_update %>% 
#   filter(location_name == "Scotland") %>% 
#   select(PCROnly = pcr_positive_7day_average,
#          LFDAndPCR = pcr_and_lfd_positive_7day_average,
#          LFDOnly = lfd_positive_7day_average,
#          ReportedCases = positive_7day_average,
#          DailyPercentReinfections = percentage_reinfections_7day_average,
#          CumulativeReportedCases = total_positive,
#          CumulativePercentReinfections = percentage_reinfections) %>% 
#   mutate(PCROnly = round_half_up(PCROnly),
#          LFDAndPCR = round_half_up(LFDAndPCR),
#          LFDOnly = round_half_up(LFDOnly),
#          ReportedCases = round_half_up(ReportedCases),
#          DailyPercentReinfections = paste0(as.character(round_half_up(DailyPercentReinfections,2)),"%"),
#          CumulativeReportedCases = round_half_up(CumulativeReportedCases),
#          CumulativePercentReinfections = paste0(as.character(round_half_up(CumulativePercentReinfections,2)),"%"))



#############################################################
#CREATE TREND FILE
#############################################################

Tests_trend <-Data_combined %>%
  mutate(Date=as.character(Date))%>%mutate(Date=as.Date(Date))  %>%
  filter(Data_type=="Trend") %>%
  mutate(sex="Total",agegroup="Total")%>%
  select(Date, location_code, sex, agegroup, total_positive_tests, pillar1_positive_tests,
         pillar2_positive_tests, lfd_positive_tests)

Trend <-Agesex_trend%>%
  left_join(Tests_trend, by=c("location_code","Date","sex","agegroup"))%>%
  arrange(agegroup,sex,location_code,Date)%>%
  mutate(Date_seven=Date-6) %>%
  mutate(total_positive_tests = replace(total_positive_tests, is.na(total_positive_tests), 0))%>%
  mutate(total_positive_tests_7day=ifelse((Date_seven==lag(Date,6) & location_code==lag(location_code,6)),
                                          total_positive_tests + lag(total_positive_tests,1)+ lag(total_positive_tests,2) + lag(total_positive_tests,3) +
                                            lag(total_positive_tests,4)  + lag(total_positive_tests,5) + lag(total_positive_tests,6), NA))%>%
  mutate(total_positive_7day=ifelse(Date_seven==lag(Date,6) & location_code==lag(location_code,6) & agegroup==lag(agegroup,6) & sex==lag(sex,6),
                                    total_daily_positive + lag(total_daily_positive,1)+ lag(total_daily_positive,2) + lag(total_daily_positive,3) +
                                      lag(total_daily_positive,4)  + lag(total_daily_positive,5) + lag(total_daily_positive,6), NA))%>%
  mutate(total_crude_rate_positive_7day=(total_positive_7day/Pop)*100000)%>%
  #left_join(hospital_admissions_trend, by=c("location_code","Date","sex","agegroup"))%>%
#  left_join(ICU_admissions_trend, by=c("location_code","Date","sex","agegroup"))%>%
  arrange(Date,location_code,location_name,geography,sex,agegroup)%>%
  mutate(pcr_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_daily_positive),
         pcr_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_cumulative_positive),
         lfd_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_daily_positive),
         lfd_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_cumulative_positive),
         pcr_and_lfd_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_and_lfd_daily_positive),
         pcr_and_lfd_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_and_lfd_cumulative_positive),
         lfd_positive_tests=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_positive_tests))%>%
 # mutate(daily_deaths=ifelse(Date>as.Date("2022/06/01"),NA,daily_deaths),
  #       cumulative_deaths=ifelse(Date>as.Date("2022/06/01"),NA,cumulative_deaths),
   #      crude_rate_deaths=ifelse(Date>as.Date("2022/06/01"),NA,crude_rate_deaths))%>%
  select(Date,location_code,location_name,geography,sex,agegroup, Pop,
         total_daily_positive, total_cumulative_positive, total_daily_crude_rate_positive, total_cumulative_crude_rate_positive,
         total_positive_7day, total_crude_rate_positive_7day,
         pcr_daily_positive, pcr_cumulative_positive,
         lfd_daily_positive, lfd_cumulative_positive,
         pcr_and_lfd_daily_positive, pcr_and_lfd_cumulative_positive,
         first_infections_daily, first_infections_cumulative, reinfections_daily, reinfections_cumulative,
         percentage_reinfections_daily, percentage_reinfections_cumulative,
        # daily_deaths, cumulative_deaths, crude_rate_deaths,
         total_positive_tests, pillar1_positive_tests, pillar2_positive_tests, lfd_positive_tests, total_positive_tests_7day,
        # hospital_admissions,ICU_admissions
        ) %>%
 # left_join(Total_Occupancy, by=c("location_name","Date","sex","agegroup","geography"))%>%
  # left_join(ONS_survey_trend, by=c("location_code","Date","sex","agegroup"))%>%
  arrange(agegroup,sex,location_code,Date) 





# %>% 
#   mutate(total_positive_tests_7day=ifelse(Date>as.Date("2022/09/11"),NA,total_positive_tests_7day),
#          lfd_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,lfd_positive_tests),
#          pillar2_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,pillar2_positive_tests),
#          pillar1_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,pillar1_positive_tests),
#          total_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,total_positive_tests),
#          percentage_reinfections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,percentage_reinfections_cumulative),
#          percentage_reinfections_daily=ifelse(Date>as.Date("2022/09/11"),NA,percentage_reinfections_daily),
#          reinfections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,reinfections_cumulative),
#          reinfections_daily=ifelse(Date>as.Date("2022/09/11"),NA,reinfections_daily),
#          first_infections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,first_infections_cumulative),
#          first_infections_daily=ifelse(Date>as.Date("2022/09/11"),NA,first_infections_daily),
#          pcr_and_lfd_cumulative_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_and_lfd_cumulative_positive),
#          pcr_cumulative_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_cumulative_positive),
#          pcr_daily_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_daily_positive),
#          lfd_daily_positive=ifelse(Date>as.Date("2022/09/11"),NA,lfd_daily_positive),
#          total_crude_rate_positive_7day=ifelse(Date>as.Date("2022/09/11"),NA,total_crude_rate_positive_7day))
# 

# g_daily_file_tests<-Trend %>% 
#   filter(location_code=="Scotland", sex=="Total",agegroup=="Total") %>% 
#  # filter(Date=="2023-06-24") %>% 
#   select(pcr_daily_positive,
#          pcr_cumulative_positive,
#          lfd_daily_positive,
#          lfd_cumulative_positive,
#          pcr_and_lfd_daily_positive,
#          pcr_and_lfd_cumulative_positive)















#Trend extract used for tables, ignore
# Trend_extract <- Agesex_trend%>%
#   left_join(Tests_trend, by=c("location_code","Date","sex","agegroup"))%>%
#   arrange(agegroup,sex,location_code,Date)%>%
#   mutate(Date_seven=Date-6)%>%
#   mutate(total_positive_tests = replace(total_positive_tests, is.na(total_positive_tests), 0))%>%
#   mutate(total_positive_tests_7day=ifelse((Date_seven==lag(Date,6) & location_code==lag(location_code,6)),
#                                           total_positive_tests + lag(total_positive_tests,1)+ lag(total_positive_tests,2) + lag(total_positive_tests,3) +
#                                             lag(total_positive_tests,4)  + lag(total_positive_tests,5) + lag(total_positive_tests,6), NA))%>%
#   mutate(total_positive_7day=ifelse(Date_seven==lag(Date,6) & location_code==lag(location_code,6) & agegroup==lag(agegroup,6) & sex==lag(sex,6),
#                                     total_daily_positive + lag(total_daily_positive,1)+ lag(total_daily_positive,2) + lag(total_daily_positive,3) +
#                                       lag(total_daily_positive,4)  + lag(total_daily_positive,5) + lag(total_daily_positive,6), NA))%>%
#   mutate(total_crude_rate_positive_7day=(total_positive_7day/Pop)*100000)%>%
##  left_join(hospital_admissions_trend, by=c("location_code","Date","sex","agegroup"))%>%
 ## left_join(ICU_admissions_trend, by=c("location_code","Date","sex","agegroup"))%>%
  # arrange(Date,location_code,location_name,geography,sex,agegroup)%>%
  # mutate(pcr_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_daily_positive),
  #        pcr_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_cumulative_positive),
  #        lfd_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_daily_positive),
  #        lfd_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_cumulative_positive),
  #        pcr_and_lfd_daily_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_and_lfd_daily_positive),
  #        pcr_and_lfd_cumulative_positive=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,pcr_and_lfd_cumulative_positive),
  #        lfd_positive_tests=ifelse((Date<as.Date("2022/01/05")|agegroup!="Total"|sex!="Total"),NA,lfd_positive_tests))%>%
##  mutate(daily_deaths=ifelse(Date>as.Date("2022/06/01"),NA,daily_deaths),
 ##        cumulative_deaths=ifelse(Date>as.Date("2022/06/01"),NA,cumulative_deaths),
  ##       crude_rate_deaths=ifelse(Date>as.Date("2022/06/01"),NA,crude_rate_deaths))%>%
  # select(Date,location_code,location_name,geography,sex,agegroup, Pop,
  #        total_daily_positive, total_cumulative_positive, total_daily_crude_rate_positive, total_cumulative_crude_rate_positive,
  #        total_positive_7day, total_crude_rate_positive_7day,
  #        pcr_daily_positive, pcr_cumulative_positive,
  #        lfd_daily_positive, lfd_cumulative_positive,
  #        pcr_and_lfd_daily_positive, pcr_and_lfd_cumulative_positive,
  #        first_infections_daily, first_infections_cumulative, reinfections_daily, reinfections_cumulative,
  #        percentage_reinfections_daily, percentage_reinfections_cumulative,
       # # daily_deaths, cumulative_deaths, crude_rate_deaths,
         # total_positive_tests, pillar1_positive_tests, pillar2_positive_tests, lfd_positive_tests, total_positive_tests_7day,
   ##      hospital_admissions,ICU_admissions
 #  ) %>%
 # #left_join(Total_Occupancy, by=c("location_name","Date","sex","agegroup","geography"))%>%
 # #left_join(ONS_survey_trend, by=c("location_code","Date","sex","agegroup"))%>%
  # arrange(agegroup,sex,location_code,Date)%>%
  # mutate(total_positive_tests_7day=ifelse(Date>as.Date("2022/09/11"),NA,total_positive_tests_7day),
  #        lfd_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,lfd_positive_tests),
  #        pillar2_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,pillar2_positive_tests),
  #        pillar1_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,pillar1_positive_tests),
  #        total_positive_tests=ifelse(Date>as.Date("2022/09/11"),NA,total_positive_tests),
  #        percentage_reinfections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,percentage_reinfections_cumulative),
  #        percentage_reinfections_daily=ifelse(Date>as.Date("2022/09/11"),NA,percentage_reinfections_daily),
  #        reinfections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,reinfections_cumulative),
  #        reinfections_daily=ifelse(Date>as.Date("2022/09/11"),NA,reinfections_daily),
  #        first_infections_cumulative=ifelse(Date>as.Date("2022/09/11"),NA,first_infections_cumulative),
  #        first_infections_daily=ifelse(Date>as.Date("2022/09/11"),NA,first_infections_daily),
  #        pcr_and_lfd_cumulative_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_and_lfd_cumulative_positive),
  #        pcr_cumulative_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_cumulative_positive),
  #        pcr_daily_positive=ifelse(Date>as.Date("2022/09/11"),NA,pcr_daily_positive),
  #        lfd_daily_positive=ifelse(Date>as.Date("2022/09/11"),NA,lfd_daily_positive),
  #        total_crude_rate_positive_7day=ifelse(Date>as.Date("2022/09/11"),NA,total_crude_rate_positive_7day))


# 
# #Delete current csv file in Data folder
# file.remove(glue("{svt_filepath}/Data/Trend.csv"))
# 
# #save out csv file for open data
# write_csv(Trend,glue("{svt_filepath}/Data/Trend.csv"), na = "")
# 
# #save out csv file for Tableau
# write_csv(Trend_extract,glue("{svt_filepath}/Data/Trend_extract.csv"), na = "")
# 
# 
# #save out dated csv file to archive.
# write_csv(Trend,glue("{svt_filepath}/Data/Archive/{Date_today}_Trend.csv"), na = "")


#################end of script  #######################