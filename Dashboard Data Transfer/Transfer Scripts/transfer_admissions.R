# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R
#-------------------#
#### input files ####
#-------------------#
adm_path <- "/PHI_conf/RAPID_Pathogen_Reporting/"

#i_adm <- read_csv_with_options(glue("{adm_path}/Proxy provisional figures/{report_date}_12_Admissions_proxy.csv"))

i_adm <- read_rds(glue("{adm_path}/rapid_ecoss_joined_provisional.rds")) %>%
  filter(covid_admission_flag == TRUE) %>%
  group_by(admission_date) %>%
  summarise(TestDIn = n()) %>%
  ungroup() %>%
  mutate(First_infection = NA,
         Reinfection = NA,
         `NA` = NA) %>%
  select(admission_date, First_infection, Reinfection, `NA`, TestDIn) %>%
  filter(admission_date <= report_date-3)

read_rds_with_options <- create_loader_with_options(readRDS)
#i_chiadm <- read_rds_with_options(glue("{adm_path}/Proxy provisional figures/CHI_Admissions_proxy.rds"))

i_chiadm <- read_rds(glue("{adm_path}/rapid_ecoss_joined_provisional.rds")) %>%
  filter(covid_admission_flag == TRUE) %>%
  select(chi_number, health_board_of_treatment, admission_date, age_year,
         sex, covid_admission_flag, patient_postcode)

spd_simd_lookup <- read_rds("/conf/linkage/output/lookups/Unicode/Deprivation/postcode_2025_1_simd2020v2.rds") %>%
  mutate(patient_postcode=str_replace_all(string=pc7, pattern=" ", repl=""),
         simd2020v2_sc_quintile=as.character(simd2020v2_sc_quintile)) %>%
  select(patient_postcode,simd2020v2_sc_quintile)

i_chiadm <- i_chiadm %>%
  left_join(spd_simd_lookup)

rm(spd_simd_lookup)

i_simd_trend <- read_csv_with_options(glue(input_data, "/{format(report_date-2, format='%Y%m%d')} - simd summary.csv"))


# Filter CHI and 12 files down to last Sunday
i_chiadm %<>% filter(admission_date <= (report_date - 3))
i_adm %<>% filter(admission_date <= (report_date - 3))


# age sex input files
# i_age_sex_weekly <- read_csv_with_options(glue(input_data, "/age_sex_weekly_adm_all paths_v2_TEST.csv"))
# 
# i_age_sex_season <- read_csv_with_options(glue(input_data, "/age_sex_season_adm_all paths_v2_TEST.csv"))

#---------------------#
#### a) Admissions ####
#---------------------#

g_adm <- i_adm
# Replace any NA with 0
g_adm[is.na(g_adm)] <- 0

# daily admissions
g_adm %<>%
  dplyr::rename(AdmissionDate = admission_date,
                TotalInfections = TestDIn,
                FirstInfections = First_infection,
                Reinfections = Reinfection) %>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(TotalInfections, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), "z", ""),
         ProvisionalFlag = case_when(
         AdmissionDate > (report_date-10) ~ 1,
         TRUE ~ 0),
         AdmissionDate = format(as.Date(AdmissionDate), "%Y%m%d"))

# daily admission no longer needed for dashboard
write_csv(g_adm, glue(output_folder, "Admissions.csv"))

# save to UKHSA adm folder
write_csv(g_adm, glue(ukhsa_adm, "Admissions.csv", row.names = FALSE, na = ""))


# weekly admissions
g_adm_weekly<-g_adm %>%
  select(AdmissionDate, TotalInfections) %>%
  mutate(AdmissionDate=ymd(AdmissionDate)) %>%
  mutate(WeekOfAdmission = ceiling_date(
    AdmissionDate,unit="week",week_start=7, change_on_boundary=FALSE)) %>%
  group_by(WeekOfAdmission) %>%
  summarise(TotalInfections = sum(TotalInfections))%>%
  ungroup() %>%
  mutate(ProvisionalFlag = case_when(
    WeekOfAdmission > (report_date-10) ~ 1,
           TRUE ~ 0)) %>%
    mutate(WeekOfAdmission = format(strptime(WeekOfAdmission, format = "%Y-%m-%d"), "%Y%m%d")) %>%
  rename(AdmissionDate=WeekOfAdmission)

write_csv(g_adm_weekly, glue(output_folder, "Admissions_Weekly.csv"))

#rm(g_adm, g_adm_weekly)

#-----------------------------------#
#### b) Admissions_Age_Breakdown ####
#-----------------------------------#
# 
g_adm_agebd <- i_chiadm %>%
  mutate(WeekOfAdmission = ceiling_date(
    as.Date(admission_date),unit="week",week_start=7, change_on_boundary=FALSE)
  ) %>%
  mutate(
    AgeYear = as.numeric(age_year),
    AgeGroup = case_when(AgeYear < 18 ~ 'Under 18',
                         AgeYear < 30 ~ '18-29',
                         AgeYear < 40 ~ '30-39',
                         AgeYear < 50 ~ '40-49',
                         AgeYear < 55 ~ '50-54',
                         AgeYear < 60 ~ '55-59',
                         AgeYear < 65 ~ '60-64',
                         AgeYear < 70 ~ '65-69',
                         AgeYear < 75 ~ '70-74',
                         AgeYear < 80 ~ '75-79',
                         AgeYear < 200 ~ '80+',
                         is.na(AgeYear) ~ 'Unknown')) %>%
  group_by(WeekOfAdmission, AgeGroup) %>%
  summarise(TotalInfections = n()) %>%
  ungroup()

totals <- g_adm_agebd %>%
  group_by(WeekOfAdmission) %>%
  summarise(TotalInfections = sum(TotalInfections)) %>%
  ungroup() %>%
  mutate(AgeGroup = "Total")

g_adm_agebd %<>%
  full_join(totals) %>%
  mutate(AgeGroup = factor(AgeGroup,
                           levels = c("Under 18", "18-29", "30-39", "40-49", "50-54", "55-59",
                                      "60-64", "65-69", "70-74", "75-79", "80+", "Total", "Unknown"))) %>%
  arrange(WeekOfAdmission, AgeGroup) %>%
  mutate(AgeGroupQF = ifelse(AgeGroup == "Total", "d", "")) %>%
  #Apply Suppression - NOTE: setting to -999 temporarily to highlight
  mutate(Original = TotalInfections,
         TotalInfections =  ifelse(TotalInfections <5, -999, TotalInfections),
         TempFlag = ifelse(TotalInfections == -999, 1, 0)) %>%
  #Apply Secondary Suppression
  group_by(WeekOfAdmission) %>%
  mutate(Row = row_number())  %>%
  mutate(TotalInfections = ifelse(
         test = (abs(TotalInfections) == min(abs(TotalInfections)) & (sum(TempFlag) == 1)),
         yes = -999, no = TotalInfections),
         TotalInfectionsQF = ifelse(TotalInfections == -999, "c", ""),
         TotalInfections = ifelse(TotalInfections == -999, NA, TotalInfections)) %>%
  mutate(WeekOfAdmission = format(WeekOfAdmission, "%Y%m%d")) %>%
    select(WeekOfAdmission, AgeGroup, AgeGroupQF, TotalInfections, TotalInfectionsQF)
# 

write.csv(g_adm_agebd, glue(output_folder, "Admissions_AgeBD.csv"), row.names = FALSE)

# Open data Output
g_adm_agebd_od<-g_adm_agebd %>%
  mutate(Country="S92000003") %>%
  select(WeekEnding=WeekOfAdmission,Country, AgeGroup, AgeGroupQF,
         Admissions=TotalInfections,
         AdmissionsQF=TotalInfectionsQF)

write_csv(g_adm_agebd_od, glue(od_folder, "weekly_admissions_ageBD_{od_report_date}.csv"),na = "")

rm(g_adm_agebd, totals, g_adm_agebd_od)

#-----------------------------#
#### c) Admissions_AgeSIMD ####
#-----------------------------#
g_adm_simd <- i_chiadm %>%
  group_by(simd2020v2_sc_quintile) %>%
  summarise(TotalInfections = n()) %>%
  dplyr::rename(SIMD = simd2020v2_sc_quintile) %>%
  mutate(TotalInfectionsPc = round_half_up(100*TotalInfections/sum(TotalInfections), 2),
         SIMD =as.character(SIMD),
         SIMD = recode(SIMD, "1" = "1 (most deprived)", "5" = "5 (least deprived)"),
         SIMD = ifelse(is.na(SIMD), "Unknown", SIMD))

write.csv(g_adm_simd, glue(output_folder, "Admissions_SIMD.csv"), row.names = FALSE)

rm(g_adm_simd)


g_simd_trend <- i_simd_trend %>%
  dplyr::rename(WeekEnding = date, NumberOfAdmissions = Total, SIMD = simd, ProvisionalOrStable = provisional) %>%
  mutate(ProvisionalFlag = case_when(
    WeekEnding > (report_date-10) ~ 1,
    TRUE ~ 0),
    WeekEnding = format(as.Date(WeekEnding), "%Y%m%d")) %>%
  select(-(ProvisionalOrStable))

write_csv(g_simd_trend, glue(output_folder, "Admissions_SimdTrend.csv"))

#----------------------------------#
#### d) Admissions by age group ####
#----------------------------------#
g_adm_agegroup  <- i_chiadm %>%
  mutate(custom_age_group_2 = case_when(age_year < 5 ~ '0-4',
                                        age_year < 15 ~ '5-14',
                                        age_year < 20 ~ '15-19',
                                        age_year < 25 ~ '20-24',
                                        age_year < 45 ~ '25-44',
                                        age_year < 65 ~ '45-64',
                                        age_year < 75 ~ '65-74',
                                        age_year < 85 ~ '75-84',
                                        age_year < 200 ~ '85+',
                                        is.na(age_year) ~ 'Unknown')) %>%
  mutate(week_ending = ceiling_date(as.Date(admission_date), unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, custom_age_group_2) %>%
  summarise(number = n()) %>%
  mutate(summer_2025_flag = case_when(week_ending >= summer_2025 ~"flag", TRUE~"")) %>% 
  dplyr::rename(Age = custom_age_group_2,
                Date = week_ending,
                Admissions = number)  %>% 
  filter(summer_2025_flag !="flag")  %>%
  select(-summer_2025_flag) 


write.csv(g_adm_agegroup, glue(output_folder, "Admissions_AgeGrp.csv"), row.names = FALSE)

#rm(g_adm_agegroup, adm_path)


g_simd_trend <- i_simd_trend %>%
  dplyr::rename(WeekEnding = date, NumberOfAdmissions = Total, SIMD = simd, ProvisionalOrStable = provisional) %>%
  mutate(ProvisionalFlag = case_when(
         WeekEnding > (report_date-10) ~ 1,
        TRUE ~ 0),
        WeekEnding = format(as.Date(WeekEnding), "%Y%m%d")) %>%
  select(-(ProvisionalOrStable))

write_csv(g_simd_trend, glue(output_folder, "Admissions_SimdTrend.csv"))

#---------------------------------#
#### e) Admissions_healthboard ####
#---------------------------------#

g_adm_hb <- i_chiadm %>%
  mutate(WeekEnding = ceiling_date(as.Date(admission_date), unit = "week", change_on_boundary = F)) %>%
  group_by(WeekEnding, health_board_of_treatment) %>%
  summarise(TotalInfections = n()) %>%
  dplyr::rename(HealthBoard = health_board_of_treatment)

g_adm_hb_scot <- i_chiadm %>%
  mutate(WeekEnding = ceiling_date(as.Date(admission_date), unit = "week", change_on_boundary = F)) %>%
  group_by(WeekEnding) %>%
  summarise(TotalInfections = n()) %>%
  mutate(HealthBoard = "NHS SCOTLAND") %>%
  select(WeekEnding, HealthBoard, TotalInfections)

g_adm_hb %<>%
  mutate(summer_2025_flag = case_when(WeekEnding >= summer_2025 ~"flag",
                                      TRUE~"")) %>% 
  filter(summer_2025_flag !="flag")  %>%
  select(-summer_2025_flag) %>% 
  bind_rows(g_adm_hb_scot) %>%
  mutate(HealthBoard = factor(HealthBoard,
                           levels = c("NHS AYRSHIRE & ARRAN", "NHS BORDERS", "NHS DUMFRIES & GALLOWAY", "NHS FIFE", "NHS FORTH VALLEY", "NHS GRAMPIAN",
                                      "NHS GREATER GLASGOW & CLYDE", "NHS HIGHLAND", "NHS LANARKSHIRE", "NHS LOTHIAN", "NHS ORKNEY", "NHS SHETLAND",
                                      "NHS TAYSIDE", "NHS WESTERN ISLES", "NATIONAL FACILITY", "NHS SCOTLAND"))) %>%
  arrange(WeekEnding, HealthBoard) %>%
  mutate(HealthBoard = recode(HealthBoard,
                              "NHS AYRSHIRE & ARRAN" = "NHS Ayrshire and Arran",
                              "NHS BORDERS" = "NHS Borders",
                              "NHS DUMFRIES & GALLOWAY" = "NHS Dumfries and Galloway",
                              "NHS FIFE" = "NHS Fife",
                              "NHS FORTH VALLEY" = "NHS Forth Valley",
                              "NHS GRAMPIAN" = "NHS Grampian",
                              "NHS GREATER GLASGOW & CLYDE" = "NHS Greater Glasgow and Clyde",
                              "NHS HIGHLAND" = "NHS Highland",
                              "NHS LANARKSHIRE" = "NHS Lanarkshire",
                              "NHS LOTHIAN" = "NHS Lothian",
                              "NHS ORKNEY" = "NHS Orkney",
                              "NHS SHETLAND" = "NHS Shetland",
                              "NHS TAYSIDE" = "NHS Tayside",
                              "NHS WESTERN ISLES" = "NHS Western Isles",
                              "NATIONAL FACILITY" = "Golden Jubilee National Hospital",
                              "NHS SCOTLAND" = "Scotland"))


write.csv(g_adm_hb, glue(output_folder, "Admissions_HB.csv"), row.names = FALSE)

#-----------------------------------------#
#### f) 3 week dataset for at a glance ####
#-----------------------------------------#

# create 3 week framework to hang Covid admissions

# three_sunday_dates <- data.frame(WeekEnding=seq(as.Date("2018-10-07"), as.Date(od_date-1), "week")) %>%
#   slice_tail(n = 3)
# 
# HealthBoardName= data.frame(HealthBoardOfTreatment=c("NHS Ayrshire and Arran",  "NHS Borders",
#                                                      "NHS Dumfries and Galloway","NHS Fife",
#                                                      "NHS Forth Valley","NHS Grampian",
#                                                      "NHS Greater Glasgow and Clyde",
#                                                      "NHS Highland","NHS Lanarkshire",
#                                                      "NHS Lothian","NHS Orkney","NHS Shetland","NHS Tayside",
#                                                      "NHS Western Isles","Golden Jubilee National Hospital",
#                                                      "Scotland" ))
# 
# hb_last_three_weeks <- expand.grid(HealthBoardOfTreatment=unique(HealthBoardName$HealthBoardOfTreatment),
#                                    WeekEnding=unique(three_sunday_dates$WeekEnding),
#                                    KEEP.OUT.ATTRS = FALSE,
#                                    stringsAsFactors = FALSE)
#
# g_adm_hb_3weeks<-g_adm_hb %>%
#   filter(WeekEnding>=od_sunday_minus_14) %>%
#   dplyr::rename(HealthBoardOfTreatment = HealthBoard)

#
# g_adm_hb_3weeks_full<-hb_last_three_weeks %>%
#   left_join(g_adm_hb_3weeks, by=c("HealthBoardOfTreatment","WeekEnding")) %>%
#   select(WeekEnding, HealthBoardOfTreatment, TotalInfections) %>%
#   mutate(TotalInfections=if_else(is.na(TotalInfections),0,TotalInfections))
#
# write.csv(g_adm_hb_3weeks_full, glue(output_folder, "Admissions_HB_3wks.csv"), row.names = FALSE)
#
# rm(g_adm_hb)
# 
# rm(i_rsv_hb_admissions, g_rsv_adm_scot, g_rsv_adm_hb,
#    three_sunday_dates, HealthBoardName, hb_last_three_weeks, g_adm_hb_3weeks, g_adm_hb_3weeks_full)

#--------------------------------------------------------#
###### g) admissions age/sex for covid, flu and rsv ######
#--------------------------------------------------------#
## season output
# g_age_sex_season <- i_age_sex_season %>%
#   dplyr::rename(AgeGroup = age_band,
#                 Sex = sex,
#                 Pathogen = admission_type,
#                 Count = season_count,
#                 Population = population,
#                 Rate = rate) %>%
#   mutate(Sex = recode(Sex,
#                       "all_sex" = "All")) %>%
#   mutate(AgeGroup = recode(AgeGroup,
#                            "all_ages" = "All"))
# 
## weekly ouput
# g_age_sex_weekly <- i_age_sex_weekly %>%
#   dplyr::rename(WeekEnding = week_ending,
#                 Pathogen = admission_type,
#                 AgeGroup = age_band,
#                 Sex = sex,
#                 Count = count,
#                 WeekStart = week_start,
#                 Week = week,
#                 Population = population,
#                 Rate = rate) %>%
#   mutate(Sex = recode(Sex,
#                       "all_sex" = "All")) %>%
#   mutate(AgeGroup = recode(AgeGroup,
#                            "all_ages" = "All"))
# 
# write.csv(g_age_sex_season, glue(output_folder, "Admissions_AgeSex_Season.csv"), row.names = FALSE)
# write.csv(g_age_sex_weekly, glue(output_folder, "Admissions_AgeSex_Weekly.csv"), row.names = FALSE)
