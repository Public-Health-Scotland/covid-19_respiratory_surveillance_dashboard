metadataButtonServer(id="mortality_euromomo",
                     panel="All-Cause Excess Mortality (Euromomo)",
                     parent = session)

# Low threshold
euromomo_low_threshold <- Respiratory_Euromomo %>% 
  select(LowThreshold) %>% 
  distinct() %>% 
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
euromomo_moderate_threshold <- Respiratory_Euromomo %>% 
  select(MediumThreshold) %>% 
  distinct() %>% 
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
euromomo_high_threshold <- Respiratory_Euromomo %>% 
  select(HighThreshold) %>% 
  distinct() %>% 
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
euromomo_extraordinary_threshold <- Respiratory_Euromomo %>% 
  select(ExtraordinaryThreshold) %>% 
  distinct() %>% 
  .$ExtraordinaryThreshold %>%
  round_half_up(2)


# Latest reporting week
latest_week <- Respiratory_Euromomo %>%
  tail(1) %>%
  .$ISOWeek %>%
  as.character()

# Get seasons used in line chart
if(latest_week %in% c("40","41","42")){
  
  euromomo_seasons <- Respiratory_Euromomo %>%
    select(Season) %>%
    arrange(Season) %>%
    distinct() %>%
    tail(5)
  euromomo_seasons <- euromomo_seasons$Season
} else{
  euromomo_seasons <- Respiratory_Euromomo %>%
    select(Season) %>%
    arrange(Season) %>%
    distinct() %>%
    tail(4)
  euromomo_seasons <- euromomo_seasons$Season
}


altTextServer("euromomo_mem_modal",
              title = "All-cause excess mortality (Euromomo)",
              content = tags$ul(tags$li(glue("This is a plot showing the weekly excess all-cause mortality for season ",
                                             euromomo_seasons[4], " compared to the last 3 seasons, ", euromomo_seasons[1], ", ",
                                             euromomo_seasons[2], ", and ", euromomo_seasons[3], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the z-score."),
                                tags$li(glue("Activity levels for all-cause excess mortality based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for all-cause excess mortality are: ",
                                             "Baseline (< ", euromomo_low_threshold, "), ",
                                             "Low (", euromomo_low_threshold, "-", euromomo_moderate_threshold-0.01, "), ",
                                             "Moderate (", euromomo_moderate_threshold, "-", euromomo_high_threshold-0.01, "), ",
                                             "High (", euromomo_high_threshold, "-", euromomo_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", euromomo_extraordinary_threshold, ").")),
                                tags$li(glue("Data for the most recent weeks are incomplete and should be treated with caution."))))

altTextServer("euromomo_mem_age_modal",
              title = "All-cause excess mortality (Euromomo) by age",
              content = tags$ul(tags$li(glue("This is a plot showing the weekly excess all-cause mortality by age group for season ",
                                             euromomo_seasons[length(euromomo_seasons)], " compared to the previous season, ", euromomo_seasons[length(euromomo_seasons)-1], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li(glue("Data for the most recent weeks are incomplete and should be treated with caution."))))


# Euromomo MEM table
output$euromomo_mem_table <- renderDataTable({
  Respiratory_Euromomo %>%
    filter(AgeGroup == "All Ages") %>%
    filter(Season %in% euromomo_seasons) %>%
    mutate(ReportingDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                                "Yes", "")) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, ZScore, ActivityLevel, ReportingDelay) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Z-score` = ZScore,
           `Activity Level` = ActivityLevel,
           `Reporting delay?` = ReportingDelay) %>%
    make_table(add_separator_cols_2dp = c(3),
               filter_cols = c(1,2,4,5))
})

# Euromomo age MEM table
output$euromomo_mem_age_table <- renderDataTable({
  Respiratory_Euromomo %>%
    filter(Season %in% euromomo_seasons[(length(euromomo_seasons)-1):length(euromomo_seasons)]) %>%
    mutate(ReportingDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                                "Yes", "")) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, ZScore, ActivityLevel, ReportingDelay) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           AgeGroup = factor(AgeGroup, levels = euromomo_mem_age_groups_full),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Z-score` = ZScore,
           `Age group` = AgeGroup,
           `Activity Level` = ActivityLevel,
           `Reporting delay?` = ReportingDelay) %>%
    make_table(add_separator_cols_2dp = c(4),
               filter_cols = c(1,2,3,5,6))
})


# Euromomo MEM plot
output$euromomo_mem_plot <- renderPlotly({
  Respiratory_Euromomo %>%
    filter(AgeGroup == "All Ages") %>%
    create_euromomo_mem_linechart()
  
})

# Euromomo age MEM plot
output$euromomo_mem_age_plot <- renderPlotly({
  Respiratory_Euromomo %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels),
           ActivityLevelDelay = factor(ActivityLevelDelay, levels = c(activity_levels,
                                                                      "Reporting delay"))) %>%
    create_euromomo_mem_heatmap(breakdown_variable = "AgeGroup",
                       value_variable = "ZScore")
  
})


observeEvent(input$jump_to_metadata_page, {updateTabsetPanel(session, "intabset", selected = "metadata")})

