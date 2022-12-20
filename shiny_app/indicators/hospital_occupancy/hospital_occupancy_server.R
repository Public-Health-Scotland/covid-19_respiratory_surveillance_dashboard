
# make data table with all the hospital occupancy data in it
output$hospital_occupancy_table <- renderDataTable({
  Occupancy_Hospital %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`Hospital Occupancy` = HospitalOccupancy) %>%
                  #`ICU Occupancy (28 days or less)` = ICUOccupancy28OrLess,
                  #`ICU Occupancy (greater than 28 days)` = ICUOccupancy28OrMore) %>%
    select(Date, HealthBoard, `Hospital Occupancy`, SevenDayAverage) %>%  #`ICU Occupancy (28 days or less)`, `ICU Occupancy (greater than 28 days)`) %>%
    #arrange(Date, desc(Geography)) %>%
    make_byboard_data_table(.,
                            board_name_column="HealthBoard",  # Name of the column with board names e.g. "NHS Board"
                            add_separator_cols=NULL, # Column indices to add thousand separators to
                            add_percentage_cols = NULL, # with % symbol and 2dp
                            rows_to_display=14,
                            order_by_firstcol="desc")

})

# make data table with all the ICU occupancy data in it
output$ICU_occupancy_table <- renderDataTable({
  Occupancy_ICU %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`ICU Occupancy` = ICUOccupancy,
    `ICU length of stay` = ICULengthOfStay) %>%
    select(Date, HealthBoard, `ICU length of stay`, `ICU Occupancy`, SevenDayAverage) %>%
    make_byboard_data_table(.,
                            board_name_column="HealthBoard",  # Name of the column with board names e.g. "NHS Board"
                            add_separator_cols=NULL, # Column indices to add thousand separators to
                            add_percentage_cols = NULL, # with % symbol and 2dp
                            rows_to_display=14,
                            order_by_firstcol="desc")

})

output$hospital_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_Hospital, healthboard = input$occupancy_healthboard, occupancy = "hospital")

})

output$icu_occupancy_less_28_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_ICU, healthboard = input$occupancy_healthboard, occupancy = "icu-less")

})

output$icu_occupancy_more_28_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_ICU, healthboard = input$occupancy_healthboard, occupancy = "icu-more")

})



