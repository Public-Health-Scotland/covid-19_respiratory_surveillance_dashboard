## Organise coronavirus admissions data into the right format for the plot and table

coron_admissions <- admissions_scotland %>% 
  filter(Pathogen == "Seasonal coronavirus") %>% 
  mutate(ISOweek = as.numeric(ISOweek)) %>% 
  mutate(Weekord = case_when(ISOweek >= 40 ~ ISOweek - 39,
                             ISOweek < 40 ~ ISOweek + 13)) %>% 
  rename(Date = WeekEnding,
         Admissions = NumberAdmissionsPerWeek,
         RatePer100000 = RateAdmissionsPerWeek,
         Year = ISOyear,
         ISOWeek = ISOweek)

coron_adm_seasons <- tail(sort(unique(coron_admissions$Season)), 6)

## Plot descriptions

altTextServer("seasonal_coronavirus_admissions_modal",
              title = "Weekly rate of seasonal coronavirus hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the weekly rate of seasonal coronavirus hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of hospital admissions per 100,000."),
                                tags$li(glue("There is a trace for each of the following seasons from ", 
                                             coron_adm_seasons[1], " to ", coron_adm_seasons[6], ".")),
                                tags$li("Hospital admissions for the most recent week may be incomplete, and should be treated as provisional and interpreted with caution")))


altTextServer("seasonal_coronavirus_admissions_age_modal",
              title = "Seasonal coronavirus hospital admission rate per 100,000 population by age group",
              content = tags$ul(tags$li("This is a plot showing the rate of seasonal coronavirus hospital admission per 100,000 population by age group."),
                                tags$li("The x axis shows the ISO week of admission, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),                                 tags$li("The y axis shows the hospital admission rate per 100,000 population."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: < 1 year, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))


# seasonal_coronavirus admissions table
output$seasonal_coronavirus_admissions_table <- renderDataTable({
  coron_admissions %>%
    filter(Season %in% coron_adm_seasons) %>%
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


# seasonal_coronavirus admissions by age table
output$seasonal_coronavirus_admissions_age_table <- renderDataTable({
  admissions_age %>%
    filter(Pathogen=="Seasonal coronavirus") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup, Season,
           Admissions = NumberAdmissionsPerWeek, rate = RateAdmissionsPerWeek) %>% 
    make_admissions_age_table()
  
})

# seasonal_coronavirus Adms plot

output$seasonal_coronavirus_admissions_plot <- renderPlotly({
  coron_admissions %>%
    
    create_pathogen_adms_linechart()
  
})


# seasonal_coronavirus Adms by age plot
output$seasonal_coronavirus_admissions_age_plot <- renderPlotly({
  admissions_age %>%
    filter(Pathogen=="Seasonal coronavirus") %>% 
    select(week_ending = WeekEnding, age_band = AgeGroup,
           rate = RateAdmissionsPerWeek, Season, week=ISOweek) %>%
    arrange(week_ending, age_band) %>%
    filter(Season == input$adm_season_coron_age) %>%
    create_pathogen_adms_age_linechart
  
})
