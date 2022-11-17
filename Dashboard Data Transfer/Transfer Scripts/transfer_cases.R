# Dashboard data transfer for Cases
# Sourced from ../dashboard_data_transfer.R

##### Cases

i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

g_cases <- i_cases$`Cumulative confirmed cases`

g_cases %<>%
  dplyr::rename(NumberCasesPerDay = `Number of cases per day`) %>%
  mutate(NumberCasesPerDay = as.numeric(NumberCasesPerDay),
         Cumulative = as.numeric(Cumulative))

pop_grandtotal <- i_population %>%
  filter(age_group == "All", sex == "Total") %>%
  .$pop_number

g_cases %<>%
  mutate(SevenDayAverage = zoo::rollmean(NumberCasesPerDay, k = 7, fill = NA, align="right"),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), "z", ""),
         CumulativeRatePer100000 = 100000 * Cumulative / pop_grandtotal,
         Date = format(Date, "%Y%m%d"))


write_csv(g_cases, glue(output_folder, "Cases.csv"))

rm(i_cases, g_cases, pop_grandtotal)




