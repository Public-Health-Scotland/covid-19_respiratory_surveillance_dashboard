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





########################################################################
########### cases and case positives  trends_ lookups ###############
#Create trend look ups with all combinations of variables for all dates.
#Age/sex trend, SIMD trend and IZ trend.
######################################################################


##### Reporting dates  & functions #######################################

#set dates

# od_date <- floor_date(today(), "week", 1) + 1
# od_sunday<- floor_date(today(), "week", 1) -1
# od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
# od_sunday_minus_14 <- today() - 17
# od_suppression_date <- "2023-05-31"

# functions 
# work in progress to create function that will suppress all values < cset value

# od_suppress_value <- function(data, col_name) {
#   needs_suppressed = data[[col_name]] == "" | (data[[col_name]]<5)
#   data %>%
#     mutate(data[col_name] == if_else( needs_suprressed, "", data[col_name] ))
# }

#add qf column to inputed column that meets a null criteria

# od_qualifiers <- function(data, col_name, symbol) {
#   needs_symbol = data[[col_name]] == "" | is.na(data[[col_name]])
#   data %>% 
#     mutate("{col_name}QF" := if_else(needs_symbol, symbol, ""))
# }     


##### Cases #################################################################


#bring in the most up to date version

 # i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

# g_daily_cases_od <- i_cases$`Cumulative confirmed cases`
# 
# g_daily_cases_od %<>%
#   rename(DailyCases="Number of cases per day",
#          CumulativeCases=Cumulative)


##### load testing RTE dataset ##################

#Flat file back up
#i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{date_to_use}.rds"))%>%

#Time_Series_Test_data <- readRDS("/PHI_conf/Real_Time_Epi/Data/PCR_Data/Time_Series_Test_data_2023-06-27.rds")

#use until RTE refreshed

#i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )

# g_daily_raw <- i_combined_pcr_lfd_tests %>% 
#   mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex)) %>%
#   mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
#                                  test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))  %>%
#   mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
#                                  (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
#                                  TRUE~test_source)) %>%
#   mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
#   mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar)) %>% 
#   select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date,
#          test_result, Sex, age, date_reporting, date_test_received_at_bi,
#          test_result_record_source, laboratory_code, pillar, flag_covid_case,
#          derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)


##### Create  cases & test type by day  ##############################
# don't need this as using existing daily and cumulative cases'
# # g_daily_cases<- g_daily_raw %>%
#   mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
#          flag_episode = ifelse(episode_number_deduplicated>0,1,0),
#          flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
#          flag_reinfection = ifelse(episode_number_deduplicated>1,1,0))%>%
#   #filter(episode_number_deduplicated != 0) %>%
#   filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
#                                          "Outside UK",NA))) %>%
#   mutate(Date=as.Date(specimen_date)) %>%
#   filter(Date <= as.Date(od_sunday))%>%
#   group_by(Date)%>%
#   summarise(daily_positive = sum(flag_episode)) %>%
#   ungroup()


###### Cases data & positives #######################################
 #keep hold of this but not needed if using existing daily cases
# but need it for test type

#Read in cases data, match on local authority, simd and filter deduped

# g_cases_data <- g_daily_raw %>%
#   mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
#   mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
#          flag_episode = ifelse(episode_number_deduplicated>0,1,0))%>%
#    #filter(episode_number_deduplicated != 0) %>% # not needed
#   filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
#                                          "Outside UK",NA))) %>%
#   mutate(Date=as.Date(specimen_date)) %>%
#   filter(Date <= as.Date(od_sunday))



##### make daily file #######################################
# this is the starter to split out different test type positives

# g_daily_test_type_all<- g_cases_data %>% 
#   group_by(Date,episode_derived_case_type)%>%
#   summarise(daily_positive = sum(flag_episode))%>%
#   mutate(location_code="Scotland",sex="Total",agegroup="Total")%>%
#   rename(test_type=episode_derived_case_type)
# 
# g_daily_pcr_test_type <- g_daily_test_type_all %>%
#   filter(test_type=="PCR POSITIVE CASE")%>%
#   select(-test_type)%>%
#   rename(PCROnly=daily_positive)
# 
# g_daily_lfd_test_type <- g_daily_test_type_all %>%
#   filter(test_type=="ANTIGEN POSITIVE CASE")%>%
#   select(-test_type)%>%
#   rename(LFDOnly=daily_positive)
# 
# g_daily_lfdpcr_test_type <- g_daily_test_type_all %>%
#   filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
#   select(-test_type)%>%
#   rename(LFDAndPCR =daily_positive )
# 
# g_daily_test_type<- g_daily_pcr_test_type %>%
#   left_join(g_daily_lfd_test_type , by=c("Date","location_code", "sex", "agegroup")) %>% # add LFD positives
#   left_join(g_daily_lfdpcr_test_type, by=c("Date","location_code", "sex", "agegroup")) %>%  # PCR positives
#   select(-sex, -agegroup) %>%
#   left_join(g_daily_cases_od, by="Date")  # add daily and cumulative cases

#work in progress to suppress values after a certain date. not clear yet if required for test types and cases
  # mutate(DailyCases= ifelse (Date > as.Date(od_suppression_date) & DailyCases <5, 0,LFDAndPCR),
  #        PCROnly= ifelse (Date > as.Date(od_suppression_date) & PCROnly <5, 0,LFDAndPCR),
  #        LFDOnly= ifelse (Date > as.Date(od_suppression_date) & LFDOnly <5, 0,LFDAndPCR),
  #        LFDAndPCR= ifelse (Date > as.Date(od_suppression_date) & LFDAndPCR <5, 0,LFDAndPCR)) %>%

#use this to add suppression columns before calculating cumulative values
# g_daily_test_type <- g_daily_test_type %>% 
#  group_by(location_code) %>% 
#   mutate_if(is.numeric, ~replace_na(., 0)) %>% 
#   od_qualifiers(., "DailyCases", "c") %>%
#   od_qualifiers(., "PCROnly", "c") %>%
#   od_qualifiers(., "LFDOnly", "c") %>%
#   od_qualifiers(., "LFDAndPCR", "c") %>% 
#     ungroup()


# calculate cumulative for each test type and format for OD

 #  g_daily_file_od<- g_daily_test_type %>% 
 #      mutate_if(is.numeric, ~replace_na(., 0)) %>% 
 #  group_by(location_code)%>%
 #  mutate(#total_cumulative_positive=cumsum(total_daily_positive), 
 #    PCROnlyCumualtive= cumsum(PCROnly),
 #    LFDOnlyCumualtive= cumsum(LFDOnly), 
 #    LFDAndPCRCumualtive= cumsum(LFDAndPCR) ) %>%
 #  ungroup() %>% 
 #  select(Date,
 #         PCROnly, PCROnlyCumualtive,
 #         LFDOnly, LFDOnlyCumualtive,
 #         LFDAndPCR, LFDAndPCRCumualtive,
 #         DailyCases,CumulativeCases )%>%#  may need to add in QFs for each test type e.g. DailyCasesQF,
 # arrange(desc(Date) ) %>%
 #  mutate(Date = format(strptime(Date, format = "%Y-%m-%d"), "%Y%m%d")) 

  #remove intermediate files
 
#   rm(i_combined_pcr_lfd_tests,g_cases_data,g_daily_raw, g_daily_cases_od,
#       g_daily_test_type_all, g_daily_pcr_test_type,
#      g_daily_lfd_test_type, g_daily_lfdpcr_test_type,
#      g_daily_test_type)
  
 #  write_csv(g_daily_file_od, glue("{output_folder}TEMPdaily_file.csv"), na = "")


  