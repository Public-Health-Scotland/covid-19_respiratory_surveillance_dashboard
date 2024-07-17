
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


