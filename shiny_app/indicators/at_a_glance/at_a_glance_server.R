
latest_week <- ceiling_date(today() - 14, unit = "week")
previous_week <- ceiling_date(today() - 21, unit = "week")

covid_cases_intro <- Cases %>%
  tail(14) %>%
  mutate(Date = as.character(Date)) %>%
  #mutate(Date = as.Date(Date, format = "%Y%m%d")) %>%
  #mutate(ISOWeek = isoweek(Date)) %>%
  mutate(week_ending = as_date(ceiling_date(as_date(Date), "week",
                                                 change_on_boundary = F))) %>%
  group_by(week_ending) %>%
  summarise(WeeklyTotal = sum(NumberCasesPerDay)) %>%
  ungroup() %>%
  mutate(flag = ifelse(week_ending == latest_week, "Latest Week", "Previous Week")) %>%
  select(-week_ending) %>%
  pivot_wider(names_from = flag, values_from = WeeklyTotal) %>%
  mutate(Pathogen = "COVID-19") %>%
  mutate(PercentageChange = ((`Latest Week` - `Previous Week`)/`Previous Week`*100)) %>%
  select(Pathogen, `Latest Week`, `Previous Week`, PercentageChange)



