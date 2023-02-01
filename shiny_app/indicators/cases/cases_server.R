
metadataButtonServer(id="cases",
                     panel="COVID-19 cases",
                     parent = session)

jumpToTabButtonServer(id="cases_from_summary",
                      location="cases",
                      parent = session)

altTextServer("ons_cases_modal",
              title = "Estimated COVID-19 infection rate",
              content = tags$ul(tags$li("This is a plot of the estimated COVID-19 infection rate in the population",
                                        "from the Office for National Statistics."),
                                tags$li("The x axis shows week ending, starting from 06 November 2020."),
                                tags$li("The y axis shows the official positivity estimate, as a percentage",
                                        "of the population in Scotland. "),
                                tags$li("There is one trace which includes error bars denoting confidence intervals."),
                                tags$li("The positivity estimate peaked at 1 in 11 for week ending 20 Mar 2022."),
                                tags$li("The latest positivity estimate in week ending",
                                        glue("{ONS %>% tail(1) %>% .$EndDate %>% convert_opendata_date() %>% format('%d %b %y')}"),
                                        glue("is {ONS %>% tail(1) %>% .$EstimatedRatio}")
                                )
              )
)



altTextServer("wastewater_modal",
              title = "Seven day average trend in wastewater COVID-19",
              content = tags$ul(tags$li("This is a plot showing the running average trend in wastewater COVID-19."),
                                tags$li("The x axis shows date of sample, starting from 28 May 2020."),
                                tags$li("The y axis shows the wastewater viral level in million gene copies per person per day."),
                                tags$li("There is one trace which shows the 7 day average of the watewater viral level."),
                                tags$li("There have been peaks throughout the pandemic, notably in",
                                        "Sep 2021, Dec 2021, Mar 2022 and Jun 2022")))

altTextServer("reported_cases_modal",
              title = "Reported COVID-19 cases",
              content = tags$ul(tags$li("This is a plot of the number of reported COVID-19 cases each day."),
                                tags$li("The x axis is the date"),
                                tags$li("The y axis is the number of reported cases"),
                                tags$li("There are two traces: a light purple trace which shows the number of reported cases each day;",
                                        "and a dark purple trace overlayed which has the 7 day average of this."),
                                tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                        "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                        "the second marks the change in testing policy on 1 May 2022."),
                                tags$li("The 7 day average peaked at about 18,000 at the start of Jan 2022.")
              )
)

output$reported_cases_table <- renderDataTable({
  Cases %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`Reported cases` = NumberCasesPerDay,
                  `7 day average` = SevenDayAverage) %>%
    select(Date, `Reported cases`, `7 day average`) %>%
    arrange(desc(Date)) %>%
    make_table(add_separator_cols = c(2,3), order_by_firstcol = "desc")
})

output$reported_cases_plot <- renderPlotly({
  Cases %>%
    make_reported_cases_plot()

})


output$ons_cases_plot <- renderPlotly({
  ONS %>%
    make_ons_cases_plot()

})


output$wastewater_plot <- renderPlotly({
  Wastewater %>%
    make_wastewater_plot()

})

output$wastewater_table <- renderDataTable({
  Wastewater %>%
    mutate(Date = convert_opendata_date(Date)) %>%
           #WastewaterSevenDayAverageMgc = round_half_up(WastewaterSevenDayAverageMgc, 1)) %>%
    dplyr::rename('7 day average (Mgc/p/d)' = WastewaterSevenDayAverageMgc) %>%
<<<<<<< HEAD
    make_table(add_separator_cols_2dp = 2, order_by_firstcol = "desc")
=======
    arrange(desc(Date)) %>%
    make_table(add_separator_cols_1dp = 2, order_by_firstcol = "desc")
>>>>>>> master

})
