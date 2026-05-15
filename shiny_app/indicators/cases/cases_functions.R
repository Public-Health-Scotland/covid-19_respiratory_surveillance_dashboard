make_reported_cases_plot <- function(data){


  data %<>%
    mutate(Date = convert_opendata_date(Date))

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Date"

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
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

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
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



# make_ons_cases_plot <- function(data){
# 
# 
#   data %<>%
#     filter(Nation == "Scotland") %>%
#     mutate(EndDate = convert_opendata_date(EndDate),
#            ErrorBarHeight = UpperCIOfficialEstimate - LowerCIOfficialEstimate,
#            ErrorBarLowerHeight = OfficialPositivityEstimate - LowerCIOfficialEstimate)
# 
#   yaxis_plots[["title"]] <- "Official positivity estimate (%)"
#   xaxis_plots[["title"]] <- "Week ending"
# 
# 
#   #xaxis_plots[["rangeslider"]] <- list(type = "date")
#   yaxis_plots[["fixedrange"]] <- FALSE
#   yaxis_plots[["ticksuffix"]] <- "%"
# 
#   p <- plot_ly(data, x = ~EndDate,
#                textposition = "none",
#                text = ~paste0("<b>Week ending</b>: ", format(EndDate, "%d %b %y"), "\n",
#                               "<b>Official positivity estimate</b>: ", round_half_up(OfficialPositivityEstimate,1), "%\n",
#                               "<b>Estimated prevalence</b>: ", EstimatedRatio, "\n",
#                               "<b>Estimated cases</b>: ", format(EstimatedCases, big.mark=",")),
#                hovertemplate = "%{text}",
#                height = 500)%>%
# 
#     add_lines(y = ~OfficialPositivityEstimate,
#               line = list(color = phs_colours("phs-blue-30")),
#               name = 'Official positivity estimate',
#               error_y = ~list(array = ErrorBarHeight/2,
#                               arrayminus = ErrorBarLowerHeight,
#                               symmetric = FALSE,
#                               width = 0.5,
#                               color = "navy"),
#               marker = list(color = "navy",
#                             size = 5)) %>%
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


  #xaxis_plots[["rangeslider"]] <- list(type = "date")
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


create_covid_line_chart <- function(data,
                                    rate_dp = 2,
                                    seasons = NULL,
                                    value_variable = "RatePer100000",
                                    y_axis_title = "Rate per 100,000 population") {
  
  # Rename value variable
  data <- data %>%
    rename(Value = !!value_variable) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  # Select recent seasons if not provided
  if (is.null(seasons)) {
    seasons <- data %>%
      select(Season) %>%
      arrange(Season) %>%
      distinct() %>%
      tail(3) %>%
      pull(Season)
  }
  
  # Wrangle data
  data <- data %>%
    filter(ISOWeek != 53) %>%
    filter(Season %in% seasons) %>%
    select(Season, ISOWeek, Weekord, Value) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.numeric(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))
  
  # Axis settings
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(-1, 52)
  xaxis_plots[["showgrid"]] <- TRUE
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  yaxis_plots[["tickformat"]] <- ""
  yaxis_plots[["showgrid"]] <- TRUE
  
  # Tooltip
  tooltip_trend <- paste0("Season: ", data$Season,
                          "<br>Week number: ", data$ISOWeek,
                          "<br>Rate: ", data$Value)
  
  # Current season data
  data_curr_season <- data %>%
    filter(Season == seasons[length(seasons)])
  
  # Create plot
  simple_linechart <- data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type = "scatter",
            mode = "lines",
            line = list(width = 5),
            colors = mem_line_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           
           legend = list(
             x = 1.05,        
             y = 0.8,        
             xanchor = "left",
             yanchor = "top"
           )) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  # Optional: Add marker for first week of new season
  if (nrow(data_curr_season) == 1) {
    simple_linechart <- simple_linechart %>%
      add_trace(data = data_curr_season,
                x = ~ISOWeek,
                y = ~Value,
                showlegend = FALSE,
                type = "scatter",
                mode = "markers",
                marker = list(color = "#FF0000"),
                text = tooltip_trend,
                hoverinfo = "text")
  }
  
  return(simple_linechart)
}

# Create pathogen age Adms line chart
create_positivity_age_chart <- function(data){
  
  # data <- Respiratory_Pathogens_Test_Positivity_by_Age %>%
  #   filter(pathogen == "Influenza (A or B)") %>%
  #   filter(season == "2020/2021")
  
  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(input$test_pos_cov_age, 1, 4), "-12-31"))) == 53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }

  plot_data <- data %>%  
    mutate(WeekNumber = ISOweek,
           WeekNumber = factor(WeekNumber, levels = week_order), 
           agegrp = factor(agegrp, levels = c("Under 1", "1-4", "5-14",
                                                  "15-44", "45-64", "65-74",  "Over 75", "All ages"),
                             labels = c("Under 1", "1 to 4", "5 to 14",
                                        "15 to 44", "45 to 64", "65 to 74",  "Over 75", "All ages"))) %>%
    arrange(WeekNumber)

  # Text for tooltip
  tooltip_trend <- paste0(#"Season: ", plot_data$Season, "<br>",
    "Week number: ", plot_data$WeekNumber, "<br>",
    "Age group: ", plot_data$agegrp, "<br>",
    "Test positivity: ", round(plot_data$positivity_percentage, 1), "%", "<br>")
  
  xaxis_plots[["title"]] <- 'Week Number'
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["dtick"]] <- 2
  #yaxis_plots[["dtick"]] <- 1
  yaxis_plots[["tickformat"]] <- NULL
  xaxis_plots[["range"]] <- list(-0.5, 52.5)
  
  
  ## Add as two separate traces to enable 'All ages' to be shown as the default trace
  p <- plot_ly(plot_data) %>%
    add_trace(data = plot_data[plot_data$agegrp!="All ages",],
              x = ~WeekNumber, y = ~positivity_percentage, split = ~agegrp, 
              type="scatter", mode="lines",
              color=~agegrp,
              colors=phs_colours(c("phs-blue", "phs-rust", "phs-green",
                                   "phs-purple", "phs-blue-50", "phs-magenta", "phs-teal")),
              # hovertemplate = paste0('<b>Week number</b>: %{x}<br>',
              #                        '<b>Age group</b>: %{text}<br>',
              #                        '<b>Test positivity</b>: %{y}')
              textposition = "none",
              text = tooltip_trend[plot_data$agegrp!="All ages"],
              hoverinfo = "text",
              visible = "legendonly"
    ) %>%
    add_trace(data = plot_data[plot_data$agegrp=="All ages",],
              x = ~WeekNumber, y = ~positivity_percentage, split = ~agegrp, 
              type="scatter", mode="lines",
              color=~agegrp,
              colors=phs_colours(c("phs-graphite-50")),
              # hovertemplate = paste0('<b>Week number</b>: %{x}<br>',
              #                        '<b>Age group</b>: %{text}<br>',
              #                        '<b>Test positivity</b>: %{y}')
              textposition = "none",
              text = tooltip_trend[plot_data$agegrp=="All ages"],
              hoverinfo = "text"
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           #xaxis = list(range = list(-0.5, 52.5)),
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  # For first week of new season (week 40), add in a marker
  if(length(unique(plot_data$ISOweek)) == 1){
    
    p <- p %>%
      add_trace(data = plot_data[plot_data$agegrp!="All ages",],
                x = ~WeekNumber,
                y = ~positivity_percentage,
                showlegend = F,
                color = ~agegrp,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend[plot_data$agegrp!="All ages"],
                hoverinfo = "text",
                visible = "legendonly") %>% 
      add_trace(data = plot_data[plot_data$agegrp=="All ages",],
                x = ~WeekNumber,
                y = ~positivity_percentage,
                showlegend = F,
                color = ~agegrp,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend[plot_data$agegrp=="All ages"],
                hoverinfo = "text")     }
  
  return(p)
  
}
