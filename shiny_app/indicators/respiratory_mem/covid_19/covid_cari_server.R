
metadataButtonServer(id="respiratory_covid_cari",
                     panel="Respiratory infection activity",
                     parent = session)

altTextServer("covid_cari_modal",
              title = "CARI - Test positivity for COVID-19",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of COVID-19 infection in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The solid purple line is the specified test positivity rate and the lighter purple area around the line indicates the confidence interval."),
                                tags$li("The bottom of the light purple shaded area represents the lower confidence interval and the top of the area represents the upper confidence interval.")))

altTextServer("covid_cari_age_modal",
              title = "CARI - Test positivity for COVID-19 by age group",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of COVID-19 infection by age group in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for each of the following age groups: 0-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

# CARI - Overall COVID-19 swabpos table
output$covid_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "COVID-19") %>%
    arrange(desc(WeekEnding)) %>%
    select(WeekEnding, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    rename(`Week Ending` = WeekEnding,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table()
})

# CARI - COVID-19 swabpos by age table
output$covid_cari_age_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "COVID-19") %>%
    arrange(desc(WeekEnding)) %>%
    select(WeekEnding, AgeGroup, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("0-4 years", "5-14 years", "15-44 years", "45-64 years",
                                                  "65-74 years", "75+ years"))) %>%
    rename(`Week Ending` = WeekEnding,
           `Age Group`= `AgeGroup`,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(filter_cols = c(2))
})

# CARI - Overall COVID-19 swabpos plot
output$covid_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "COVID-19") %>%
    create_cari_linechart()
  
})

# CARI - COVID-19 swabpos by age plot
output$covid_cari_age_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "COVID-19") %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("0-4 years", "5-14 years", "15-44 years", "45-64 years",
                                                  "65-74 years", "75+ years"))) %>%
    create_cari_age_linechart()
  
})



