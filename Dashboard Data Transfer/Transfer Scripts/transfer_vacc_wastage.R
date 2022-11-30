# Dashboard data transfer for Vaccine Wastage data
# Sourced from ../dashboard_data_transfer.R

##### Vaccine wastage

i_vaccine_wastage <- read_all_excel_sheets(glue(input_data, "{format(report_date -2,'%Y-%m-%d')}_vaccine_wastage.xlsx"))

g_vaccine_wastage <- i_vaccine_wastage$Sheet1 %>%
  dplyr::rename(Month = `month`,
                NumberOfDosesAdministered = `number_of_doses_administered`,
                NumberOfDosesWasted = `number_of_doses_wasted`,
                PercentageWasted = `percentage_wasted`) %>%
  mutate(Month = format(as.Date(Month), "%Y%m%d"))

write.csv(g_vaccine_wastage, glue(output_folder, "Vaccine_Wastage.csv"), row.names = FALSE)

g_vaccine_wastage_reason <- i_vaccine_wastage$Sheet2 %>%
  dplyr::rename(ReasonForWastage = `reason`,
                ReasonForWastagePc = `percentage`) %>%
  mutate(ReasonForWastagePc = ReasonForWastagePc*100)

write.csv(g_vaccine_wastage_reason, glue(output_folder, "Vaccine_Wastage_Reason.csv"), row.names = FALSE)

rm(i_vaccine_wastage, g_vaccine_wastage, g_vaccine_wastage_reason)