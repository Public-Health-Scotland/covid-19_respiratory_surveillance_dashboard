#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RStudio Workbench is strictly for use by Public Health Scotland staff and     
# authorised users only, and is governed by the Acceptable Usage Policy https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md.
#
# This is a shared resource and is hosted on a pay-as-you-go cloud computing
# platform.  Your usage will incur direct financial cost to Public Health
# Scotland.  As such, please ensure
#
#   1. that this session is appropriately sized with the minimum number of CPUs
#      and memory required for the size and scale of your analysis;
#   2. the code you write in this script is optimal and only writes out the
#      data required, nothing more.
#   3. you close this session when not in use; idle sessions still cost PHS
#      money!
#
# For further guidance, please see https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


#add QF column to inputed column that meets a null criteria
od_qualifiers <- function(data, col_name, symbol) {
  needs_symbol = data[[col_name]] == "" | is.na(data[[col_name]])
  data %>%
    mutate("{col_name}QF" := if_else(needs_symbol, symbol, ""))
}



####### create framework to hang Covid admissions and occupancy on ######
Dates <- data.frame(WeekEnding=seq(as.Date("2020-03-01"), as.Date(od_date-1), "week")) %>% 
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) #use OD data format

library(ckanr)
ckan <- src_ckan("https://www.opendata.nhs.scot")
hb2019_id<-"652ff726-e676-4a20-abda-435b98dd7bdc"

hb_code <- tbl(src = ckan$con, from = hb2019_id) %>%
  as_tibble() %>%
  clean_names() %>%
  filter(is.na(hb_date_archived)) %>%
  select(HealthBoardName=hb_name, HealthBoard=hb)

HealthBoardName= data.frame(HealthBoardName=c("NHS Ayrshire and Arran",  "NHS Borders", 
                                              "NHS Dumfries and Galloway","NHS Fife",
                                              "NHS Forth Valley","NHS Grampian",
                                              "NHS Greater Glasgow and Clyde",
                                              "NHS Highland","NHS Lanarkshire",
                                              "NHS Lothian","NHS Orkney","NHS Shetland","NHS Tayside",
                                              "NHS Western Isles","Golden Jubilee National Hospital",
                                              "Scotland" ))

#resp_adm_pathogen= data.frame(Pathogen=c("Influenza - Type A or B","Respiratory syncytial virus" ))
             
df_hb_weekly <- expand.grid(HealthBoardName=unique(HealthBoardName$HealthBoardName),
                            WeekEnding=unique(Dates$WeekEnding),
                            KEEP.OUT.ATTRS = FALSE, 
                            stringsAsFactors = FALSE) %>%  
  left_join(hb_code, by="HealthBoardName" )%>% # add HB codes
  mutate(HealthBoard= case_when(HealthBoardName== "Scotland"~ "S92000003",
                                HealthBoardName== "Golden Jubilee National Hospital"~ "SB0801",
                                TRUE~  HealthBoard)) #add codes for Scotland & Jubilee

#### create framework to hang influenza and rsv admissions on to  ####

# 
# resp_dates<- data.frame(WeekEnding=seq(as.Date("2018-10-07"), as.Date(od_date-1), "week")) %>% 
#   mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) #use OD data format

# df_resp_hb_weekly <- expand.grid(HealthBoardName=unique(HealthBoardName$HealthBoardName),
#                             WeekEnding=unique(resp_dates$WeekEnding),
#                             Pathogen=unique(resp_adm_pathogen$Pathogen),
#                             KEEP.OUT.ATTRS = FALSE, 
#                             stringsAsFactors = FALSE) %>%  
#   mutate(WeekEnding=as.numeric(WeekEnding)) %>% 
#   left_join(hb_code, by="HealthBoardName" )%>% # add HB codes
#   filter(HealthBoardName!="Golden Jubilee National Hospital") %>% 
#   mutate(HealthBoardOfTreatment_OD= case_when(HealthBoardName== "Scotland"~ "S92000003",TRUE~  HealthBoard)) %>%  
#   select(-HealthBoard) %>% 
#   rename(HealthBoardOfTreatment=HealthBoardName) %>% 
#   arrange(WeekEnding, Pathogen)


### covid admissions and occupancyy #####

i_od_healthboard_admissions <- read_csv(glue(output_folder, "Admissions_HB.csv"))

g_od_healthboard_admissions <-i_od_healthboard_admissions  %>% 
  rename(HealthBoardName=HealthBoard, Admissions=TotalInfections)%>% # rename for OD consistency
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d"), # use OD date format
         HealthBoardName = recode(HealthBoardName,  "National Facility"=
                                  "Golden Jubilee National Hospital" )) # update Jubilee name,
  
# import as at occupancy from outpout folder
i_od_occupancy <- read_csv(glue(output_folder, "weekly_HB_occupancy.csv")) %>% 
  select(WeekEnding, HealthBoardName,
         InpatientsAsAtLastSunday, SevenDayAverage,
         -HospitalOccupancyQF, -SevenDayAverageQF)

# join admissions and occupancy to  weekly frameworkdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==
g_weekly_healthboard_od<- df_hb_weekly %>% 
left_join(g_od_healthboard_admissions, by=c("HealthBoardName","WeekEnding")) %>% 
 mutate(WeekEnding=as.numeric(WeekEnding)) %>% 
left_join(i_od_occupancy, by=(c("WeekEnding", "HealthBoardName"))) %>% 
  mutate(HealthBoardOfTreatmentQF=case_when(HealthBoard=="S92000003"&!is.na(Admissions)~"d",
                                            TRUE~"")) %>%
  od_qualifiers(., "Admissions", ":") %>%
  od_qualifiers(., "InpatientsAsAtLastSunday", ":") %>%
  od_qualifiers(., "SevenDayAverage", ":") %>%
  select(WeekEnding, 
         HealthBoardOfTreatment=HealthBoard, HealthBoardOfTreatmentQF,
         Admissions, AdmissionsQF, 
         InpatientsAsAtLastSunday, InpatientsAsAtLastSundayQF,
         InpatientsSevenDayAverage= SevenDayAverage, 
         InpatientsSevenDayAverageQF= SevenDayAverageQF)


write_csv(g_weekly_healthboard_od, glue(od_folder, "weekly_admissions_occupancy_HB_{od_report_date}.csv"),na = "")


# #### flu and respiratory admissions by HB #####
# 
# i_od_flu_hb_adm <- read_csv(glue(output_folder,"Flu_Admissions_HB.csv")) %>% 
#   mutate(Pathogen="Influenza - Type A or B")
# i_od_rsv_hb_adm <- read_csv(glue(output_folder,"RSV_Admissions_HB.csv"))%>% 
#   mutate(Pathogen="Respiratory syncytial virus")
# 
# # bind flu and rsv i_-files, rename variables
# 
# g_od_flu_rsv_hb_adm <-i_od_flu_hb_adm %>% 
#   rbind(i_od_rsv_hb_adm) %>% 
#     rename(Admissions=TotalInfections)%>% # rename for OD consistency
#   mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) %>%  # use OD date format
#   mutate(WeekEnding=as.numeric(WeekEnding)) #needed for join to framework
# 
# # join flu/rsv admissions to  weekly framework
# g_weekly_resp_hb_od<- df_resp_hb_weekly %>% 
#   left_join(g_od_flu_rsv_hb_adm, by=c("HealthBoardOfTreatment","WeekEnding", "Pathogen")) %>% 
#   mutate(HealthBoardOfTreatmentQF=case_when(HealthBoardOfTreatment_OD=="S92000003"&!is.na(Admissions)~"d",
#                                                                 TRUE~""),
#         AdmissionsQF = ifelse(is.na(Admissions), ":", "")) %>%  
#   group_by(WeekEnding) %>% 
#   arrange(WeekEnding, HealthBoardOfTreatment, Pathogen) %>% 
#   select(WeekEnding, 
#          Name=HealthBoardOfTreatment,
#          HealthBoardOfTreatment=HealthBoardOfTreatment_OD, 
#          HealthBoardOfTreatmentQF,Pathogen,
#          Admissions, AdmissionsQF)
# 
# 
# 
# write_csv(g_weekly_resp_hb_od, glue(od_folder, "weekly_respiratory_admissions_HB_v1.csv"),na = "")


  # # %>% 
  #   arrange( factor(HealthBoardOfTreatment,
  #                              levels = c("NHS AYRSHIRE & ARRAN", "NHS BORDERS", "NHS DUMFRIES & GALLOWAY", "NHS FIFE", "NHS FORTH VALLEY", "NHS GRAMPIAN",
  #                                         "NHS GREATER GLASGOW & CLYDE", "NHS HIGHLAND", "NHS LANARKSHIRE", "NHS LOTHIAN", "NHS ORKNEY", "NHS SHETLAND",
  #                                         "NHS TAYSIDE", "NHS WESTERN ISLES", "SCOTLAND")), Pathogen)

#Output (on hold)
#write_csv(g_weekly_resp_hb_od, glue(od_folder, "weekly_flu_rsv_admissions_HB_{od_report_date}.csv"),na = "")


i_od_flu_hb_adm<- read_csv(glue(output_folder,"Flu_Admissions_HB.csv")) 

g_od_flu_hb_adm<-i_od_flu_hb_adm %>% 
  select(WeekEnding, HealthBoardName=HealthBoardOfTreatment,
         InfluenzaAdmissions=TotalInfections) %>% 
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) #%>%  # use OD date format
  #mutate(WeekEnding=as.numeric(WeekEnding))

i_od_rsv_hb_adm <- read_csv(glue(output_folder,"RSV_Admissions_HB.csv"))

g_od_rsv_hb_adm<-i_od_rsv_hb_adm%>% 
  select(WeekEnding, HealthBoardName= HealthBoardOfTreatment, 
         RSVAdmissions=TotalInfections) %>% 
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) #%>%  # use OD date format

g_weekly_resp_hb_od<- df_hb_weekly %>% 
  left_join(g_od_flu_hb_adm, by=c("HealthBoardName","WeekEnding")) %>% 
  left_join(g_od_rsv_hb_adm, by=c("HealthBoardName","WeekEnding")) %>% 
  mutate(HealthBoardOfTreatmentQF= if_else(HealthBoard=="S92000003","d","")) %>%  
  od_qualifiers(., "InfluenzaAdmissions", ":") %>%
  od_qualifiers(., "RSVAdmissions", ":") %>% 
  select(WeekEnding,
         HealthBoardName, #remove before final merge
         HealthBoardOfTreatment=HealthBoard,
         HealthBoardOfTreatmentQF,
         InfluenzaAdmissions,InfluenzaAdmissionsQF,
         RSVAdmissions,
         RSVAdmissionsQF)


write_csv(g_weekly_resp_hb_od, glue(od_folder, "weekly_respiratory_admissions_HB.csv"),na = "")



rm(ckan, hb2019_id, hb_code, Dates,  HealthBoardName, df_hb_weekly, 
   i_od_healthboard_admissions , g_od_healthboard_admissions,  i_od_occupancy, 
   g_weekly_healthboard_od, 
   i_od_flu_hb_adm, i_od_rsv_hb_adm, g_od_flu_rsv_hb_adm, g_weekly_resp_hb_od)

# aaa<-read_csv(glue(output_folder,"Admissions_HB.csv"))
# 
# a<-aaa %>% 
#   filter(WeekEnding>"2023-11-05") %>% 
#    mutate(WeekEnding= as.character((WeekEnding))) %>% 
#    rename(HealthBoardName=HealthBoard)
# 
# 
#  three_sunday_dates <- data.frame(WeekEnding=seq(as.Date("2018-10-07"), as.Date(od_date-1), "week")) %>% 
#    # mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d")) ) %>% 
#    slice_tail(n = 3)
#  
#  HealthBoardName= data.frame(HealthBoardOfTreatment=c("NHS Ayrshire and Arran",  "NHS Borders", 
#                                                       "NHS Dumfries and Galloway","NHS Fife",
#                                                       "NHS Forth Valley","NHS Grampian",
#                                                       "NHS Greater Glasgow and Clyde",
#                                                       "NHS Highland","NHS Lanarkshire",
#                                                       "NHS Lothian","NHS Orkney","NHS Shetland","NHS Tayside",
#                                                       "NHS Western Isles","Golden Jubilee National Hospital",
#                                                       "Scotland" ))
#  
#  
#  hb_last_three_weeks <- expand.grid(HealthBoardOfTreatment=unique(HealthBoardName$HealthBoardOfTreatment),
#                                     WeekEnding=unique(three_sunday_dates$WeekEnding),
#                                     KEEP.OUT.ATTRS = FALSE, 
#                                     stringsAsFactors = FALSE) 
#  
#  aba<-aaa %>% 
#    filter(WeekEnding>=od_sunday_minus_14)%>% 
#    rename(HealthBoardOfTreatment=HealthBoard)
#  
#  
#  abc<-hb_last_three_weeks %>% 
#    left_join(aba, by=c("HealthBoardOfTreatment","WeekEnding")) %>% 
#    select(WeekEnding, HealthBoardOfTreatment, TotalInfections) %>% 
#    mutate(TotalInfections=if_else(is.na(TotalInfections),0,TotalInfections))
# 
#    
#  write.csv(abc, glue(output_folder, "Admissions_HB_3wks.csv"), row.names = FALSE)
#  
 
            