
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


altTextServer("rsv_admissions_age_modal",
              title = "RSV hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by age group."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                 tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: < 1 year, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("rsv_admissions_hb_modal",
              title = "RSV hospital admission rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li("This is a plot showing the rate of RSV hospital admission per 100,000 population by NHS Health Board."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. "),
                                tags$li("The y axis shows the hospital admission rate per 100,000 population.")
              ))


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
                tags$li("The x axis shows a break down of admissions by age groups: <1 year, 1-4 years, 5-14 years, 
                        15-44 years, 45-64 years, 65-74 years, and 75+ years and finally for all ages combined."),
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
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2))
})

# RSV HB admissions table
output$rsv_admissions_hb_table <- renderDataTable({
  admissions_hb_new %>%
    filter(Pathogen == "RSV") %>%
    filter(HBName != "Golden Jubilee National Hospital") %>% 
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


# RSV admissions by age table
output$rsv_admissions_age_table <- renderDataTable({
  admissions_age %>%
    filter(Pathogen=="RSV") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup, Season,
           Admissions = NumberAdmissionsPerWeek, rate = RateAdmissionsPerWeek) %>% 
    make_admissions_age_table()
  
})

# RSV Adms plot
output$rsv_admissions_plot <- renderPlotly({
  rsv_admissions %>%
    create_pathogen_adms_linechart()

})

# RSV Adms by age plot
output$rsv_admissions_age_plot <- renderPlotly({
  admissions_age %>%
    filter(Pathogen=="RSV") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup,
           rate = RateAdmissionsPerWeek, Season, week=ISOweek) %>%
    arrange(week_ending, age_band) %>%
    filter(Season == input$adm_season_rsv_age) %>%
    create_pathogen_adms_age_linechart()
  
})



# RSV Adms by HB plot
output$rsv_admissions_hb_plot <- renderPlotly({
  admissions_hb_new %>%
    filter(Pathogen == "RSV") %>% 
    filter(HBName != "Golden Jubilee National Hospital") %>% 
    filter(Season %in% input$rsv_adms_selected_seasons) %>%
    select(ISOweek, WeekEnding, HBName, RateAdmissionsPerWeek) %>%
    arrange(WeekEnding, HBName) %>%
    create_pathogen_adms_hb_linechart()
  
})

### WEEKLY ADMISSIONS BY SIMD ### ----


### Modal links
observeEvent(input$btn_modal_simd, { showModal(simd_modal) })

# Table
output$rsv_admissions_simd_table <- renderDataTable({
  admissions_simd_new %>% 
    filter(Pathogen == "RSV") %>%
    arrange(desc(WeekEnding)) %>%
    mutate(SIMD = factor(SIMD)) %>% 
    mutate(ProvisionalFlag = case_when(WeekEnding == max(WeekEnding) ~ "p",
                                       T ~ "")) %>%
    select(WeekEnding, SIMD, NumberAdmissionsPerWeek, RateAdmissionsPerWeek, ProvisionalFlag) %>%
    dplyr::rename(`Week ending` = WeekEnding,
                  `Number of admissions` = NumberAdmissionsPerWeek,
                  `Admission Rate per 100k` = RateAdmissionsPerWeek,
                  `Is data provisional (p)?` = ProvisionalFlag) %>%
    make_table(add_separator_cols_1dp = c(4),
               add_separator_cols = c(3),
               filter_cols = c(2,5))
})



# Plot
output$rsv_admissions_simd_plot <- renderPlotly({
  admissions_simd_new %>% 
    filter(Pathogen == "RSV") %>%
    rename(week_ending = WeekEnding,
           week = ISOweek) %>% 
    filter(Season == input$adm_season_rsv_simd) %>%
    make_hospital_admissions_simd_plot()
  
})


#--------------------------#
### LENGTH OF STAY ### ----
#-------------------------#

# # los plot reactive title
output$rsv_los_title <- renderUI({h3(glue("RSV length of stay by age group in Season ",
                                          input$los_season_rsv))})

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
                                                  "65 to 74", "75+", "All Ages"),
                             labels=mem_age_groups_full)) %>% 
    filter(Pathogen == "RSV",
           Season == input$los_season_rsv) %>% 
    make_hospital_admissions_los_plot()
  
})

# Table
output$rsv_los_table <- renderDataTable({
  avg_rsv_los_table <- Average_Length_of_Stay %>% 
    filter(Pathogen == "RSV") %>% #,
    mutate(AverageLengthOfStay = round(AverageLengthOfStay,2),
           AgeGroup = factor(AgeGroup, levels = c("<1", "1 to 4", "5 to 14", "15 to 44", "45 to 64",  
                                                  "65 to 74", "75+", "All Ages"),
                             labels=mem_age_groups_full),
           Season = as.factor(Season)) %>% 
    arrange(desc(Season), AgeGroup) %>% 
    select(Season, 'Age group' = AgeGroup, 'Average Length of stay' = AverageLengthOfStay) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2))
  
})


