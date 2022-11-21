# Dashboard data transfer for ONS
# Sourced from ../dashboard_data_transfer.R

##### ONS

i_ons_scot <- read_csv_with_options(glue(input_data, "scotland_official_estimates_{format(report_date-7, format='%Y-%m-%d')}.csv"))
i_ons_wales <- read_csv_with_options(glue(input_data, "wales_official_estimates_{format(report_date-7, format='%Y-%m-%d')}.csv"))
i_ons_eng <- read_csv_with_options(glue(input_data, "england_official_estimates_{format(report_date-7, format='%Y-%m-%d')}.csv"))
i_ons_ni <- read_csv_with_options(glue(input_data, "ni_official_estimates_{format(report_date-7, format='%Y-%m-%d')}.csv"))



process_ons_data <- function(df,nation){
  out <- df %>%
    tail(-3) %>%
    select(-model) %>%
    dplyr::rename(StartDate = start_date, EndDate = end_date, OfficialPositivityEstimate = official_positivity_estimate,
                  LowerCIOfficialEstimate = lower_ci_official_estimate, UpperCIOfficialEstimate = upper_ci_official_estimate,
                  EstimatedCases = estimated_n, LowerCIEstimatedCases = lower_ci_estimated_n,
                  UpperCIEstimatedCases = upper_ci_estimated_n, EstimatedRatio = estimated_ratio, LowerCIRatio = lower_ci_ratio,
                  UpperCIRatio = upper_ci_ratio) %>%
    mutate(StartDate = format(as.Date(StartDate), "%Y%m%d"), EndDate = format(as.Date(EndDate), "%Y%m%d"), Nation = nation)

  return(out)
}

g_ons_scot <- process_ons_data(i_ons_scot, "Scotland")
g_ons_wales <- process_ons_data(i_ons_scot, "Wales")
g_ons_eng <- process_ons_data(i_ons_scot, "England")
g_ons_ni <- process_ons_data(i_ons_scot, "NI")

g_ons <- rbind(g_ons_scot, g_ons_wales, g_ons_eng, g_ons_ni) %>%
  select(Nation, StartDate, EndDate, OfficialPositivityEstimate, LowerCIOfficialEstimate, UpperCIOfficialEstimate,
         EstimatedCases, LowerCIEstimatedCases, UpperCIEstimatedCases, EstimatedRatio, LowerCIRatio, UpperCIRatio)

write_csv(g_ons, glue(output_folder, "ONS.csv"))

rm(i_ons_scot, i_ons_wales, i_ons_eng, i_ons_ni, g_ons_scot, g_ons_wales, g_ons_eng, g_ons_ni, g_ons)
