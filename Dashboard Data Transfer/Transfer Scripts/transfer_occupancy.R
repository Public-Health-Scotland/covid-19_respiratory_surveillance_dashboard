# Dashboard data transfer for Occupancy
# Sourced from ../dashboard_data_transfer.R

##### Hospital & ICU Occupancy

# Health Board lookup
hblookup <- list("NHS Ayrshire and Arran" = "S08000015",
                 "NHS Borders" = "S08000016",
                 "NHS Dumfries and Galloway" = "S08000017",
                 "NHS Fife" = "S08000029",
                 "NHS Forth Valley" = "S08000019",
                 "NHS Grampian" = "S08000020",
                 "NHS Greater Glasgow and Clyde" = "S08000031",
                 "NHS Highland" = "S08000022",
                 "NHS Lanarkshire" = "S08000032",
                 "NHS Lothian" = "S08000024",
                 "NHS Orkney" = "S08000025",
                 "NHS Shetland" = "S08000026",
                 "NHS Tayside" = "S08000030",
                 "NHS Western Isles" = "S08000028",
                 "NHS Orkney, Shetland, and Western Isles"= "GR0800001",
                 "Scotland" = "S92000003",
                 "Other"=  "")

i_occupancy <- read_all_excel_sheets(glue("{input_data}/Hospital-ICU Daily Numbers_{report_date}.xlsx"))

###Hospital

g_occupancy_hospital_healthboard <- i_occupancy$Data %>%
  clean_names() %>%
  rename(HospitalOccupancy = total_number_of_confirmed_c19_inpatients_in_hospital_at_8am_yesterday_new_measure_number_of_confirmed_c19_inpatients_in_hospital_10_days_at_8am_as_of_08_05_2023,
         #ICUOccupancy28OrLess = total_number_of_confirmed_c19_inpatients_in_icu_28_days_or_less_at_8am_yesterday_new_measure,
         #ICUOccupancy28OrMore = total_number_of_confirmed_c19_inpatients_in_icu_greater_than_28_days_at_8am_yesterday_measure_as_of_20_01_21,
         Date = date,
         HealthBoard = health_board) %>%
  filter(Date >= "2020-09-08" & Date <= report_date-2) %>% # filter to sunday date
  mutate(HospitalOccupancy = as.numeric(HospitalOccupancy),
         #ICUOccupancy28OrLess = as.numeric(ICUOccupancy28OrLess),
         #ICUOccupancy28OrMore = as.numeric(ICUOccupancy28OrMore),
         #Date = as.Date(as.POSIXct(Date-1, 'GMT')),
         Date = format(as.Date(Date-1), "%Y%m%d"), #-1 as number is for "8am yesterday"
         HealthBoard = str_replace(HealthBoard, "&", "and"))


g_occupancy_hospital_scotland <- g_occupancy_hospital_healthboard %>%
  group_by(Date) %>%
  summarise(HospitalOccupancy = sum(HospitalOccupancy,na.rm=T)) %>%
            #ICUOccupancy28OrLess = sum(ICUOccupancy28OrLess,na.rm=T),
            #ICUOccupancy28OrMore = sum(ICUOccupancy28OrMore,na.rm=T)) %>%
  ungroup() %>%
  mutate(HealthBoard = "Scotland",
         HealthBoardQF = "d")


###############
g_occupancy_hospital <- bind_rows(g_occupancy_hospital_healthboard, g_occupancy_hospital_scotland) %>%
  group_by(HealthBoard) %>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(HospitalOccupancy, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), ":", ""),
         SevenDayAverageQF = ifelse(Date <= 20200912 , "z", SevenDayAverageQF),
         HospitalOccupancyQF = ifelse(is.na(HospitalOccupancy), ":", "")) %>%
  ungroup() %>%
  #filter(substr(HealthBoard,1,3) == "NHS") %>%
  arrange(Date) %>%
  select(Date, HealthBoard, HealthBoardQF, HospitalOccupancy, HospitalOccupancyQF, SevenDayAverage, SevenDayAverageQF) %>%
  mutate(HealthBoard = ifelse(substr(HealthBoard,1,1)=="Z", "Other", HealthBoard),
         HealthBoard = unlist(hblookup[HealthBoard]),
         HealthBoardQF = ifelse(HealthBoard == "", ":", HealthBoardQF)) %>%
  filter(HealthBoard == "S92000003") #for disclosure reasons temporarily filtering for Scotland only

write.csv(g_occupancy_hospital, glue(output_folder, "Occupancy_Hospital.csv"), row.names = FALSE)

g_occupancy_hospital_hb <- bind_rows(g_occupancy_hospital_healthboard, g_occupancy_hospital_scotland) %>%
  group_by(HealthBoard) %>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(HospitalOccupancy, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), ":", ""),
         SevenDayAverageQF = ifelse(Date <= 20200912 , "z", SevenDayAverageQF),
         HospitalOccupancyQF = ifelse(is.na(HospitalOccupancy), ":", "")) %>%
  ungroup() %>%
  #filter(substr(HealthBoard,1,3) == "NHS") %>%
  arrange(Date) %>%
  select(Date, HealthBoard, HealthBoardQF, HospitalOccupancy, HospitalOccupancyQF, SevenDayAverage, SevenDayAverageQF) %>%
  mutate(Date = as.Date(Date, format = "%Y%m%d")) %>%
  mutate(HealthBoard = ifelse(substr(HealthBoard,1,1)=="Z", "National Facility", HealthBoard),
         #HealthBoard = unlist(hblookup[HealthBoard]),
         HealthBoardQF = ifelse(HealthBoard == "", ":", HealthBoardQF))

write.csv(g_occupancy_hospital_hb, glue(output_folder, "Occupancy_Hospital_HB.csv"), row.names = FALSE)



########## Open Data Section ############

g_weekly_ocupancy_od<-g_occupancy_hospital_hb %>% 
  rename(HealthBoardName=HealthBoard) %>% 
  mutate(HealthBoardName = recode(HealthBoardName,  "National Facility"=
                                   "Golden Jubilee National Hospital" )) %>%
  mutate(WeekEnding = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
  group_by(WeekEnding, HealthBoardName) %>% 
  filter(Date==max(Date)) %>% 
  rename(InpatientsAsAtLastSunday= HospitalOccupancy) %>% 
  ungroup()  %>% 
  mutate( WeekEnding = format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d") ) %>% 
  select(-Date) 


write_csv(g_weekly_ocupancy_od, glue(output_folder, "weekly_HB_occupancy.csv"),na = "")



#   arrange(WeekEnding)
#   
# 
# 
# 
# g_OD_occupancy_hb <- i_occupancy$Data%>% 
#   clean_names()  %>%
#   select(HospitalOccupancy = total_number_of_confirmed_c19_inpatients_in_hospital_at_8am_yesterday_new_measure_number_of_confirmed_c19_inpatients_in_hospital_10_days_at_8am_as_of_08_05_2023,
#          Date = date,
#          HealthBoardName = health_board) %>% 
#   mutate(HospitalOccupancy = as.numeric(HospitalOccupancy),
#          Date = format(as.Date(Date-1), "%Y-%m-%d"), #-1 as number is for "8am yesterday"
#          HealthBoardName = str_replace(HealthBoardName, "&", "and")) %>% 
# filter(Date >= "2020-09-08" & Date <= report_date-2) %>% # filter to sunday date
#   mutate(Date = as.Date(Date))%>% 
#   mutate(HealthBoardName = recode(HealthBoardName, "Z - National"=
#                                     "Golden Jubilee National Hospital"))
# 
# g_AsAt_occupancy_hb<-g_OD_occupancy_hb %>% 
#  mutate(WeekEnding = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
#   group_by(WeekEnding, HealthBoardName) %>% 
#   filter(Date==max(Date)) %>% 
#   rename(InpatientsAsAtLastSunday= HospitalOccupancy) %>% 
#   ungroup() %>% 
#   select(-Date) 
# 
# 
# g_AsAt_occupancy_hospital_scot <-g_AsAt_occupancy_hb %>%
#   group_by(WeekEnding) %>%
#   summarise(InpatientsAsAtLastSunday = sum(InpatientsAsAtLastSunday,na.rm=T)) %>%
#   ungroup() %>%
#   mutate(HealthBoardName = "Scotland") 
# 
# g_AsAt_OD<-g_AsAt_occupancy_hb  %>% 
#   rbind(g_AsAt_occupancy_hospital_scot) %>% 
#   mutate( WeekEnding = format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d") ) %>% 
#   arrange(WeekEnding)
# 
# # calculate seven day average values
# g_seven_day_occupancy_hospital_hb<-g_OD_occupancy_hb %>% 
#   group_by(HealthBoardName) %>%
#   mutate(SevenDayAverage = round_half_up(zoo::rollmean(HospitalOccupancy, k = 7, fill = NA, align="right"),0),
#          SevenDayAverageQF = ifelse(is.na(SevenDayAverage), ":", ""),
#          SevenDayAverageQF = ifelse(Date <= 20200912 , "z", SevenDayAverageQF),
#          HospitalOccupancyQF = ifelse(is.na(HospitalOccupancy), ":", "")) %>%
#   ungroup() %>%
#   mutate(WeekEnding = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>% 
#   group_by(WeekEnding, HealthBoardName) %>% 
#   filter(Date==max(Date)) %>% 
#   ungroup() %>% 
#   select(-Date) 
# # 
# g_seven_day_occupancy_hospital_scot<-g_OD_occupancy_hb %>% 
#   group_by(Date) %>%  
#   summarise(InpatientsAsAtLastSunday = sum(InpatientsAsAtLastSunday,na.rm=T)) %>%
#   ungroup() %>%
#   mutate(HealthBoardName = "Scotland") 

  

#   arrange(Date) %>%
#   select(Date, HealthBoard, HealthBoardQF, HospitalOccupancy, HospitalOccupancyQF, SevenDayAverage, SevenDayAverageQF) %>%
#   mutate(Date = as.Date(Date, format = "%Y%m%d")) %>%
#   mutate(HealthBoard = ifelse(substr(HealthBoard,1,1)=="Z", "National Facility", HealthBoard),
#          #HealthBoard = unlist(hblookup[HealthBoard]),
#          HealthBoardQF = ifelse(HealthBoard == "", ":", HealthBoardQF))




write_csv(g_AsAt_OD, glue(output_folder, "weekly_AsAt_occupancy.csv"),na = "")
  

################




###ICU
g_occupancy_ICU_healthboard <- i_occupancy$Data %>%
  clean_names() %>%
  rename(`28 days or less` = total_number_of_confirmed_c19_inpatients_in_icu_28_days_or_less_at_8am_yesterday_new_measure,
         `greater than 28 days` = total_number_of_confirmed_c19_inpatients_in_icu_greater_than_28_days_at_8am_yesterday_measure_as_of_20_01_21,
         Date = date,
         HealthBoard = health_board) %>%
  filter(Date >= "2020-09-08" & Date <= "2023-05-08") %>% # filter to 8th May when reporting stopped
  select(Date, HealthBoard, `28 days or less`, `greater than 28 days`) %>%
  pivot_longer(cols=names(.)[!(names(.) %in% c("Date", "HealthBoard"))],
               names_to = "ICULengthOfStay", values_to="ICUOccupancy") %>%
  mutate(ICUOccupancy = as.numeric(ICUOccupancy),
         #Date = as.Date(as.POSIXct(Date-1, 'GMT')),
         Date = format(as.Date(Date-1), "%Y%m%d"),
         HealthBoard = str_replace(HealthBoard, "&", "and"))


g_occupancy_ICU_scotland <- g_occupancy_ICU_healthboard %>%
  group_by(Date, ICULengthOfStay) %>%
  summarise(ICUOccupancy = sum(ICUOccupancy,na.rm=T)) %>%
  ungroup() %>%
  mutate(HealthBoard = "Scotland",
         HealthBoardQF = "d",
         ICUOccupancy = ifelse(((Date <= 20210118) & (ICULengthOfStay == "greater than 28 days")),NA, ICUOccupancy))



g_occupancy_ICU <- bind_rows(g_occupancy_ICU_healthboard, g_occupancy_ICU_scotland) %>%
  group_by(HealthBoard, ICULengthOfStay) %>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(ICUOccupancy, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), ":", ""),
         SevenDayAverageQF = ifelse(Date <= 20200912 , "z", SevenDayAverageQF),
         ICUOccupancyQF = ifelse(is.na(ICUOccupancy), ":", "")) %>%
  ungroup() %>%
  select(Date, HealthBoard, HealthBoardQF, ICULengthOfStay, ICUOccupancy, ICUOccupancyQF, SevenDayAverage, SevenDayAverageQF) %>%
  arrange(Date) %>%
  mutate(HealthBoard = ifelse(substr(HealthBoard,1,1)=="Z", "Other", HealthBoard),
         HealthBoard = unlist(hblookup[HealthBoard]),
         HealthBoardQF = ifelse(HealthBoard == "", ":", HealthBoardQF)) %>%
  filter(HealthBoard == "S92000003") #for disclosure reasons temporarily filtering for Scotland only

write.csv(g_occupancy_ICU, glue(output_folder, "Occupancy_ICU.csv"), row.names = FALSE)

rm(i_occupancy, g_occupancy_hospital_healthboard, g_occupancy_hospital_scotland, g_occupancy_hospital,
   g_occupancy_ICU_healthboard, g_occupancy_ICU_scotland, g_occupancy_ICU)




