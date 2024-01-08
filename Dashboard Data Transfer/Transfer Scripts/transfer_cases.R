# Dashboard data transfer for Cases
# Sourced from ../dashboard_data_transfer.R

##### Cases

i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

g_cases <- i_cases$`Cumulative confirmed cases`

g_cases %<>%
  dplyr::rename(NumberCasesPerDay = `Number of cases per day`) %>%
  mutate(NumberCasesPerDay = as.numeric(NumberCasesPerDay),
         Cumulative = as.numeric(Cumulative))

pop_grandtotal <- i_population_v2 %>%
  filter(AgeGroup == "Total", Sex == "Total") %>%
  .$PopNumber

g_cases %<>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(NumberCasesPerDay, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), "z", ""),
         CumulativeRatePer100000 = round_half_up(100000 * Cumulative / pop_grandtotal,1),
         Date = format(Date, "%Y%m%d"))


write_csv(g_cases, glue(output_folder, "Cases.csv"))

g_cases_weekly <- i_cases$`Cumulative confirmed cases`

g_cases_weekly %<>%
  mutate(WeekEnding = ceiling_date(
    as.Date(Date),unit="week",week_start=7, change_on_boundary=FALSE)) %>%
  dplyr::rename(NumberCasesPerWeek = `Number of cases per day`) %>%
  mutate(NumberCasesPerWeek = as.numeric(NumberCasesPerWeek),
         Cumulative = as.numeric(Cumulative)) %>%
  group_by(WeekEnding) %>%
  summarise(NumberCasesPerWeek = sum(NumberCasesPerWeek)) %>%
  mutate(Cumulative = cumsum(NumberCasesPerWeek)) %>%
  mutate(WeekEnding = format(WeekEnding, "%Y%m%d"))

write_csv(g_cases_weekly, glue(output_folder, "Cases_Weekly.csv"))


rm(i_cases, g_cases, pop_grandtotal)




