make_reported_cases_plot <- function(data){


  data %<>%
    mutate(Date = convert_opendata_date(Date))

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Date"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  p <- plot_ly(data, x = ~Date,
               textposition = "none",
               text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                              "<b>Reported cases</b>: ", format(NumberCasesPerDay, big.mark=","), "\n",
                              "<b>7 day average</b>: ", format(round_half_up(SevenDayAverage, 1), big.mark=","), "\n"),
               hovertemplate = "%{text}",
               height = 500)%>%

    add_lines(y = ~NumberCasesPerDay,
             line = list(color = phs_colours("phs-blue-30")),
             name = 'Reported cases') %>%

    add_lines(y = ~SevenDayAverage, name = '7 day average',
              line = list(color = "navy",
                          dash = "dash",
                          width = 2)) %>%


    # Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                             ycol = "NumberCasesPerDay",
                             xs= c("2022-01-06", "2022-05-01"),
                             notes=c("From 5 Jan cases include PCR + LFD",
                                     "Change in testing policy on 1 May"),
                             colors=c(phs_colours("phs-rust"),
                                      phs_colours("phs-teal"))) %>%


    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}


make_weekly_reported_cases_plot <- function(data){


  data %<>%
    mutate(WeekEnding = convert_opendata_date(WeekEnding))

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Week ending"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  p <- plot_ly(data, x = ~WeekEnding,
               textposition = "none",
               text = ~paste0("<b>Week ending</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                              "<b>Reported cases</b>: ", format(NumberCasesPerWeek, big.mark=","), "\n"),
               hovertemplate = "%{text}",
               height = 500)%>%

    add_lines(y = ~NumberCasesPerWeek,
              line = list(color = "navy"),
              name = 'Reported cases') %>%


    # Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                        ycol = "NumberCasesPerWeek",
                        xs= c("2022-01-09", "2022-05-01"),
                        notes=c("From 5 Jan cases include PCR + LFD",
                                "Change in testing policy on 1 May"),
                        colors=c(phs_colours("phs-rust"),
                                 phs_colours("phs-teal"))) %>%


    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}



make_ons_cases_plot <- function(data){


  data %<>%
    filter(Nation == "Scotland") %>%
    mutate(EndDate = convert_opendata_date(EndDate),
           ErrorBarHeight = UpperCIOfficialEstimate - LowerCIOfficialEstimate,
           ErrorBarLowerHeight = OfficialPositivityEstimate - LowerCIOfficialEstimate)

  yaxis_plots[["title"]] <- "Official positivity estimate (%)"
  xaxis_plots[["title"]] <- "Week ending"


  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"

  p <- plot_ly(data, x = ~EndDate,
               textposition = "none",
               text = ~paste0("<b>Week ending</b>: ", format(EndDate, "%d %b %y"), "\n",
                              "<b>Official positivity estimate</b>: ", round_half_up(OfficialPositivityEstimate,1), "%\n",
                              "<b>Estimated prevalence</b>: ", EstimatedRatio, "\n",
                              "<b>Estimated cases</b>: ", format(EstimatedCases, big.mark=",")),
               hovertemplate = "%{text}",
               height = 500)%>%

    add_lines(y = ~OfficialPositivityEstimate,
              line = list(color = phs_colours("phs-blue-30")),
              name = 'Official positivity estimate',
              error_y = ~list(array = ErrorBarHeight/2,
                              arrayminus = ErrorBarLowerHeight,
                              symmetric = FALSE,
                              width = 0.5,
                              color = "navy"),
              marker = list(color = "navy",
                            size = 5)) %>%

    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}

# make_r_number_plot <- function(data){
#
#
#   data %<>%
#     mutate(Date = convert_opendata_date(Date),
#            ErrorBarHeight = UpperBound - LowerBound,
#            ErrorBarCentre = (UpperBound + LowerBound)/2)
#
#
#   yaxis_plots[["title"]] <- "Estimated R number"
#   xaxis_plots[["title"]] <- "Date reporting"
#
#
#   xaxis_plots[["rangeslider"]] <- list(type = "date")
#   yaxis_plots[["fixedrange"]] <- FALSE
#
#   p <- plot_ly(data, x = ~Date,
#                textposition = "none",
#                text = ~paste0("<b>Date reporting</b>: ", format(Date, "%d %b %y"), "\n",
#                               "<b>Lower estimate</b>: ", LowerBound, "\n",
#                               "<b>Upper estimate</b>: ", UpperBound),
#                hovertemplate = "%{text}",
#                height = 500)%>%
#
#     add_segments(x = ~(min(Date)- months(1)),
#                  xend = ~(max(Date) + months(1)),
#                  y = 1,
#                  yend = 1,
#                  showlegend = FALSE,
#                  line = list(color = phs_colours("phs-purple"), width = 1)) %>%
#
#     add_lines(y = ~ErrorBarCentre,
#               line = list(color = phs_colours("phs-purple"), width = 0),
#               name = 'Estimated R number',
#               showlegend = FALSE,
#               error_y = ~list(array = ErrorBarHeight/2,
#                               #symmetric = TRUE,
#                               width = 0.5,
#                               color = phs_colours("phs-purple"))) %>%
#
#     layout(margin = list(b = 80, t = 5),
#            yaxis = yaxis_plots, xaxis = xaxis_plots,
#            legend = list(x = 100, y = 0.5),
#            paper_bgcolor = phs_colours("phs-liberty-10"),
#            plot_bgcolor = phs_colours("phs-liberty-10")) %>%
#
#     config(displaylogo = FALSE, displayModeBar = TRUE,
#            modeBarButtonsToRemove = bttn_remove)
#
#   return(p)
#
# }

make_wastewater_plot <- function(data){


  data %<>%
    mutate(Date = convert_opendata_date(Date))

  yaxis_plots[["title"]] <- "Wastewater viral RNA (Mgc/p/d)"
  xaxis_plots[["title"]] <- "Date of sample"


  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data, x = ~Date,
               textposition = "none",
               text = ~paste0("<b>Date of sample</b>: ", format(Date, "%d %b %y"), "\n",
                              "<b>COVID-19 wastewater level (Mgc/p/d)</b>: ", signif(WastewaterSevenDayAverageMgc,3), "\n"),
               hovertemplate = "%{text}",
               height = 500)%>%

    add_lines(y = ~WastewaterSevenDayAverageMgc,
              line = list(color = "navy"),
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
