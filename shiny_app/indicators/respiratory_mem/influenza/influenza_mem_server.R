
metadataButtonServer(id="respiratory_influenza_mem",
                     panel="Respiratory infection activity",
                     parent = session)

altTextServer("influenza_positivity_modal",
              title = "Influenza percentage test positivity",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate for influenza testing across Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis is test positivity rate."),
                                tags$li("There are several traces representing the test positivity rate across multiple seasons."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant season from the legend on the right of the chart.")
              )
)

output$influenza_positivity_table <- renderDataTable({
  Respiratory_Pathogens_Test_Positivity %>%
    filter(pathogen == "Influenza (A or B)") %>%
    dplyr::rename(`Year` = year,
                  `Season` = season,
                  `ISO Week` = ISOweek,
                  `Total Samples` = total_samples,
                  `Positive Samples` = positive_count,
                  `Test Positivity (%)` = positivity_percentage) %>%
    select(`Year`, `ISO Week`, `Total Samples`, `Positive Samples`, `Test Positivity (%)`) %>%
    arrange(desc(`Year`), desc(`ISO Week`)) %>%
    mutate(Year = as.factor(Year),
           `ISO Week` = as.factor(`ISO Week`)) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3,4),
               add_separator_cols_1dp = c(5),
               order_by_firstcol = "desc")
})

output$influenza_positivity_plot <- renderPlotly({
  Respiratory_Pathogens_Test_Positivity %>%
    create_test_pos_seasons_linechart(., "Influenza (A or B)")
  
})


## Test positivity by age

altTextServer("flu_positivity_age_modal",
              title = "Influenza test positivity by age group",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of influenza testing across Scotland by age."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis is test positivity rate."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")
              )
)

output$flu_positivity_age_table <- renderDataTable({
  Respiratory_Pathogens_Test_Positivity_by_Age %>%
    filter(pathogen == "Influenza (A or B)") %>%
    filter(season %in% unlist(tail(flu_cases_seasons, 6))) %>%
    mutate(agegrp = case_when(is.na(agegrp) ~ "Unknown",
                              TRUE ~ agegrp)) %>% 
    dplyr::rename(`Year` = year,
                  `Season` = season,
                  `ISO Week` = ISOweek,
                  `Age Group` = agegrp,
                  `Total Samples` = total_samples,
                  `Positive Samples` = positive_count,
                  `Test Positivity (%)` = positivity_percentage) %>%
    select(`Year`, `ISO Week`, `Age Group`, `Total Samples`, `Positive Samples`, `Test Positivity (%)`) %>%
    arrange(desc(`Year`), desc(`ISO Week`)) %>%
    mutate(Year = as.factor(Year),
           `ISO Week` = as.factor(`ISO Week`),
           `Age Group` = as.factor(`Age Group`)) %>%
    make_table(filter_cols = c(1,2,3),
               add_separator_cols = c(4,5),
               add_separator_cols_1dp = c(6), order_by_firstcol = "desc")
})


output$flu_positivity_age_plot <- renderPlotly({
  Respiratory_Pathogens_Test_Positivity_by_Age %>% 
    filter(pathogen == "Influenza (A or B)") %>% 
    filter(season == input$test_pos_flu_age) %>%
    create_positivity_age_chart()
  
})


# Low threshold
influenza_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
influenza_medium_threshold <- Respiratory_Pathogens_MEM_Scot %>%
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
influenza_very_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(VeryHighThreshold) %>%
  distinct() %>%
  .$VeryHighThreshold %>%
  round_half_up(2)

# # Get seasons used in line chart
# seasons_1 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Pathogen == "Influenza") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct() %>%
#   tail(6)
# seasons_2 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Season == "2010/2011") %>%
#   filter(Pathogen == "Influenza") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct()
# seasons <- bind_rows(seasons_2, seasons_1)
# seasons <- seasons$Season

# Get seasons used in line chart
influenza_seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
influenza_seasons <- influenza_seasons$Season



altTextServer("influenza_mem_modal",
              title = "Laboratory-confirmed influenza incidence per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of laboratory-confirmed influenza infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of laboratory-confirmed influenza infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", influenza_seasons[1], ", ",
                                             influenza_seasons[2], ", ", influenza_seasons[3], ", ", influenza_seasons[4], 
                                             ", ", influenza_seasons[5],", and ", influenza_seasons[6], ".")),
                                tags$li(glue("Activity levels for influenza based on MEM thresholds are represented by different coloured panels on the plot. ",
                                        "The activity levels and MEM thresholds for influenza are: ",
                                        "Baseline (< ", influenza_low_threshold, "), ",
                                        "Low (", influenza_low_threshold, "-", influenza_medium_threshold-0.01, "), ",
                                        "Medium (", influenza_medium_threshold, "-", influenza_high_threshold-0.01, "), ",
                                        "High (", influenza_high_threshold, "-", influenza_very_high_threshold-0.01, "), and ",
                                        "Very High (>= ", influenza_very_high_threshold, ").")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))

altTextServer("influenza_mem_hb_modal",
              title = "Laboratory-confirmed influenza incidence per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed influenza infection per 100,000 population by NHS Health Board for seasons ",
                                             influenza_seasons[5], " and ", influenza_seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Medium, High, or Very High ."),
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


altTextServer("influenza_mem_age_modal",
              title = "Laboratory-confirmed influenza incidence per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed influenza infection per 100,000 population by age group for seasons ",
                                             influenza_seasons[5], " and ", influenza_seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Medium, High, or Very High ."),
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
output$influenza_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% influenza_seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, RatePer100000, ActivityLevel) %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
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
output$influenza_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% influenza_seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, HBName, RatePer100000, ActivityLevel) %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
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
output$influenza_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% influenza_seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, RatePer100000, ActivityLevel) %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
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
output$influenza_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_linechart()

})

# Influenza MEM by HB plot
output$influenza_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBName")

})


# Influenza MEM by Age plot
output$influenza_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    # mutate(ActivityLevel = case_when(
    #   ActivityLevel == "Moderate" ~ "Medium",
    #   ActivityLevel == "Extraordinary" ~ "Very High",
    #   TRUE ~ ActivityLevel
    # )) %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")

})

### Age and sex plot ###

# altTextServer("influenza_age_sex",
#               title = glue("Influenza cases by age and/or sex in Scotland"),
#               content = tags$ul(
#                 tags$li(glue("This is a plot of the total influenza cases in Scotland.")),
#                 tags$li("The information is displayed for a selected season and week."),
#                 tags$li("One of three different plots is displayed depending on the breakdown",
#                         "selected: either Age; Sex; or Age + Sex."),
#                 tags$li("All three plots show rate per 100,000 people on the y axis."),
#                 tags$li("For the x axis the first plot shows age group, the second shows",
#                         "sex, and the third shows age group and sex."),
#                 tags$li("The first plot (Age) is a bubble plot. This is a scatter plot",
#                         "where both the position and the area of the circle correspond",
#                         "to the rate per 100,000 people."),
#                 tags$li("The second and third plots are bar charts where the left hand column",
#                         "corresponds to female (F) and the right hand column to male (M).")
#                 # tags$li("The youngest and oldest groups have the highest rates of illness.")
#               )
# )

altTextServer("influenza_age_sex",
              title = glue("Laboratory-confirmed influenza cases by age and/or sex in Scotland"),
              content = tags$ul(
                tags$li(glue("This is a pyramid plot of rate per 100,000 population of laboratory-confirmed influenza cases in Scotland by age and sex.")),
                tags$li("The information is displayed for a selected season."),
                tags$li("Weekly rate data for age and sex on a weekly basis are available on ",
                        "the PHS Open Data platform ",
                        tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
                               "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website).", 
                               target="_blank")),
                tags$li("The y axis shows the age group. The left side of the y axis corresponds to females and the right side to males."),
                tags$li("For the x axis the plot shows rate per 100,000 population.")
                # tags$li("The youngest and oldest groups have the highest rates of illness.")
              )
)



# pyramid plot that shows the breakdown by age and sex
output$influenza_age_sex_pyramid_plot = renderPlotly({
  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(Season %in% recent_six_seasons) %>%
    mutate(Season = gsub("/", "/20", Season)) %>%
    mutate(Rate = round_half_up(Rate,1)) %>%
    filter(scotland_by_age_sex_season_flag == 1,
           # scotland_by_age_sex_flag == 1,
           Season == input$flu_respiratory_season) %>%
    make_age_sex_pyramid_plot()#respiratory functions

})

# Flu by age/sex/age and sex
output$influenza_age_sex_table = renderDataTable({

  flu_age <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_age_flag == 1) %>%
    mutate(Sex = "All") %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    mutate(Rate = round_half_up(Rate,1)) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate")

  flu_sex <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_sex_flag == 1) %>%
    mutate(AgeGroup = "All") %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate")

  flu_age_sex <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_age_sex_flag == 1) %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    arrange(desc(Date), AgeGroup, Sex) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate") %>%
    bind_rows(flu_age, flu_sex) %>%
    mutate(Sex = factor(Sex, levels = c("All", "F", "M")),
           `Age group` = factor(`Age group`, levels =
                                  c("All", "<1", "1-4", "5-14",
                                    "15-44", "45-64", "65-74", "75+"))) %>%
    arrange(desc(`Week ending`), `Age group`, Sex) %>%
    make_table(add_separator_cols_1dp = c(5),
               filter_cols = c(1,3,4))

})

# Flu by age/sex/age and sex
output$influenza_age_sex_pyramid_table = renderDataTable({

  flu_age_sex_pyramid_table <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(Season %in% recent_six_seasons) %>%
    mutate(Season = gsub("/", "/20", Season)) %>%
    filter(scotland_by_age_sex_season_flag == 1) %>%
    select(Season, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    arrange(desc(Season), AgeGroup, Sex) %>%
    dplyr::rename("Season" = "Season",
                  "Age Group" = "AgeGroup",
                  "Rate per 100,000 population" = "Rate") %>%
    mutate(Sex = case_when(
      Sex == "F" ~ "Female",
      Sex == "M" ~ "Male",
      TRUE ~ NA_character_
    )) %>%
    mutate(`Age Group` = paste0(`Age Group`, " years")) %>%
    mutate(Sex = factor(Sex, levels = c("Female", "Male")),
           `Age Group` = factor(`Age Group`, levels =
                                  c("<1 years", "1-4 years", "5-14 years",
                                    "15-44 years", "45-64 years", "65-74 years", 
                                    "75+ years"))) %>%
    arrange(desc(`Season`), `Age Group`, Sex) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3))

})





