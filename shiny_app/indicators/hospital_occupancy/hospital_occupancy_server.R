
# make data table with all the hospital occupancy data in it
output$hospital_occupancy_table <- renderDataTable({
  Occupancy_Hospital %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`Hospital Occupancy` = HospitalOccupancy) %>%
                  #`ICU Occupancy (28 days or less)` = ICUOccupancy28OrLess,
                  #`ICU Occupancy (greater than 28 days)` = ICUOccupancy28OrMore) %>%
    select(Date,`Hospital Occupancy`, SevenDayAverage) %>%  #`ICU Occupancy (28 days or less)`, `ICU Occupancy (greater than 28 days)`) %>%
    #arrange(Date, desc(Geography)) %>%
    make_table(.,
                            add_separator_cols=NULL, # Column indices to add thousand separators to
                            add_percentage_cols = NULL, # with % symbol and 2dp
                            maxrows=10,
                            order_by_firstcol="desc")

})

# make data table with all the ICU occupancy data in it
output$ICU_occupancy_table <- renderDataTable({
  Occupancy_ICU %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`ICU Occupancy` = ICUOccupancy,
    `ICU length of stay` = ICULengthOfStay) %>%
    select(Date, `ICU length of stay`, `ICU Occupancy`, SevenDayAverage) %>%
    make_table(.,
                            add_separator_cols=NULL, # Column indices to add thousand separators to
                            add_percentage_cols = NULL, # with % symbol and 2dp
                            maxrows=10,
                            order_by_firstcol="desc")

})

output$hospital_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_Hospital,  occupancy = "hospital")

})

output$icu_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_ICU, occupancy = "icu")

})





