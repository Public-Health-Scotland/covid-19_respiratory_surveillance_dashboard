# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

##### Hospital Admissions

adm_path <- "/conf/PHSCOVID19_Analysis/RAPID Reporting/Daily_extracts"

i_adm <- read_csv_with_options(glue("{adm_path}/Proxy provisional figures/{report_date}_12_Admissions_proxy.csv"))

read_rds_with_options <- create_loader_with_options(readRDS)
i_chiadm <- read_rds_with_options(glue("{adm_path}/Proxy provisional figures/CHI_Admissions_proxy.rds"))

i_simd_trend <- read_csv_with_options(glue(input_data, "/{format(report_date-2, format='%Y%m%d')} - simd summary.csv"))


# Filter CHI and 12 files down to last Sunday
i_chiadm %<>% filter(admission_date <= (report_date - 3))
i_adm %<>% filter(admission_date <= (report_date - 3))


### a) Admissions

g_adm <- i_adm
# Replace any NA with 0
g_adm[is.na(g_adm)] <- 0

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


write_csv(g_adm, glue(output_folder, "Admissions.csv"))

rm(g_adm)

#Opendata weekly admissions output

g_weekly_adm<- i_chiadm %>%
  mutate(WeekEnding = ceiling_date(
    as.Date(admission_date),unit="week",week_start=7, change_on_boundary=FALSE)  ) %>%
  group_by(WeekEnding) %>%
  summarise(Admissions = n()) %>%
  mutate(CumulativeAdmissions=(cumsum(Admissions)),
         LocationCode="S92000003",
         WeekEnding = format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) %>% 
  select(WeekEnding, LocationCode,Admissions, CumulativeAdmissions )

write_csv(g_weekly_adm, glue(output_folder, "TEMP_WeeklyAdmissions.csv"))

rm(g_weekly_adm)

### b) Admissions_Age_Breakdown

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
  mutate(Row = row_number()) %>%
  mutate(TotalInfections = ifelse(
         test = (abs(TotalInfections) == min(abs(TotalInfections)) & (sum(TempFlag) == 1)),
         yes = -999, no = TotalInfections),
         TotalInfectionsQF = ifelse(TotalInfections == -999, "c", ""),
         TotalInfections = ifelse(TotalInfections == -999, NA, TotalInfections)) %>%
  mutate(WeekOfAdmission = format(WeekOfAdmission, "%Y%m%d")) %>%
  select(WeekOfAdmission, AgeGroup, AgeGroupQF, TotalInfections, TotalInfectionsQF)


write.csv(g_adm_agebd, glue(output_folder, "Admissions_AgeBD.csv"), row.names = FALSE)
rm(g_adm_agebd, totals)


# Open data equivalent
g_adm_agebd_od<-g_adm_agebd %>% 
  mutate(Country="S92000003") %>% 
  select(WeekEnding=WeekOfAdmission,Country, AgeGroup, AgeGroupQF,
         Admissions=TotalInfections, 
         AdmissionsQF=TotalInfectionsQF)


write_csv(g_adm_agebd_od, glue("{output_folder}TEMP_Admissions_AgeBD_od.csv"), na = "")


### c) Admissions_AgeSex

g_adm_agesex <- i_chiadm %>%
  mutate(AgeGroup = case_when(age_year < 5 ~ '0-4',
                                        age_year < 15 ~ '5-14',
                                        age_year < 20 ~ '15-19',
                                        age_year < 25 ~ '20-24',
                                        age_year < 45 ~ '25-44',
                                        age_year < 65 ~ '45-64',
                                        age_year < 75 ~ '65-74',
                                        age_year < 85 ~ '75-84',
                                        age_year < 200 ~ '85+',
                                        is.na(age_year) ~ 'Unknown')) %>%
  group_by(AgeGroup, sex) %>%
  summarise(TotalInfections = n()) %>%
  dplyr::rename(Sex = sex) %>%
  select(Sex, AgeGroup, TotalInfections) %>%
  mutate(Sex = recode(Sex, F = "Female", M = "Male"),
         TotalInfections = as.numeric(TotalInfections))

# Add totals

male <-  c("Male", "Total",
           sum(g_adm_agesex$TotalInfections[g_adm_agesex$Sex == "Male"])
)

female <- c("Female", "Total",
            sum(g_adm_agesex$TotalInfections[g_adm_agesex$Sex == "Female"])
)

g_adm_agesex$TotalInfections %<>% as.character(g_adm_agesex$TotalInfections)

g_adm_agesex[nrow(g_adm_agesex) + 1, ] <- as.list(male)
g_adm_agesex[nrow(g_adm_agesex) + 1, ] <- as.list(female)


agegroups <- unique(g_adm_agesex$AgeGroup)

for(agegroup in agegroups){

  num <- as.numeric(g_adm_agesex$TotalInfections[g_adm_agesex$AgeGroup == agegroup])

  newline <- c("Total", agegroup,
               sum(num)
  )

  g_adm_agesex[nrow(g_adm_agesex) + 1, ] <- as.list(newline)

}

g_adm_agesex$TotalInfections <- as.numeric(g_adm_agesex$TotalInfections)

# Add population

g_adm_agesex %<>% left_join(i_population, by=c("AgeGroup", "Sex")) %>%
  mutate(TotalInfectionsPer100000 = round_half_up(100000*TotalInfections/PopNumber, 2)) %>%
  select(-c("PopNumber")) %>%
  arrange(factor(AgeGroup, levels= c("0-4", "5-14", "15-19", "20-24", "25-44","45-64", "65-74", "75-84", "85+", "Unknown"))) %>%
  arrange(factor(Sex, levels = c("Male", "Female", "Unknown"))) %>%
  mutate(AgeGroupQF = ifelse(AgeGroup == "Total", "d", ""),
         SexQF = ifelse(Sex == "Total", "d", "")) %>%
  select(Sex, SexQF, AgeGroup, AgeGroupQF, TotalInfections, TotalInfectionsPer100000)

write.csv(g_adm_agesex, glue(output_folder, "Admissions_AgeSex.csv"), row.names = FALSE)

rm(g_adm_agesex, num, newline, agegroups, male, female)


### d) Admissions_AgeSIMD

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


### e) Admissions by age group

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
  dplyr::rename(Age = custom_age_group_2,
                Date = week_ending,
                Admissions = number)

write.csv(g_adm_agegroup, glue(output_folder, "Admissions_AgeGrp.csv"), row.names = FALSE)



g_simd_trend <- i_simd_trend %>%
  dplyr::rename(WeekEnding = date, NumberOfAdmissions = Total, SIMD = simd, ProvisionalOrStable = provisional) %>%
  mutate(ProvisionalFlag = case_when(
         WeekEnding > (report_date-10) ~ 1,
        TRUE ~ 0),
        WeekEnding = format(as.Date(WeekEnding), "%Y%m%d")) %>%
  select(-(ProvisionalOrStable))

write_csv(g_simd_trend, glue(output_folder, "Admissions_SimdTrend.csv"))

rm(g_adm_agegroup, adm_path)


