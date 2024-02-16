
metadataButtonServer(id="respiratory_rhinovirus_cari",
                     panel="Rhinovirus",
                     parent = session)

altTextServer("rhinovirus_cari_modal",
              title = "CARI - Swab positivity for Rhinovirus",
              content = tags$ul(tags$li("This is a plot showing the swab positivity rate of Rhinovirus infection in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the swab positivity rate."),
                                tags$li("The solid purple line is the specified swab positivity rate and the lighter purple area around the line indicates the confidence interval."),
                                tags$li("The bottom of the light purple shaded area represents the lower confidence interval and the top of the area represents the upper confidence interval.")))

altTextServer("rhinovirus_cari_age_modal",
              title = "CARI - Swab positivity for Rhinovirus by age group",
              content = tags$ul(tags$li("This is a plot showing the swab positivity rate of Rhinovirus infection by age group in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the swab positivity rate."),
                                tags$li("The plot contains a trace showing the swab positivity rate for each of the following age groups: 0-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years.")))

# CARI - Overall Rhinovirus swabpos table
output$rhinovirus_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Rhinovirus") %>%
    arrange(desc(WeekEnding)) %>%
    select(WeekEnding, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    rename(`Week Ending` = WeekEnding,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Swab Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table()
})

# CARI - Rhinovirus swabpos by age table
output$rhinovirus_cari_age_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "Rhinovirus") %>%
    arrange(desc(WeekEnding)) %>%
    select(WeekEnding, AgeGroup, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("0-4 years", "5-14 years", "15-44 years", "45-64 years",
                                                  "65-74 years", "75+ years"))) %>%
    rename(`Week Ending` = WeekEnding,
           `Age Group`= `AgeGroup`,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Swab Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(filter_cols = c(2))
})

# CARI - Overall Rhinovirus swabpos plot
output$rhinovirus_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Rhinovirus") %>%
    create_cari_linechart()
  
})

# CARI - Rhinovirus swabpos by age plot
output$rhinovirus_cari_age_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "Rhinovirus") %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("0-4 years", "5-14 years", "15-44 years", "45-64 years",
                                                  "65-74 years", "75+ years"))) %>%
    create_cari_age_linechart()
  
})



