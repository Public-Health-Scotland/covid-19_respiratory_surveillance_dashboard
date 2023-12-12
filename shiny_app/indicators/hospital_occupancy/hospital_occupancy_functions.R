# function for occupancy or ICU plot, ICU data now archived but code retained as runs old data in the archive
make_occupancy_plots <- function(data, occupancy) {

  data%<>%
    filter(HealthBoardQF== "d") # filter to Scotland
    
  xaxis_plots[["title"]] <- "Week ending"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  if(occupancy == "hospital") {

    data %<>%
      mutate(y_axis = SevenDayAverage)

    yaxis_plots[["title"]] <- "Average number of people in hospital"

    p <- plot_ly(data, x = ~WeekEnding,
                 textposition = "none",
                 colors = phs_colours("phs-magenta"),
                 text = ~paste0("<b>WeekEnding</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                              #  "<b>Number of People in hospital</b>: ", format(HospitalOccupancy, big.mark=","), "\n",
                                "<b>7 day average number of people in hospital</b>: ", format(SevenDayAverage, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500)%>%
      add_lines(y = ~SevenDayAverage, name = '7 day average',
                line = list(color = "navy",
                           # dash = "dash",
                            width = 2)) %>%
      add_lines_and_notes(dataframe = data,
                          ycol = "HospitalOccupancy",
                          xs= c("2023-05-08"),
                          notes=c("Change to inpatient definition from 08 May 2023 (max number 10 days)"),
                          colors=c(phs_colours("phs-rust"))) %>% #phs_colours("phs-purple") 
      layout(legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'))



  } else if(occupancy == "icu") {

    data %<>%
      mutate(y_axis = SevenDayAverage)

    yaxis_plots[["title"]] <- "7 day average number of people in ICU"

    p <- plot_ly(data, x = ~Date, y = ~y_axis,
                 textposition = "none",
                 color = ~ICULengthOfStay,
                 colors = c(phs_colours("phs-blue"), "navy"),
                 text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                                "<b>Length of stay in ICU</b>: ", ICULengthOfStay, "\n",
                                "<b>7 day average number of People in ICU</b>: ", format(SevenDayAverage, big.mark=","), "\n"),
                 hovertemplate = "%{text}",
                 height = 500,
                 linetype = ~ICULengthOfStay,
                 linetypes = c("dash", "solid")) %>%
      add_trace(type = 'scatter', mode = 'lines') %>%
      layout(legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'))
  }

  p <- p %>%
    #add_trace(type = 'scatter', mode = 'lines') %>%
    #           line = list(color = phs_colours("phs-magenta")))  %>%
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

}




