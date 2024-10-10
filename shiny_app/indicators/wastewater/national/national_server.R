
metadataButtonServer(id="national_wastewater_metadata",
                     panel="Wastewater",
                     parent = session)

# Create the table content

table_content <- data.frame(
  "Wastewater" = "Mgc/p/d",
  "Previous_Week_Ending" = round((COVID_Wastewater_National_table %>% mutate(Date = convert_opendata_date(Date)) %>% filter(Date == max(Date) - days(7)) %>% .$average)[1],2),
  "Current_Week_Ending" = round(COVID_Wastewater_National_table %>% tail(1) %>% .$average,2)
)

colnames(table_content)[2] = glue("{COVID_Wastewater_National_table %>% mutate(Date = convert_opendata_date(Date)) %>% filter(Date == max(Date) - days(7)) %>% .$Date %>% format('%d %b %y')}")
colnames(table_content)[3] = glue("{COVID_Wastewater_National_table %>% tail(1) %>%.$Date %>% convert_opendata_date() %>% format('%d %b %y')}")
colnames(table_content) <- gsub("_", " ", colnames(table_content))

output$wastewater_week_ending_table <- renderDataTable({
  datatable(table_content, rownames = FALSE,
            style = 'bootstrap',
            options = list(
              dom = 't',  # Only show the table body
              paging = FALSE,  # Disable pagination
              searching = FALSE,  # Disable search box
              ordering = FALSE  # Disable sorting arrows
            ))%>%
    formatStyle(
      columns = colnames(table_content),
      backgroundColor = '#3E2A6D',
      color = 'white',
      fontWeight = 'bold'
    ) %>%
    formatStyle(
      1:3, backgroundColor = 'white', color = 'black', fontWeight = 'bold'
    )
})




altTextServer("national_wastewater_modal",
              title = "Seven day average trend in wastewater COVID-19",
              content = tags$ul(tags$li("This is a plot showing the running average trend in wastewater COVID-19."),
                                tags$li("The x axis shows date of sample, starting from 28 May 2020."),
                                tags$li("The y axis shows the wastewater COVID-19 viral level in million gene copies per person per day."),
                                tags$li("There is one trace which shows the 7 day average of the watewater COVID-19 viral level."),
                                tags$li("There have been peaks throughout the pandemic, notably in",
                                        "Sep 2021, Dec 2021, Mar 2022 and Jun 2022")))
#wastewater plot
output$national_wastewater_plot <- renderPlotly({
  COVID_Wastewater_National_table %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    make_national_wastewater_plot()

})

output$national_wastewater_table <- renderDataTable({
  COVID_Wastewater_National_table %>%
    mutate(Date = convert_opendata_date(Date)) %>%
    dplyr::rename('7 day average (Mgc/p/d)' = average) %>%
    arrange(desc(Date)) %>%
    make_table(add_separator_cols_2dp = 2, order_by_firstcol = "desc",filter_cols = TRUE)
})