# Dashboard data transfer for influezna hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### Influenza

#create weekord
date_reference_ord <-readRDS("/conf/C19_Test_and_Protect/Analyst Space/Calum (Analyst Space)/flu_seasons.Rds") %>%
  distinct(flu_season, year, ISOweek) %>%
  mutate(alltime_weekord = row_number()) %>%
  group_by(flu_season) %>%
  mutate(season_weekord = row_number()) %>%
  ungroup() %>%
  rename(Weekord = season_weekord) %>%
  select(-alltime_weekord)

#create lookup to add season and weekord to data
 date_reference <- readRDS("/conf/C19_Test_and_Protect/Analyst Space/Calum (Analyst Space)/flu_seasons.Rds") %>%
  distinct(date, year, ISOweek, flu_season) %>%
   left_join(date_reference_ord)

i_resp_admissions_summary <- read_csv_with_options(match_base_filename(glue(input_data, "Combined_weekly_Flu_RSV_COVID_data.csv")))

g_resp_admissions_summary <- i_resp_admissions_summary %>%
  dplyr::rename(Admissions = Frequency,
                Date = date_plot) %>%
  mutate(date = as.Date(Date)) %>%
  left_join(date_reference) %>%
  mutate(Date = as_date(ceiling_date(as_date(Date), "week",
                                     change_on_boundary = F))) %>%
  dplyr::rename(CaseDefinition = Case_definition,
                Year = year,
                ISOWeek = ISOweek,
                Season = flu_season) %>%
  select(Date, Year, ISOWeek, Weekord, Season, CaseDefinition, Admissions)


i_influenza_admissions <- read_csv_with_options(match_base_filename(glue(input_data, "admissions_flu.csv")))

g_influenza_admissions <- i_influenza_admissions %>%
  dplyr::rename(Admissions = Frequency,
                Date = date_plot) %>%
  mutate(date = as.Date(Date)) %>%
  left_join(date_reference) %>%
  mutate(Date = as_date(ceiling_date(as_date(Date), "week",
                                                 change_on_boundary = F))) %>%
  dplyr::rename(FluType = Flu_type_AB,
                RatePer100000 = Rate_per_100000,
                Year = year,
                ISOWeek = ISOweek,
                Season = flu_season) %>%
  select(Date, Year, ISOWeek, Weekord, Season, FluType, Admissions)

g_influenza_admissions_combined <- g_influenza_admissions %>%
  group_by(Date, Year, ISOWeek, Weekord, Season) %>%
  summarise(Admissions = sum(Admissions)) %>%
  ungroup() %>%
  mutate(FluType = "Influenza A & B") %>%
  select(Date, Year, ISOWeek, Weekord, Season, FluType, Admissions)

g_influenza_admissions <- g_influenza_admissions %>%
  bind_rows(g_influenza_admissions_combined) %>%
  arrange(Date)


write.csv(g_resp_admissions_summary, glue(output_folder, "Respiratory_admissions_summary.csv"), row.names = FALSE)
write.csv(g_influenza_admissions, glue(output_folder, "Influenza_admissions.csv"), row.names = FALSE)

rm(i_influenza_admissions, g_influenza_admissions)
