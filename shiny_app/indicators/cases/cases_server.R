
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


output$ons_cases_plot <- renderPlotly({
  ONS %>%
    make_ons_cases_plot()

})


# output$r_number_plot <- renderPlotly({
#   R_Number %>%
#     make_r_number_plot()
#
# })

output$wastewater_plot <- renderPlotly({
  Wastewater %>%
    make_wastewater_plot()

})

output$wastewater_table <- renderDataTable({
  Wastewater %>%
    mutate(Date = convert_opendata_date(Date)) %>%
           #WastewaterSevenDayAverageMgc = round_half_up(WastewaterSevenDayAverageMgc, 1)) %>%
    dplyr::rename('7 day average (Mgc/p/d)' = WastewaterSevenDayAverageMgc) %>%
    make_table(add_separator_cols_1dp = 2, order_by_firstcol = "desc")

})
