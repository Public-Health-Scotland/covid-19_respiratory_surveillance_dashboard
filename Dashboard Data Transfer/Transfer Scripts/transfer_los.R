##### Length of Stay data transfer

all_path_median_los_by_age <- read_csv_with_options(match_base_filename(glue(input_data, "_all_path_median_los_by_age.csv")))

all_path_median_los_by_age_table <- all_path_median_los_by_age %>%  
  select(Season, week_ending, week, pathogen, los_age_band, median_los)

write.csv(all_path_median_los_by_age_table, glue(output_folder, "Median_LOS_by_Age.csv"), row.names=FALSE)

rm(all_path_median_los_by_age, all_path_median_los_by_age_table)

# i_los_weekly <- read_csv_with_options(glue(input_data, "los_weekly.csv"))
# i_los_season <- read_csv_with_options(glue(input_data, "los_season.csv"))
# 
# 
# #  los by week ending 
# g_los_weekly <- i_los_weekly %>%
#   mutate(PercentageOfAdmissions =  round_half_up(ProportionOfAdmissions*100, 1),
#          AdmissionWeekEnding = format(as.Date(WeekEnding), "%Y%m%d"),
#          AdmissionWeekStarting = format(as.Date(WeekStart), "%Y%m%d"),
#          AgeGroupQF = ifelse(age_band_custom == "All Ages", "d", ""),
#          AgeGroup = factor(age_band_custom,
#                            levels = c("0-17", "18-64",  "65-74", "75+", "All Ages")),
#          LengthOfStay = factor(los,
#                                levels = c("1 day or less", "2-3 days", "4-5 days", "6-7 days", "8+ days"))) %>% 
#   select(Season, AdmissionWeekEnding, AdmissionWeekStarting, Week, Weekord,
#          Pathogen, admission_type, AgeGroup,  AgeGroupQF,
#          LengthOfStay,NumberOfAdmissions, ProportionOfAdmissions, PercentageOfAdmissions) %>%
#   arrange(Pathogen, AdmissionWeekEnding, AgeGroup ,LengthOfStay)
# 
# write.csv(g_los_weekly, glue(output_folder, "Length_of_Stay_Weekly.csv"), row.names=FALSE)
# 
# # los by season # 
# g_los_season <- i_los_season %>% 
#   rename(ProportionOfAdmissions=ProportionOfAdmission) %>% 
#   mutate(PercentageOfAdmissions =  round_half_up(ProportionOfAdmissions*100, 1)) %>% 
#   arrange(Pathogen, Season, AgeGroup, LengthOfStay)
# 
# write.csv(g_los_season, glue(output_folder, "Length_of_Stay_Season.csv"), row.names=FALSE)
# 
# rm(i_los_weekly, g_los_weekly,g_los_season, i_los_season)
