
metadataButtonServer(id="mortality_euromomo",
                     panel="Euromomo (all-cause mortality)",
                     parent = session)

metadataButtonServer(id="respiratory_influenza_mem",
                     panel="Respiratory infection activity",
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

# Get seasons used in line chart
seasons <- Respiratory_Euromomo %>% 
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(4)
seasons <- seasons$Season


altTextServer("euromomo_mem_modal",
              title = "All-cause excess mortality (Euromomo)",
              content = tags$ul(tags$li(glue("This is a plot showing the weekly excess all-cause mortality for season ",
                                             seasons[4], " compared to the last 3 seasons, ", seasons[1], ", ",
                                             seasons[2], ", and ", seasons[3], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the z-score."),
                                tags$li(glue("Activity levels for all-cause excess mortality based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for all-cause excess mortality are: ",
                                             "Baseline (< ", euromomo_low_threshold, "), ",
                                             "Low (", euromomo_low_threshold, "-", euromomo_moderate_threshold-0.01, "), ",
                                             "Moderate (", euromomo_moderate_threshold, "-", euromomo_high_threshold-0.01, "), ",
                                             "High (", euromomo_high_threshold, "-", euromomo_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", euromomo_extraordinary_threshold, ")."))))

altTextServer("euromomo_mem_age_modal",
              title = "All-cause excess mortality (Euromomo) by age",
              content = tags$ul(tags$li(glue("This is a plot showing the weekly excess all-cause mortality by age group for season ",
                                             seasons[4], " compared to the previous season, ", seasons[3], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the z-score."),
                                tags$li(glue("Activity levels for all-cause excess mortality based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for all-cause excess mortality are: ",
                                             "Baseline (< ", euromomo_low_threshold, "), ",
                                             "Low (", euromomo_low_threshold, "-", euromomo_moderate_threshold-0.01, "), ",
                                             "Moderate (", euromomo_moderate_threshold, "-", euromomo_high_threshold-0.01, "), ",
                                             "High (", euromomo_high_threshold, "-", euromomo_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", euromomo_extraordinary_threshold, ")."))))


# altTextServer("influenza_mem_age_modal",
#               title = "Influenza incidence rate per 100,000 population by age group",
#               content = tags$ul(tags$li(glue("This is a plot showing the rate of influenza infection per 100,000 population by age group for seasons ",
#                                              seasons[6], " and ", seasons[7], ".")),
#                                 tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
#                                         "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
#                                 tags$li("The y axis shows the age group."),
#                                 tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
#                                 tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
#                                         "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
#                                         "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
#                                         "with larger populations.")))


# Influenza MEM table
output$euromomo_mem_table <- renderDataTable({
  Respiratory_Euromomo %>%
    filter(AgeGroup == "All Ages") %>%
    filter(Season %in% seasons) %>%
    mutate(Provisional = ifelse(ActivityLevelDelay == "Reporting delay",
                                "p", "")) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, ZScore, ActivityLevel, Provisional) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Z-score` = ZScore,
           `Activity Level` = ActivityLevel,
           `Is data provisional (p)?` = Provisional) %>%
    make_table(add_separator_cols_2dp = c(3),
               filter_cols = c(1,2,4,5))
})

# Influenza MEM table
output$euromomo_mem_age_table <- renderDataTable({
  Respiratory_Euromomo %>%
    filter(Season %in% seasons[3:4]) %>%
    mutate(Provisional = ifelse(ActivityLevelDelay == "Reporting delay",
                                "p", "")) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, ZScore, ActivityLevel, Provisional) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Z-score` = ZScore,
           `Activity Level` = ActivityLevel,
           `Is data provisional (p)?` = Provisional) %>%
    make_table(add_separator_cols_2dp = c(4),
               filter_cols = c(1,2,3,5,6))
})



# # Influenza MEM by Age table
# output$influenza_mem_age_table <- renderDataTable({
#   Respiratory_Pathogens_MEM_Age %>%
#     filter(Pathogen == "Influenza") %>%
#     arrange(desc(WeekEnding)) %>%
#     select(Season, ISOWeek, AgeGroup, RatePer100000, ActivityLevel) %>%
#     mutate(Season = factor(Season),
#            ISOWeek = factor(ISOWeek),
#            AgeGroup = factor(AgeGroup, levels = mem_age_groups_full),
#            ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
#     rename(`ISO Week` = ISOWeek,
#            `Age Group`= AgeGroup,
#            `Rate per 100,000` = RatePer100000,
#            `Activity Level` = ActivityLevel) %>%
#     make_table(add_separator_cols_2dp = c(4),
#                filter_cols = c(1,2,3,5))
# })


# Influenza MEM plot
output$euromomo_mem_plot <- renderPlotly({
  Respiratory_Euromomo %>%
    filter(AgeGroup == "All Ages") %>%
    create_euromomo_mem_linechart()
  
})

# Influenza MEM plot
output$euromomo_mem_age_plot <- renderPlotly({
  Respiratory_Euromomo %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels),
           ActivityLevelDelay = factor(ActivityLevelDelay, levels = c(activity_levels,
                                                                      "Reporting delay"))) %>%
    create_euromomo_mem_heatmap(breakdown_variable = "AgeGroup",
                       value_variable = "ZScore")
  
})




# # Influenza MEM by Age plot
# output$influenza_mem_age_plot <- renderPlotly({
#   Respiratory_Pathogens_MEM_Age %>%
#     filter(Pathogen == "Influenza") %>%
#     mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
#     create_mem_heatmap(breakdown_variable = "AgeGroup")
#   
# })



