
metadataButtonServer(id="la_wastewater_metadata",
                     panel="Wastewater",
                     parent = session)

output$council_area_plot =  renderPlotly({
  filtered_data <- COVID_Wastewater_CA_table %>% filter(council_area == input$selected_area)
  p <- plot_ly() %>%
    add_trace(
      data = filtered_data, 
      x = ~End, 
      y = ~average, 
      type = 'scatter', 
      mode = 'lines+markers',
      line = list(dash = 'solid', color = "#3F3685"),
      marker = list(color = "#3F3685"),
      name = input$selected_area,
      text = ~paste("Week Ending Date:", End, "<br>Average (Mgc/p/d):", round(average, 2), "<br>Coverage:", paste0(round_half_up(coverage, 2)*100, "%")),
      hoverinfo = "text"
    ) %>%
    # Add the Scotland data
    add_trace(
      data = HB_scotland, 
      x = ~End, 
      y = ~average, 
      type = 'scatter', 
      mode = 'lines+markers',
      line = list(dash = 'solid', color = "green"),  # Different style for Scotland
      marker = list(color = "green"),
      name = 'Scotland',
      text = ~paste("Week Ending Date:", End, "<br>Scotland Average (Mgc/p/d):", round(average, 2), "<br>Scotland Coverage:", paste0(round_half_up(coverage, 2)*100, "%")),
      hoverinfo = "text"
    ) %>%
    layout(title = paste("COVID-19 wastewater viral RNA (Mgc/p/d) for", input$selected_area),
           xaxis = list(title = "Week Ending Date",
                        rangeslider = list(type = "date")),
           yaxis = list(title = "Wastewater viral RNA (Mgc/p/d)"),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% 
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  
  p
  
  
})

altTextServer("CA_modal",
              title = "Weekly trend in wastewater COVID-19 by Local authority",
              content = tags$ul(tags$li("This is a plot showing the weekly trend in wastewater COVID-19 for the selected Local authority."),
                                tags$li("The x-axis shows week ending date, starting from 02 June 2020."),
                                tags$li("The y-axis shows the average wastewater COVID-19 viral level in million gene copies per person per day."),
                                tags$li("The plot contains two traces. The purple line shows the average wastewater COVID-19 viral level in the ",
                                        "selected Local authority. The green line shows the average wastewater COVID-19 viral level in Scotland."),
                                tags$li("Wastewater coverage is given as percentage of Local authority inhabitants covered by a wastewater RNA sampling site ",
                                        "delivering data during the relevant period.")
              ))

COVID_Wastewater_CA_table$average = round(COVID_Wastewater_CA_table$average,2)
COVID_Wastewater_CA_table$coverage = round(COVID_Wastewater_CA_table$coverage,2)

output$council_area_table <- renderDataTable({
  filtered <- COVID_Wastewater_CA_table %>%
    filter(council_area == input$selected_area) %>%
    mutate(coverage = coverage*100)
  filtered[-1] %>% 
    arrange(desc(End)) %>%
    dplyr::rename('Week Ending Date' = End) %>% 
    dplyr::rename('Local Authority' = council_area) %>% 
    dplyr::rename('Average (Mgc/p/d)' = average) %>%
    dplyr::rename('Coverage (%)' = coverage) %>% 
    make_table(order_by_firstcol = "desc")
  
})