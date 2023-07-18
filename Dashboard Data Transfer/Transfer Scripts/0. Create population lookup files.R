###############################################################################
# Create population lookups
# Original authors: Andrew Mair
# Original date: 09/12/21
# Latest update author: Andrew Mair
# Latest update date: 09/12/21
# Latest update description: Finished  writing script
# Type of script
# Written on R-server using Rstudio
# Version of R that the script was most recently run on - 3.6.1
# Description: Creating RDS versions of the population lookup files
#              that are saved out by the SPSS script in the folder
#              \\stats\cl-out\Covid Daily Dashboard\Tableau process\Archive\SPSS syntax
#              with name 0. Create population lookup files.sps
# Approximate run time: 5 seconds
###############################################################################

###############################################################################
# Housekeeping ------------------------------------------------------------
###############################################################################

# Recording script start time
start_time_overall = Sys.time()

# Loading/installing all required packages

if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
pacman::p_load(dplyr, readr, tidyr, haven, stringr, glue, lubridate)

# Input filepath
input_filepath <- "//conf/linkage/output/lookups/Unicode/Populations/Estimates"

# Output filepath
output_filepath <- "//conf/linkage/output/Covid Daily Dashboard/Tableau process/Lookups"

###############################################################################
# Reading in outputs of SPSS script to check work -------------------------
###############################################################################

spss_scotland_populations <- read_sav(glue("{output_filepath}/Scotland_populations.sav"))
spss_hb_populations <- read_sav(glue("{output_filepath}/HB_populations.sav"))
spss_la_populations <- read_sav(glue("{output_filepath}/LA_populations.sav"))
spss_populations <- read_sav(glue("{output_filepath}/Populations.sav"))
spss_simd_populations <- read_sav(glue("{output_filepath}/SIMD_populations.sav"))
spss_intzone_populations <- read_sav(glue("{output_filepath}/IntZone_populations.sav"))

###############################################################################
# Reading in files used to create outputs ---------------------------------
###############################################################################

base_hb_population <- readRDS(glue("{input_filepath}/HB2019_pop_est_5year_agegroups_1981_2020.rds"))
base_la_population <- readRDS(glue("{input_filepath}/CA2019_pop_est_5year_agegroups_1981_2020.rds"))
base_datazone_population <-  readRDS(glue("{input_filepath}/DataZone2011_pop_est_5year_agegroups_2011_2020.rds"))

###############################################################################
# Scotland populations output ---------------------------------------------
###############################################################################

# Breaking down Scottish population by Scottish age grouping and sex
scotland_agegroup_scotland <- base_hb_population %>% 
  filter(year == 2020) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" ~ "0 to 14",
                              age_group_name == "15-19" ~ "15 to 19",
                              age_group_name == "20-24" ~ "20 to 24",
                              age_group_name == "25-29" | age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" ~ "25 to 44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45 to 64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65 to 74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75 to 84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Breaking down Scottish population by sex and over or under 60s.
scotland_agegroup60plus <- base_hb_population %>% 
  filter(year == 2020) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                              age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Total population of Scotland
scotland_total <- base_hb_population %>% 
  filter(year == 2020) %>% 
  mutate(location_code = "Scotland")%>% 
  group_by(location_code) %>% 
  summarise(Pop = sum(pop)) %>% 
  mutate(sex = "Total", agegroup = "Total")

# Combining above breakdowns of Scottish population.
scotland_populations <- bind_rows(scotland_agegroup_scotland, scotland_agegroup60plus, scotland_total) %>% 
  arrange(sex, agegroup)
  
# Checking that the R dataframe matches the SPSS dataframe
print(all(scotland_populations == spss_scotland_populations))

# Saving out dataframe
saveRDS(scotland_populations, glue("{output_filepath}/Scotland_populations.rds"))

# Removing dataframes
rm(scotland_agegroup_scotland, scotland_agegroup60plus, scotland_total)

###############################################################################
# Health board population output ------------------------------------------
###############################################################################

# Breaking down population of each health board by age group and sex.
hb_agegroup <- base_hb_population %>% 
  filter(year == 2020) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" ~ "0 to 14",
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | age_group_name == "30-34" |
                              age_group_name == "35-39" | age_group_name == "40-44" ~ "15 to 44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45 to 64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65 to 74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75 to 84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+")) %>%
  rename(location_code = hb2019) %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Breaking down population of each health board by age group and over or under 60
hb_agegroup60plus <- base_hb_population %>% 
  filter(year == 2020) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                              age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+")) %>%
  rename(location_code = hb2019) %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Breaking down Scottish population by health board.
hb_totals <- base_hb_population %>% 
  filter(year == 2020) %>% 
  rename(location_code = hb2019)%>% 
  group_by(location_code) %>% 
  summarise(Pop = sum(pop)) %>% 
  mutate(sex = "Total", agegroup = "Total")

# Combining the above breakdowns of health board populations.
hb_populations <- bind_rows(hb_agegroup, hb_agegroup60plus, hb_totals) %>% 
  arrange(location_code, sex, agegroup)

# Checking that R dataframe matches the SPSS dataframe.
print(all(hb_populations == spss_hb_populations))

# Saving out dataframe
saveRDS(hb_populations, glue("{output_filepath}/HB_populations.rds"))

# Removing dataframes
rm(hb_agegroup, hb_agegroup60plus, hb_totals)

###############################################################################
# Local authority population output ---------------------------------------
###############################################################################

# Breaking down local authority populations by age group and sex.
la_agegroup <- base_la_population %>% 
  filter(year == 2020) %>%
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" ~ "0 to 14",
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | age_group_name == "30-34" |
                              age_group_name == "35-39" | age_group_name == "40-44" ~ "15 to 44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45 to 64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65 to 74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75 to 84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+")) %>%
  rename(location_code = ca2019) %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Breaking down local authority populations by sex and under/over 60s.
la_agegroup60plus <- base_la_population %>% 
  filter(year == 2020) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                              age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+")) %>%
  rename(location_code = ca2019) %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(sex = sex_name)

# Scottish population broken down by local authority.
la_totals <- base_la_population %>% 
  filter(year == 2020) %>%
  rename(location_code = ca2019) %>%
  group_by(location_code) %>% 
  summarise(Pop = sum(pop)) %>% 
  mutate(sex = "Total", agegroup = "Total")

# Combining the above breakdowns of the local authority populations
la_populations <- bind_rows(la_agegroup, la_agegroup60plus, la_totals) %>% 
  arrange(location_code, sex, agegroup)

# Checking that R dataframe matches the SPSS dataframe
print(all(la_populations == spss_la_populations))

# Saving out dataframe
saveRDS(la_populations, glue("{output_filepath}/LA_populations.rds"))

# removing dataframes
rm(la_agegroup, la_agegroup60plus, la_totals)

###############################################################################
# Combined scotland, health board and local authority output ------------------------
###############################################################################

populations <- bind_rows(hb_populations, la_populations, scotland_populations)

# Checking that R dataframe matches the SPSS dataframe
print(all(populations == spss_populations))

# Saving out dataframe
saveRDS(populations, glue("{output_filepath}/Populations.rds"))
  
###############################################################################
# SIMD population output --------------------------------------------------
###############################################################################

# Breaking down the population of each health board by SIMD quintile.
simd_hb <- base_datazone_population %>% 
  filter(year == 2020) %>% 
  rename(SIMD = simd2020v2_sc_quintile,
         location_code = hb2019) %>%
  group_by(location_code, SIMD) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the population of each local authority by SIMD quintile.
simd_la <- base_datazone_population %>% 
  filter(year == 2020) %>% 
  rename(SIMD = simd2020v2_sc_quintile,
         location_code = ca2019) %>%
  group_by(location_code, SIMD) %>% 
  summarise(Pop = sum(total_pop))

# Breaking down the Scottish population by SIMD quintile
simd_scotland <- base_datazone_population %>% 
  filter(year == 2020) %>% 
  rename(SIMD = simd2020v2_sc_quintile) %>% 
  mutate(location_code = "Scotland") %>% 
  group_by(location_code, SIMD) %>% 
  summarise(Pop = sum(total_pop))

# Combining the above population breakdowns.
simd_populations <- bind_rows(simd_hb, simd_la, simd_scotland) %>% 
  arrange(location_code, SIMD)

# Checking that there are no unusually large differences from SPSS dataframe.
# There will be differences though since this script uses 2020 data and the SPSS
# script used 2019 data for SIMD breakdowns.

simd_diffs <- abs(simd_populations$Pop - spss_simd_populations$Pop)
print(summary(simd_diffs))  

# Median difference of 164 for SIMD so should be explainable by move from 2019 to 2020 data.

# Saving out dataframe
saveRDS(simd_populations, glue("{output_filepath}/SIMD_populations.rds"))

# Removing dataframes
rm(simd_hb, simd_la, simd_scotland)

###########################################################################
# Intermediate zone output ------------------------------------------------
###########################################################################

# Breaking down the Scottish population by intermediate zone
intzone_populations <- base_datazone_population %>% 
  filter(year == 2020) %>% 
  rename(IntZone2011 = intzone2011) %>% 
  group_by(IntZone2011) %>% 
  summarise(Pop = sum(total_pop))

# Checking that there are no unusually large differences from SPSS dataframe.
# There will be differences though since this script uses 2020 data and the SPSS
# script used 2019 data for intermediate zone breakdowns.
intzone_diffs <- abs(intzone_populations$Pop - spss_intzone_populations$Pop)
print(summary(intzone_diffs))

# Median difference of 36 for intermediate zone so should be explainable by move from 2019 to 2020 data.

# Saving out dataframe
saveRDS(intzone_populations, glue("{output_filepath}/IntZone_populations.rds"))

###########################################################################
# Computing run time ------------------------------------------------------
###########################################################################

end_time_overall = Sys.time()
print("Run time")
print(end_time_overall- start_time_overall)