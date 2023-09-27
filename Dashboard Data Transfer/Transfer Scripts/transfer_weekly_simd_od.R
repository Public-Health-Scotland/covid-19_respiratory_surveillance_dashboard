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



##### lookups and values #######################################
 

# GPD base look_path
gpd_base_path<-"/conf/linkage/output/lookups/Unicode/"

#use this to assign simd quintile by matching postcode to cases postcode
spd_simd_lookup <- read_rds(glue(gpd_base_path,"Deprivation/postcode_2023_2_simd2020v2.rds"))%>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl=""),
         simd=as.character(simd2020v2_sc_quintile)) %>%
  select(PostCode,simd)

#create populations for different geographies

base_datazone_population <-  read_rds(glue(gpd_base_path,"Populations/Estimates/DataZone2011_pop_est_5year_agegroups_2011_2021.rds"))

# Breaking down the population of each health board by SIMD quintile.
pop_simd_hb <- base_datazone_population %>% 
  filter(year == 2021) %>% 
  rename(simd= simd2020v2_sc_quintile,
         location_code = hb2019) %>%
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the population of each local authority by SIMD quintile.
pop_simd_la <- base_datazone_population %>% 
  filter(year == 2021) %>% 
  rename(simd = simd2020v2_sc_quintile,
         location_code = ca2019) %>%
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the Scottish population by SIMD quintile
pop_simd_scotland <- base_datazone_population %>% 
  filter(year == 2021) %>% 
  rename(simd = simd2020v2_sc_quintile) %>% 
  mutate(location_code = "Scotland") %>% 
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Combining the above population breakdowns.
simd_populations <- bind_rows(pop_simd_hb, pop_simd_la, pop_simd_scotland) %>% 
  arrange(location_code, simd)  %>% 
  mutate(simd=as.character(simd))

rm(pop_simd_hb, pop_simd_la, pop_simd_scotland, base_datazone_population)


##### set dates #######################################

# Reporting Dates 
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1
od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
od_sunday_minus_14 <- today() - 17
#od_suppression_date <- "2023-05-31"


##### SIMD trend dataframe #######################################

# create df template containing 5 simd quintiles (plus unassinged) for each day post Dec 2019 until today
Dates <- data.frame(SpecimenDate=seq(as.Date("2019/12/08"), as.Date(Sys.Date()), "day"))

SIMD <- data.frame(SIMD=seq(1,5,1)) %>% 
  mutate(SIMD=as.character(SIMD))

df_unassinged<-data.frame(SIMD="Unknown") # add unassigned 

SIMD <- bind_rows(SIMD,df_unassinged) 


df_simd <- expand.grid(Date=unique(Dates$SpecimenDate) , simd=unique(SIMD$SIMD),
                       KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  mutate(location_code="Scotland", simd=as.character(simd))

rm(Dates, SIMD, df_unassinged)



#### Functions ###########################################
# 
# od_suppress_value <- function(data, col_name) {
#   
#   needs_suppressed = data[[col_name]] == "" | (data[[col_name]]<5)
#   
#   data %>% 
#     mutate(data[col_name] == if_else(
#       needs_suprressed, 0, data[col_name]
#     ))
#   
# }

# od_qualifiers <- function(data, col_name, symbol) {
#   
#   needs_symbol = data[[col_name]] == "" | is.na(data[[col_name]])
#   
#   data %>% 
#     mutate("{col_name}QF" := if_else(
#       needs_symbol, symbol, ""
#     ))
#   
# }


#### Cases ##############################


i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds") )

g_daily_raw<- i_combined_pcr_lfd_tests %>% 
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
         derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)


g_daily_geog_simd_test<- g_daily_raw %>%
  mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
  left_join(spd_simd_lookup,by="PostCode")%>%
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0),
         flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
         flag_reinfection = ifelse(episode_number_deduplicated>1,1,0))%>%
  filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday)) %>% 
  arrange(desc(Date)) %>% 
  mutate(location_code="Scotland") 
  
g_simd_scotland_daily_cases <- g_daily_geog_simd_test %>%
  mutate(simd = replace(simd, is.na(simd), "Unknown")) %>% 
  group_by(Date,simd,location_code) %>%
  summarise(daily_positive = sum(flag_episode))


rm(spd_simd_lookup, g_daily_raw, g_daily_geog_simd_test )

##### #SIMD trend - Scotland only  #############################

g_simd_weekly_cases  <- df_simd %>%
  left_join(g_simd_scotland_daily_cases, by=c("Date","location_code","simd")) %>% 
  mutate_if(is.numeric, ~replace_na(., 0)) %>% 
  filter(Date>as.Date("2020/02/27") & Date<as.Date(od_date-1)) %>% 
  group_by(Date,simd) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
  ungroup() %>% 
  group_by(week_ending, simd) %>% 
  mutate(CasesLastSevendDays=sum(daily_positive)) %>% 
  ungroup() %>%   
  select(-Date,-daily_positive) %>% 
  unique()%>% 
  group_by(simd) %>% 
  mutate(CumulativeCases=(cumsum(CasesLastSevendDays))) %>% 
  ungroup %>% 
  arrange(week_ending, simd) %>% 
  left_join(simd_populations, by=c("location_code","simd")) %>% 
  mutate(CrudeRateCases=((CumulativeCases/Pop)*100000 ), 
         CrudeRateCases=round_half_up(CrudeRateCases))  %>% 
  mutate(CrudeRateCasesQF=if_else(is.na(CrudeRateCases),":","d"),
         WeekEnding = format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d")) %>%
  select(WeekEnding ,SIMD=simd, CasesLastSevendDays, 
         CumulativeCases, CrudeRateCases,CrudeRateCasesQF)  
  

write_csv(g_simd_weekly_cases, glue("{output_folder}TEMP_simd_weekly.csv"), na = "")


rm(df_simd, g_simd_scotland_daily_cases, simd_populations, g_simd_weekly_cases)
##### End of script #######################################





