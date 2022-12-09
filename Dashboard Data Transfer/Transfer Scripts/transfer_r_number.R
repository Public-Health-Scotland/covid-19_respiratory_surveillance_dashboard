# Dashboard data transfer for R Number
# Sourced from ../dashboard_data_transfer.R

##### R Number

i_r_number <- read_excel_with_options(glue(input_data, "{format(report_date-9, format='%Y-%m-%d')}_r_number_data_dashboard.xlsx"))

g_r_number <- i_r_number %>%
  dplyr::rename(Date = date, LowerBound = lower_bound, UpperBound = upper_bound) %>%
  mutate(Date = format(Date, "%Y%m%d"))

write_csv(g_r_number, glue(output_folder, "R_Number.csv"))

rm(i_r_number, g_r_number)