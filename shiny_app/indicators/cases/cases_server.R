
output$reported_cases_table <- renderDataTable({
  Cases %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename(`Reported cases` = NumberCasesPerDay,
                  `7 day average` = SevenDayAverage) %>%
    select(Date, `Reported cases`, `7 day average`) %>%
    make_table(add_separator_cols = 2, add_separator_cols_1dp = 3, order_by_firstcol = "desc")
})

output$reported_cases_plot <- renderPlotly({
  Cases %>%
    make_reported_cases_plot()
})