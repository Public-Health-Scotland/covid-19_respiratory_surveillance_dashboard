
# Low threshold
gp_low_threshold <- Respiratory_GPILI_MEM_Scot %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
gp_medium_threshold <- Respiratory_GPILI_MEM_Scot %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
gp_high_threshold <- Respiratory_GPILI_MEM_Scot %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
gp_very_high_threshold <- Respiratory_GPILI_MEM_Scot %>%
  select(VeryHighThreshold) %>%
  distinct() %>%
  .$VeryHighThreshold %>%
  round_half_up(2)


# Get seasons used in line chart
gp_seasons <- Respiratory_GPILI_MEM_Scot %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
gp_seasons <- gp_seasons$Season



altTextServer("gp_mem_modal",
              title = "GP consultation rates for influenza-like illness (ILI) per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of GP consultations for ILI per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of GP consultations for ILI per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", gp_seasons[1], ", ",
                                             gp_seasons[2], ", ", gp_seasons[3], ", ", gp_seasons[4], 
                                             ", ", gp_seasons[5],", and ", gp_seasons[6], ".")),
                                tags$li(glue("Activity levels for GP consultations for ILI based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for GP ILI consultations are: ",
                                             "Baseline (< ", gp_low_threshold, "), ",
                                             "Low (", gp_low_threshold, "-", gp_medium_threshold-0.01, "), ",
                                             "Medium (", gp_medium_threshold, "-", gp_high_threshold-0.01, "), ",
                                             "High (", gp_high_threshold, "-", gp_very_high_threshold-0.01, "), and ",
                                             "Very High (>= ", gp_very_high_threshold, ")."))))


altTextServer("gp_mem_age_modal",
              title = "GP consultation rates for influenza-like illness (ILI) per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of GP consultations for ILI infection per 100,000 population by age group for seasons ",
                                             gp_seasons[5], " and ", gp_seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Medium, High, or Very High."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The consultation rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations."),
                                tags$li("MEM thresholds for each age group are available in the metadata of the",
                                        tags$a("accompanying report.",
                                               href="https://www.publichealthscotland.scot/publications/show-all-releases?id=102486"))))


# GP MEM table
output$gp_mem_table <- renderDataTable({
  Respiratory_GPILI_MEM_Scot %>%
    filter(Season %in% gp_seasons) %>%
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



# GP MEM by Age table
output$gp_mem_age_table <- renderDataTable({
  Respiratory_GPILI_MEM_Age %>%
    filter(Season %in% gp_seasons) %>%
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


# GP MEM plot
output$gp_mem_plot <- renderPlotly({
  Respiratory_GPILI_MEM_Scot %>%
    create_mem_linechart()

})



# GP MEM by Age plot
output$gp_mem_age_plot <- renderPlotly({
  Respiratory_GPILI_MEM_Age %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")

})



