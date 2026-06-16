
altTextServer("rhinovirus_cari_modal",
              title = "CARI - Test positivity for Rhinovirus",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Rhinovirus infection in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The solid black line is the specified test positivity rate and the lighter purple area around the line indicates the confidence interval."),
                                tags$li("The bottom of the light purple shaded area represents the lower confidence interval and the top of the area represents the upper confidence interval.")))

altTextServer("rhinovirus_cari_age_modal",
              title = "CARI - Test positivity for Rhinovirus by age group",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Rhinovirus infection by age group in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for for the selected age group(s)."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("rhinovirus_cari_hb_modal",
              title = "CARI - Test positivity for Rhinovirus by NHS Health Board",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Rhinovirus infection by NHS Health Board in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for the selected NHS Health Board(s)."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

# CARI - Overall Rhinovirus swabpos table
output$rhinovirus_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Rhinovirus") %>%
    arrange(desc(WeekEnding)) %>%
    select(WeekEnding, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    rename(`Week Ending` = WeekEnding,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(add_separator_cols = c(2,3),
               add_separator_cols_1dp = c(4,5,6))
})



# CARI - Overall Rhinovirus swabpos plot
output$rhinovirus_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Rhinovirus") %>%
    create_cari_linechart()
  
})


# CARI - rhinovirus swabpos by age table
output$rhinovirus_cari_age_table <- renderDataTable({
  rhinovirus_cari_age %>%
    arrange(desc(WeekEnding), AgeGroup) %>%
    select(WeekEnding, AgeGroup, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    mutate(AgeGroup = factor(AgeGroup)) %>%
    rename(`Week Ending` = WeekEnding,
           `Age Group`= `AgeGroup`,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3,4),
               add_separator_cols_1dp = c(5,6,7))
})

# CARI - rhinovirus swabpos by age plot
output$rhinovirus_cari_age_plot <- renderPlotly({
  rhinovirus_cari_age %>%
    filter(AgeGroup %in% input$rhinovirus_cari_selected_age) %>%
    create_cari_age_linechart2()
  
})

# CARI - Overall rhinovirus HB swabpos plot
output$rhinovirus_cari_hb_plot <- renderPlotly({
  rhinovirus_cari_hb %>%
    filter(HBName %in% input$rhinovirus_cari_selected_boards) %>%
    create_cari_hb_linechart()
  
})

# CARI - rhinovirus swabpos by hb table
output$rhinovirus_cari_hb_table <- renderDataTable({
  rhinovirus_cari_hb %>%
    arrange(desc(WeekEnding), HBName) %>%
    mutate(HBName = factor(HBName)) %>%
    select(WeekEnding, HBName, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    rename(`Week Ending` = WeekEnding,
           `NHS Health Board`= `HBName`,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3,4),
               add_separator_cols_1dp = c(5,6,7))
})





