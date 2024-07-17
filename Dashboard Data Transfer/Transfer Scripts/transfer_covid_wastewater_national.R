# Dashboard data transfer for Wastewater national data
# Sourced from ../dashboard_data_transfer.R

i_national=  read_excel_with_options(glue(input_data, "wastewater_{format(report_date -2,'%y%m%d')}.xlsx"))

g_national <- i_national %>% 
  rename(Date = Date7DayEnding,
         average = WWAvgMgc) %>%
  mutate(Date = format(Date, "%Y%m%d"),
         average = round_half_up(average,2))

write_csv(g_national,
          glue(output_folder, "COVID_Wastewater_National_table.csv"))

rm(i_national, g_national)
