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

# enter latest population year
pop_year= 2021 # use to filter through entire script, only need to update 1 line when Pop ESt files updated

# GPD base look_path
gpd_base_path<-"/conf/linkage/output/lookups/Unicode/"

#use this to assign simd quintile by matching postcode to cases postcode

spd_simd_lookup <- read_rds(glue(gpd_base_path,"Deprivation/postcode_2023_1_simd2020v2.rds"))%>%
  mutate(PostCode=str_replace_all(string=pc7, pattern=" ", repl=""),
         simd=as.character(simd2020v2_sc_quintile)) %>%
  select(PostCode,simd)

######### simd population lookup #####

base_datazone_population <-  read_rds(glue(gpd_base_path,"Populations/Estimates/DataZone2011_pop_est_5year_agegroups_2011_2021.rds"))

# Breaking down the population of each health board by SIMD quintile.
pop_simd_hb <- base_datazone_population %>% 
  filter(year == pop_year)  %>% 
  rename(simd= simd2020v2_sc_quintile,
         location_code = hb2019) %>%
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the population of each local authority by SIMD quintile.
pop_simd_la <- base_datazone_population %>% 
  filter(year == pop_year)  %>% 
  rename(simd = simd2020v2_sc_quintile,
         location_code = ca2019) %>%
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the Scottish population by SIMD quintile
pop_simd_scotland <- base_datazone_population %>% 
  filter(year == pop_year)  %>% 
  rename(simd = simd2020v2_sc_quintile) %>% 
  mutate(location_code = "Scotland") %>% 
  group_by(location_code, simd) %>% 
  summarise(Pop = sum(total_pop))

# Combining the above population breakdowns.
simd_populations <- bind_rows(pop_simd_hb, pop_simd_la, pop_simd_scotland) %>% 
  arrange(location_code, simd)  %>% 
  mutate(simd=as.character(simd))

rm(pop_simd_hb, pop_simd_la, pop_simd_scotland, base_datazone_population)


##### SIMD trend dataframe #######################################

# create df template containing 5 simd quintiles (plus unassinged) for each day post Dec 2019 until today
# ensure date/simd quintile is included when there are no cases for that combination in a particular week

Dates <- data.frame(SpecimenDate=seq(as.Date("2019/12/08"), as.Date(Sys.Date()), "day"))

SIMD <- data.frame(SIMD=seq(1,5,1)) %>% 
  mutate(SIMD=as.character(SIMD))

df_unassinged<-data.frame(SIMD="Unknown") # add unassigned 

SIMD <- bind_rows(SIMD,df_unassinged) 


df_simd <- expand.grid(Date=unique(Dates$SpecimenDate) , simd=unique(SIMD$SIMD),
                       KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE) %>%
  mutate(location_code="Scotland", simd=as.character(simd))

rm(Dates, SIMD, df_unassinged) # remove building blocks



#### Functions ###########################################

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
# 
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

i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds"))%>%
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex))%>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))%>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source))%>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar))%>%
  select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date,
         test_result, Sex, age, date_reporting, date_test_received_at_bi,
         test_result_record_source, laboratory_code, pillar, flag_covid_case,
         derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)


g_daily_geog_simd_cases<- i_combined_pcr_lfd_tests %>%
  mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
  left_join(spd_simd_lookup,by="PostCode")%>%
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0))%>%
  filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>% 
  filter(Date <= as.Date(od_sunday)) %>% 
  arrange(desc(Date)) %>% 
  mutate(location_code="Scotland") 
  
g_simd_scotland_daily_cases <- g_daily_geog_simd_cases %>%
  mutate(simd = replace(simd, is.na(simd), "Unknown")) %>% 
  group_by(Date,simd,location_code) %>%
  summarise(daily_positive = sum(flag_episode))

rm(spd_simd_lookup)

##### #SIMD weekly - Scotland only  #############################

g_simd_weekly_cases_od  <- df_simd %>%
  left_join(g_simd_scotland_daily_cases, by=c("Date","location_code","simd")) %>% 
  mutate_if(is.numeric, ~replace_na(., 0)) %>% 
  filter(Date>as.Date("2020/02/27") & Date<as.Date(od_date-1)) %>% 
  group_by(Date,simd) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
  ungroup() %>% 
  group_by(week_ending, simd) %>% 
  mutate(WeeklyPositiveCases=sum(daily_positive)) %>% 
  ungroup() %>%   
  select(-Date,-daily_positive) %>% 
  unique()%>% 
  group_by(simd) %>% 
  mutate(CumulativePositive=(cumsum(WeeklyPositiveCases))) %>% 
  ungroup %>% 
  arrange(week_ending, simd) %>% 
  left_join(simd_populations, by=c("location_code","simd")) %>% 
  mutate(CrudeRatePositive=(CumulativePositive/Pop)*100000) %>% 
  mutate(CrudeRatePositive=round_half_up(CrudeRatePositive)) %>% 
  mutate(CrudeRatePositiveQF=if_else(is.na(CrudeRatePositive),":","d"),
         WeekEnding= format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d")
         ) %>%
  mutate(Country="S92000003") %>% 
  select(WeekEnding,Country, SIMDQuintile=simd, 
         WeeklyCases=WeeklyPositiveCases, 
         CumulativeCases= CumulativePositive, 
         CrudeRateCumulativeCases= CrudeRatePositive,
         CrudeRateCumulativeCasesQF=CrudeRatePositiveQF)  

#write_csv(g_simd_weekly_cases_od , glue("{output_folder}TEMP_cases_simd_weekly.csv"), na = "")
write_csv(g_simd_weekly_cases_od, glue(od_folder, "weekly_cases_simd_{od_report_date}.csv"), na = "")



rm(df_simd, g_daily_geog_simd_cases, i_combined_pcr_lfd_tests,
   g_simd_weekly_cases_od,g_simd_scotland_daily_cases, simd_populations)

##### End of script #######################################

