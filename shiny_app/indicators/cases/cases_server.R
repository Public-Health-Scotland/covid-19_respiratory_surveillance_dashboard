
metadataButtonServer(id="cases",
                     panel="COVID-19 cases",
                     parent = session)

jumpToTabButtonServer(id="cases_from_summary",
                      location="cases",
                      parent = session)



### Test positivity

altTextServer("covid_positivity_modal",
              title = "COVID-19 test positivity",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of COVID-19 testing across Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis is test positivity rate."),
                                tags$li("There are several traces representing the test positivity rate across multiple seasons."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant season from the legend on the right of the chart.")
              )
)

output$covid_positivity_table <- renderDataTable({
  Respiratory_Pathogens_Test_Positivity %>%
    filter(pathogen == "Covid-19") %>%
    filter(season >= "2023/2024") %>%
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

output$covid_positivity_plot <- renderPlotly({
  Respiratory_Pathogens_Test_Positivity %>%
    filter(season >= "2023/2024") %>%
    create_test_pos_seasons_linechart(., "Covid-19")

})



## Positivity by age

altTextServer("covid_positivity_age_modal",
              title = "COVID-19 test positivity by age group",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of COVID-19 testing across Scotland by age."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis is test positivity rate."),
                                tags$li("By default, the plot contains a trace showing the admission rate per 100,000 across all age groups."),
                                tags$li("Traces can be added for each of the following age groups: <1 years, 1-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")
              )
)

output$covid_positivity_age_table <- renderDataTable({
  Respiratory_Pathogens_Test_Positivity_by_Age %>%
    filter(pathogen == "Covid-19") %>%
    filter(season %in% unlist(tail(cov_cases_seasons, 3))) %>%
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
               add_separator_cols_1dp = c(6),
               order_by_firstcol = "desc")
})


output$covid_positivity_age_plot <- renderPlotly({
  Respiratory_Pathogens_Test_Positivity_by_Age %>% 
    filter(pathogen == "Covid-19") %>% 
    filter(season == input$test_pos_cov_age) %>%
    create_positivity_age_chart()
  
})


output$covid_line_plot <- renderPlotly({

  covid_cases_weekly %>%
    create_covid_line_chart()
})

# COVID Rates per 100,000 table
output$covid_cases_table <- renderDataTable({
  covid_cases_weekly %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, RatePer100000) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek,
           `Rate per 100,000` = RatePer100000) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2))
})

altTextServer("reported_cases_per_100k",
title = "COVID-19 incidence rate per 100,000 population in Scotland",
content = tags$ul(tags$li("This is a plot showing the rate of laboratory-confirmed COVID-19 infection per 100,000 population in Scotland."),
 tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
 tags$li("The y axis shows the rate of laboratory-confirmed COVID-19 infection per 100,000 population."),
 tags$li("There is a trace for the three most recent seasons: 2023/2024, 2024/2025 and 2025/26.")
  )
)


###########
### MEM ###
###########

# Low threshold
covid_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Covid-19") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Medium threshold
covid_medium_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Covid-19") %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
covid_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Covid-19") %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Very High
covid_very_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Covid-19") %>%
  select(VeryHighThreshold) %>%
  distinct() %>%
  .$VeryHighThreshold %>%
  round_half_up(2)

### National ----

altTextServer("covid_mem_modal",
              title = "Laboratory-confirmed COVID-19 incidence per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of laboratory-confirmed COVID-19 infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of laboratory-confirmed COVID-19 infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: 2023/2024, 2024/2025, and 2025/2026.")),
                                tags$li(glue("Activity levels for COVID-19 based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for COVID-19 are: ",
                                             "Baseline (< ", covid_low_threshold, "), ",
                                             "Low (", covid_low_threshold, "-", covid_medium_threshold-0.01, "), ",
                                             "Medium (", covid_medium_threshold, "-", covid_high_threshold-0.01, "), ",
                                             "High (", covid_high_threshold, "-", covid_very_high_threshold-0.01, "), and ",
                                             "Very High (>= ", covid_very_high_threshold, ").")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes.")))



# Covid MEM table
output$covid_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
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

# Covid MEM plot
output$covid_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_linechart()
  
})

### HB ----

altTextServer("covid_mem_hb_modal",
              title = "Laboratory-confirmed COVID-19 incidence per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed COVID-19 infection per 100,000 population by NHS Health Board for seasons ",
                                             "2024/2025 and  2025/2026.")),
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
                                        "overall number of laboratory-confirmed episodes.")))


# COVID-19 MEM by HB table
output$covid_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
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

# COVID-19 MEM by HB plot
output$covid_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBName")
  
})


### Age ----

altTextServer("covid_mem_age_modal",
              title = "Laboratory-confirmed COVID-19 incidence per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of laboratory-confirmed COVID-19 infection per 100,000 population by age group for seasons ",
                                             "2024/2025 and  2025/2026.")),
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
                                        "overall number of laboratory-confirmed episodes.")))

# COVID-19 MEM by Age table
output$covid_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
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

# COVID-19 MEM by Age plot
output$covid_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Covid-19") %>%
    filter(Season >= "2023/2024") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")
  
})


### AGE/SEX BY SEASON ----

altTextServer("covid_age_sex",
              title = glue("Laboratory-confirmed COVID-19 cases by age and/or sex in Scotland"),
              content = tags$ul(
                tags$li(glue("This is a pyramid plot of rate per 100,000 population of laboratory-confirmed COVID-19 cases in Scotland by age and sex.")),
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
output$covid_age_sex_pyramid_plot = renderPlotly({
  covid_cases_agesex_season %>% 
    filter(season == input$covid_respiratory_season) %>%
    rename(Season = season,
           AgeGroup = age_group,
           Sex = sex,
           Rate = rate) %>%
    mutate(Sex = substr(Sex,1,1)) %>%
    mutate(AgeGroup = gsub(" years", "", AgeGroup)) %>%
    make_age_sex_pyramid_plot()#respiratory functions
})

# Flu by age/sex/age and sex
output$covid_age_sex_pyramid_table = renderDataTable({
  
  covid_cases_agesex_season %>% 
    filter(season >= "2023/2024") %>%
    mutate(season = factor(season)) %>%
    arrange(desc(season), age_group, sex) %>%
    dplyr::rename("Season" = "season",
                  "Age Group" = "age_group",
                  "Sex" = "sex",
                  "Rate per 100,000 population" = "rate") %>%
    mutate(Sex = factor(Sex, levels = c("Female", "Male")),
           `Age Group` = factor(`Age Group`, levels =
                                  c("<1 years", "1-4 years", "5-14 years",
                                    "15-44 years", "45-64 years", "65-74 years", 
                                    "75+ years"))) %>%
    arrange(desc(`Season`), `Age Group`, Sex) %>%
    select(Season, `Age Group`, Sex, `Rate per 100,000 population`) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3))
  
})

