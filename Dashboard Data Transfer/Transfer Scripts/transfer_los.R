##### Length of Stay data transfer



i_los <- read_csv_with_options(glue(input_data, "Hospital Admissions/{format(report_date -2,'%Y-%m-%d')}_LOS Table Dashboard.csv"))

g_los <- i_los %>%
  dplyr::rename(AgeGroup = age_band_custom,
                AdmissionWeekEnding = week_ending,
                LengthOfStay = los,
                NumberOfAdmissions = n,
                ProportionOfAdmissions = prop) %>%
  mutate(ProportionOfAdmissions = round_half_up(ProportionOfAdmissions, 3),
         AdmissionWeekEnding = format(as.Date(AdmissionWeekEnding), "%Y%m%d"),
         AgeGroupQF = ifelse(AgeGroup == "All Ages", "d", ""),
         AgeGroup = factor(AgeGroup,
                           levels = c("0-17", "18-29", "30-39", "40-49", "50-54", "55-59",
                                      "60-64", "65-69", "70-74", "75-79", "80+", "All Ages")),
         LengthOfStay = factor(LengthOfStay,
                               levels = c("1 day or less", "2-3 days", "4-5 days", "6-7 days", "8+ days"))) %>%
  select(AdmissionWeekEnding, AgeGroup, AgeGroupQF, LengthOfStay, NumberOfAdmissions, ProportionOfAdmissions) %>%
  arrange(AdmissionWeekEnding, AgeGroup, LengthOfStay)



write.csv(g_los, glue(output_folder, "Length_of_Stay.csv"), row.names=FALSE)

rm(i_los, g_los)