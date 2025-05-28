
lookup_filepath <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Equalities/Lookups/"

i_admissions_equalities <- read_excel_with_options(glue(input_data, "equality_admission_combined.xlsx"))


#Ethnicity
g_admissions_ethnicity <- i_admissions_equalities %>%
  select(chi, age_group,Pathogen, Season, Week, Year, ethnic_code, ethnic_group,ethnic_desc) %>%
  filter(ethnic_group != "Not Known") %>%  #removing rows with unknowns
  dplyr::rename(CHI = chi,
                EthnicCode = ethnic_code,
                EthnicGroup = ethnic_group,
                EthnicDesc = ethnic_desc,
                AgeGroup = age_group) %>%
  group_by(Season, Pathogen, AgeGroup, EthnicCode, EthnicGroup,EthnicDesc) %>%
  summarise(Admissions = n())

# #reading in the ethnicity population data file
ethnicity_age_population <-  read_csv(paste0(lookup_filepath,"ethnicity_age_population.csv")) %>% 
  pivot_longer(!age_band, names_to = "EthnicGroup", values_to = "census_population") %>% 
  rename(AgeGroup = age_band)
# 
 g_admissions_ethnicity <- g_admissions_ethnicity %>% 
   left_join(ethnicity_age_population, by = c("EthnicGroup","AgeGroup"))

##Calculation of a European age standardised rate (directly standardised rate using European Standard Population 2013)
 
# European Standard Population data
euro_std_pop <- read_csv(paste0(lookup_filepath,"esp_2013.csv"))

#use a join to attach the European Standard Population data
g_admissions_ethnicity <- g_admissions_ethnicity %>% 
  left_join(euro_std_pop,by = join_by("AgeGroup" == "age"))

k <- 100000

# inserting a column into our data frame for the age-specific rate
g_admissions_ethnicity_standardised <-g_admissions_ethnicity %>%
  group_by(Season,Pathogen,EthnicGroup,AgeGroup) %>% 
  mutate(age_specific_rate = (Admissions * k) / census_population) %>% 
# insert 2 new columns
# the first column gives the age specific rate for the standard population
  mutate(asr_std_popn = age_specific_rate * esp_2013)


# Step 1: Calculate EASR
g_easr_ethnicity <- g_admissions_ethnicity_standardised %>%
  group_by(Season, Pathogen, EthnicGroup) %>% #dropping the age groups and calculating easr within each ethnic group
  summarise(
    EASR = sum(asr_std_popn) / k,
    .groups = "drop"
  )

# Step 2: Join back EthnicDesc
 

g_easr_ethnicity <- g_easr_ethnicity %>%
  left_join(
    g_admissions_ethnicity %>%
      ungroup() %>% 
      select(EthnicGroup, EthnicDesc) %>%
      distinct(),
    by = "EthnicGroup"
  ) %>% 
  select(Season,Pathogen,EthnicGroup,EthnicDesc,EASR)

  

#SIMD
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



write.csv(g_easr_ethnicity, glue(output_folder, "Admissions_Ethnicity.csv"), row.names = FALSE)

write.csv(g_admissions_simd, glue(output_folder, "Admissions_Simd.csv"), row.names = FALSE)

rm(i_admissions_equalities, g_easr_ethnicity, g_admissions_simd, simd_adm_prop)

##cases


i_cases_equalities <- read_excel_with_options(glue(input_data, "equality_cases_combined.xlsx"))

#cases - ethnicity

g_cases_ethnicity <- i_cases_equalities %>%
  select(chi,age_group, Pathogen, Season, Week, Year, ethnic_code, ethnic_group,ethnic_desc) %>%
  filter(ethnic_group != "Not Known") %>%  #removing rows with unknowns
  dplyr::rename(CHI = chi,
                EthnicCode = ethnic_code,
                EthnicGroup = ethnic_group,
                EthnicDesc = ethnic_desc,
                AgeGroup = age_group) %>%
  group_by(Season, Pathogen,AgeGroup, EthnicCode, EthnicGroup,EthnicDesc) %>%
  summarise(Cases = n())

 g_cases_ethnicity <-  g_cases_ethnicity %>% 
   left_join(ethnicity_age_population, by = c("EthnicGroup","AgeGroup"))
 

 
 #use a join to attach the European Standard Population data
 g_cases_ethnicity <- g_cases_ethnicity %>% 
   left_join(euro_std_pop,by = join_by("AgeGroup" == "age"))
 
 
 # inserting a column into our data frame for the age-specific rate
 g_cases_ethnicity_standardised <-g_cases_ethnicity %>%
   group_by(Season,Pathogen,EthnicGroup,AgeGroup) %>% 
   mutate(age_specific_rate = (Cases * k) / census_population) %>% 
   # insert 2 new columns
   # the first column gives the age specific rate for the standard population
   mutate(asr_std_popn = age_specific_rate * esp_2013)
 
 
 # Step 1: Calculate EASR
 g_easr_ethnicity_cases <- g_cases_ethnicity_standardised %>%
   group_by(Season, Pathogen, EthnicGroup) %>% #dropping the age groups and calculating easr within each ethnic group
   summarise(
     EASR = sum(asr_std_popn) / k,
     .groups = "drop"
   )
 
 # Step 2: Join back EthnicDesc
 
 
 g_easr_ethnicity_cases <- g_easr_ethnicity_cases %>%
   left_join(
     g_cases_ethnicity %>%
       ungroup() %>% 
       select(EthnicGroup, EthnicDesc) %>%
       distinct(),
     by = "EthnicGroup"
   ) %>% 
   select(Season,Pathogen,EthnicGroup,EthnicDesc,EASR)

 
 #simd for cases

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


write.csv(g_easr_ethnicity_cases, glue(output_folder, "Cases_Ethnicity.csv"), row.names = FALSE)

write.csv(g_cases_simd, glue(output_folder, "Cases_Simd.csv"), row.names = FALSE)

rm(i_cases_equalities, g_easr_ethnicity_cases, g_cases_simd, simd_cases_prop)
