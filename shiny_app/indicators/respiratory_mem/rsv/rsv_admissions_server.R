metadataButtonServer(id="respiratory_rsv_admissions",
                     panel="Respiratory infection activity",
                     parent = session)

# Get recent seasons
rsv_adm_seasons <- tail(sort(unique(RSV_admissions$Season)), 6)


altTextServer("rsv_admissions_modal",
              title = "RSV hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the number of RSV hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the number of hospital admissions."),
                                tags$li(glue("There is a trace for each of the following season from ", 
                                             rsv_adm_seasons[1], " to ", rsv_adm_seasons[6], "."))))

altTextServer("rsv_admissions_age_modal",
              title = "RSV hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by age group."),
                                tags$li("The x axis is the week ending date."),
                                tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("The plot contains a trace showing the admission rate per 100k for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))




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
              title = "Length of stay of acute RSV hospital admissions",
              content = tags$ul(
                tags$li("This is a plot of the median lengths of stay in hospital",
                        "for acute RSV hospital admissions by respiratory season, broken down by age group."),
                tags$li("There is a drop down above the chart which allows you to select",
                        "the respiratory season for plotting. The default is the current season."),
                tags$li("There are seven distinct categories for age group that can be selected: <1, 1 to 4, 5 to 14,",
                        "15 to 44, 45 to 64, 65 to 74 and 75+ years. As a default, the overall median for all age groups is shown."),
                tags$li("The 4-week rolling median is calculated using the length of stay for all individuals in a given age group 
                        over the four-week period leading up to the given ISO week."),
                tags$li("The x axis shows the ISO week that the 4-week rolling median relates to."),
                tags$li("The y axis is the median length of stay in days.") ))


# RSV admissions table
output$rsv_admissions_table <- renderDataTable({
  RSV_admissions %>%
    filter(Season %in% flu_adm_seasons) %>%
    arrange(desc(Date)) %>%
    select(Season, ISOWeek, Admissions) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek) %>%
    make_table(filter_cols = c(1,2))
})


# RSV admissions by age table
output$rsv_admissions_age_table <- renderDataTable({
  age_rate_data_all_path %>%
    select(week_ending, age_band,
           rate = rsv_rate) %>% 
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

# RSV Adms plot
output$rsv_admissions_plot <- renderPlotly({
  RSV_admissions %>%

    create_pathogen_adms_linechart()

})

# RSV Adms by age plot
output$rsv_admissions_age_plot <- renderPlotly({
  age_rate_data_all_path %>%
    #mutate(week_ending = dmy(week_ending)) %>%
    filter(age_band != "All Ages") %>% 
    select(week_ending, age_band,
           rate = rsv_rate) %>%
    mutate(age_band = factor(age_band, levels = c("<1",  "1-4", "5-14", "15-44", "45-64",
                                                  "65-74", "75+"))) %>% 
    arrange(week_ending, age_band) %>%
    create_pathogen_adms_age_linechart()
  
})

observeEvent(input$respiratory_season,
             {
               updatePickerInput(session, inputId = "respiratory_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)


# HB Table
output$rsv_admissions_hb_table <- renderDataTable({
  RSV_Admissions_HB_3wks %>%
   # filter(WeekEnding %in% adm_hb_dates) %>%
    mutate(WeekEnding = format(WeekEnding, format = "%d %b %y")) %>%
    select(WeekEnding, HealthBoardOfTreatment,TotalInfections) %>% 
    pivot_wider(names_from = WeekEnding,
                values_from = TotalInfections) %>%
    mutate(HealthBoardOfTreatment = factor(HealthBoardOfTreatment,
                                           levels = c("NHS Ayrshire and Arran", "NHS Borders", "NHS Dumfries and Galloway", "NHS Fife", "NHS Forth Valley", "NHS Grampian",
                                                      "NHS Greater Glasgow and Clyde", "NHS Highland", "NHS Lanarkshire", "NHS Lothian", "NHS Orkney", "NHS Shetland",
                                                      "NHS Tayside", "NHS Western Isles","Golden Jubilee National Hospital", "Scotland"))) %>%
    arrange(HealthBoardOfTreatment) %>%
    dplyr::rename(`Health Board of treatment` = HealthBoardOfTreatment) %>%
    make_summary_table(maxrows = 16)
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
# 
# # los plot reactive title
output$rsv_los_title <- renderUI({h3(glue("RSV length of stay by age group in Season ",
                                          input$los_season_rsv))})

# Plot
output$rsv_los_plot<- renderPlotly({
  rsv_los_weekly_plot <- Median_LOS_by_Age %>%
    filter(pathogen == "RSV") %>% 
    filter(Season == input$los_season_rsv) %>%
    filter(los_age_band %in% input$los_rsv_age) %>%
    make_hospital_admissions_los_plot()
  
})

output$rsv_los_table <- renderDataTable({
  flu_los_weekly_table <- Median_LOS_by_Age %>% 
    filter(pathogen == "RSV") %>% 
    select(Season, week_ending, week, los_age_band, median_los) %>% 
    mutate(los_age_band = factor(los_age_band, levels = c("<1", "1 to 4", "5 to 14",
                                                          "15 to 44", "45 to 64", "65 to 74",  "75+", "All ages"))) %>% 
    arrange(desc(week_ending), los_age_band) %>% 
    filter(Season == input$los_season_rsv) %>%
    filter(los_age_band %in% input$los_rsv_age) %>%
    rename(`Median Length of Stay (4-week)` = median_los,
           `Age Group` = los_age_band,
           `ISO Week` = week,
           `Week Ending` = week_ending)
})
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

