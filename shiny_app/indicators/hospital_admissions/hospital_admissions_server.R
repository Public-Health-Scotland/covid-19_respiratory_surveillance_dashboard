
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
              title = "Weekly number of COVID-19 hospital admissions",
              content = tags$ul(tags$li("This is a plot of weekly COVID-19 hospital admissions."),
                                tags$li("The x axis is the date, starting 01 Mar 2020."),
                                tags$li("The y axis is the number of admissions in that week."),
                                tags$li("There is one blue trace, which shows the number of",
                                        "hospital admissions."),
                                tags$li("The data for the most recent week are provisional and displayed in grey."),
                                tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                        "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                        "the second marks the change in testing policy on 1 May 2022."),
                                tags$li("There have been several peaks since the start of the pandemic, notably in",
                                        "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021,",
                                        "Jan 2022, Mar 2022, Jun 2022, Jan 2023 and Mar 2023.")
              )
)

altTextServer("hospital_admissions_age_modal",
              title = "COVID-19 hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of COVID-19 hospital admission per 100,000 population by age group."),
                                tags$li("The x axis is the week ending date."),
                                tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("The plot contains a trace showing the admission rate per 100k for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))




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
                                        "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021,",
                                        "Jan 2022, Mar 2022, Jun 2022, Jan 2023 and Mar 2023.")
              )
)

altTextServer("cov_los_modal",
              title = "Length of stay of acute COVID-19 hospital admissions by age group",
              content = tags$ul(
                tags$li("This is a plot of the median lengths of stay in hospital",
                        "for acute COVID-19 hospital admissions by respiratory season, broken down by age group."),
                tags$li("The 4-week rolling median is calculated using the length of stay for all individuals in a given age group 
                        over the four-week period leading up to the given ISO week."),
                tags$li("There is a drop down above the chart which allows you to select",
                        "the respiratory season for plotting. The default is the current season."),
                tags$li("There are eight distinct categories for age group that can be displayed: <1, 1 to 4, 5 to 14,",
                        "15 to 44, 45 to 64, 65 to 74, 75+ years, and 'All ages'. As a default, the overall median for all age groups is shown."),
                tags$li("The x axis shows the ISO week that the 4-week rolling median relates to."),
                tags$li("The y axis is the median length of stay in days."),
                tags$li("Where no data is available for a given week, this means that no individuals within that age group
                        were admitted to hospital with COVID-19 over the 4-week period prior to the missing data point.") ))


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


altTextServer("covid_adm_age_sex",
             title = glue("Acute COVID-19 cases by age and sex in Scotland"),
             content = tags$ul(
               tags$li(glue("This is a pyramid plot of rate per 100,000 people of acute COVID-19 hospital admissions in Scotland by age and sex.")),
               tags$li("The information is displayed for a selected season."),
               tags$li("Weekly rate data for age and sex on a weekly basis are available in ",
                       "the PHS Open Data platform ",
                       tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
                              "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website).",
                              target="_blank")),
               tags$li("The y axis shows the age group. The left side of the y axis corresponds to females (F) and the right side to males (M)."),
               tags$li("For the x axis the plot shows rate per 100,000 people.")
               # tags$li("The youngest and oldest groups have the highest rates of illness.")
             )
)


### WEEKLY ADMISSIONS-Scotland ### ----

# # Table
# output$hospital_admissions_table <- renderDataTable({
#   Admissions_Weekly %>%
#     arrange(desc(AdmissionDate)) %>%
#     mutate(AdmissionDate = convert_opendata_date(AdmissionDate),
#            ProvisionalFlag = factor(recode(ProvisionalFlag, "1" = "p", "0" = " "))) %>%
#     select(AdmissionDate, TotalInfections,  ProvisionalFlag) %>%
#     dplyr::rename(`Week of Admission` = AdmissionDate,
#                   `Number of admissions` = TotalInfections,
#                   `Is data provisional (p)?` = ProvisionalFlag) %>%
#   make_table(add_separator_cols = 2,
#                filter_cols = 3)
# 
# })

# Table
output$hospital_admissions_table <- renderDataTable({
  all_pathogen_admissions %>%
    select(Date, cov) %>%
    rename(AdmissionDate = Date,
           TotalInfections = cov) %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(ProvisionalFlag = ifelse(row_number() == 1, "p", " ")) %>%
    mutate(ProvisionalFlag = factor(ProvisionalFlag)) %>%
    select(AdmissionDate, TotalInfections,  ProvisionalFlag) %>%
    dplyr::rename(`Week of Admission` = AdmissionDate,
                  `Number of admissions` = TotalInfections,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols = 2,
               filter_cols = 3)
  
})

# # Plot
# output$hospital_admissions_plot <- renderPlotly({
#   Admissions_Weekly %>%
#     make_hospital_admissions_plot()
# 
# })

# Plot
output$hospital_admissions_plot <- renderPlotly({
  all_pathogen_admissions %>%
    select(Date, cov) %>%
    rename(AdmissionDate = Date,
           TotalInfections = cov) %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(ProvisionalFlag = ifelse(row_number() == 1, 1, 0)) %>%
    select(AdmissionDate, TotalInfections,  ProvisionalFlag) %>%
    mutate(AdmissionDate = as.numeric(format(AdmissionDate, "%Y%m%d"))) %>%
    make_hospital_admissions_plot()
  
})

#### WEEKLY ADMISSIONS BY AGE

# COVID-19 admissions by age table
output$covid_admissions_age_table <- renderDataTable({
  age_rate_data_all_path %>%
    select(week_ending, age_band,
           rate = cov_rate) %>% 
    #mutate(week_ending = dmy(week_ending)) %>%
    filter(age_band != "All Ages") %>%
    mutate(week_ending = as_date(week_ending)) %>% 
    arrange(desc(week_ending)) %>%
    rename(`Week Ending` = week_ending,
           `Age Group` = age_band,
           `Admission Rate per 100k` = rate) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2))
})

# COVID-19 Adms by age plot
output$covid_admissions_age_plot <- renderPlotly({
  age_rate_data_all_path %>%
    #mutate(week_ending = dmy(week_ending)) %>%
    filter(age_band != "All Ages") %>% 
    select(week_ending, age_band,
           rate = cov_rate) %>%
    mutate(age_band = factor(age_band, levels = c("<1",  "1-4", "5-14", "15-44", "45-64",
                                                  "65-74", "75+"))) %>% 
    arrange(week_ending, age_band) %>%
    create_pathogen_adms_age_linechart()
  
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

### WEEKLY HB ADMISSIONS Table ### ----

output$hospital_admissions_hb_table <- renderDataTable({
  Admissions_HB_3wks%>%
   # filter(WeekEnding %in% adm_hb_dates) %>%
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

# los plot reactive title
# output$cov_los_title <- renderUI({h3(glue("COVID-19 length of stay by age group in Season ",
#                                                         input$los_season_cov))})
# # 
# output$respiratory_over_time_title <- renderUI({h3(glue("Influenza cases over time by subtype in ",
#                                                         input$respiratory_select_healthboard))})


# Plot
output$cov_los_plot<- renderPlotly({
  cov_los_weekly_plot <- Median_LOS_by_Age %>%
    filter(pathogen == "COVID-19") %>% 
    filter(Season == input$los_season_cov) %>%
    #filter(los_age_band %in% input$los_cov_age) %>%
    make_hospital_admissions_los_plot()
  
})

# output$cov_los_plot<- renderPlotly({
#   cov_los_weekly_plot <- Length_of_Stay_Season %>%
#     filter(admission_type == "cov") %>% 
#     filter(Season == input$los_season_cov) %>%
#     make_hospital_admissions_los_plot()
# 
# })
# Table

output$cov_los_table <- renderDataTable({
  cov_los_weekly_table <- Median_LOS_by_Age %>% 
    filter(pathogen == "COVID-19") %>% 
    select(Season, week_ending, week, los_age_band, median_los) %>% 
    mutate(los_age_band = factor(los_age_band, levels = c("<1", "1 to 4", "5 to 14",
                                                          "15 to 44", "45 to 64", "65 to 74",  "75+", "All ages"))) %>% 
    arrange(desc(week_ending), los_age_band) %>% 
    filter(Season == input$los_season_cov) %>%
    #filter(los_age_band %in% input$los_cov_age) %>%
    rename(`Median Length of Stay (4-week)` = median_los,
           `Age Group` = los_age_band,
           `ISO Week` = week,
           `Week Ending` = week_ending)
})
# 
# output$cov_los_table <- renderDataTable({
#   cov_los_weekly_table <-Length_of_Stay_Season %>% 
#     filter(admission_type == "cov") %>% 
#     filter(Season == input$los_season_cov) %>%
#     mutate(`Length of stay` = factor(LengthOfStay,
#                                      levels = c("1 day or less",
#                                                 "2-3 days", "4-5 days",
#                                                 "6-7 days", "8+ days"))) %>% 
#     select(Season, 'Age group' = AgeGroup,'Length of stay',
#            'Percent' = PercentageOfAdmissions) })


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



#------------------------#
#### Hosp adm pyramid ####
#------------------------#

# output$cov_adm_pyr_title <- renderUI({h3(glue("Acute COVID-19 hospital admissions by age and sex in Scotland; ",
#                                           input$cov_age_sex_adm_season))})
# 
# 
# # pyramid plot that shows the breakdown by age and sex
# output$covid_adm_age_sex_pyramid_plot = renderPlotly({
#   Admissions_AgeSex_Season %>%
#     filter(Pathogen == "cov",
#            Sex %in% c("M", "F"),
#            Season == input$cov_age_sex_adm_season) %>%
#     make_age_sex_adm_pyramid_plot # hospital_admissions_functions
#   
# })


# output$covid_adm_age_sex_pyramid_table = renderDataTable({
#   
#   covid_adm_sex_pyramid_table <- Admissions_AgeSex_Season %>%
#     filter(Pathogen == "cov",
#            Season == input$cov_age_sex_adm_season) %>%
#     select(Season, AgeGroup, Sex, Rate) %>%
#     mutate(Season = factor(Season)) %>%
#     arrange(desc(Season), AgeGroup, Sex) %>%
#     dplyr::rename("Season" = "Season",
#                   "Age group" = "AgeGroup",
#                   "Rate per 100,000" = "Rate") %>%
#     mutate(Sex = factor(Sex, levels = c("All", "F", "M")),
#            `Age group` = factor(`Age group`, levels =
#                                   c("All","Under 18","18-64","65-74","75+"))) %>%
#     arrange(desc(`Season`), `Age group`, Sex) %>%
#     make_table(add_separator_cols_1dp = c(4),
#                filter_cols = c(1,2,3))
#   
# })
