

metadataButtonServer(id="hospital_occupancy",
                     panel="COVID-19 hospital occupancy",
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
                tags$li("There are two traces: a light pink trace which shows the number of",
                        "patients with COVID-19 in hospital each day;",
                        "and a dark pink trace overlayed which has the 7 day average of this."),
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
                        "one for length of stay 28 days or less (pink; trace commences 13 Sep 2020);",
                        "the other for length of stay greater than 28 days (purple; trace commences 27 Jan 2021)."),
                tags$li("Since Oct 2021 the overarching trend has been a decrease in the number of",
                        "patients with COVID-19 in ICU.")
              )
)

# make data table with all the hospital occupancy data in it
output$hospital_occupancy_table <- renderDataTable({
  Occupancy_Hospital %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    filter(Date <= floor_date(today(), "week")) %>%
    dplyr::rename(`Hospital occupancy` = HospitalOccupancy,
                  `7 day average` = SevenDayAverage) %>%
                  #`ICU Occupancy (28 days or less)` = ICUOccupancy28OrLess,
                  #`ICU Occupancy (greater than 28 days)` = ICUOccupancy28OrMore) %>%
    select(Date,`Hospital occupancy`, `7 day average`) %>%  #`ICU Occupancy (28 days or less)`, `ICU Occupancy (greater than 28 days)`) %>%
    arrange(desc(Date)) %>%
    #arrange(Date, desc(Geography)) %>%
    make_table(.,
                add_separator_cols=NULL, # Column indices to add thousand separators to
                add_percentage_cols = NULL, # with % symbol and 2dp
                maxrows=10,
                order_by_firstcol="desc"
               )

})

# make data table with all the hospital occupancy health board data in it
# HB Table
output$hospital_occupancy_hb_table <- renderDataTable({
  Occupancy_Hospital_HB %>%
    select(Date, HealthBoard, SevenDayAverage) %>%
    mutate(Date = as.Date(Date, format = "%Y-%m-%d")) %>%
    filter(Date %in% adm_hb_dates) %>%
    mutate(Date = format(Date, format = "%d %b %y")) %>%
    pivot_wider(names_from = Date,
                values_from = SevenDayAverage) %>%
    mutate(HealthBoard = factor(HealthBoard,
                                levels = c("NHS Ayrshire and Arran", "NHS Borders", "NHS Dumfries and Galloway", "NHS Fife", "NHS Forth Valley", "NHS Grampian",
                                           "NHS Greater Glasgow and Clyde", "NHS Highland", "NHS Lanarkshire", "NHS Lothian", "NHS Orkney", "NHS Shetland",
                                           "NHS Tayside", "NHS Western Isles", "Other", "Scotland"))) %>%
    arrange(HealthBoard) %>%
    dplyr::rename(`Health Board` = HealthBoard) %>%
    make_summary_table(maxrows = 16)
})

# make data table with all the ICU occupancy data in it
output$ICU_occupancy_table <- renderDataTable({
  Occupancy_ICU %>%
    mutate(Date = convert_opendata_date(Date),
           ICULengthOfStay = factor(ICULengthOfStay)) %>%
    filter(Date <= floor_date(today(), "week")) %>%
    dplyr::rename(`ICU occupancy` = ICUOccupancy,
    `ICU length of stay` = ICULengthOfStay,
    `7 day average` = SevenDayAverage) %>%
    select(Date, `ICU length of stay`, `ICU occupancy`, `7 day average`) %>%
    arrange(desc(Date)) %>%
    make_table(.,
                add_separator_cols=NULL, # Column indices to add thousand separators to
                add_percentage_cols = NULL, # with % symbol and 2dp
                maxrows=10,
                order_by_firstcol="desc",
                filter_cols = 2)

})

output$hospital_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_Hospital,  occupancy = "hospital")

})

output$icu_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_ICU, occupancy = "icu")

})





