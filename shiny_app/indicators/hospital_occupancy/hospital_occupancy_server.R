

metadataButtonServer(id="hospital_occupancy",
                     panel="Hospital occupancy",
                     parent = session)


jumpToTabButtonServer(id="hospital_occupancy_from_summary",
                      location="hospital_occupancy",
                      parent = session)


# Hospital occupancy ----

altTextServer("hospital_occupancy_modal",
              title = "Number of patients with COVID-19 in hospital",
              content = tags$ul(
                tags$li("This is a plot of the number of patients with COVID-19 in hospital."),
                tags$li("The x axis is the date, commencing 08 Sep 2020."),
                tags$li("The y axis is the number of people with COVID-19 in hospital."),
                tags$li("There are two traces: a light blue trace which shows the number of",
                        "patients with COVID-19 in hospital each day;",
                        "and a dark blue trace overlayed which has the 7 day average of this."),
                tags$li("There were peaks in COVID-19 occupancy in Nov 2020, Jan 2021, Jul 2021,",
                        "Sep 2021, Jan 2022, Apr 2022, Jul 2022 and Oct 2022.")
              )
)

altTextServer("icu_occupancy_modal",
              title = "Number of patients with COVID-19 in ICU",
              content = tags$ul(
                tags$li("This is a plot of the 7 day average of the number of",
                        "patients with COVID-19 in hospital intensive care units (ICU)."),
                tags$li("The x axis is the date, commencing 13 Sep 2020."),
                tags$li("The y axis is the 7 day average number of people in ICU."),
                tags$li("There are two traces broken down by length of stay in ICU:",
                        "one for length of stay 28 days or less (blue; trace commences 13 Sep 2020);",
                        "the other for length of stay greater than 28 days (red; trace commences 27 Jan 2021)."),
                tags$li("Since Oct 2021 the overarching trend has been a decrease in the number of",
                        "patients with COVID-19 in ICU.")
              )
)


# make data table with all the hospital occupancy data in it
output$hospital_occupancy_table <- renderDataTable({
  Occupancy_Hospital %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`Hospital occupancy` = HospitalOccupancy,
                  `7 day average` = SevenDayAverage) %>%
                  #`ICU Occupancy (28 days or less)` = ICUOccupancy28OrLess,
                  #`ICU Occupancy (greater than 28 days)` = ICUOccupancy28OrMore) %>%
    select(Date,`Hospital occupancy`, `7 day average`) %>%  #`ICU Occupancy (28 days or less)`, `ICU Occupancy (greater than 28 days)`) %>%
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
    dplyr::rename(`ICU occupancy` = ICUOccupancy,
    `ICU length of stay` = ICULengthOfStay,
    `7 day average` = SevenDayAverage) %>%
    select(Date, `ICU length of stay`, `ICU occupancy`, `7 day average`) %>%
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





