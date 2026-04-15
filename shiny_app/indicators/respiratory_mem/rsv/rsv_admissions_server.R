

metadataButtonServer(id="respiratory_rsv_admissions",
                     panel="Respiratory infection activity",
                     parent = session)



altTextServer("rsv_admissions_modal",
              title = "Wekly rate of RSV hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the weekly rate of RSV hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of hospital admissions per 100,000."),
                                tags$li(glue("There is a trace for each of the following seasons from ", 
                                             rsv_adm_seasons[1], " to ", rsv_adm_seasons[6], ".")),
                                tags$li("Hospital admissions for the most recent week may be incomplete, and should be treated as provisional and interpreted with caution")
              )
)


# altTextServer("rsv_admissions_modal",
#               title = "RSV hospital admissions in Scotland",
#               content = tags$ul(tags$li("This is a plot showing the number of RSV hospital admissions in Scotland."),
#                                 tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
#                                         "Week 40 is typically the start of October and when the winter respiratory season starts."),
#                                 tags$li("The y axis shows the number of hospital admissions."),
#                                 tags$li(glue("There is a trace for each of the following season from ", 
#                                              rsv_adm_seasons[1], " to ", rsv_adm_seasons[6], "."))))

altTextServer("rsv_admissions_age_modal",
              title = "RSV hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by age group."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                 tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("rsv_admissions_hb_modal",
              title = "RSV hospital admission rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by NHS Health Board."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. "),
                                tags$li("The y axis shows the hospital admission rate per 100,000 population.")
              ))


altTextServer("rsv_adm_age_sex",
              title = glue("Acute RSV admissions by age and sex in Scotland"),
              content = tags$ul(
                tags$li(glue("This is a pyramid plot of rate per 100,000 people of RSV cases in Scotland by age and sex.")),
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


altTextServer("rsv_los_modal",
              title = "Average length of stay of acute RSV hospital admissions",
              content = tags$ul(
                tags$li("This is a plot of the average length of stay in hospital",
                        "for acute RSV hospital admissions for individuals within different age groups 
                        for a given respiratory season."),
                tags$li("Length of stay is calculated as the difference between the discharge date and",
                        "the date of admission in days."),
                tags$li("There is a drop down above the chart which allows you to select",
                        "the respiratory season for plotting. The default is the current season."),
                tags$li("The x axis shows a break down of admissions by age groups: Under 1, 1-4, 5-14, 15-44,
                        45-64, 65-74, 75+ and finally for all ages combined."),
                tags$li("The y axis is the average length of stay for admissions within a given age group category."),
                tags$li("For each age group category, the 95% confidence interval (CI) for the average length of stay is
                        also shown. The CI represents a range of plausible values for the average length of stay and 
                        can provide a sense of how much variation there is within the underlying data."),
                tags$li("CIs will generally be wider when they are calculated based on less data 
                        (e.g. for an incomplete season).") ))

altTextServer("rsv_admissions_simd_modal",
              title = "RSV hospital admission rate per 100,000 population by deprivation category (SIMD)",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by SIMD deprivation category
                                        for the selected season."),
                                tags$li("SIMD is a relative measure of deprivation across small areas in Scotland.",
                                        "There are equal numbers of data zones in each of the five categories.",
                                        "SIMD 1 contains the 20% most deprived zones and SIMD 5 contains the 20%",
                                        "least deprived zones. See the",
                                        tags$a("Scottish government website (external link)",
                                               href="https://www.gov.scot/collections/scottish-index-of-multiple-deprivation-2020/"),
                                        "for more information."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                 tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("The plot contains a trace for each of the SIMD categories. SIMD 1 is",
                                        "highlighted in red and SIMD 5 in blue. The other categories are in grey."),
                                # tags$li("There have been several peaks throughout the pandemic, notably in",
                                #         "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021,",
                                #         "Jan 2022, Mar 2022, Jun 2022, Jan 2023 and Mar 2023.")
              )
)

# RSV admissions table
output$rsv_admissions_table <- renderDataTable({
  rsv_admissions %>%
    filter(Season %in% rsv_adm_seasons) %>%
    arrange(desc(Date)) %>%
    select(Season, ISOWeek, Admissions, RatePer100000) %>%
    mutate(Season = factor(Season),
           RatePer100000 = round(RatePer100000, 1),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek,
           `Number of Admissions` = Admissions,
           `Admission Rate per 100k` = RatePer100000) %>%
    make_table(filter_cols = c(1,2))
})

# RSV HB admissions table
output$rsv_admissions_hb_table <- renderDataTable({
  admissions_hb_all_path %>%
    filter(admission_type == "rsv") %>%
    filter(health_board_of_treatment != "Golden Jubilee National Hospital") %>% 
    filter(Season %in% rsv_adm_seasons) %>%
    arrange(desc(week_ending), health_board_of_treatment) %>%
    mutate(health_board_of_treatment = factor(health_board_of_treatment)) %>%
    select('Week ending' = week_ending, 
           'NHS Health Board' = health_board_of_treatment,
           'Number of hospital admissions' = n,
           'Rate of hospital admissions per 100,000 population' = rate) %>%
    make_table(add_separator_cols_1dp = c(4),
               add_separator_cols = c(3),
               filter_cols = c(1,2))
})


# RSV admissions by age table
output$rsv_admissions_age_table <- renderDataTable({
  age_rate_data_all_path %>%
    add_season() %>% 
    select(week_ending, age_band, Season,
           Admissions = rsv, rate = rsv_rate) %>% 
    mutate(Season = paste0(substr(Season, 1, 4), "/", substr(Season, 6, 9)),
           age_band = as.factor(age_band)) %>% 
    filter(Season %in% rsv_adm_seasons) %>% 
    make_admissions_age_table()
  
})

# RSV Adms plot
output$rsv_admissions_plot <- renderPlotly({
  rsv_admissions %>%

    create_pathogen_adms_linechart()

})

# RSV Adms by age plot
output$rsv_admissions_age_plot <- renderPlotly({
  age_rate_data_all_path %>%
    add_season() %>%    
    mutate(Season = paste0(substr(Season, 1, 4), "/", substr(Season, 6, 9))) %>% 
    filter(Season %in% rsv_adm_seasons) %>% 
    #mutate(week_ending = dmy(week_ending)) %>%
    #filter(age_band != "All Ages") %>% 
    select(week_ending, age_band,
           rate = rsv_rate, Season) %>%
    mutate(age_band = factor(age_band, levels = c("<1",  "1-4", "5-14", "15-44", "45-64",
                                                  "65-74", "75+", "All Ages"))) %>% 
    arrange(week_ending, age_band) %>%
    mutate(week = isoweek(week_ending)) %>% 
    filter(Season == input$adm_season_rsv_age) %>%
    #filter(Season == "2024/2025") %>% 
    create_pathogen_adms_age_linechart()
  
})

# observeEvent(input$respiratory_season,
#              {
#                updatePickerInput(session, inputId = "respiratory_date",
#                                  choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
#                                      .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
#                                  selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
#                                      .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
# 
#              }
# )

# RSV Adms by HB plot
output$rsv_admissions_hb_plot <- renderPlotly({
  admissions_hb_all_path %>%
    filter(admission_type == "rsv") %>% 
    filter(health_board_of_treatment != "Golden Jubilee National Hospital") %>% 
    filter(Season %in% input$rsv_adms_selected_seasons) %>%
    select(Season, week, week_ending, health_board_of_treatment, rate) %>%
    arrange(week_ending, health_board_of_treatment) %>%
    create_pathogen_adms_hb_linechart()
  
})

### WEEKLY ADMISSIONS BY SIMD ### ----


### Modal links
observeEvent(input$btn_modal_simd, { showModal(simd_modal) })

# Table
output$rsv_admissions_simd_table <- renderDataTable({
  admissions_simd_Cov_flu_RSV %>% 
    filter(Pathogen == "RSV") %>%
    arrange(desc(WeekEnding)) %>%
    mutate(WeekEnding = convert_opendata_date(WeekEnding),
           SIMD = factor(SIMD),
           ProvisionalFlag = factor(recode(ProvisionalFlag, "1" = "p", "0" = ""))) %>%
    select(WeekEnding, SIMD, NumberOfAdmissions, RateOfAdmissions, ProvisionalFlag) %>%
    dplyr::rename(`Week ending` = WeekEnding,
                  `Number of admissions` = NumberOfAdmissions,
                  `Admission Rate per 100k` = RateOfAdmissions,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols = c(3),
               filter_cols = c(2,5))
})



# Plot
output$rsv_admissions_simd_plot <- renderPlotly({
  admissions_simd_Cov_flu_RSV %>% 
    filter(Pathogen == "RSV") %>%
    mutate(week_ending = ymd(WeekEnding)) %>% 
    add_season() %>%    
    mutate(Season = paste0(substr(Season, 1, 4), "/", substr(Season, 6, 9))) %>% 
    mutate(week = isoweek(week_ending)) %>% 
    filter(Season == input$adm_season_rsv_simd) %>%
    make_hospital_admissions_simd_plot()
  
})

#---------------------##
### RSV adm pyramid ####
#----------------------#
# 
# output$rsv_adm_pyr_title <- renderUI({h3(glue("Acute RSV hospital admissions by age and sex in Scotland; ",
#                                               input$rsv_age_sex_adm_season))})
# 
# 
# # pyramid plot that shows the breakdown by age and sex
# output$rsv_adm_age_sex_pyramid_plot = renderPlotly({
#   Admissions_AgeSex_Season %>%
#     filter(Pathogen == "rsv",
#            Sex %in% c("M", "F"),
#            Season == input$rsv_age_sex_adm_season) %>%
#     make_age_sex_adm_pyramid_plot # hospital_admissions_functions
#   
# })
# 
# 
# output$rsv_adm_age_sex_pyramid_table = renderDataTable({
#   
#   rsv_adm_age_sex_pyramid_table <- Admissions_AgeSex_Season %>%
#     filter(Pathogen  == "rsv",
#            Season == input$rsv_age_sex_adm_season) %>%
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

#--------------------------#
### LENGTH OF STAY ### ----
#-------------------------#

# # los plot reactive title
output$rsv_los_title <- renderUI({h3(glue("RSV length of stay by age group in Season ",
                                          input$los_season_rsv))})

#recent_ISO_week <- isoweek(floor_date(today(), "week", 1) - 8)  #Two Sundays ago - accounting for lag

rsv_los_recent_ISO_week <- rsv_admissions %>%
  arrange(Date) %>%
  tail(2) %>%
  head(1) %>%
  .$ISOWeek

output$rsv_los_text <- renderText({
  if (input$los_season_rsv == tail(admission_seasons, 1)) {
    paste("*The plot for the current season covers the period from ISO week 40 to ISO week ", rsv_los_recent_ISO_week, ".", sep="")
  } } )

# Plot
output$rsv_los_plot <- renderPlotly({
  avg_rsv_los_plot <- Average_Length_of_Stay %>% 
    mutate(AgeGroup = factor(AgeGroup, levels = c("<1", "1 to 4", "5 to 14", "15 to 44", "45 to 64",  
                                                  "65 to 74", "75+", "All Ages"))) %>% 
    filter(Pathogen == "RSV",
           Season == input$los_season_rsv) %>% 
    make_hospital_admissions_los_plot()
  
})

# Table
output$rsv_los_table <- renderDataTable({
  avg_rsv_los_table <- Average_Length_of_Stay %>% 
    filter(Pathogen == "RSV") %>% #,
    #           Season == input$los_season_rsv) %>% 
    mutate(AverageLengthOfStay = round(AverageLengthOfStay,2),
           AgeGroup = factor(AgeGroup, levels = c("<1", "1 to 4", "5 to 14", "15 to 44", "45 to 64",  
                                                  "65 to 74", "75+", "All Ages")),
           Season = as.factor(Season)) %>% 
    arrange(desc(Season), AgeGroup) %>% 
    select(Season, 'Age group' = AgeGroup, 'Average Length of stay' = AverageLengthOfStay) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2))
  
})

# 
# # los plot reactive title
# output$rsv_los_title <- renderUI({h3(glue("RSV length of stay by age group in Season ",
#                                           input$los_season_flu))})
# 
# # Plot
# output$rsv_los_plot<- renderPlotly({
#   rsv_los_weekly_plot<-Length_of_Stay_Season %>%
#     filter(admission_type == "rsv") %>% 
#     filter(Season == input$los_season_rsv) %>%
#     make_hospital_admissions_los_plot() #function in "/...../indicators/hospital_admissions/hospital_admissions_functions.R"
# })
# # Table
# output$rsv_los_table <- renderDataTable({
#   rsv_los_weekly_table<- Length_of_Stay_Weekly %>% 
#     filter(admission_type == "rsv") %>% 
#     filter(Season == input$los_season_rsv) %>%
#     mutate(`Length of stay` = factor(LengthOfStay,
#                                      levels = c("1 day or less",
#                                                 "2-3 days", "4-5 days",
#                                                 "6-7 days", "8+ days"))) %>% 
#     select(Season,
#            'Week ending' = AdmissionWeekEnding, 
#            'Age group' = AgeGroup,
#            'Length of stay',
#            'Percent' = PercentageOfAdmissions) })

