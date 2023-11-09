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

#bring output ethnicity file back in and reformat for Open Data

i_ethnicity_od <- read_csv(glue(output_folder, "Ethnicity.csv"))

g_ethnicity_od=i_ethnicity_od%>% 
  mutate(Country= "S92000003" ,
         AdmissionsQF = "", PercentageQF = "",
         Admissions = ifelse(Admissions < 5, "", Admissions),
         AdmissionsQF = ifelse(is.na(Admissions), "c", AdmissionsQF),
         Percentage = ifelse(is.na(Admissions), "", Percentage),
         PercentageQF = ifelse(is.na(Admissions), "c", PercentageQF)) %>% 
  select(MonthBeginning=MonthBegining, Country, EthnicGroup, 
         Admissions, AdmissionsQF, Percentage, PercentageQF)

write.csv(g_ethnicity_od, glue(od_folder, "ethnicity_{od_report_date}.csv"), row.names = FALSE, na = "")

rm(g_ethnicity_od, i_ethnicity_od)


