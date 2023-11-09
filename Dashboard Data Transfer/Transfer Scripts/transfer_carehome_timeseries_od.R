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



i_carehome_timeseries <- read_excel_with_options(
  glue( '//PHI_conf/Real_Time_Epi/Routine_Reporting/Time_Series/Outputs/PCR_LFD',
        '/Care Home Time Series (PCRLFD Reinfections) {format(report_date -1,"%d%m%Y")}_all.xlsx' )) %>%
  select( specimen_date, RESIDENT, STAFF ) %>%
  filter(specimen_date != "Total") %>%
  mutate(specimen_date = ymd(specimen_date),
         `Week Ending` = ceiling_date(specimen_date,
                                      unit='week',
                                      week_start = c(5),
                                      change_on_boundary = FALSE)) %>%
  filter( specimen_date <= ceiling_date( Sys.Date()-7, unit = 'week', week_start = c(5),
                                         change_on_boundary = FALSE ) ) %>%
  group_by( `Week Ending` ) %>%
  mutate( StWk = sum(STAFF), ReWk = sum(RESIDENT), TOTAL = StWk + ReWk ) %>%
  ungroup() %>%
  mutate( Staff = case_when( between(StWk, 1, 4) ~ '*',
                             TRUE ~ as.character(StWk)),
          Resident = case_when( between(ReWk, 1, 4) ~ '*',
                                TRUE ~ as.character(ReWk)),
          Total = case_when( between(StWk, 1, 4) | between(ReWk, 1, 4) ~ '*',
                             TRUE ~ as.character(TOTAL) )) %>%
  select( `Week Ending`, Resident, Staff, Total ) %>%
  distinct()



g_carehome_timeseries<-i_carehome_timeseries  %>%
  mutate(ResidentQF = if_else(Resident == "*", "c", ""),
         StaffQF = if_else(Staff == "*", "c", ""),
         TotalQF = if_else(Total == "*", "c", ""),
         across(c(Resident, Staff, Total), function(x) if_else(x == "*", "", x)))%>%
  rename(WeekEnding="Week Ending") %>%
  mutate(WeekEnding = format(strptime(WeekEnding, format = "%Y-%m-%d"), "%Y%m%d")) %>%
  select(WeekEnding, Resident, ResidentQF,
         Staff, StaffQF,Total, TotalQF)

# original output , is this still needed?
#write_csv(g_carehome_timeseries, glue("{output_folder}/TEMP_care_home_time_series_{report_date}.csv"),
#         na = "")


#revised open data  output
g_carehome_timeseries_od<-g_carehome_timeseries  %>%
  mutate(Country="S92000003") %>% 
  select(WeekEnding, Country, Resident, ResidentQF,
         Staff, StaffQF,
         TotalStaffAndResidents=Total, 
         TotalStaffAndResidentsQF=TotalQF)

write_csv(g_carehome_timeseries_od, glue(od_folder,"care_home_time_series_{od_report_date}.csv"),na = "")


rm(i_carehome_timeseries, g_carehome_timeseries, g_carehome_timeseries_od)

