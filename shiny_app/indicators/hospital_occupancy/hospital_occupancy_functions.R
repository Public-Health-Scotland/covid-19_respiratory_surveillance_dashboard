make_occupancy_plots <- function(data, healthboard, occupancy) {

  data %<>%
    filter(LocationName == healthboard)

  xaxis_plots[["title"]] <- "Date"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  if(occupancy == "hospital") {

    data %<>%
      mutate(y_axis = HospitalOccupancy)

    yaxis_plots[["title"]] <- "Number of people in hospital"

    p <- plot_ly(data, x = ~Date,
                 textposition = "none",
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Number of People in hospital</b>: ", format(HospitalOccupancy, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500)

  } else if(occupancy == "icu-less") {

    data %<>%
      mutate(y_axis = ICUOccupancy28OrLess)

    yaxis_plots[["title"]] <- "Number of people in icu (28 days or less)"

    p <- plot_ly(data, x = ~Date,
                 textposition = "none",
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Number of People in ICU (28 days or less)</b>: ", format(ICUOccupancy28OrLess, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500)

  } else if(occupancy == "icu-more") {

    data %<>%
      mutate(y_axis = ICUOccupancy28OrMore)

    yaxis_plots[["title"]] <- "Number of people in icu (more than 28 days)"

    p <- plot_ly(data, x = ~Date,
                 textposition = "none",
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Number of People in ICU (more than 28 days)</b>: ", format(ICUOccupancy28OrMore, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500)

  }

  p <- p %>%
    add_trace(y = ~y_axis,
              type = 'scatter', mode = 'lines',
              line = list(color = phs_colours("phs-blue")))  %>%
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

}


test <- make_occupancy_plots(Occupancy, healthboard = "Scotland", occupancy = "hospital")
test
