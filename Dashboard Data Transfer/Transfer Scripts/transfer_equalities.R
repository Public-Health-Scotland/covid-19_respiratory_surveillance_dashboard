
i_admissions_equalities <- read_excel_with_options(glue(input_data, "equality_admission_combined.xlsx"))



g_admissions_ethnicity <- i_admissions_equalities %>%
  select(chi, Pathogen, Season, Week, Year, ethnic_code, ethnic_group,ethnic_desc) %>%
  dplyr::rename(CHI = chi,
                EthnicCode = ethnic_code,
                EthnicGroup = ethnic_group,
                EthnicDesc = ethnic_desc) %>%
  group_by(Season, Pathogen, EthnicCode, EthnicGroup,EthnicDesc) %>%
  summarise(Admissions = n())

ethnicity_adm_prop <- g_admissions_ethnicity %>%
  group_by(Season, Pathogen) %>%
  summarise(Proportion = (Admissions/sum(Admissions))*100) %>%
  ungroup()

g_admissions_ethnicity$Proportion = ethnicity_adm_prop$Proportion

g_admissions_simd <- i_admissions_equalities %>%
  select(chi, Pathogen, Season, Week, Year, simd2020v2_sc_quintile) %>%
  dplyr::rename(CHI = chi,
                SIMD = simd2020v2_sc_quintile) %>%
  mutate(SIMD = as.character(SIMD),
         SIMD = recode(SIMD, "1" = "1 (most deprived)", "5" = "5 (least deprived)"),
         SIMD = ifelse(is.na(SIMD), "Unknown", SIMD)) %>%
  group_by(Season, Pathogen, SIMD) %>%
  summarise(Admissions = n())

simd_adm_prop <- g_admissions_simd %>%
  group_by(Season, Pathogen) %>%
  summarise(Proportion = (Admissions/sum(Admissions))*100) %>%
  ungroup()

g_admissions_simd$Proportion = simd_adm_prop$Proportion



write.csv(g_admissions_ethnicity, glue(output_folder, "Admissions_Ethnicity.csv"), row.names = FALSE)

write.csv(g_admissions_simd, glue(output_folder, "Admissions_Simd.csv"), row.names = FALSE)

rm(i_admissions_equalities, g_admissions_ethnicity, ethnicity_adm_prop, g_admissions_simd, simd_adm_prop)

##cases

i_cases_equalities <- read_excel_with_options(glue(input_data, "equality_cases_combined.xlsx"))



g_cases_ethnicity <- i_cases_equalities %>%
  select(chi, Pathogen, Season, Week, Year, ethnic_code, ethnic_group,ethnic_desc) %>%
  dplyr::rename(CHI = chi,
                EthnicCode = ethnic_code,
                EthnicGroup = ethnic_group,
                EthnicDesc = ethnic_desc) %>%
  group_by(Season, Pathogen, EthnicCode, EthnicGroup,EthnicDesc) %>%
  summarise(Cases = n())

ethnicity_cases_prop <- g_cases_ethnicity %>%
  group_by(Season, Pathogen) %>%
  summarise(Proportion = (Cases/sum(Cases))*100) %>%
  ungroup()

g_cases_ethnicity$Proportion = ethnicity_cases_prop$Proportion

g_cases_simd <- i_cases_equalities %>%
  select(chi, Pathogen, Season, Week, Year, simd2020v2_sc_quintile) %>%
  dplyr::rename(CHI = chi,
                SIMD = simd2020v2_sc_quintile) %>%
  mutate(SIMD = as.character(SIMD),
         SIMD = recode(SIMD, "1" = "1 (most deprived)", "5" = "5 (least deprived)"),
         SIMD = ifelse(is.na(SIMD), "Unknown", SIMD)) %>%
  group_by(Season, Pathogen, SIMD) %>%
  summarise(Cases = n())

simd_cases_prop <- g_cases_simd %>%
  group_by(Season, Pathogen) %>%
  summarise(Proportion = (Cases/sum(Cases))*100) %>%
  ungroup()

g_cases_simd$Proportion = simd_cases_prop$Proportion


write.csv(g_cases_ethnicity, glue(output_folder, "Cases_Ethnicity.csv"), row.names = FALSE)

write.csv(g_cases_simd, glue(output_folder, "Cases_Simd.csv"), row.names = FALSE)

rm(i_cases_equalities, g_cases_ethnicity, ethnicity_cases_prop, g_cases_simd, simd_cases_prop)
