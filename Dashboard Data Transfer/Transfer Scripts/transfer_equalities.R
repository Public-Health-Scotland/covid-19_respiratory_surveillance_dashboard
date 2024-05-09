i_admissions_equalities <- read_excel_with_options(glue(input_data, "equality_admission_combined.xlsx"))



g_admissions_ethnicity <- i_admissions_equalities %>%
  select(chi, Pathogen, Season, Week, Year, ethnic_code, ethnic_group) %>%
  dplyr::rename(CHI = chi,
                EthnicCode = ethnic_code,
                EthnicGroup = ethnic_group) %>%
  group_by(Season, Pathogen, EthnicCode, EthnicGroup) %>%
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
