# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

##### Hospital & ICU Occupancy

i_occupancy <- read_all_excel_sheets(glue("{input_data}/Hospital-ICU Daily Numbers_{report_date}.xlsx"))

g_occupancy_healthboard <- i_occupancy$Data %>%
  clean_names() %>%
  rename(HospitalOccupancy = total_number_of_confirmed_c19_inpatients_in_hospital_at_8am_yesterday_new_measure,
         ICUOccupancy28OrLess = total_number_of_confirmed_c19_inpatients_in_icu_28_days_or_less_at_8am_yesterday_new_measure,
         ICUOccupancy28OrMore = total_number_of_confirmed_c19_inpatients_in_icu_greater_than_28_days_at_8am_yesterday_measure_as_of_20_01_21,
         Date = date,
         LocationName = health_board) %>%
  filter(Date <= report_date-2) %>% # filter to sunday date
  mutate(HospitalOccupancy = as.numeric(HospitalOccupancy),
         ICUOccupancy28OrLess = as.numeric(ICUOccupancy28OrLess),
         ICUOccupancy28OrMore = as.numeric(ICUOccupancy28OrMore),
         Date = as.Date(as.POSIXct(Date-1, 'GMT')),
         LocationName = str_replace(LocationName, "&", "and")) %>%
  select(Date, LocationName, HospitalOccupancy, ICUOccupancy28OrLess, ICUOccupancy28OrMore)


g_occupancy_scotland <- g_occupancy_healthboard %>%
  group_by(Date) %>%
  summarise(HospitalOccupancy = sum(HospitalOccupancy,na.rm=T),
            ICUOccupancy28OrLess = sum(ICUOccupancy28OrLess,na.rm=T),
            ICUOccupancy28OrMore = sum(ICUOccupancy28OrMore,na.rm=T)) %>%
  ungroup() %>%
  mutate(LocationName = "Scotland",
         HospitalOccupancyQF = "d",
         ICUOccupancy28OrLessQF = "d",
         ICUOccupancy28OrMoreQF = "d")

g_occupancy <- bind_rows(g_occupancy_healthboard, g_occupancy_scotland) %>%
  mutate(Sex = "Total",
         AgeGroup = "Total",
         Geography = ifelse(LocationName == "Scotland", "Scotland", "Health Board"),
         HospitalOccupancy = ifelse(LocationName != "Scotland" & HospitalOccupancy < 5, NA, HospitalOccupancy),
         ICUOccupancy28OrLess = ifelse(LocationName != "Scotland" & ICUOccupancy28OrLess < 5, NA, ICUOccupancy28OrLess),
         ICUOccupancy28OrMore = ifelse(LocationName != "Scotland" & ICUOccupancy28OrMore < 5, NA, ICUOccupancy28OrMore))
  arrange(Date)

write.csv(g_occupancy, glue(output_folder, "Occupancy.csv"), row.names = FALSE)



