
metadataButtonServer(id="respiratory_influenza_admissions",
                     panel="Influenza",
                     parent = session)




altTextServer("influenza_admissions_modal",
              title = "Influenza hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the number of influenza hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the number of hospital admissions."),
                                tags$li("There is a trace for each of the following season from 2016/2017 to 2022/2023")))



# Influenza admissions table
output$influenza_admissions_table <- renderDataTable({
  Influenza_admissions %>%
    filter(FluType == "Influenza A & B") %>%
    arrange(desc(Date)) %>%
    select(Season, ISOWeek, Admissions) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek) %>%
    make_table(filter_cols = c(1,2))
})


# Influenza Adms plot
output$influenza_admissions_plot <- renderPlotly({
  Influenza_admissions %>%
    filter(FluType == "Influenza A & B") %>%
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



