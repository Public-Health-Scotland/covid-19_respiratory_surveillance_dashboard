# Dashboard data transfer for Winter CIS
# Sourced from ../dashboard_data_transfer.R


i_winter_cis <- read_excel_with_options(glue(input_data, "UKHSA prevalence estimates.xlsx"))

g_winter_cis <- i_winter_cis %>%
  dplyr::rename(EndDate = end_date, OfficialPositivityEstimate = official_positivity_estimate,
                LowerCIOfficialEstimate = lower_ci_official_estimate, UpperCIOfficialEstimate = upper_ci_official_estimate,
                EstimatedCases = estimated_n, EstimatedRatio = estimated_ratio, LowerCIRatio = lower_ci_ratio,
                UpperCIRatio = upper_ci_ratio) %>%
  mutate(EndDate = format(as.Date(EndDate), "%Y%m%d"))


write_csv(g_winter_cis, glue(output_folder, "Winter_CIS.csv"))