
###########################
### HOSPITAL ADMISSIONS ### ----
###########################

metadataButtonServer(id="hospital_admissions",
                     panel="COVID-19 hospital admissions",
                     parent = session)

jumpToTabButtonServer(id="hospital_admissions_from_summary",
                      location="hospital_admissions",
                      parent = session)

observeEvent(input$glossary,
             {
               updateTabsetPanel(session = session, "intabset", selected = "metadata")
               updateCollapse(session = session, "notes_collapse", open = "Glossary")

             })


# Hospital admissions ----

altTextServer("hospital_admissions_modal",
              title = "Daily number of COVID-19 hospital admissions",
              content = tags$ul(tags$li("This is a plot of daily COVID-19 hospital admissions."),
                                tags$li("The x axis is the date, starting 01 Mar 2020."),
                                tags$li("The y axis is the number of admissions."),
                                tags$li("There are two traces: a light blue trace which shows the number of",
                                        "hospital admissions; and a dark blue trace overlayed which shows the 7 day average of this."),
                                tags$li("The data for the most recent week are provisional and displayed in grey."),
                                tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                        "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                        "the second marks the change in testing policy on 1 May 2022."),
                                tags$li("There have been several peaks throughout the pandemic, notably in",
                                        "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021, Jan 2022, Mar 2022 and Jun 2022.")
              )
)

altTextServer("hospital_admissions_simd_modal",
              title = "Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)",
              content = tags$ul(tags$li("This is a plot of weekly COVID-19 hospital admissions broken down by SIMD deprivation category."),
                                tags$li("SIMD is a relative measure of deprivation across small areas in Scotland.",
                                        "There are equal numbers of data zones in each of the five categories.",
                                        "SIMD 1 contains the 20% most deprived zones and SIMD 5 contains the 20%",
                                        "least deprived zones. See the",
                                        tags$a("Scottish government website (external link)",
                                               href="https://www.gov.scot/collections/scottish-index-of-multiple-deprivation-2020/"),
                                        "for more information."),
                                tags$li("The x axis is the week ending, starting 03 Jan 2021."),
                                tags$li("The y axis is the number of COVID-19 hospital admissions in that week."),
                                tags$li("The plot contains a trace for each of the SIMD categories. SIMD 1 is",
                                        "highlighted in red and SIMD 5 in blue. The other categories are in grey."),
                                tags$li("There have been several peaks throughout the pandemic, notably in",
                                        "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021, Jan 2022, Mar 2022 and Jun 2022.")
              )
)

altTextServer("hospital_admissions_los_modal",
              title = "Length of stay of acute COVID-19 hospital admissions",
              content = tags$ul(
                tags$li("This is a plot of the distribution of lengths of stay in hospital",
                        "for acute COVID-19 hospital admissions."),
                tags$li("There is a drop down above the chart which allows you to select",
                        "an age group for plotting. The default is all ages."),
                tags$li("The legend shows five categories for length of stay: 1 day or less;",
                        "2-3 days, 4-5 days, 6-7 days, 8+ days. See the metadata tab for further detail."),
                tags$li("The x axis is the hospital admission date by week ending."),
                tags$li("The y axis is the percentage of admissions in a given length of stay category."),
                tags$li("The plot is a stacked bar chart for each week ending, where the",
                        "sections of vertical bars correspond to different length of stay categories.",
                        "The bar sections are ordered from smallest length of stay to largest",
                        "length of stay from bottom to top."),
                tags$li("Please note that in cases where there are no hospital admissions there",
                        "will be a gap in the chart.")
              )
)

altTextServer("hospital_admissions_ethnicity_modal",
              title = "COVID-19 admissions to hospital by ethnicity",
              content = tags$ul(
                tags$li("This is a plot of COVID-19 admissions to hospital ",
                        "broken down by ethnic group."),
                tags$li("The x axis is the month of admission to hospital."),
                tags$li("The y axis is the number of admissions."),
                tags$li("The plot is a stacked bar chart for each month beginning,",
                        "where the bars are broken down by ethnic group."),
                tags$li("The ethnic groups are displayed from bottom to top in the",
                        "following order: African; Asian, Asian Scottish or Asian British;",
                        "Caribbean or Black; White; Mixed or Multiple Ethnic Groups;",
                        "Other; Unknown.")
              )
)

altTextServer("icu_admissions_modal",
              title = "Weekly number of COVID-19 ICU admissions",
              content = tags$ul(
                tags$li("This is a plot of the weekly number of COVID-19 admissions to",
                        "hospital intensive care units (ICU)."),
                tags$li("The x axis is the week ending of admission, commencing 12 Mar 2020."),
                tags$li("The y axis is the number of ICU admissions."),
                tags$li("There is a dark blue trace which shows the number of ICU admissions each week."),
                tags$li("There were large peaks in ICU admissions in Apr 2020, Jan 2021",
                        "and Sep 2021. Since then the overall trend has been a decline",
                        "in ICU admissions over time.")
              )
)

### DAILY ADMISSIONS ### ----

# Table
output$hospital_admissions_table <- renderDataTable({
  Admissions %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(AdmissionDate = convert_opendata_date(AdmissionDate),
           ProvisionalFlag = factor(recode(ProvisionalFlag, "1" = "p", "0" = ""))) %>%
    select(AdmissionDate, TotalInfections, SevenDayAverage, ProvisionalFlag) %>%
    dplyr::rename(`Date` = AdmissionDate,
                  `Number of admissions` = TotalInfections,
                  `7 day average` = SevenDayAverage,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols = c(2,3),
               filter_cols = 4)
})

# Plot
output$hospital_admissions_plot <- renderPlotly({
  Admissions %>%
    make_hospital_admissions_plot()

})


### WEEKLY ADMISSIONS BY SIMD ### ----

## Modal to explain what SIMD is
simd_modal <- modalDialog(
  h3("What is Scottish Index of Multiple Deprivation (SIMD)?"),
  p("People have been allocated to different levels of deprivation based on the small area (data zone) in which they live and the",
                    tags$a("Scottish Index of Multiple Deprivation (SIMD) (external website)",
                           href = "https://simd.scot/#/simd2020/BTTTFTT/9/-4.0000/55.9000/"),
      "score for that area. SIMD scores are based on data for
                    38 indicators covering seven topic areas: income, employment, health, education, skills and training, housing, geographic access, and crime."),
  p("The SIMD identifies deprived areas, not deprived individuals."),
  p("In this tool we have presented results for people living in different SIMD ‘quintiles’. To produce quintiles,
                    data zones are ranked by their SIMD score then the areas each containing a fifth (20%) of the overall population of Scotland are identified.
                    People living in the most and least deprived areas that each contain a fifth of the population are assigned to SIMD quintile 1 and 5 respectively."),
  size = "l",
  easyClose = TRUE, fade=TRUE, footer = modalButton("Close (Esc)")
)

### Modal links
observeEvent(input$btn_modal_simd, { showModal(simd_modal) })

# Table
output$hospital_admissions_simd_table <- renderDataTable({
  Admissions_SimdTrend %>%
    arrange(desc(WeekEnding)) %>%
    mutate(WeekEnding = convert_opendata_date(WeekEnding),
           SIMD = factor(SIMD),
           ProvisionalFlag = factor(recode(ProvisionalFlag, "1" = "p", "0" = ""))) %>%
    select(WeekEnding, SIMD, NumberOfAdmissions, ProvisionalFlag) %>%
    dplyr::rename(`Week ending` = WeekEnding,
                  `Number of admissions` = NumberOfAdmissions,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols = c(3),
               filter_cols = c(2,4))
})


# Plot
output$hospital_admissions_simd_plot <- renderPlotly({
  Admissions_SimdTrend %>%
    make_hospital_admissions_simd_plot()

})

# HB Table
output$hospital_admissions_hb_table <- renderDataTable({
  Admissions_HB_3wks%>%
    filter(WeekEnding %in% adm_hb_dates) %>%
    rename(HealthBoard=HealthBoardOfTreatment) %>% 
    mutate(WeekEnding = format(WeekEnding, format = "%d %b %y")) %>%
    pivot_wider(names_from = WeekEnding,
                values_from = TotalInfections) %>%
    mutate(HealthBoard = factor(HealthBoard,
                                levels = c("NHS Ayrshire and Arran", "NHS Borders", "NHS Dumfries and Galloway", "NHS Fife", "NHS Forth Valley", "NHS Grampian",
                                                        "NHS Greater Glasgow and Clyde", "NHS Highland", "NHS Lanarkshire", "NHS Lothian", "NHS Orkney", "NHS Shetland",
                                                        "NHS Tayside", "NHS Western Isles", "Golden Jubilee National Hospital", "Scotland"))) %>%
    arrange(HealthBoard) %>%
    dplyr::rename(`Health Board of treatment` = HealthBoard) %>%
    make_summary_table(maxrows = 16)
})


### LENGTH OF STAY ### ----

# Table
output$hospital_admissions_los_table <- renderDataTable({
  Length_of_Stay %>%
    arrange(desc(AdmissionWeekEnding)) %>%
    mutate(AdmissionWeekEnding = convert_opendata_date(AdmissionWeekEnding),
           AgeGroup = factor(AgeGroup),
           LengthOfStay = factor(LengthOfStay),
           ProportionOfAdmissions = ProportionOfAdmissions*100) %>%
    select(AdmissionWeekEnding, AgeGroup, LengthOfStay, ProportionOfAdmissions) %>%
    dplyr::rename(`Week ending` = AdmissionWeekEnding,
                  `Age group` = AgeGroup,
                  `Length of stay` = LengthOfStay,
                  `Percentage of age group in length of stay category` = ProportionOfAdmissions) %>%
    make_table(add_percentage_cols = c(4),
               maxrows = 15,
               filter_cols = c(2,3))
})


# Plot
output$hospital_admissions_los_plot<- renderPlotly({
  Length_of_Stay %>%
    make_hospital_admissions_los_plot()

})


######################
### ICU ADMISSIONS ### ----
######################

# DAILY ADMISSIONS # ----

# # Table
# output$icu_admissions_table <- renderDataTable({
#   ICU %>%
#     arrange(desc(DateFirstICUAdmission)) %>%
#     mutate(DateFirstICUAdmission = convert_opendata_date(DateFirstICUAdmission)) %>%
#     select(DateFirstICUAdmission, NewCovidAdmissionsPerDay, SevenDayAverage) %>%
#     dplyr::rename(`Date` = DateFirstICUAdmission,
#                   `Number of ICU admissions` = NewCovidAdmissionsPerDay,
#                   `7 day average` = SevenDayAverage) %>%
#     make_table(add_separator_cols = c(2,3))
# })

# Table
output$icu_admissions_table <- renderDataTable({
  ICU_weekly %>%
    mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                              "*", NewCovidAdmissionsPerWeek)) %>%
    arrange(desc(WeekEndingFirstICUAdmission)) %>%
    mutate(WeekEndingFirstICUAdmission = convert_opendata_date(WeekEndingFirstICUAdmission)) %>%
    select(WeekEndingFirstICUAdmission, NewCovidAdmissionsPerWeek) %>%
    dplyr::rename(`Week Ending` = WeekEndingFirstICUAdmission,
                  `Number of ICU admissions` = NewCovidAdmissionsPerWeek) %>%
    make_table(add_separator_cols = c(2))
})


# # Plot
# output$icu_admissions_plot<- renderPlotly({
#   ICU %>%
#     make_icu_admissions_plot()
#
# })

# Plot
output$icu_admissions_plot<- renderPlotly({
  ICU_weekly %>%
    make_icu_admissions_weekly_plot()

})

output$disclosure_statement <- renderUI({

  tagList(p("* Statistical disclosure control has been applied according to ",
            tags$a(href="https://publichealthscotland.scot/media/3219/1_statistical-disclosure-control-protocol.pdf",
                                                       "PHS Statistical Disclosure Control Protocol (external website).",
                                                       target="_blank")))
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
               maxrows = 7,
               filter_cols = 2)
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