metadataButtonServer(id="nhs24_mem",
                     panel="Syndromic Surveillance",
                     parent = session)

# Low threshold
nhs24_low_threshold <- Respiratory_NHS24_MEM_Scot %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
nhs24_moderate_threshold <- Respiratory_NHS24_MEM_Scot %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
nhs24_high_threshold <- Respiratory_NHS24_MEM_Scot %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
nhs24_extraordinary_threshold <- Respiratory_NHS24_MEM_Scot %>%
  select(ExtraordinaryThreshold) %>%
  distinct() %>%
  .$ExtraordinaryThreshold %>%
  round_half_up(2)

# Get seasons used in line chart
seasons_1 <- Respiratory_NHS24_MEM_Scot %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons_2 <- Respiratory_NHS24_MEM_Scot %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(13) %>%
  head(1)
seasons <- bind_rows(seasons_2, seasons_1)
seasons <- seasons$Season


altTextServer("nhs24_mem_modal",
              title = "Percentage of NHS24 calls for respiratory symptoms",
              content = tags$ul(tags$li("This is a plot showing the percentage of NHS24 calls for respiratory symptoms in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the percentage of NHS24 calls for respiratory symptoms."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", ",
                                             seasons[6], ", and ", seasons[7], ".")),
                                tags$li(glue("Activity levels for NHS24 calls based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for NHS24 calls are: ",
                                             "Baseline (< ", nhs24_low_threshold, "), ",
                                             "Low (", nhs24_low_threshold, "-", nhs24_moderate_threshold-0.01, "), ",
                                             "Moderate (", nhs24_moderate_threshold, "-", nhs24_high_threshold-0.01, "), ",
                                             "High (", nhs24_high_threshold, "-", nhs24_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", nhs24_extraordinary_threshold, ")."))))

altTextServer("nhs24_mem_hb_modal",
              title = "Percentage of NHS24 calls for respiratory symptoms by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the percentage of NHS24 calls for respiratory symptoms by NHS Health Board for seasons ",
                                             seasons[6], " and ", seasons[7], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations.")))


altTextServer("nhs24_mem_age_modal",
              title = "Percentage of NHS24 calls for respiratory symptoms by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the percentage of NHS24 calls for respiratory symptoms by age group for seasons ",
                                             seasons[6], " and ", seasons[7], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations.")))


# NHS24 MEM table
output$nhs24_mem_table <- renderDataTable({
  Respiratory_NHS24_MEM_Scot %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, Percentage, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Percentage of NHS24 Calls for Respiratory Symptoms` = Percentage,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2,4))
})

# NHS24 MEM by HB table
output$nhs24_mem_hb_table <- renderDataTable({
  Respiratory_NHS24_MEM_HB %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, HBName, Percentage, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           HBName = factor(HBName),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `NHS Health Board`= HBName,
           `Percentage of NHS24 Calls for Respiratory Symptoms` = Percentage,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})

# NHS24 MEM by Age table
output$nhs24_mem_age_table <- renderDataTable({
  Respiratory_NHS24_MEM_Age %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, Percentage, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           AgeGroup = factor(AgeGroup, levels = mem_age_groups_full),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Age Group`= AgeGroup,
           `Percentage of NHS24 Calls for Respiratory Symptoms` = Percentage,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})


# NHS24 MEM plot
output$nhs24_mem_plot <- renderPlotly({
  Respiratory_NHS24_MEM_Scot %>%
    create_mem_linechart(value_variable = "Percentage",
                         y_axis_title = "Percentage of calls to NHS24 <br> for respiratory symptoms")

})

# NHS24 MEM by HB plot
output$nhs24_mem_hb_plot <- renderPlotly({
  Respiratory_NHS24_MEM_HB %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode", value_variable = "Percentage")

})


# NHS24 MEM by Age plot
output$nhs24_mem_age_plot <- renderPlotly({
  Respiratory_NHS24_MEM_Age %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup", value_variable = "Percentage")

})



