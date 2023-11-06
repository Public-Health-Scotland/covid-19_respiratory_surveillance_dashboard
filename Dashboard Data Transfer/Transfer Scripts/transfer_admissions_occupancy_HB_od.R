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

# create framework to hang admissions and occupancy on
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
                                              "NHS Lothian","NHS Orkney","NHS Shetland",
                                              "NHS Western Isles","Golden Jubilee National Hospital",
                                              "Scotland" ))
             
df_hb_weekly <- expand.grid(HealthBoardName=unique(HealthBoardName$HealthBoardName),
                            WeekEnding=unique(Dates$WeekEnding),
                            KEEP.OUT.ATTRS = FALSE, 
                            stringsAsFactors = FALSE) %>%  
  left_join(hb_code, by="HealthBoardName" )%>% # add HB codes
  mutate(HealthBoard= case_when(HealthBoardName== "Scotland"~ "S92000003",
                                HealthBoardName== "Golden Jubilee National Hospital"~ "SB0801",
                                TRUE~  HealthBoard)) #add codes for Scotland & Jubilee
 
###### import health board admissions from output folder

i_od_healthboard_admissions <- read_csv(glue(output_folder, "Admissions_HB.csv"))

g_od_healthboard_admissions <-i_od_healthboard_admissions  %>% 
  rename(HealthBoardName=HealthBoard, Admissions=TotalInfections)%>% # rename for OD consistency
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d"),# update Jubilee name, use OD date format
         HealthBoardName = recode(HealthBoardName,  "National Facility"=
                                  "Golden Jubilee National Hospital" )) 
  
# import as at occupancy from outpout folder
i_od_occupancy <- read_csv(glue(output_folder, "weekly_HB_occupancy.csv"))

# join admissions and occupancy to  weekly framework
g_weekly_healthboard_od<- df_hb_weekly %>% 
left_join(g_od_healthboard_admissions, by=c("HealthBoardName","WeekEnding"), multiple="all") %>% 
 mutate(WeekEnding=as.numeric(WeekEnding)) %>% 
mutate(AdmissionsQF = ifelse(is.na(Admissions), ":", "")) %>% 
left_join(i_od_occupancy, by=(c("WeekEnding", "HealthBoardName"))) %>% 
  mutate(InpatientsAsAtLastSundayQF = ifelse(is.na(InpatientsAsAtLastSunday), ":", ""),
         SevenDayAverageQF=  ifelse(is.na(SevenDayAverage), ":", "")) %>% 
  select(WeekEnding, HealthBoard, Admissions, AdmissionsQF, 
         InpatientsAsAtLastSunday, InpatientsAsAtLastSundayQF,
         InpatientsSevenDayAverage= SevenDayAverage, 
         InpatientsSevenDayAverageQF= SevenDayAverageQF)

write_csv(g_weekly_healthboard_od, glue(od_folder, "weekly_admissions_occupancy_HB_{od_report_date}.csv"),na = "")

rm(ckan, hb2019_id, hb_code, Dates,  HealthBoardName, df_hb_weekly, 
   i_od_healthboard_admissions , g_od_healthboard_admissions,  i_od_occupancy, 
   g_weekly_healthboard_od)



