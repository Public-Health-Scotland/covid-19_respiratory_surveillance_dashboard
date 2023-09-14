# Dashboard data transfer for RSV hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### RSV

i_rsv <- read_csv_with_options(glue(input_data, "admissions_rsv_{format(report_date -1,'%Y-%m-%d')}.csv"))

g_rsv <- i_rsv %>%
  dplyr::rename(admissions = Freq_RSV_positives) 

write.csv(g_rsv, glue(output_folder, "RSV_admissions.csv"), row.names = FALSE)

rm(i_rsv, g_rsv)
