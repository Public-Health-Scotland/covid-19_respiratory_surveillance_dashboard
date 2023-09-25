# Dashboard data transfer for RSV hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### RSV

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

i_rsv_admissions <- read_csv_with_options(match_base_filename(glue(input_data, "admissions_rsv.csv")))

g_rsv_admissions <- i_rsv_admissions %>%
  dplyr::rename(Admissions = Freq_RSV_positives,
                Date = date_plot) %>%
  mutate(date = as.Date(Date)) %>%
  left_join(date_reference) %>%
  mutate(Date = as_date(ceiling_date(as_date(Date), "week",
                                     change_on_boundary = F))) %>%
  dplyr::rename(Year = year,
                ISOWeek = ISOweek,
                Season = flu_season) %>%
  select(Date, Year, ISOWeek, Weekord, Season, Admissions)



write.csv(g_rsv_admissions, glue(output_folder, "RSV_admissions.csv"), row.names = FALSE)

rm(i_rsv_admissions, g_rsv_admissions)
