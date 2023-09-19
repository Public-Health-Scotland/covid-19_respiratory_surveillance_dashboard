# Dashboard data transfer for influezna hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### Influenza

date_reference <-readRDS("/conf/C19_Test_and_Protect/Analyst Space/Calum (Analyst Space)/flu_seasons.Rds") %>%
  distinct(date, year, ISOweek, flu_season)

i_influenza_admissions <- read_csv_with_options(match_base_filename(glue(input_data, "admissions_flu.csv")))

g_influenza_admissions <- i_influenza %>%
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
  select(Date, Year, ISOWeek, Season, FluType, Admissions, RatePer100000)

write.csv(g_influenza_admissions, glue(output_folder, "Influenza_admissions.csv"), row.names = FALSE)

rm(i_influenza_admissions, g_influenza_admissions)
