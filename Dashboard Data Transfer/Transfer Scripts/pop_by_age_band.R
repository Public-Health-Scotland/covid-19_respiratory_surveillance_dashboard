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


###############################################################################
# Housekeeping ------------------------------------------------------------
###############################################################################

# enter latest population year
pop_year= 2021

###############################################################################
# Reading in files used to create outputs ---------------------------------
###############################################################################

gpd_base_path<-"/conf/linkage/output/lookups/Unicode/"

#base_hb_population <- readRDS(glue(gpd_base_path, "Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_2021.rds"))

base_hb_population <- readRDS(glue(gpd_base_path,"Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_2021.rds"))
# base_la_population <- readRDS(glue("{input_filepath}/CA2019_pop_est_5year_agegroups_1981_2020.rds"))
# base_datazone_population <-  readRDS(glue("{input_filepath}/DataZone2011_pop_est_5year_agegroups_2011_2020.rds"))

###############################################################################
# Scotland populations output ---------------------------------------------
###############################################################################

# Breaking down Scottish population by Scottish age grouping and sex
pop_agegroup_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
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
  rename(Sex = sex_name)

scotland_agegroup_total<-scotland_agegroup_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(Pop = sum(Pop)) %>% 
  mutate(Sex="Total")

# Breaking down Scottish population by sex and over or under 60s.
scotland_60plus_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                              age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                              age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex_name, agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(Sex = sex_name)
#group without sex to obtain total pop 0-60 and plus 60 

scotland_60plus_total<-scotland_60plus_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(Pop = sum(Pop))  %>% 
  mutate(Sex="Total")


# Total population of Scotland by sex
scotland_total_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(location_code = "Scotland", 
         agegroup="Total")%>% 
  group_by(location_code,sex_name,agegroup) %>% 
  summarise(Pop = sum(pop)) %>% 
  rename(Sex = sex_name)

# Total population of Scotland
scotland_total_total<-scotland_total_sex%>% 
  group_by(location_code, agegroup) %>% 
  summarise(Pop=sum(Pop)) %>% 
  mutate(Sex="Total")

# Combining above breakdowns of Scottish population.
scotland_populations <- bind_rows(scotland_agegroup_sex ,scotland_agegroup_total,
                                  scotland_60plus_sex, scotland_60plus_total,
                                  scotland_total_sex,scotland_total_total ) %>% 
  arrange(Sex, agegroup)

# Removing dataframes
rm(base_hb_population, scotland_agegroup_sex ,scotland_agegroup_total,
   scotland_60plus_sex, scotland_60plus_total,
   scotland_total_sex,scotland_total_total)
