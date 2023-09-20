metadataButtonServer(id="respiratory_rsv_admissions",
                     panel="Respiratory infection activity",
                     parent = session)




altTextServer("rsv_admissions_modal",
              title = "Influenza incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of influenza infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the rate of influenza infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", ",
                                             seasons[6], ", and ", seasons[7], ".")),
                                tags$li(glue("Activity levels for influenza based on MEM thresholds are represented by different coloured panels on the plot. ",
                                             "The activity levels and MEM thresholds for influenza are: ",
                                             "Baseline (< ", influenza_low_threshold, "), ",
                                             "Low (", influenza_low_threshold, "-", influenza_moderate_threshold-0.01, "), ",
                                             "Moderate (", influenza_moderate_threshold, "-", influenza_high_threshold-0.01, "), ",
                                             "High (", influenza_high_threshold, "-", influenza_extraordinary_threshold-0.01, "), and ",
                                             "Extraordinary (>= ", influenza_extraordinary_threshold, ")."))))



# RSV admissions table
output$rsv_admissions_table <- renderDataTable({
  RSV_admissions %>%
    arrange(desc(Date)) %>%
    select(Season, ISOWeek, Admissions) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek) %>%
    make_table(filter_cols = c(1,2))
})


# RSV Adms plot
output$rsv_admissions_plot <- renderPlotly({
  RSV_admissions %>%
    create_adms_linechart()

})


observeEvent(input$respiratory_season,
             {
               updatePickerInput(session, inputId = "respiratory_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)







