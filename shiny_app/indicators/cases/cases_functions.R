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
 
  # ### Create test data for week 53
  # if(unique(data$season == "2025/2026")){
  #   
  #   data_2526_wk53 <- data %>%
  #     filter(ISOweek == 52) %>%
  #     mutate(ISOweek = 53)
  #   
  #   data <- data %>%
  #     bind_rows(data_2526_wk53) %>%
  #     arrange(season, year, ISOweek)
  #   
  # }
  # ################################
  
  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(unique(data$season), 1, 4), "-12-31"))) == 53 | max(data$ISOweek) == 53){
    
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
  xaxis_plots[["range"]] <- list(-0.5, max(week_order)-0.5)
  
  
  ## Add as two separate traces to enable 'All ages' to be shown as the default trace
  p <- plot_ly(plot_data) %>%
    add_trace(data = plot_data[plot_data$agegrp!="All ages",],
              x = ~WeekNumber, y = ~positivity_percentage, split = ~agegrp, 
              type="scatter", mode="lines",
              color=~agegrp,
              colors=cases_agegpp_colours,
              # colors=phs_colours(c("phs-blue", "phs-rust", "phs-green",
              #                      "phs-purple", "phs-blue-50", "phs-magenta", "phs-teal")),
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
