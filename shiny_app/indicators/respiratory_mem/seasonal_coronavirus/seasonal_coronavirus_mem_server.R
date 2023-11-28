
metadataButtonServer(id="respiratory_seasonal_coronavirus_mem",
                     panel="Respiratory infection activity",
                     parent = session)

# Low threshold
seasonal_coronavirus_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Coronavirus") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
seasonal_coronavirus_moderate_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Coronavirus") %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
seasonal_coronavirus_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Coronavirus") %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
seasonal_coronavirus_extraordinary_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Coronavirus") %>%
  select(ExtraordinaryThreshold) %>%
  distinct() %>%
  .$ExtraordinaryThreshold %>%
  round_half_up(2)

# # Get seasons used in line chart
# seasons_1 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Pathogen == "Coronavirus") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct() %>%
#   tail(6)
# seasons_2 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Season == "2010/2011") %>%
#   filter(Pathogen == "Coronavirus") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct()
# seasons <- bind_rows(seasons_2, seasons_1)
# seasons <- seasons$Season

# Get seasons used in line chart
seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Coronavirus") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons <- seasons$Season



altTextServer("seasonal_coronavirus_mem_modal",
              title = "Seasonal coronavirus incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of seasonal coronavirus infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of seasonal coronavirus infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", and ",
                                             seasons[6], ".")),
                                tags$li(glue("Activity levels for seasonal coronavirus based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for seasonal coronavirus are: ",
                                             "Baseline (< ", seasonal_coronavirus_low_threshold, "), ",
                                             "Low (", seasonal_coronavirus_low_threshold, "-", seasonal_coronavirus_moderate_threshold-0.01, "), ",
                                             "Moderate (", seasonal_coronavirus_moderate_threshold, "-", seasonal_coronavirus_high_threshold-0.01, "), ",
                                             "High (", seasonal_coronavirus_high_threshold, "-", seasonal_coronavirus_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", seasonal_coronavirus_extraordinary_threshold, ").")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))

altTextServer("seasonal_coronavirus_mem_hb_modal",
              title = "Seasonal coronavirus incidence rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of seasonal coronavirus infection per 100,000 population by NHS Health Board for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations."),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


altTextServer("seasonal_coronavirus_mem_age_modal",
              title = "Seasonal coronavirus incidence rate per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of seasonal coronavirus infection per 100,000 population by age group for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations."),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


# seasonal coronavirus MEM table
output$seasonal_coronavirus_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Coronavirus") %>%
    filter(Season %in% seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2,4))
})

# seasonal coronavirus MEM by HB table
output$seasonal_coronavirus_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Coronavirus") %>%
    filter(Season %in% seasons) %>%
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
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})

# seasonal coronavirus MEM by Age table
output$seasonal_coronavirus_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Coronavirus") %>%
    filter(Season %in% seasons) %>%
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
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})


# seasonal coronavirus MEM plot
output$seasonal_coronavirus_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Coronavirus") %>%
    create_mem_linechart()

})

# seasonal coronavirus MEM by HB plot
output$seasonal_coronavirus_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Coronavirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode")

})


# seasonal coronavirus MEM by Age plot
output$seasonal_coronavirus_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Coronavirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")

})



