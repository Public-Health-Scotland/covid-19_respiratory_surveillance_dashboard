

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
                tags$li("This is a plot of the number of patients in hospital with COVID-19."),
                tags$li("The number of patients are seven day averages taken as a snapshot each Sunday."),
                tags$li("The x axis is the date, commencing 08 Sep 2020."),
                tags$li("The y axis is the average number of people in hospital."),
                tags$li("There is one blue line showing the average number of" ,
                        "patients with COVID-19 in hospital each week."),
                tags$li("There were peaks in COVID-19 occupancy in Nov 2020, Jan 2021, Jul 2021,",
                        "Sep 2021, Jan 2022, Apr 2022, Jul 2022, Oct 2022, Jan 2023 and March 2023."),
                tags$li("The data table also supplies the number of patients in hospital with COVID-19",
                        "as at the Sunday of each week.")
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
# the Occupancy_Weekly_Hospital_HB has two dates, an numeric 'open data' version, formatted as a number, 
# and a date-formatted WeekEnding
output$hospital_occupancy_table <- renderDataTable({
  Occupancy_Weekly_Hospital_HB %>%
    filter(HealthBoardQF== "d") %>% #filters for Scotland values
   arrange(desc(WeekEnding_od)) %>% 
    select('Week ending' = WeekEnding,
           'Number of patients in hospital' = HospitalOccupancy,
           `7 day average`= SevenDayAverage) %>%
    make_table(.,
                add_separator_cols=NULL, # Column indices to add thousand separators to
                add_percentage_cols = NULL, # with % symbol and 2dp
                maxrows=10,
                order_by_firstcol="desc"
               )

})

# make data table with all the hospital occupancy health board data in it
# HB Table (uses weekly values)
output$hospital_occupancy_hb_table <- renderDataTable({
  Occupancy_Weekly_Hospital_HB %>%
    select(WeekEnding, HealthBoard=HealthBoardName, SevenDayAverage) %>%
    filter(WeekEnding %in% adm_hb_dates) %>%
    #mutate(Date = format(Date, format = "%d %b %y")) %>%
    pivot_wider(names_from = WeekEnding,
                values_from = SevenDayAverage) %>%
    mutate(HealthBoard = factor(HealthBoard,
                                levels = c("NHS Ayrshire and Arran", "NHS Borders", "NHS Dumfries and Galloway", "NHS Fife", "NHS Forth Valley", "NHS Grampian",
                                           "NHS Greater Glasgow and Clyde", "NHS Highland", "NHS Lanarkshire", "NHS Lothian", "NHS Orkney", "NHS Shetland",
                                           "NHS Tayside", "NHS Western Isles", "Golden Jubilee National Hospital", "Scotland"))) %>%
    arrange(HealthBoard) %>%
    dplyr::rename(`Health Board of treatment` = HealthBoard) %>%
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

  make_occupancy_plots(Occupancy_Weekly_Hospital_HB,  occupancy = "hospital")

})

output$icu_occupancy_plot <- renderPlotly({

  make_occupancy_plots(Occupancy_ICU, occupancy = "icu")

})





