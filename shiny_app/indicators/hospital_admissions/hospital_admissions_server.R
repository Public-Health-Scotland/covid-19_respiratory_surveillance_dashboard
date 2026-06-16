
###########################
### HOSPITAL ADMISSIONS ### ----
###########################
#admissions labels- (matches Respiratory_admissions_summary data set)
latest_week_admissions_title <- admissions_scotland %>%
  tail(1) %>%
  select(WeekEnding)

# # Convert to the correct format
latest_week_admissions_title$WeekEnding<- format(latest_week_admissions_title$WeekEnding, "%d %b %y")
 
# # make it a value
latest_week_admissions_title <- latest_week_admissions_title$WeekEnding
 
previous_week_admissions_title <- admissions_scotland %>%
  filter(Pathogen=='RSV') %>%
  tail(2) %>%
  filter(WeekEnding== min(WeekEnding)) %>%
  select(WeekEnding)
 
# # Convert to correct format
previous_week_admissions_title$WeekEnding <- format(previous_week_admissions_title$WeekEnding, "%d %b %y")
 
# # make it a value
previous_week_admissions_title <- previous_week_admissions_title$WeekEnding
 
previous_2week_admissions_title <- admissions_scotland %>%
  filter(Pathogen=='RSV') %>%
  tail(3) %>%
  filter(WeekEnding== min(WeekEnding)) %>%
  select(WeekEnding)
 
# # Convert to correct format
previous_2week_admissions_title$WeekEnding <- format(previous_2week_admissions_title$WeekEnding, "%d %b %y")
 
# # make it a value
previous_2week_admissions_title <- previous_2week_admissions_title$WeekEnding

observeEvent(input$glossary,
             {
               updateTabsetPanel(session = session, "intabset", selected = "metadata")
               updateCollapse(session = session, "notes_collapse", open = "Glossary")

             })



# Hospital admissions ----



## Create plot descriptions

altTextServer("hospital_admissions_modal",
              title = "Weekly rate of COVID-19 hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the weekly rate of COVID-19 hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of hospital admissions per 100,000."),
                                tags$li(glue("There is a trace for each of the following seasons from ", 
                                             cov_adm_seasons[1], " to ", cov_adm_seasons[3], ".")),
                                tags$li("Hospital admissions for the most recent week may be incomplete, and should be treated as provisional and interpreted with caution")
              )
)

altTextServer("hospital_admissions_age_modal",
              title = "COVID-19 hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of COVID-19 hospital admission per 100,000 population by age group."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("hospital_admissions_hb_modal",
              title = "COVID-19 hospital admission rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li("This is a plot showing the rate of COVID-19 hospital admission per 100,000 population by NHS Health Board."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39."),
                                tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("The plot contains a trace showing the admission rate per 100,000 population for each of the NHS Scotland Health Boards."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))



altTextServer("hospital_admissions_simd_modal",
              title = "COVID-19 hospital admission rate per 100,000 population by deprivation category (SIMD)",
              content = tags$ul(tags$li("This is a plot showing the rate of COVID-19 hospital admission per 100,000 population by SIMD deprivation category
                                        for the selected season."),
                                tags$li("SIMD is a relative measure of deprivation across small areas in Scotland.",
                                        "There are equal numbers of data zones in each of the five categories.",
                                        "SIMD 1 contains the 20% most deprived zones and SIMD 5 contains the 20%",
                                        "least deprived zones. See the",
                                        tags$a("Scottish government website (external link)",
                                               href="https://www.gov.scot/collections/scottish-index-of-multiple-deprivation-2020/"),
                                        "for more information."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                
                                tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("The plot contains a trace for each of the SIMD categories. SIMD 1 is",
                                        "highlighted in red and SIMD 5 in blue. The other categories are in grey.")
              )
)

altTextServer("cov_los_modal",
              title = "Average length of stay of acute COVID-19 hospital admissions",
              content = tags$ul(
                tags$li("This is a plot of the average length of stay in hospital",
                        "for acute COVID-19 hospital admissions for individuals within different age groups for a given respiratory season."),
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



### WEEKLY ADMISSIONS-Scotland ### ----


# COVID admissions table
output$hospital_admissions_table <- renderDataTable({
  cov_admissions %>%
    filter(Season %in% cov_adm_seasons) %>%
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


# Covid Adms plot
output$hospital_admissions_plot <- renderPlotly({
  cov_admissions %>%
    
    create_pathogen_adms_linechart()
  
})



#### WEEKLY ADMISSIONS BY AGE

# COVID-19 admissions by age table
output$covid_admissions_age_table <- renderDataTable({
  admissions_age %>%
    filter(Pathogen=="COVID-19") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup, Season,
           Admissions = NumberAdmissionsPerWeek, rate = RateAdmissionsPerWeek) %>% 
    mutate(age_band = factor(age_band, levels = c("<1", "1-4", "5-14",
                                                  "15-44", "45-64", "65-74",  "75+", "Total"),
                             labels = c("<1", "1 to 4", "5 to 14",
                                        "15 to 44", "45 to 64", "65 to 74",  "75+", "All ages"))) %>% 
    make_admissions_age_table()
  
})



output$covid_admissions_age_plot <- renderPlotly({
  admissions_age %>%
    filter(Pathogen=="COVID-19") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup,
           rate = RateAdmissionsPerWeek, Season, week=ISOweek) %>%
    mutate(age_band = factor(age_band, levels = c("<1",  "1-4", "5-14", "15-44", "45-64",
                                                  "65-74", "75+", "Total"))) %>% 
    arrange(week_ending, age_band) %>%
    filter(Season == input$adm_season_cov_age) %>%
    #filter(Season == "2024/25") %>% 
    create_pathogen_adms_age_linechart()
  
})

#### WEEKLY ADMISSIONS BY HEALTH BOARD

# COVID-19 HB admissions table
output$hospital_admissions_hb_table <- renderDataTable({
  admissions_hb_new %>%
    filter(Pathogen == "COVID-19") %>%
    filter(HBName != "Golden Jubilee National Hospital") %>% 
    #filter(Season >= "2023/2024") %>%
    arrange(desc(WeekEnding), HBName) %>%
    mutate(HBName = factor(HBName)) %>%
    select('Week ending' = WeekEnding, 
           'NHS Health Board' = HBName,
           'Number of hospital admissions' = NumberAdmissionsPerWeek,
           'Rate of hospital admissions per 100,000 population' = RateAdmissionsPerWeek) %>%
    make_table(add_separator_cols_1dp = c(4),
               add_separator_cols = c(3),
               filter_cols = c(1,2))
})

# COVID-19 Adms by HB plot
output$hospital_admissions_hb_plot <- renderPlotly({
  admissions_hb_new %>%
    filter(Pathogen == "COVID-19") %>% 
    filter(HBName != "Golden Jubilee National Hospital") %>% 
    filter(Season %in% input$hospital_adms_selected_seasons) %>%
    select(ISOweek, WeekEnding, HBName, RateAdmissionsPerWeek) %>%
    arrange(WeekEnding, HBName) %>%
    create_pathogen_adms_hb_linechart()
  
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
  admissions_simd_new %>% 
    filter(Pathogen == "COVID-19") %>%
    arrange(desc(WeekEnding)) %>%
    mutate(SIMD = factor(SIMD)) %>% 
    mutate(ProvisionalFlag = case_when(WeekEnding == max(WeekEnding) ~ "p",
                                       T ~ "")) %>%
    select(WeekEnding, SIMD, NumberAdmissionsPerWeek, RateAdmissionsPerWeek, ProvisionalFlag) %>%
    dplyr::rename(`Week ending` = WeekEnding,
                  `Number of admissions` = NumberAdmissionsPerWeek,
                  `Admission Rate per 100k` = RateAdmissionsPerWeek,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols = c(3),
               filter_cols = c(2,5))
})



# Plot
output$hospital_admissions_simd_plot <- renderPlotly({
  admissions_simd_new %>% 
    filter(Pathogen == "COVID-19") %>%
    rename(week_ending = WeekEnding,
           week = ISOweek) %>% 
    filter(Season == input$adm_season_cov_simd) %>%
    make_hospital_admissions_simd_plot()
  
})


### LENGTH OF STAY ### ----

# los plot reactive title
output$cov_los_title <- renderUI({h3(glue("COVID-19 length of stay by age group in Season ",
                                                        input$los_season_cov))})

cov_los_recent_ISO_week <- cov_admissions %>%
  arrange(Date) %>%
  tail(2) %>%
  head(1) %>%
  .$ISOWeek

output$cov_los_text <- renderText({
  if (input$los_season_cov == tail(admission_seasons, 1)) {
    paste("*The plot for the current season covers the period from ISO week 40 to ISO week ",cov_los_recent_ISO_week, ".", sep="")
  } } )

# Plot
output$cov_los_plot <- renderPlotly({
  avg_cov_los_plot <- Average_Length_of_Stay %>% 
    mutate(AgeGroup = factor(AgeGroup, levels = c("<1", "1 to 4", "5 to 14", "15 to 44", "45 to 64",  
                                                             "65 to 74", "75+", "All Ages"))) %>% 
    filter(Pathogen == "COVID-19",
           Season == input$los_season_cov) %>% 
    make_hospital_admissions_los_plot()

})

# Table
output$cov_los_table <- renderDataTable({
  avg_cov_los_table <- Average_Length_of_Stay %>% 
    filter(Pathogen == "COVID-19") %>% 
    mutate(AverageLengthOfStay = round(AverageLengthOfStay,2),
           AgeGroup = factor(AgeGroup, levels = c("<1", "1 to 4", "5 to 14", "15 to 44", "45 to 64",  
           "65 to 74", "75+", "All Ages")),
           Season = as.factor(Season)) %>% 
    arrange(desc(Season), AgeGroup) %>% 
    select(Season, 'Age group' = AgeGroup, 'Average Length of stay' = AverageLengthOfStay) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols_1dp = c(3))

})

