# Dashboard data transfer for RSV hospital admissions data
# Sourced from ../dashboard_data_transfer.R

##### RSV

#create weekord
date_reference_ord <-readRDS("/conf/C19_Test_and_Protect/Analyst Space/Calum (Analyst Space)/flu_seasons.Rds") %>%
  distinct(flu_season, year, ISOweek) %>%
  mutate(alltime_weekord = row_number()) %>%
  group_by(flu_season) %>%
  mutate(season_weekord = row_number()) %>%
  ungroup() %>%
  rename(Weekord = season_weekord) %>%
  select(-alltime_weekord)

#create lookup to add season and weekord to data
date_reference <- readRDS("/conf/C19_Test_and_Protect/Analyst Space/Calum (Analyst Space)/flu_seasons.Rds") %>%
  distinct(date, year, ISOweek, flu_season) %>%
  left_join(date_reference_ord)

i_rsv_admissions <- read_csv_with_options(match_base_filename(glue(input_data, "admissions_rsv.csv")))

# i_rsv_admissions <- i_rsv_admissions %>%
#   mutate(date_plot = strptime(as.character(date_plot), "%Y-%m-%d")) %>%
#   mutate(date_plot = format(date_plot, "%Y/%m/%d"))

g_rsv_admissions <- i_rsv_admissions %>%
  dplyr::rename(Admissions = Freq_RSV_positives,
                Date = date_plot) %>%
  mutate(date = as.Date(Date)) %>%
  left_join(date_reference) %>%
  mutate(Date = as_date(ceiling_date(as_date(Date), "week",
                                     change_on_boundary = F))) %>%
  dplyr::rename(Year = year,
                ISOWeek = ISOweek,
                Season = flu_season) %>%
  select(Date, Year, ISOWeek, Weekord, Season, Admissions)



write.csv(g_rsv_admissions, glue(output_folder, "RSV_admissions.csv"), row.names = FALSE)

rm(i_rsv_admissions, g_rsv_admissions)


#### RSV healthboard admissions
i_rsv_hb_admissions <- read_csv_with_options(match_base_filename(glue(input_data, "admissions_rsv_hb.csv")))



g_rsv_adm_hb<- i_rsv_hb_admissions %>%
  mutate(WeekBeginning = as.Date(week_start)) %>% 
  mutate(WeekEnding = as.Date(week_end)) %>% 
  arrange(WeekEnding , NHS_BOARD_NAME_TREATMENT) %>%
  mutate(HealthBoardOfTreatment = recode(NHS_BOARD_NAME_TREATMENT,
                                         "NHS AYRSHIRE & ARRAN" = "NHS Ayrshire and Arran",
                                         "NHS BORDERS" = "NHS Borders",
                                         "NHS DUMFRIES & GALLOWAY" = "NHS Dumfries and Galloway",
                                         "NHS FIFE" = "NHS Fife",
                                         "NHS FORTH VALLEY" = "NHS Forth Valley",
                                         "NHS GRAMPIAN" = "NHS Grampian",
                                         "NHS GREATER GLASGOW & CLYDE" = "NHS Greater Glasgow and Clyde",
                                         "NHS HIGHLAND" = "NHS Highland",
                                         "NHS LANARKSHIRE" = "NHS Lanarkshire",
                                         "NHS LOTHIAN" = "NHS Lothian",
                                         "NHS ORKNEY" = "NHS Orkney",
                                         "NHS SHETLAND" = "NHS Shetland",
                                         "NHS TAYSIDE" = "NHS Tayside",
                                         "NATIONAL FACILITY" = "Golden Jubilee National Hospital",
                                         "NHS WESTERN ISLES" = "NHS Western Isles" )) %>% 
  select(Flu_Season,week,WeekBeginning,WeekEnding, HealthBoardOfTreatment, 
         TotalInfections=Freq_RSV_positives)

g_rsv_adm_scot <- g_rsv_adm_hb  %>% 
  group_by(Flu_Season,week,WeekBeginning,WeekEnding) %>% 
  summarise(TotalInfections = sum(TotalInfections)) %>%
  mutate(HealthBoardOfTreatment = "Scotland") 

g_rsv_adm_hb %<>%
  bind_rows(g_rsv_adm_scot) %>% 
  arrange(WeekEnding)

write.csv(g_rsv_adm_hb, glue(output_folder, "RSV_Admissions_HB.csv"), row.names = FALSE)


#  create 3 week framework to hang  admissions ######

three_sunday_dates <- data.frame(WeekEnding=seq(as.Date("2018-10-07"), as.Date(od_date-1), "week")) %>% 
 # mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d")) ) %>% 
  slice_tail(n = 3)

HealthBoardName= data.frame(HealthBoardOfTreatment=c("NHS Ayrshire and Arran",  "NHS Borders", 
                                              "NHS Dumfries and Galloway","NHS Fife",
                                              "NHS Forth Valley","NHS Grampian",
                                              "NHS Greater Glasgow and Clyde",
                                              "NHS Highland","NHS Lanarkshire",
                                              "NHS Lothian","NHS Orkney","NHS Shetland","NHS Tayside",
                                              "NHS Western Isles","Golden Jubilee National Hospital",
                                              "Scotland" ))


hb_last_three_weeks <- expand.grid(HealthBoardOfTreatment=unique(HealthBoardName$HealthBoardOfTreatment),
                                   WeekEnding=unique(three_sunday_dates$WeekEnding),
                                   KEEP.OUT.ATTRS = FALSE, 
                                   stringsAsFactors = FALSE) 

g_rsv_adm_hb_3weeks<-g_rsv_adm_hb %>% 
  filter(WeekEnding>=od_sunday_minus_14)


g_rsv_adm_hb_3weeks_full<-hb_last_three_weeks %>% 
  left_join(g_rsv_adm_hb_3weeks, by=c("HealthBoardOfTreatment","WeekEnding")) %>% 
  select(WeekEnding, HealthBoardOfTreatment, TotalInfections) %>% 
  mutate(TotalInfections=if_else(is.na(TotalInfections),0,TotalInfections))
  #arrange(HealthBoardOfTreatment) 
  

write.csv(g_rsv_adm_hb_3weeks_full, glue(output_folder, "RSV_Admissions_HB_3wks.csv"), row.names = FALSE)

  

rm(i_rsv_hb_admissions, g_rsv_adm_scot, g_rsv_adm_hb )

