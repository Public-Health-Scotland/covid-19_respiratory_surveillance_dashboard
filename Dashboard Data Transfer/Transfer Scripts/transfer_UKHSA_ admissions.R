# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

##### Hospital Admissions

adm_path <- "/conf/PHSCOVID19_Analysis/RAPID Reporting/Daily_extracts"


read_rds_with_options <- create_loader_with_options(readRDS)
i_chiadm <- read_rds_with_options(glue("{adm_path}/Proxy provisional figures/CHI_Admissions_proxy.rds"))


# Filter CHI and 12 files down to last Sunday
i_chiadm %<>% filter(admission_date <= (report_date - 3))



### Admissions_Age_Breakdown



g_adm_daily<- i_chiadm %>%
  mutate(
    AgeYear = as.numeric(age_year),
    AgeGroup = case_when(AgeYear < 6 ~ '0-5',
                         AgeYear < 18 ~ '6-17',
                         AgeYear < 24 ~ '18-24',
                         AgeYear < 50 ~ '25-34',
                         AgeYear < 55 ~ '35-44',
                         AgeYear < 60 ~ '45-54',
                         AgeYear < 65 ~ '55-64',
                         AgeYear < 70 ~ '65-69',
                         AgeYear < 75 ~ '70-74',
                         AgeYear < 80 ~ '75-84',
                         AgeYear < 200 ~ '85+',
                         is.na(AgeYear) ~ 'Unknown')) 

g_adm_all_ages<- g_adm_daily %>%
  group_by(Date=admission_date) %>%
  summarise(Admissions = n()) %>%
  ungroup() %>% 
  mutate(AgeGroup="All ages")

g_adm_daily_agegroup<- g_adm_daily %>%
  group_by(Date=admission_date, AgeGroup) %>%
  summarise(Admissions = n()) %>%
  ungroup() %>% 
  rbind(g_adm_all_ages) 


age_grp_pivot<-g_adm_daily_agegroup %>%
  pivot_wider(names_from = AgeGroup,
              values_from = Admissions) %>% 
  select(Date,'0-5','6-17','18-24','25-34','35-44','45-54',
         '55-64','65-69', '70-74', '75-84','85+','All ages')

  write.csv(age_grp_pivot, glue(ukhsa_adm, "daily_adms_{od_report_date}.csv"), na="")

