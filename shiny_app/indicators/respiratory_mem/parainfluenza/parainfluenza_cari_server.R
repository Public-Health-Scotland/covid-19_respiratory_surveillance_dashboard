
metadataButtonServer(id="respiratory_parainfluenza_cari",
                     panel="Parainfluenza Virus",
                     parent = session)

altTextServer("parainfluenza_cari_modal",
              title = "CARI - Swab positivity for Parainfluenza",
              content = tags$ul(tags$li("This is a plot showing the swab positivity rate of Parainfluenza infection in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the swab positivity rate."),
                                tags$li("The solid purple line is the specified swab positivity rate and the lighter purple area around the line indicates the confidence interval."),
                                tags$li("The bottom of the light purple shaded area represents the lower confidence interval and the top of the area represents the upper confidence interval.")))

altTextServer("parainfluenza_cari_age_modal",
              title = "CARI - Swab positivity for Parainfluenza by age group",
              content = tags$ul(tags$li("This is a plot showing the swab positivity rate of Parainfluenza infection by age group in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the swab positivity rate."),
                                tags$li("The plot contains a trace showing the swab positivity rate for each of the following age groups: 0-4 years, 5-14 years, 15-44 years, 45-64 years, 65-74 years, and 75+ years.")))

# CARI - Overall Parainfluenza swabpos table
output$parainfluenza_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
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

# CARI - Parainfluenza swabpos by age table
output$parainfluenza_cari_age_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
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

# CARI - Overall Parainfluenza swabpos plot
output$parainfluenza_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
    create_cari_linechart()
  
})

# CARI - Parainfluenza swabpos by age plot
output$parainfluenza_cari_age_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Age %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("0-4 years", "5-14 years", "15-44 years", "45-64 years",
                                                  "65-74 years", "75+ years"))) %>%
    create_cari_age_linechart()
  
})



