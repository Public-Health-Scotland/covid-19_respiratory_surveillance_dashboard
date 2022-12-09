
# make data table with all the data in it
output$occupancy_table <- renderDataTable({
  Occupancy %>%
    mutate(Date = as.Date(Date, format="%Y%m%d")) %>%
    dplyr::rename(`Hospital Occupancy` = HospitalOccupancy,
                  `ICU Occupancy (28 days or less)` = ICUOccupancy28OrLess,
                  `ICU Occupancy (greater than 28 days)` = ICUOccupancy28OrMore) %>%
    select(Date, Geography, LocationName, `Hospital Occupancy`, `ICU Occupancy (28 days or less)`, `ICU Occupancy (greater than 28 days)`) %>%
    arrange(Date, desc(Geography)) %>%
    make_byboard_data_table(.,
                            board_name_column="LocationName",  # Name of the column with board names e.g. "NHS Board"
                            add_separator_cols=NULL, # Column indices to add thousand separators to
                            add_percentage_cols = NULL, # with % symbol and 2dp
                            rows_to_display=14,
                            order_by_firstcol="desc")

})

output$hospital_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy, healthboard = input$occupancy_healthboard, occupancy = "hospital")

})

output$icu_occupancy_less_28_plot <- renderPlotly({

  make_occupancy_plots(Occupancy, healthboard = input$occupancy_healthboard, occupancy = "icu-less")

})

output$icu_occupancy_more_28_plot <- renderPlotly({

  make_occupancy_plots(Occupancy, healthboard = input$occupancy_healthboard, occupancy = "icu-more")

})



