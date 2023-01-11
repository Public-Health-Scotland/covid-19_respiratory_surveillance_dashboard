make_occupancy_plots <- function(data, occupancy) {

  data %<>%
    mutate(Date = convert_opendata_date(Date))

  xaxis_plots[["title"]] <- "Date"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  if(occupancy == "hospital") {

    data %<>%
      mutate(y_axis = SevenDayAverage)

    yaxis_plots[["title"]] <- "Number of people in hospital"

    p <- plot_ly(data, x = ~Date,
                 textposition = "none",
                 colors = phs_colours("phs-blue"),
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Number of People in hospital</b>: ", format(HospitalOccupancy, big.mark=","), "\n",
                                "<b>7 day average number of people in hospital</b>: ", format(SevenDayAverage, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500)%>%
      layout(legend = list(x = 100, y = 0.5)) %>%

      add_lines(y = ~HospitalOccupancy,
                line = list(color = phs_colours("phs-blue-30")),
                name = 'Number of people in hospital') %>%

      add_lines(y = ~SevenDayAverage, name = '7 day average',
                line = list(color = phs_colours("phs-blue"),
                            dash = "dash",
                            width = 2))



  } else if(occupancy == "icu") {

    data %<>%
      mutate(y_axis = SevenDayAverage)

    yaxis_plots[["title"]] <- "7 day average number of people in ICU"

    p <- plot_ly(data, x = ~Date, y = ~y_axis,
                 textposition = "none",
                 color = ~ICULengthOfStay,
                 colors = phs_colours(c("phs-blue", "phs-rust")),
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Length of stay in ICU</b>: ", ICULengthOfStay, "\n",
                                "<b>7 day average number of People in ICU</b>: ", format(SevenDayAverage, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500,
                 linetype = ~ICULengthOfStay,
                 linetypes = c("dash", "solid")) %>%
      add_trace(type = 'scatter', mode = 'lines') %>%
      layout(legend = list(x = 100, y = 0.5, title =list(text = "Length of stay in ICU", size = 12)))
  }

  p <- p %>%
     #add_trace(type = 'scatter', mode = 'lines') %>%
    #           line = list(color = phs_colours("phs-blue")))  %>%
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

}




