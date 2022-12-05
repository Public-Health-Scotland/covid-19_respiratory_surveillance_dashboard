# Dashboard data transfer for Wastewater data
# Sourced from ../dashboard_data_transfer.R

##### Wastewater

i_wastewater <- read_excel_with_options(glue(input_data, "wastewater_{format(report_date -2,'%y%m%d')}.xlsx"))

g_wastewater <- i_wastewater %>%
  dplyr::rename(Date = Date7DayEnding,
                WastewaterSevenDayAverageMgc = WWAvgMgc) %>%
  mutate(Date = format(Date, "%Y%m%d"))


write.csv(g_wastewater, glue(output_folder, "Wastewater.csv"), row.names = FALSE)

rm(i_wastewater, g_wastewater)
