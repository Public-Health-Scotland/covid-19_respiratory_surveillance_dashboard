# #This script reads in "Care home" open data output and save them to Open Data folder
# #24/10/2025
# #Nipuni Rajapaksha
# 
# #* Week is from Saturday to Friday
# 
# #1. Care home time series-------------------------------------------------------
# 
# care_home_ts<-read_csv(paste0(file_paths$Data$Open_data_folder,
#                               "care_home_time_series_",od_report_date,".csv")) %>% 
#   mutate(Pathogen="COVID-19") %>% 
#   relocate(Pathogen,.after = Country)
# 
# ##write csv----
# message("Writing Care_Home_CASES_COVID19_time_series file")
# write_csv(care_home_ts,paste0(file_paths$Outputs$Output_folder,
#                               "Care_Home_CASES_COVID19_time_series_",od_report_date,".csv"))
# 
# 
# 
# rm(care_home_ts)