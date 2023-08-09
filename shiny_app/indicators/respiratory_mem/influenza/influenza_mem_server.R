
metadataButtonServer(id="respiratory_influenza_mem",
                     panel="Respiratory infection activity",
                     parent = session)

# Low threshold
influenza_low_threshold <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>% 
  select(LowThreshold) %>% 
  distinct() %>% 
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
influenza_moderate_threshold <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>% 
  select(MediumThreshold) %>% 
  distinct() %>% 
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
influenza_high_threshold <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>% 
  select(HighThreshold) %>% 
  distinct() %>% 
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
influenza_extraordinary_threshold <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>% 
  select(ExtraordinaryThreshold) %>% 
  distinct() %>% 
  .$ExtraordinaryThreshold %>%
  round_half_up(2)

# Get seasons used in line chart
seasons_1 <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons_2 <- Respiratory_Pathogens_MEM_Scot %>% 
  filter(Pathogen == "Influenza") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(13) %>%
  head(1)
seasons <- bind_rows(seasons_2, seasons_1)
seasons <- seasons$Season


altTextServer("influenza_mem_modal",
              title = "Influenza incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of influenza infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the rate of influenza infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", ",
                                             seasons[6], ", and ", seasons[7], ".")),
                                tags$li(glue("Activity levels for influenza based on MEM thresholds are represented by different coloured panels on the plot. ",
                                        "The activity levels and MEM thresholds for influenza are: ",
                                        "Baseline (< ", influenza_low_threshold, "), ",
                                        "Low (", influenza_low_threshold, "-", influenza_moderate_threshold, "), ",
                                        "Moderate (", influenza_moderate_threshold, "-", influenza_high_threshold, "), ",
                                        "High (", influenza_high_threshold, "-", influenza_extraordinary_threshold, "), and ",
                                        "Extraordinary (> ", influenza_extraordinary_threshold, ")."))))

altTextServer("influenza_mem_hb_modal",
              title = "Influenza incidence rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of influenza infection per 100,000 population by NHS Health Board for seasons ",
                                             seasons[6], " and ", seasons[7], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations.")))
                                

altTextServer("influenza_mem_age_modal",
              title = "Influenza incidence rate per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of influenza infection per 100,000 population by age group for seasons ",
                                             seasons[6], " and ", seasons[7], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ", 
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations.")))


# Influenza MEM table
output$influenza_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_2dp = c(3),
               filter_cols = c(1,2,4))
})

# Influenza MEM by HB table
output$influenza_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, HBName, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           HBName = factor(HBName),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `NHS Health Board`= HBName,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_2dp = c(4),
               filter_cols = c(1,2,3,5))
})

# Influenza MEM by Age table
output$influenza_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           AgeGroup = factor(AgeGroup, levels = mem_age_groups_full),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Age Group`= AgeGroup,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_2dp = c(4),
               filter_cols = c(1,2,3,5))
})


# Influenza MEM plot
output$influenza_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    create_mem_linechart()
  
})

# Influenza MEM by HB plot
output$influenza_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode")
  
})


# Influenza MEM by Age plot
output$influenza_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")
  
})



