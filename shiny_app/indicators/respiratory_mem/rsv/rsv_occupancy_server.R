
# Hospital occupancy ----

altTextServer("rsv_occupancy_modal",
              title = "Number of patients with RSV in hospital",
              content = tags$ul(
                tags$li("This is a plot of the number of patients in hospital with RSV."),
                tags$li("The number of patients are seven day averages taken as a snapshot each Sunday."),
                tags$li("The x axis is the week number."),
                tags$li("The y axis is the seven day average number of patients in hospital.")))

altTextServer("rsv_occupancy_hb_modal",
              title = "Number of patients with RSV in hospital by NHS Health Board of treatment",
              content = tags$ul(
                tags$li("This is a plot of the number of patients in hospital with RSV by NHS Health Board of treatment."),
                tags$li("The number of patients are seven day averages taken as a snapshot each Sunday."),
                tags$li("The x axis is the week number."),
                tags$li("The y axis is the seven day average number of patients in hospital.")))
              

# make data table with all the hospital occupancy data in it
output$rsv_occupancy_table <- renderDataTable({
  occupancy_rapid_new %>%
    filter(Pathogen == "RSV") %>% 
    arrange(desc(WeekEnding)) %>% 
    mutate(ISOweek = factor(ISOweek),
           Season = factor(Season)) %>%
    select('Season' = Season,
           'Week number' = ISOweek,
           #'Number of patients in hospital as at Sunday' = bed_occupancy,
           `7 day average of number of patients in hospital as at Sunday`= SevenDayAverageInpatients) %>%
    make_table(.,
                add_separator_cols=c(3), # Column indices to add thousand separators to
                add_percentage_cols = NULL, # with % symbol and 2dp
                maxrows=10,
                order_by_firstcol="desc",
               filter_cols = c(1,2)
               )

})

output$rsv_occupancy_hb_table <- renderDataTable({
  occupancy_rapid_hb_new %>%
    filter(Pathogen == "RSV") %>% 
    arrange(desc(WeekEnding)) %>% 
    mutate(ISOweek = factor(ISOweek),
           Season = factor(Season),
           HBName = factor(HBName)) %>%
    select('Season' = Season,
           'Week number' = ISOweek,
           'NHS Health Board' = HBName,
           `7 day average of number of patients in hospital as at Sunday`= SevenDayAverageInpatients) %>%
    make_table(.,
               add_separator_cols=c(4), # Column indices to add thousand separators to
               add_percentage_cols = NULL, # with % symbol and 2dp
               maxrows=15,
               order_by_firstcol="desc",
               filter_cols = c(1,2, 3)
    )
  
})



output$rsv_occupancy_plot <- renderPlotly({
  occupancy_rapid_new %>%
    filter(Pathogen == "RSV") %>%
    create_pathogen_occupancy_linechart()
  
})

output$rsv_occupancy_hb_plot <- renderPlotly({
  occupancy_rapid_hb_new %>%
    filter(Pathogen == "RSV") %>%
    filter(Season %in% input$rsv_occupancy_selected_seasons) %>%
    create_pathogen_occupancy_hb_linechart()
  
})

