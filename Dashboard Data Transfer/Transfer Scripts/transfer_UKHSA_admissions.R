# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

##### Hospital Admissions

adm_path <- "/conf/PHSCOVID19_Analysis/RAPID Reporting/Daily_extracts"

ukhsa_adm_min_date <- format(as.Date("2023-08-01"), "%Y-%m-%d")



read_rds_with_options <- create_loader_with_options(readRDS)
i_chiadm_ukhsa <- read_rds_with_options(glue("{adm_path}/Proxy provisional figures/CHI_Admissions_proxy.rds"))


# Filter CHI and 12 files down to last Sunday
i_chiadm_ukhsa %<>% 
  filter( admission_date >= ukhsa_adm_min_date &  admission_date <= (report_date - 3))

### Admissions_Age_Breakdown
ukhsa_adm_daily<- i_chiadm_ukhsa  %>%
  dplyr::rename(AdmissionDate = admission_date) %>% 
  mutate(ProvisionalFlag = case_when(
          AdmissionDate > (report_date-10) ~ 1,
          TRUE ~ 0),
         AdmissionDate = format(as.Date(AdmissionDate), "%Y%m%d"),
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

# create all age groups
ukhsa_adm_all_ages<- ukhsa_adm_daily %>%
  group_by(AdmissionDate) %>%
  summarise(Admissions = sum(TestDIn)) %>%
  ungroup() %>% 
  mutate(AgeGroup="All ages")


# sum admissions by UKSA agegroup and bind all ages to it
ukhsa_adm_agegroup<- ukhsa_adm_daily %>%
  group_by(AdmissionDate, AgeGroup) %>%
  summarise(Admissions = sum(TestDIn)) %>%
  ungroup() %>% 
  rbind(ukhsa_adm_all_ages) 

#create pivot table
ukhsa_adm_agegroup_pivot<-ukhsa_adm_agegroup %>%
  pivot_wider(names_from = AgeGroup,
              values_from = Admissions) %>% 
  select(AdmissionDate,'0-5','6-17','18-24','25-34','35-44','45-54',
         '55-64','65-69', '70-74', '75-84','85+', 'All ages')

  write.csv(ukhsa_adm_agegroup_pivot, glue(ukhsa_adm, "daily_adms_agegrp.csv"), 
            row.names=FALSE, na="")
  
  rm(i_chiadm_ukhsa, ukhsa_adm_agegroup, ukhsa_adm_all_ages, ukhsa_adm_daily,
     ukhsa_adm_agegroup_pivot)
