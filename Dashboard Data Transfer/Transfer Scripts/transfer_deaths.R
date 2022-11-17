# Dashboard data transfer for NRS Deaths
# Sourced from ../dashboard_data_transfer.R

##### Deaths

i_deaths <- read_excel(glue(input_data, "NRS deaths.xlsx"))

g_deaths <- i_deaths %>%
  dplyr::rename(WeekEnding = `Week ending`,
                DeathsInvolvingCovid = `Number of deaths involving COVID in Scotland`,
                DeathsWithUnderlyingCovid = `Number of deaths with COVID as the underlying cause`) %>%
  mutate(WeekEnding = format(WeekEnding, "%Y%m%d"),
         DeathsInvolvingCovid = as.numeric(DeathsInvolvingCovid),
         DeathsWithUnderlyingCovid = as.numeric(DeathsWithUnderlyingCovid))

write_csv(g_deaths, glue(output_folder, "Deaths.csv"))

rm(i_deaths, g_deaths)