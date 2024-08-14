
make_national_wastewater_plot <- function(data){
  
  
  data %<>%
    mutate(Date = Date)
  
  yaxis_plots[["title"]] <- "Wastewater viral RNA (Mgc/p/d)"
  xaxis_plots[["title"]] <- "Date of sample"
  
  
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  
  p <- plot_ly(data, x = ~Date,
               textposition = "none",
               text = ~paste0("<b>Date of sample</b>: ", format(Date, "%d %b %y"), "\n",
                              "<b>COVID-19 wastewater level (Mgc/p/d)</b>: ", signif(average,3), "\n"),
               hovertemplate = "%{text}",
               height = 500)%>%
    
    add_lines(y = ~average,
              line = list(color = "#3F3685"),
              name = 'Wastewater viral RNA (Mgc/p/d)'
              #marker = list(color = phs_colours("phs-purple"),
              #             size = 5)
    ) %>%
    
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}


create_wastewater_hb_map <- function(hb_data, site_data) {
  
  hb_map <- leaflet() %>% 
    setView(lng = -4.3, lat = 57.7, zoom = 6.45) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(data = hb_data,
                weight = 1, smoothFactor = 0.5, fillColor = '#3F3685',
                opacity = 0.6, fillOpacity = 0.6, color = "black", dashArray = "0",
                popup = ~paste0(
                  "Week Ending Date: ", format(End, "%d %b %y"), "<br>",
                  "Health board: ", health_board, "<br>",
                  "Average (Mgc/p/d): ", round(average, 2), "<br>",
                  "Coverage: ", paste0(round(coverage, 2)*100,"%")),
                label = ~paste0("Healthboard: ", health_board),
                labelOptions = labelOptions(noHide = FALSE, direction = "auto"),
                highlightOptions = highlightOptions(color = "#ECEBF3", weight = 2, bringToFront = TRUE),
                group = "Health Boards") %>%
    addCircleMarkers(data = site_data,
                     radius = 2, color = "#83BB26", fill = TRUE, fillOpacity = 1,stroke=FALSE,
                     popup = ~paste0("Site: ", site_name,"<br>",
                                     "Health Board: ",health_board),
                     group="Sites") %>% 
    addLayersControl(overlayGroups = c("Health Boards", "Sites"),
                     options = layersControlOptions(collapsed = FALSE))
  return(hb_map)
}

