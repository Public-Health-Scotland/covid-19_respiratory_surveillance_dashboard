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


#### New population section####
# retain i_population in the interim, but update cases with this version

pop_year= 2021# use to filter through entire script, only need to update 1 line when Pop Est files updated

gpd_base_path<-"/conf/linkage/output/lookups/Unicode/"

# update when Pop Estimates updated
base_hb_population <- readRDS(glue(gpd_base_path,"Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_2021.rds"))%>% 
  mutate(sex=if_else(sex_name=="F", "Female", "Male"))


pop_agegroup_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% # changes when GPD population estimates updated
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" ~ "0 to 14",
                              age_group_name == "15-19" ~ "15 to 19",
                              age_group_name == "20-24" ~ "20 to 24",
                              age_group_name == "25-29" | age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" ~ "25 to 44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45 to 64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65 to 74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75 to 84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex, agegroup) %>% 
  summarise(pop = sum(pop)) %>% 
  ungroup()

pop_agegroup_total<-pop_agegroup_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop = sum(pop)) %>% 
  mutate(sex="Total") %>% 
  ungroup()

pop_60plus_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(agegroup = case_when(age_group_name == "0" | age_group_name == "1-4" | age_group_name == "5-9" | age_group_name == "10-14" |
                                age_group_name == "15-19" | age_group_name == "20-24" | age_group_name == "25-29" | 
                                age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" |
                                age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" ~ "0 to 59",
                              TRUE ~ "60+"),
         location_code = "Scotland") %>% 
  group_by(location_code, sex, agegroup) %>% 
  summarise(pop = sum(pop)) %>% 
  ungroup()

#group without sex to obtain total pop 0-60 and plus 60 
pop_60plus_total<-pop_60plus_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop = sum(pop))  %>% 
  mutate(sex="Total") %>% 
  ungroup()

# Total population of Scotland by sex
pop_total_sex <- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(location_code = "Scotland", 
         agegroup="Total")%>% 
  group_by(location_code,sex) %>% 
  summarise(pop = sum(pop)) %>% 
  mutate(agegroup="Total") %>% 
  ungroup()

# Total population of Scotland combined sex
pop_total_total<- pop_total_sex %>% 
  group_by(location_code, agegroup) %>% 
  summarise(pop=sum(pop)) %>% 
  mutate(sex="Total") %>% 
  ungroup()

######  dashboard population for cases rates #######
pop_dash_sex_ageband <- base_hb_population %>% 
  filter(year == pop_year) %>% # changes when GPD population estimates updated
  mutate(AgeGroup = case_when(age_group_name == "0" | age_group_name == "1-4" ~ "0-4 ", 
                              age_group_name == "5-9" | age_group_name == "10-14" ~ "5-14",
                              age_group_name==  "15-19" ~ "15-19",
                              age_group_name == "20-24"~ "20-24",
                              age_group_name == "25-29" | age_group_name == "30-34" | age_group_name == "35-39" | age_group_name == "40-44" ~ "25-44",
                              age_group_name == "45-49" | age_group_name == "50-54" | age_group_name == "55-59" | age_group_name == "60-64" ~ "45-64",
                              age_group_name == "65-69" | age_group_name == "70-74" ~ "65-74",
                              age_group_name == "75-79" | age_group_name == "80-84" ~ "75-84",
                              age_group_name == "85-89" | age_group_name == "90+" ~ "85+")) %>% 
  group_by(sex, AgeGroup) %>% 
  summarise(PopNumber = sum(pop)) %>% 
  ungroup() %>% 
  arrange(AgeGroup, sex)

pop_dash_sex<-pop_dash_sex_ageband %>% 
  group_by(sex) %>% 
  summarise(PopNumber = sum(PopNumber)) %>% 
  ungroup() %>% 
  mutate(AgeGroup="Total")

pop_dash_ageband <-  pop_dash_sex_ageband %>% 
  group_by(AgeGroup) %>% 
  summarise(PopNumber = sum(PopNumber)) %>% 
  mutate(sex="Total") %>% 
  ungroup()

pop_dash_total<-pop_dash_ageband  %>% 
  group_by(sex) %>% 
  summarise(PopNumber = sum(PopNumber)) %>% 
  mutate(sex="Total", AgeGroup="Total") %>% 
  ungroup()


pop_dash_sex_fifteen_fourty_four<- base_hb_population %>% 
  filter(year == pop_year) %>% 
  mutate(AgeGroup = case_when(age_group_name==  "15-19" |age_group_name == "20-24"|
                                age_group_name == "25-29" | age_group_name == "30-34"|
                                age_group_name == "35-39" | age_group_name == "40-44" ~ "15-44",
                              TRUE ~ "remove")) %>% 
  filter(AgeGroup!="remove") %>% 
  group_by(sex, AgeGroup) %>%  
  summarise(PopNumber = sum(pop)) %>% 
  ungroup() 

pop_dash_fifteen_fourty_four <- pop_dash_sex_fifteen_fourty_four%>% 
  group_by(AgeGroup) %>% 
  summarise(PopNumber = sum(PopNumber)) %>% 
  mutate(sex="Total") %>% 
  ungroup()

i_population_v2<- bind_rows(pop_dash_sex_ageband,
                            pop_dash_ageband,
                            pop_dash_sex,
                            pop_dash_total,
                            pop_dash_sex_fifteen_fourty_four,
                            pop_dash_fifteen_fourty_four) %>% 
  arrange(AgeGroup) %>% 
  rename(Sex=sex)

write_csv(i_population_v2, glue(output_folder, "i_population_v2.csv"))

rm(pop_dash_sex_ageband,
   pop_dash_ageband,
   pop_dash_sex,
   pop_dash_total,
   pop_dash_sex_fifteen_fourty_four,
   pop_dash_fifteen_fourty_four, 
   i_population_v2)
