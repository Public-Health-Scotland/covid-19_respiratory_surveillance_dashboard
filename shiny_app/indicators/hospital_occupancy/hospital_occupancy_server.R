

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
                tags$li("The x axis is the week number."),
                tags$li("The y axis is the seven day average number of patients in hospital."),
                
              )
)

altTextServer("hospital_occupancy_hb_modal",
              title = "Number of patients with COVID-19 in hospital by NHS Health Board of treatment",
              content = tags$ul(
                tags$li("This is a plot of the number of patients in hospital with COVID-19 by NHS Health Board of treatment."),
                tags$li("The number of patients are seven day averages taken as a snapshot each Sunday."),
                tags$li("The x axis is the week number."),
                tags$li("The y axis is the seven day average number of patients in hospital.")
                
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
  occupancy_rapid_new %>%
    filter(Pathogen == "COVID-19") %>% 
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
               filter_cols = c(1, 2)
    )
  
})

output$hospital_occupancy_hb_table <- renderDataTable({
  occupancy_rapid_hb_new %>%
    filter(Pathogen == "COVID-19") %>% 
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



output$hospital_occupancy_plot <- renderPlotly({
  occupancy_rapid_new %>%
    filter(Pathogen == "COVID-19") %>%
    create_pathogen_occupancy_linechart()
  
})

output$hospital_occupancy_hb_plot <- renderPlotly({
  occupancy_rapid_hb_new %>%
    filter(Pathogen == "COVID-19") %>%
    filter(Season %in% input$hospital_occupancy_selected_seasons) %>%
    create_pathogen_occupancy_hb_linechart()

})


