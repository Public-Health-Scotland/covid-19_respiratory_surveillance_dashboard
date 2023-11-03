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
  mutate(HealthBoard= ifelse(HealthBoardName== "Scotland", "S92000003", HealthBoard))%>% #add code for Scotland
  mutate(HealthBoardQF = ifelse(is.na(HealthBoard), ":", "")) # add QF for Jubilee

###### import health board admissions from transfer admissions admissions process
# bring output back in temporarily until source input, reformat for Open Data

od_healthboard_admissions <- read_csv(glue(output_folder, "Admissions_HB.csv")) %>% 
  rename(HealthBoardName=HealthBoard, Admissions=TotalInfections)%>% # rename for OD consistency
  mutate(WeekEnding= format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) #use OD data format
  


# import as at occupancy
od_occupancy <- read_csv(glue(output_folder, "weekly_HB_occupancy.csv"))
# import as at occupancy
# od_seven_day_occupancy <- read_csv(glue(output_folder, "Occupancy_Hospital_HB.csv")) %>% 
#   mutate_all(~ifelse(is.na(.), "", .))


weekly_healthboard_od<- df_hb_weekly %>% 
  select(WeekEnding, HealthBoardName,HealthBoard,HealthBoardQF) %>% 
  left_join(od_healthboard_admissions, by=c("HealthBoardName","WeekEnding"), multiple="all") %>% 
  mutate(WeekEnding=as.numeric(WeekEnding)) %>% 
  mutate(AdmissionsQF = ifelse(is.na(Admissions), ":", "")) %>% 
  left_join(od_occupancy, by=(c("WeekEnding", "HealthBoardName")))

