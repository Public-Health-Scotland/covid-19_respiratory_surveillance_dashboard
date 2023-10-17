
metadataButtonServer(id="respiratory_adenovirus_mem",
                     panel="Respiratory infection activity",
                     parent = session)

# Low threshold
adenovirus_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Adenovirus") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
adenovirus_moderate_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Adenovirus") %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
adenovirus_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Adenovirus") %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
adenovirus_extraordinary_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Adenovirus") %>%
  select(ExtraordinaryThreshold) %>%
  distinct() %>%
  .$ExtraordinaryThreshold %>%
  round_half_up(2)

# # Get seasons used in line chart
# seasons_1 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Pathogen == "Adenovirus") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct() %>%
#   tail(6)
# seasons_2 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Season == "2010/2011") %>%
#   filter(Pathogen == "Adenovirus") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct()
# seasons <- bind_rows(seasons_2, seasons_1)
# seasons <- seasons$Season

# Get seasons used in line chart
seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Adenovirus") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons <- seasons$Season


altTextServer("adenovirus_mem_modal",
              title = "Adenovirus incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of adenovirus infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                       "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                       #"The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the rate of adenovirus infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", and ",
                                             seasons[6], ".")),
                                tags$li(glue("Activity levels for adenovirus based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for adenovirus are: ",
                                             "Baseline (< ", adenovirus_low_threshold, "), ",
                                             "Low (", adenovirus_low_threshold, "-", adenovirus_moderate_threshold-0.01, "), ",
                                             "Moderate (", adenovirus_moderate_threshold, "-", adenovirus_high_threshold-0.01, "), ",
                                             "High (", adenovirus_high_threshold, "-", adenovirus_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", adenovirus_extraordinary_threshold, ")."))))

altTextServer("adenovirus_mem_hb_modal",
              title = "Adenovirus incidence rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of adenovirus infection per 100,000 population by NHS Health Board for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                #"The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations.")))


altTextServer("adenovirus_mem_age_modal",
              title = "Adenovirus incidence rate per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of adenovirus infection per 100,000 population by age group for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations.")))


# adenovirus MEM table
output$adenovirus_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Adenovirus") %>%
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

# adenovirus MEM by HB table
output$adenovirus_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Season %in% seasons) %>%
    filter(Pathogen == "Adenovirus") %>%
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

# adenovirus MEM by Age table
output$adenovirus_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Season %in% seasons) %>%
    filter(Pathogen == "Adenovirus") %>%
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


# adenovirus MEM plot
output$adenovirus_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Adenovirus") %>%
    create_mem_linechart()
  
})

# adenovirus MEM by HB plot
output$adenovirus_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Adenovirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode")
  
})


# adenovirus MEM by Age plot
output$adenovirus_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Adenovirus") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")
  
})



