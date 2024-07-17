
metadataButtonServer(id="hb_wastewater_metadata",
                     panel="Wastewater",
                     parent = session)

output$health_board_plot =  renderPlotly({
  filtered_data <- HB_table_edited %>% filter(health_board == input$selected_board)
  p <- plot_ly() %>%
    add_trace(
      data = filtered_data, 
      x = ~End, 
      y = ~average, 
      type = 'scatter', 
      mode = 'lines+markers',
      line = list(dash = 'solid', color = "#3F3685"),
      marker = list(color = "#3F3685"),
      name = input$selected_board,
      text = ~paste("Week Ending Date:", End, "<br>Average:", round(average, 2), "<br>Coverage:", round(coverage, 2)),
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
      text = ~paste("Week Ending Date:", End, "<br>Scotland Average:", round(average, 2), "<br>Scotland Coverage:", round(coverage, 2)),
      hoverinfo = "text"
    ) %>%
    layout(title = paste("COVID-19 wastewater viral RNA (Mgc/p/d) for", input$selected_board),
           xaxis = list(title = "Week Ending Date"),
           yaxis = list(title = "Wastewater viral RNA (Mgc/p/d)"),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% 
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  
  p
  
  
})

altTextServer("HB_modal",
              title = "Weekly trend in wastewater COVID-19",
              content = tags$ul(tags$li("This is a plot showing the weekly trend in wastewater COVID-19 for the selected NHS Health Board.")
              ))

HB_table_edited$average = round(HB_table_edited$average,2)
HB_table_edited$coverage = round(HB_table_edited$coverage,2)

output$health_board_table <- renderDataTable({
  filtered <- HB_table_edited %>%
    filter(health_board == input$selected_board)
  filtered[-1] %>% 
    arrange(desc(End)) %>%
    dplyr::rename('Week Ending Date' = End) %>% 
    dplyr::rename('NHS Health Board' = health_board) %>% 
    dplyr::rename('Average (Mgc/p/d)' = average) %>%
    dplyr::rename('Coverage (Mgc/p/d)' = coverage) %>% 
    make_table(order_by_firstcol = "desc")
  
})