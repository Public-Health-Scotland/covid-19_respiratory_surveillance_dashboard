# Dashboard data transfer for influezna hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### Influenza

i_influenza <- read_csv_with_options(glue(input_data, "admissions_flu_{format(report_date -1,'%Y-%m-%d')}.csv"))

g_influenza <- i_influenza %>%
  dplyr::rename(admissions = Frequency) 

write.csv(g_influenza, glue(output_folder, "Influenza_admissions.csv"), row.names = FALSE)

rm(i_influenza, g_influenza)
