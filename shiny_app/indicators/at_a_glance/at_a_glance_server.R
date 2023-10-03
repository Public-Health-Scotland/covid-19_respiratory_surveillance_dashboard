
### Setup data -----

#latest_week <- ceiling_date(today() - 14, unit = "week")
latest_week <- Cases %>%
  tail(1) %>%
  .$Date %>%
  convert_opendata_date()

#previous_week <- ceiling_date(today() - 21, unit = "week")
previous_week <- Cases %>%
  tail(8) %>% slice(1) %>%
  .$Date %>%
  convert_opendata_date()

pop_scot_total <- i_population_v2 %>%
  filter(AgeGroup == "Total", Sex == "Total") %>%
  .$PopNumber

###Cases
covid_cases_intro <- Cases %>%
  tail(14) %>%
  mutate(Date = as.character(Date)) %>%
  mutate(week_ending = as_date(ceiling_date(as_date(Date), "week",change_on_boundary = F))) %>%
  group_by(week_ending) %>%
  summarise(cases_number = sum(NumberCasesPerDay)) %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>% 
  ungroup() %>%
  mutate(flag = ifelse(week_ending == latest_week, "latest_week", "previous_week")) %>%
  select(-week_ending) %>%
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  mutate(Pathogen = "COVID-19") 
 # mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  

flu_cases_intro <- Respiratory_AllData %>%
  filter(FluOrNonFlu == "flu") %>%
  filter(Organism == "Influenza - Type A or B") %>%
  filter(BreakDown == "Scotland") %>%
  group_by(Date) %>%
  summarise(cases_number = sum(Count)) %>%
  ungroup() %>%
  tail(2) %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>% 
    mutate(flag = ifelse(Date == latest_week, "latest_week", "previous_week")) %>%
  select(-Date) %>%
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  mutate(Pathogen = "Influenza") 
  # mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%


nonflu_cases_intro <- Respiratory_AllData %>%
  filter(FluOrNonFlu == "nonflu") %>%
  filter(Organism != "Total") %>%
  filter(BreakDown == "Scotland") %>%
  group_by(Date, Organism) %>%
  summarise(cases_number = sum(Count)) %>%
  ungroup() %>%
  filter(Date %in% latest_week | Date %in% previous_week) %>%
  ungroup() %>%
  mutate(flag = ifelse(Date == latest_week, "latest_week", "previous_week")) %>%
  select(-Date) %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>% 
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  select(-c(flag_latest_week, flag_previous_week)) %>% 
  rename(Pathogen = Organism) %>%
  #mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  mutate(Pathogen =  factor(Pathogen, levels = c("Respiratory syncytial virus", "Adenovirus", "Human metapneumovirus",
                                                 "Mycoplasma pneumoniae", "Parainfluenza virus", "Rhinovirus",
                                                 "Seasonal coronavirus (Non-SARS-CoV-2)"))) %>%
  arrange(Pathogen)


cases_intro <- covid_cases_intro %>%
  bind_rows(flu_cases_intro) %>%
  bind_rows(nonflu_cases_intro) %>% 
  select(Pathogen, 
         'Number of cases (latest week)'= cases_number_latest_week, 
         'Rate per 100,000 population (latest week)'= cases_rate_latest_week,
         'Number of cases (previous week)'= cases_number_previous_week, 
         'Rate per 100,000 population (previous week)'= cases_rate_previous_week)


# 
# covid_cases_intro <- Cases %>%
#   tail(14) %>%
#   mutate(Date = as.character(Date)) %>%
#   mutate(week_ending = as_date(ceiling_date(as_date(Date), "week",
#                                             change_on_boundary = F))) %>%
#   group_by(week_ending) %>%
#   summarise(WeeklyTotal = sum(NumberCasesPerDay)) %>%
#   mutate(CumulativeRatePer100000 = round_half_up(100000 * WeeklyTotal / pop_grandtotal,1)) %>% 
#   ungroup() %>%
#   mutate(flag = ifelse(week_ending == latest_week, "Latest Week", "Previous Week")) %>%
#   select(-week_ending) %>%
#   pivot_wider(names_from = flag, values_from = WeeklyTotal) %>%
#   mutate(Pathogen = "COVID-19") %>%
#   mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
#  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)



# flu_cases_intro <- Respiratory_AllData %>%
#   filter(FluOrNonFlu == "flu") %>%
#   filter(Organism == "Influenza - Type A or B") %>%
#   filter(BreakDown == "Scotland") %>%
#   group_by(Date) %>%
#   summarise(WeeklyTotal = sum(Count)) %>%
#   ungroup() %>%
#   tail(2) %>%
#   mutate(flag = ifelse(Date == latest_week, "Latest Week", "Previous Week")) %>%
#   select(-Date) %>%
#   pivot_wider(names_from = flag, values_from = WeeklyTotal) %>%
#   mutate(Pathogen = "Influenza") %>%
#   mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
#   select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)

# 
# nonflu_cases_intro <- Respiratory_AllData %>%
#   filter(FluOrNonFlu == "nonflu") %>%
#   filter(Organism != "Total") %>%
#   filter(BreakDown == "Scotland") %>%
#   group_by(Date, Organism) %>%
#   summarise(WeeklyTotal = sum(Count)) %>%
#   ungroup() %>%
#   filter(Date %in% latest_week | Date %in% previous_week) %>%
#   ungroup() %>%
#   mutate(flag = ifelse(Date == latest_week, "Latest Week", "Previous Week")) %>%
#   select(-Date) %>%
#   pivot_wider(names_from = flag, values_from = WeeklyTotal) %>%
#   rename(Pathogen = Organism) %>%
#   mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
#   select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange) %>%
#   mutate(Pathogen =  factor(Pathogen, levels = c("Respiratory syncytial virus", "Adenovirus", "Human metapneumovirus",
#                                                  "Mycoplasma pneumoniae", "Parainfluenza virus", "Rhinovirus",
#                                                  "Seasonal coronavirus (Non-SARS-CoV-2)"))) %>%
#   arrange(Pathogen)




###Hosp Adms

covid_hosp_adms_intro <- Admissions %>%
  tail(14) %>%
  mutate(AdmissionDate = as.character(AdmissionDate)) %>%
  mutate(week_ending = as_date(ceiling_date(as_date(AdmissionDate), "week",
                                            change_on_boundary = F))) %>%
  group_by(week_ending) %>%
  summarise(WeeklyTotal = sum(TotalInfections)) %>%
  ungroup() %>%
  mutate(flag = ifelse(week_ending == latest_week, "Latest Week", "Previous Week")) %>%
  select(-week_ending) %>%
  pivot_wider(names_from = flag, values_from = WeeklyTotal) %>%
  mutate(Pathogen = "COVID-19") %>%
  mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)

flu_hosp_adms_intro <- Influenza_admissions %>%
  filter(FluType == "Influenza A & B") %>%
  tail(2) %>%
  select(Date, Admissions) %>%
  mutate(flag = ifelse(Date == latest_week, "Latest Week", "Previous Week")) %>%
  select(-Date) %>%
  pivot_wider(names_from = flag, values_from = Admissions) %>%
  mutate(Pathogen = "Influenza") %>%
  mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)

rsv_hosp_adms_intro <- RSV_admissions %>%
  tail(2) %>%
  select(Date, Admissions) %>%
  mutate(flag = ifelse(Date == latest_week, "Latest Week", "Previous Week")) %>%
  select(-Date) %>%
  pivot_wider(names_from = flag, values_from = Admissions) %>%
  mutate(Pathogen = "Respiratory syncytial virus") %>%
  mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)

hosp_adms_intro <- covid_hosp_adms_intro %>%
  bind_rows(flu_hosp_adms_intro) %>%
  bind_rows(rsv_hosp_adms_intro)

###Inpatients

covid_inpatients_intro_latest <- Occupancy_Hospital %>%
  tail(1)

covid_inpatients_intro_prev <- Occupancy_Hospital %>%
  tail(8) %>%
  slice(1)

covid_inpatients_intro <- covid_inpatients_intro_prev %>%
  bind_rows(covid_inpatients_intro_latest) %>%
  mutate(Date = as.character(Date)) %>%
  mutate(Date = as.Date(Date, format = "%Y%m%d")) %>%
  mutate(flag = ifelse(Date == latest_week, "Latest Week", "Previous Week")) %>%
  select(flag, HospitalOccupancy) %>%
  pivot_wider(names_from = flag, values_from = HospitalOccupancy) %>%
  mutate(Pathogen = "COVID-19") %>%
  mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)

### Data tables -----

# Cases table
output$cases_intro_table <- renderDataTable({
  cases_intro %>%
  # rename(`Percentage Change` = PercentageChange) %>%
    make_table(add_separator_cols_2dp = c(4))
})

# Hospital admissions table
output$hosp_adms_intro_table <- renderDataTable({
  hosp_adms_intro %>%
    rename(`Percentage Change` = PercentageChange) #%>%
   # make_table(add_separator_cols_2dp = c(4))
})

# Inpatients table
output$inpatients_intro_table <- renderDataTable({
  covid_inpatients_intro %>%
    rename(`Percentage Change` = PercentageChange) %>%
    make_table(add_separator_cols_2dp = c(4))
})

### Plot -----
output$hosp_adms_intro_plot <- renderPlotly({
  Respiratory_admissions_summary %>%
    create_summary_adms_linechart()

})

