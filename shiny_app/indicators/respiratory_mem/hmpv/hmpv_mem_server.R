
# Low threshold
hmpv_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Human Metapneumovirus") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
hmpv_medium_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Human Metapneumovirus") %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
hmpv_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Human Metapneumovirus") %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
hmpv_very_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Human Metapneumovirus") %>%
  select(VeryHighThreshold) %>%
  distinct() %>%
  .$VeryHighThreshold %>%
  round_half_up(2)


# Get seasons used in line chart
hmpv_seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Human Metapneumovirus") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
hmpv_seasons <- hmpv_seasons$Season


altTextServer("hmpv_mem_modal",
              title = "Laboratory-confirmed HMPV incidence per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of laboratory-confirmed HMPV infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of laboratory-confirmed HMPV infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", hmpv_seasons[1], ", ",
                                             hmpv_seasons[2], ", ", hmpv_seasons[3], ", ", hmpv_seasons[4], 
                                             ", ", hmpv_seasons[5],", and ", hmpv_seasons[6], ".")),
                                tags$li(glue("Activity levels for HMPV based on MEM thresholds are represented by different coloured panels on the plot. ",
                                        "The activity levels and MEM thresholds for HMPV are: ",
                                        "Baseline (< ", hmpv_low_threshold, "), ",
                                        "Low (", hmpv_low_threshold, "-", hmpv_medium_threshold-0.01, "), ",
                                        "Medium (", hmpv_medium_threshold, "-", hmpv_high_threshold-0.01, "), ",
                                        "High (", hmpv_high_threshold, "-", hmpv_very_high_threshold-0.01, "), and ",
                                        "Very High (>= ", hmpv_very_high_threshold, ").")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))

altTextServer("hmpv_mem_hb_modal",
              title = "Laboratory-confirmed HMPV incidence per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed HMPV infection per 100,000 population by NHS Health Board for seasons ",
                                             hmpv_seasons[5], " and ", hmpv_seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Medium, High, or Very High."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The incidence rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations."),
                                tags$li("MEM thresholds for each NHS Health Board are available in the metadata of the",
                                        tags$a("accompanying report.",
                                               href="https://www.publichealthscotland.scot/publications/show-all-releases?id=102486")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


altTextServer("hmpv_mem_age_modal",
              title = "Laboratory-confirmed HMPV incidence per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed HMPV infection per 100,000 population by age group for seasons ",
                                             hmpv_seasons[5], " and ", hmpv_seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Medium, High, or Very High."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The incidence rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations."),
                                tags$li("MEM thresholds for each age group are available in the metadata of the",
                                        tags$a("accompanying report.",
                                               href="https://www.publichealthscotland.scot/publications/show-all-releases?id=102486")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


# Influenza MEM table
output$hmpv_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    filter(Season %in% hmpv_seasons) %>%
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

# Influenza MEM by HB table
output$hmpv_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    filter(Season %in% hmpv_seasons) %>%
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

# Influenza MEM by Age table
output$hmpv_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    filter(Season %in% hmpv_seasons) %>%
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


# Influenza MEM plot
output$hmpv_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    create_mem_linechart()

})

# Influenza MEM by HB plot
output$hmpv_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode")

})


# Influenza MEM by Age plot
output$hmpv_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Human Metapneumovirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")

})



