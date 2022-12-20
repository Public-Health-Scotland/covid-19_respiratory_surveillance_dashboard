
###########################
### HOSPITAL ADMISSIONS ### ----
###########################

### DAILY ADMISSIONS ### ----

# Table
output$hospital_admissions_table <- renderDataTable({
  Admissions %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(AdmissionDate = convert_opendata_date(AdmissionDate)) %>%
    select(AdmissionDate, TotalInfections, SevenDayAverage, ProvisionalFlag) %>%
    dplyr::rename(`Date` = AdmissionDate,
                  `Number of admissions` = TotalInfections,
                  `7 day average` = SevenDayAverage,
                  `Stable or provisional` = ProvisionalFlag) %>%
    make_table(add_separator_cols = c(2),
               add_separator_cols_1dp = c(3))
})

# Plot
output$hospital_admissions_plot <- renderPlotly({
  Admissions %>%
    make_hospital_admissions_plot()

})


### WEEKLY ADMISSIONS BY SIMD ### ----

# Table
output$hospital_admissions_simd_table <- renderDataTable({
  Admissions_SimdTrend %>%
    arrange(desc(WeekEnding)) %>%
    mutate(WeekEnding = convert_opendata_date(WeekEnding)) %>%
    select(WeekEnding, SIMD, NumberOfAdmissions, ProvisionalOrStable) %>%
    dplyr::rename(`Week ending` = WeekEnding,
                  `Number of admissions` = NumberOfAdmissions,
                  `Provisional or stable` = ProvisionalOrStable) %>%
    make_table(add_separator_cols = c(3))
})


# Plot
output$hospital_admissions_simd_plot<- renderPlotly({
  Admissions_SimdTrend %>%
    make_hospital_admissions_simd_plot()

})


### LENGTH OF STAY ### ----

# Table
output$hospital_admissions_los_table <- renderDataTable({
  Length_of_Stay %>%
    arrange(desc(AdmissionWeekEnding)) %>%
    mutate(AdmissionWeekEnding = convert_opendata_date(AdmissionWeekEnding),
           ProportionOfAdmissions = ProportionOfAdmissions*100) %>%
    select(AdmissionWeekEnding, AgeGroup, LengthOfStay, ProportionOfAdmissions) %>%
    dplyr::rename(`Week ending` = AdmissionWeekEnding,
                  `Age group` = AgeGroup,
                  `Length of stay` = LengthOfStay,
                  `Percentage of age group in length of stay category` = ProportionOfAdmissions) %>%
    make_table(add_percentage_cols = c(4),
               maxrows = 15)
})


# Plot
output$hospital_admissions_los_plot<- renderPlotly({
  Length_of_Stay %>%
    make_hospital_admissions_los_plot()

})

########################################
### HOSPITAL ADMISSIONS BY ETHNICITY ### ----
########################################

# TABLE
output$hospital_admissions_ethnicity_table <- renderDataTable({
  Ethnicity %>%
    arrange(desc(MonthBegining)) %>%
    mutate(MonthBegining = convert_opendata_date(MonthBegining),
           Admissions = ifelse(is.na(Admissions), "*", as.character(Admissions)),
           Percentage = ifelse(is.na(Percentage), "*", as.character(Percentage)),
           EthnicGroup = factor(EthnicGroup,
                                levels = c("African",
                                           "Asian, Asian Scottish or Asian British",
                                           "Caribbean or Black",
                                           "White",
                                           "Mixed or Multiple Ethnic Groups",
                                           "Other",
                                           "Unknown"))) %>%
    select(MonthBegining, EthnicGroup, Admissions, Percentage) %>%
    dplyr::rename(`Month beginning` = MonthBegining,
                  `Ethnic group` = EthnicGroup,
                  `Percentage of admissions in ethnic group` = Percentage) %>%
    make_table(add_separator_cols = c(3),
               add_percentage_cols = c(4),
               maxrows = 7)
})

# Plot: Numbers
output$hospital_admissions_ethnicity_plot<- renderPlotly({
  Ethnicity %>%
    mutate(MonthBegining = convert_opendata_date(MonthBegining),
           EthnicGroup = factor(EthnicGroup,
                                levels = c("African",
                                           "Asian, Asian Scottish or Asian British",
                                           "Caribbean or Black",
                                           "White",
                                           "Mixed or Multiple Ethnic Groups",
                                           "Other",
                                           "Unknown"))) %>%
    make_hospital_admissions_ethnicity_plot()

})

# Plot: Percentage
output$hospital_admissions_ethnicity_perc_plot <- renderPlotly({
  Ethnicity_Chart %>%
    mutate(month_begining = convert_opendata_date(month_begining)) %>%
    make_hospital_admissions_ethnicity_perc_plot()

})

######################
### ICU ADMISSIONS ### ----
######################

# DAILY ADMISSIONS # ----

# Table
output$icu_admissions_table <- renderDataTable({
  ICU %>%
    arrange(desc(DateFirstICUAdmission)) %>%
    mutate(DateFirstICUAdmission = convert_opendata_date(DateFirstICUAdmission)) %>%
    select(DateFirstICUAdmission, NewCovidAdmissionsPerDay, SevenDayAverage) %>%
    dplyr::rename(`Date` = DateFirstICUAdmission,
                  `Number of ICU admissions` = NewCovidAdmissionsPerDay,
                  `7 day average` = SevenDayAverage) %>%
    make_table(add_separator_cols = c(2),
               add_separator_cols_1dp = c(3))
})

# Plot
output$icu_admissions_plot<- renderPlotly({
  ICU %>%
    make_icu_admissions_plot()

})