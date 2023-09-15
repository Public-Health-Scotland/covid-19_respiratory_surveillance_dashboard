
###########################
### HOSPITAL ADMISSIONS ###
###########################

# Daily Hospital Admissions plot
make_flu_admissions_plot <- function(data){

  # Wrangle Data
  data <- data %>%
    arrange(desc(date_plot)) %>%
    mutate(date_plot = convert_opendata_date(date_plot))

   # Create axis titles
  yaxis_title <- "Number of admissions"
  xaxis_title <- ""

  #Modifying standard layout
  yaxis_plots[["title"]] <- yaxis_title
  xaxis_plots[["title"]] <- xaxis_title

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  #Creating time trend plot
  p <- plot_ly(data, x = ~ date_plot) %>%
    add_lines(y = ~admissions,
              line = list(color = phs_colours("phs-blue-30")),
             # text = tooltip_trend, hoverinfo = "text",
              name = "Weekly hospital admissions") %>%
    
  # Add layout and config
    layout(margin = list(b = 80, t = 5),
                yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
                paper_bgcolor = phs_colours("phs-liberty-10"),
                plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)


  return(p)

}
