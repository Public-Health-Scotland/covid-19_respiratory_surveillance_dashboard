# Dashboard data transfer for ICU
# Sourced from ../dashboard_data_transfer.R

###### ICU

i_icu_newpatient <- read_all_excel_sheets(glue(input_data, "{(report_date -2)}_ICU_newpatientadmissions_bydate.xlsx"))
i_icu_cp_agesex_rate <- read_all_excel_sheets(glue(input_data, "{(report_date -2)}_ICU_cumulativepos_agesex_ratedata.xlsx"))

### a) ICU

g_icu <- i_icu_newpatient$Sheet1 %>%
  dplyr::rename(DateFirstICUAdmission = `Date of First ICU Admission`,
                NewCovidAdmissionsPerDay = `Count of New COVID-19 Admissions per Day`,
                SevenDayAverage = `7-Day Moving Average`) %>%
  mutate(SevenDayAverage = round_half_up(SevenDayAverage,0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), "z", ""),
         DateFirstICUAdmission = format(DateFirstICUAdmission, "%Y%m%d"))

write.csv(g_icu, glue(output_folder, "ICU.csv"), row.names = FALSE)

### b) ICU_AgeSex

g_icu_agesex <- i_icu_cp_agesex_rate$Sheet1 %>%
  dplyr::rename(Sex=gender,
                AgeGroup = PHSagegrp,
                CovidAdmissionsToICU = Counts,
                Population = population,
                RateCovidICUPer100000 = rate) %>%
  select(Sex, AgeGroup, CovidAdmissionsToICU, Population, RateCovidICUPer100000) %>%
  mutate(Sex = case_when(Sex == "F" ~ "Female",
                         Sex == "M" ~ "Male",
                         TRUE ~ NA_character_),
         CovidAdmissionsToICU = as.numeric(CovidAdmissionsToICU))

# Add totals

male <-  c("Male", "Total",
           sum(g_icu_agesex$CovidAdmissionsToICU[g_icu_agesex$Sex == "Male"]),
           sum(g_icu_agesex$Population[g_icu_agesex$Sex == "Male"]),
           100000*sum(g_icu_agesex$CovidAdmissionsToICU[g_icu_agesex$Sex == "Male"])/sum(g_icu_agesex$Population[g_icu_agesex$Sex == "Male"])
)

female <- c("Female", "Total",
            sum(g_icu_agesex$CovidAdmissionsToICU[g_icu_agesex$Sex == "Female"]),
            sum(g_icu_agesex$Population[g_icu_agesex$Sex == "Female"]),
            100000*sum(g_icu_agesex$CovidAdmissionsToICU[g_icu_agesex$Sex == "Female"])/sum(g_icu_agesex$Population[g_icu_agesex$Sex == "Female"])
)

g_icu_agesex %<>% rbind(male) %>%  rbind(female)

agegroups <- unique(g_icu_agesex$AgeGroup)

for(agegroup in agegroups){

  num <- as.numeric(g_icu_agesex$CovidAdmissionsToICU[g_icu_agesex$AgeGroup == agegroup])
  pop <-  as.numeric(g_icu_agesex$Population[g_icu_agesex$AgeGroup == agegroup])


  newline <- c("Total", agegroup,
               sum(num),
               sum(pop),
               100000*sum(num)/sum(pop))

  g_icu_agesex %<>% rbind(newline)

}


g_icu_agesex %<>% arrange(factor(Sex, levels = c("Male", "Female", "Total"))) %>% select(-c(Population)) %>%
  mutate(SexQF = ifelse(Sex == "Total", "d", ""),
         AgeGroupQF = ifelse(AgeGroup == "Total", "d", ""),
         RateCovidICUPer100000 = round_half_up(as.numeric(RateCovidICUPer100000), 2),
         CovidAdmissionsToICU = as.numeric(CovidAdmissionsToICU)) %>%
  select(Sex, SexQF, AgeGroup, AgeGroupQF, CovidAdmissionsToICU, RateCovidICUPer100000)


write.csv(g_icu_agesex, glue(output_folder, "ICU_AgeSex.csv"), row.names = FALSE)


### c) ICU - Weekly

g_icu_weekly <- i_icu_newpatient$Sheet1 %>%
  dplyr::rename(DateFirstICUAdmission = `Date of First ICU Admission`,
                NewCovidAdmissionsPerDay = `Count of New COVID-19 Admissions per Day`,
                SevenDayAverage = `7-Day Moving Average`) %>%
  mutate(WeekEndingFirstICUAdmission = ceiling_date(DateFirstICUAdmission,
                                                    unit = "week", 
                                                    change_on_boundary = F)) %>%
  mutate(WeekEndingFirstICUAdmission = format(WeekEndingFirstICUAdmission, "%Y%m%d")) %>%
  group_by(WeekEndingFirstICUAdmission) %>%
  summarise(NewCovidAdmissionsPerWeek = sum(NewCovidAdmissionsPerDay)) %>%
  ungroup()

# Apply suppression
g_icu_weekly <- g_icu_weekly %>%
  mutate(NewCovidAdmissionsPerWeekQF = ifelse(
    WeekEndingFirstICUAdmission >= "20230528" & NewCovidAdmissionsPerWeek < 5
    & NewCovidAdmissionsPerWeek > 0, "c", "")) %>%
  mutate(NewCovidAdmissionsPerWeek = ifelse(
    NewCovidAdmissionsPerWeekQF == "c", "", NewCovidAdmissionsPerWeek))
  

write.csv(g_icu_weekly, glue(output_folder, "ICU_weekly.csv"), row.names = FALSE)

rm(g_icu, g_icu_weekly, g_icu_agesex, i_icu_cp_agesex_rate, i_icu_newpatient, agegroups)
