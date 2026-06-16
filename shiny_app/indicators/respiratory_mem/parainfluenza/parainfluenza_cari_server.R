
altTextServer("parainfluenza_cari_modal",
              title = "CARI - Test positivity for Parainfluenza",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Parainfluenza infection in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The solid black line is the specified test positivity rate and the lighter purple area around the line indicates the confidence interval."),
                                tags$li("The bottom of the light purple shaded area represents the lower confidence interval and the top of the area represents the upper confidence interval.")))

altTextServer("parainfluenza_cari_age_modal",
              title = "CARI - Test positivity for Parainfluenza by age group",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Parainfluenza infection by age group in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for for the selected age group(s)."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("parainfluenza_cari_hb_modal",
              title = "CARI - Test positivity for Parainfluenza by NHS Health Board",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Parainfluenza infection by NHS Health Board in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for the selected NHS Health Board(s)."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("parainfluenza_cari_subtype1_modal",
              title = "CARI - Test positivity for Parainfluenza by subtype",
              content = tags$ul(tags$li("This is a plot showing the test positivity rate of Parainfluenza infection by subtype in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the test positivity rate."),
                                tags$li("The plot contains a trace showing the test positivity rate for the selected subtype(s)."),
                                tags$li("Each trace can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))

altTextServer("parainfluenza_cari_subtype2_modal",
              title = "CARI - Number of positive samples by Parainfluenza subtype",
              content = tags$ul(tags$li("This is a plot showing the number of positive samples for each Parainfluenza subtype in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis is the week ending date, starting 09 October 2022."),
                                tags$li("The y axis is the number of positive samples."),
                                tags$li("The plot contains a stacked bar showing the number of positive samples for each subtype."),
                                tags$li("Each bar can be hidden/unhidden by clicking on the relevant age group from the legend on the right of the chart.")))


# CARI - Overall Parainfluenza swabpos table
output$parainfluenza_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
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


# CARI - Overall Parainfluenza swabpos plot
output$parainfluenza_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_Scot %>%
    filter(Pathogen == "Parainfluenza Virus") %>%
    create_cari_linechart()
  
})


# CARI - parainfluenza swabpos by age table
output$parainfluenza_cari_age_table <- renderDataTable({
  parainfluenza_cari_age %>%
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

# CARI - parainfluenza swabpos by age plot
output$parainfluenza_cari_age_plot <- renderPlotly({
  parainfluenza_cari_age %>%
    filter(AgeGroup %in% input$parainfluenza_cari_selected_age) %>%
    create_cari_age_linechart2()
  
})

# CARI - Overall parainfluenza HB swabpos plot
output$parainfluenza_cari_hb_plot <- renderPlotly({
  parainfluenza_cari_hb %>%
    filter(HBName %in% input$parainfluenza_cari_selected_boards) %>%
    create_cari_hb_linechart()
  
})

# CARI - parainfluenza swabpos by hb table
output$parainfluenza_cari_hb_table <- renderDataTable({
  parainfluenza_cari_hb %>%
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







# CARI - Overall parainfluenza swabpos table
output$parainfluenza_cari_subtype1_table <- renderDataTable({
  parainfluenza_cari_subtype %>%
    arrange(desc(WeekEnding), Pathogen) %>%
    mutate(Pathogen = factor(Pathogen)) %>%
    select(WeekEnding, Pathogen, TotalSamples, PositiveSamples, SwabPositivity, SwabPositivityLCL, SwabPositivityUCL) %>%
    rename(`Week Ending` = WeekEnding,
           `Subtype` = Pathogen,
           `Total Samples` = TotalSamples,
           `Positive Samples` = PositiveSamples,
           `Test Positivity (%)` = SwabPositivity,
           `Lower Confidence Limit (%)` = SwabPositivityLCL,
           `Upper Confidence Limit (%)` = SwabPositivityUCL) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3,4),
               add_separator_cols_1dp = c(5,6,7))
})

# CARI - Overall parainfluenza swabpos table
output$parainfluenza_cari_subtype2_table <- renderDataTable({
  parainfluenza_cari_subtype %>%
    filter(Pathogen %in% c("HPIV-1", "HPIV-2",
                           "HPIV-3", "HPIV-4")) %>%
    arrange(desc(WeekEnding), Pathogen) %>%
    mutate(Pathogen = factor(Pathogen)) %>%
    select(WeekEnding, Pathogen, PositiveSamples) %>%
    rename(`Week Ending` = WeekEnding,
           `Subtype` = Pathogen,
           `Positive Samples` = PositiveSamples) %>%
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3))
})



# CARI - Overall RSV swabpos plot
output$parainfluenza_cari_subtype1_plot <- renderPlotly({
  parainfluenza_cari_subtype %>%
    filter(Pathogen %in% input$parainfluenza_cari_selected_subtype1) %>%
    create_cari_subtype_linechart()
  
})

# CARI - Overall RSV swabpos plot
output$parainfluenza_cari_subtype2_plot <- renderPlotly({
  parainfluenza_cari_subtype %>%
    filter(Pathogen %in% c("HPIV-1", "HPIV-2",
                           "HPIV-3", "HPIV-4")) %>%
    create_cari_subtype_barchart()
  
})



