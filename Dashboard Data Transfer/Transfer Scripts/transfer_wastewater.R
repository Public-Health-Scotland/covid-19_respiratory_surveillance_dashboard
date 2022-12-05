# Dashboard data transfer for Vaccine Wastage data
# Sourced from ../dashboard_data_transfer.R

##### Wastewater

#i_wastewater <- read_excel(glue(input_data, "wastewater_{format(report_date -5,'%d%m%y')}.xlsx"))
i_wastewater <- read_excel(glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Wastewater Analysis/Data/", "wastewater_{format(report_date -9,'%y%m%d')}.xlsx"))
i_wastewater

g_wastewater <- i_wastewater %>%
  dplyr::rename(Date = Date7DayEnding,
                WastewaterAverageMgc = WWAvgMgc) %>%
  mutate(Date = format(Date, "%Y%m%d"))


write.csv(g_wastewater, glue(output_folder, "Wastewater.csv"), row.names = FALSE)

rm(i_wastewater, g_wastewater)
