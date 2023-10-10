# Dashboard data transfer for Ethnicity
# Sourced from ../dashboard_data_transfer.R

##### Ethnicity

i_ethnicity <- read_csv_with_options(glue(input_data, "/RAPID_Ethnicity_Apr23.csv"))

### a) Ethnicity

g_ethnicity <- i_ethnicity %>%
  mutate(Month_begining = as.Date(Month_begining, format = "%Y-%m-%d")) %>%
  dplyr::rename(MonthBegining = `Month_begining`,
                EthnicGroup = `Ethnic_group`,
                Admissions = count,
                Percentage = percentage) %>%
  mutate(MonthBegining = format(MonthBegining, "%Y%m%d"),
         EthnicGroup = as.character(EthnicGroup),
         Admissions = as.numeric(Admissions),
         Percentage = as.numeric(Percentage)) %>%
  mutate(Percentage = Percentage*100) %>%
  mutate_if(is.numeric, round, 2) %>%
  mutate(AdmissionsQF = "", PercentageQF = "",
         Admissions = ifelse(Admissions < 5, NA, Admissions),
         AdmissionsQF = ifelse(is.na(Admissions), "c", AdmissionsQF),
         Percentage = ifelse(is.na(Admissions), NA, Percentage),
         PercentageQF = ifelse(is.na(Admissions), "c", PercentageQF)) %>%
  select(MonthBegining, EthnicGroup, Admissions, AdmissionsQF, Percentage, PercentageQF)

write.csv(g_ethnicity, glue(output_folder, "Ethnicity.csv"), row.names = FALSE)

#bring output back in temporarily until source input, reforat for Opend Data

TEMP_ethnicity <- read_csv(glue(output_folder, "Ethnicity.csv"))

g_ethnicity_od=TEMP_ethnicity %>% 
  mutate(Country= "S92000003" ,
         AdmissionsQF = "", PercentageQF = "",
         Admissions = ifelse(Admissions < 5, "", Admissions),
         AdmissionsQF = ifelse(is.na(Admissions), "c", AdmissionsQF),
         Percentage = ifelse(is.na(Admissions), "", Percentage),
         PercentageQF = ifelse(is.na(Admissions), "c", PercentageQF)) %>% 
  select(MonthBeginning=MonthBegining, Country, EthnicGroup, 
         Admissions, AdmissionsQF, Percentage, PercentageQF)

write.csv(g_ethnicity_od, glue(od_folder, "ethnicity_{od_report_date}.csv"), row.names = FALSE, na = "")

rm(g_ethnicity_od, TEMP_ethnicity)


### b) Ethnicity Chart

g_ethnicitychart <- g_ethnicity %>%
  select(-c("AdmissionsQF", "PercentageQF")) %>%
  dplyr::rename("Ethnicity" = "EthnicGroup") %>%
  pivot_wider(names_from = Ethnicity, values_from = c(Admissions, Percentage)) %>%
  clean_names()


write.csv(g_ethnicitychart, glue(output_folder, "Ethnicity_Chart.csv"), row.names = FALSE, na = "")

rm(g_ethnicity, g_ethnicitychart, i_ethnicity)

