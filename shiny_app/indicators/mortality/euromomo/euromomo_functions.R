# Create MEM line chart
create_euromomo_mem_linechart <- function(data, 
                                          rate_dp = 2,
                                          seasons = NULL,
                                          value_variable = "ZScore",
                                          y_axis_title = "Z-score",
                                          reporting_delay = T) {
  
  # data <- Respiratory_Euromomo %>%
  #   filter(AgeGroup == "All Ages")
  
  # Add in a new row so that dashed line works
  new_row <- data %>%
    tail(4) %>%
    head(1) %>%
    mutate(ActivityLevelDelay = "Reporting delay",
           new_row = "Yes")
  
  # Combine
  data <- bind_rows(data, new_row) %>%
    arrange(Season, Weekord)
  
  # Rename value variable
  data <- data %>%
    rename(Value = value_variable) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  # If seasons not supplied, use two most recent seasons
  if(is.null(seasons)){
    seasons <- data %>%
      select(Season) %>%
      arrange(Season) %>%
      distinct() %>%
      tail(4)
    seasons <- seasons$Season
  }
  
  # Wrangle data
  data = data %>%
    filter(ISOWeek != 53) %>%
    filter(Season %in% seasons) %>%
    select(Season, ISOWeek, Weekord, Value, ActivityLevel, ActivityLevelDelay, LowThreshold, 
           MediumThreshold, HighThreshold, ExtraordinaryThreshold, new_row) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))
  
  # if(reporting_delay = T){
  #   data = data %>%
  #     mutate(Season = ifelse(ActivityLevelDelay == "Reporting delay",
  #                            "Reporting delay", Season))
  # }
  
  # Add in provisional marker
  data = data %>%
    mutate(Provisional = ifelse(ActivityLevelDelay == "Reporting delay" & is.na(new_row),
                                " (provisional) ", ""))
  
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  
  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  
  xaxis_plots[["showgrid"]] <- FALSE
  yaxis_plots[["showgrid"]] <- FALSE
  
  # Get thresholds
  baseline_max <- unique(data$LowThreshold)
  low_max <- unique(data$MediumThreshold)
  moderate_max <- unique(data$HighThreshold)
  high_max <- unique(data$ExtraordinaryThreshold)
  extraordinary_max <- max(pretty(data$Value), na.rm = T)
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Z-score: ", data$Value, data$Provisional,
                            "<br>", "Activity level: ", data$ActivityLevel, data$Provisional))
  
  # Update for reporting delay
  data = data %>%
    mutate(SeasonDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                           "Reporting delay", Season))
  # 
  # # Add in a new row so that dashed line works
  # new_row <- data %>%
  #   tail(4) %>%
  #   head(1) %>%
  #   mutate(SeasonDelay = "Reporting delay",
  #          Provisional = "")
  # 
  # data <- bind_rows(data, new_row)
  
  # Create plot
  mem_linechart = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend, 
            hoverinfo = "text",
            color = ~SeasonDelay,
            type="scatter",
            mode="lines",
            line = list(width = 5),
            linetype = ~SeasonDelay,
            linetypes = c("solid", "solid", "solid", "solid", "dot"),
            colors = euromomo_mem_line_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           shapes = list(
             list(type = "rect",
                  fillcolor = activity_level_colours[1],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = 0,
                  x1 = 52,
                  xref = "x",
                  y0 = 0,
                  y1 = baseline_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[2],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = 0,
                  x1 = 52,
                  xref = "x",
                  y0 = baseline_max,#+0.00001,
                  y1 = low_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[3],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = 0,
                  x1 = 52,
                  xref = "x",
                  y0 = low_max,#+0.00001,
                  y1 = moderate_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[4],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = 0,
                  x1 = 52,
                  xref = "x",
                  y0 = moderate_max,#+0.00001,
                  y1 = high_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[5],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = 0,
                  x1 = 52,
                  xref = "x",
                  y0 = high_max,#+0.00001,
                  y1 = extraordinary_max,
                  yref = "y",
                  layer = "below")
           ))
  
  # Add static legend
  mem_linechart <- mem_linechart %>%
    layout(
      images = list(  
        list(  
          source =  raster2uri(mem_legend),  
          xref = "paper",  
          yref = "paper",  
          x = 0.5,  
          y = -0.3,  
          sizex = 0.4,  
          sizey = 0.3,  
          xanchor="center",  
          yanchor="bottom" 
        )
      )) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(mem_linechart)
  
}


# Create MEM heatmaps
create_euromomo_mem_heatmap <- function(data, 
                               rate_dp = 2,
                               include_text_annotation = F,
                               text_annotation_dp = 1,
                               breakdown_variable = "AgeGroup",
                               heatmap_seasons = NULL,
                               value_variable = "ZScore") {
  
  data=Respiratory_Euromomo %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels),
           ActivityLevelDelay = factor(ActivityLevelDelay, levels = c(activity_levels,
                                                                      "Reporting delay")))
  
  # Rename HB/Age variable
  # Rename value variable
  data <- data %>%
    rename(Breakdown = breakdown_variable,
           Value = value_variable)
  
  # If seasons not supplied, use two most recent seasons
  if(is.null(heatmap_seasons)){
    heatmap_seasons <- data %>%
      select(Season) %>%
      arrange(Season) %>%
      distinct() %>%
      tail(2)
    heatmap_seasons <- heatmap_seasons$Season
  }
  
  # If Age, reverse order
  if(breakdown_variable == "AgeGroup"){
    data <- data %>%
      mutate(Breakdown = gsub(" years", "", Breakdown)) %>%
      mutate(Breakdown = factor(Breakdown, levels = rev(euromomo_mem_age_groups))) %>%
      mutate(Breakdown_hover = Breakdown)
    breakdown_hover <- "Age group: " 
  } else{
    if(breakdown_variable == "HBName"){
      data <- data %>%
        mutate(Breakdown_hover = Breakdown)
    } else{
      data <- data %>%
        mutate(Breakdown_hover = HBName)
    }
    breakdown_hover <- "NHS Health Board: "
  }
  
  # Breakdown of data
  data_breakdown <- unique(sort(data$Breakdown))
  
  # Add in provisional marker
  data = data %>%
    mutate(Provisional = ifelse(ActivityLevelDelay == "Reporting delay",
                                " (provisional) ", ""))
  
  # Data for previous season
  data_prev_season <- data %>%
    filter(Season == heatmap_seasons[1]) %>%
    mutate(Breakdown = factor(Breakdown)) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  # Ensure the correct colours are selected for activity levels in the data
  act_levels_prev_season <- as.numeric(unique(sort(data_prev_season$ActivityLevel)))
  activity_level_colours_prev_season <- activity_level_colours[act_levels_prev_season]
  
  # Create a heat map using Plotly
  heatmap_prev_season <- plot_ly(
    data = data_prev_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~as.numeric(ActivityLevelDelay),
    colors = activity_level_colours_prev_season,
    alpha = 0.5,
    showscale = FALSE,
    type = "heatmap",
    hovertext = ~ paste0("Season: ", unique(data_prev_season$Season), "<br>",
                         "Week number: ", ISOWeek, "<br>", 
                         breakdown_hover, Breakdown_hover, "<br>",
                         "Z-score: ", data$Value, data$Provisional, "<br>",
                         "Activity level: ", data$ActivityLevel, data$Provisional),
    hoverinfo = "text"
  ) %>%
    layout(
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 100, t = 5),
      title = "",
      xaxis = list(title = list(text = "Week number",
                                standoff = 10L),
                   ticktext = mem_isoweeks[c(TRUE, FALSE)], 
                   tickvals = mem_week_order[c(TRUE, FALSE)],
                   tickmode = "array",
                   showgrid = F,
                   visible = F,
                   dtick = 1),
      yaxis = list(title = "", autorange = "reversed",
                   ticktext = data_breakdown, 
                   tickvals = c(1:length(data_breakdown)),
                   tickmode = "array",
                   dtick = 1,
                   showgrid = F),
      shapes = apply(expand.grid(x = c(0.5:51.5, (length(data_breakdown)-0.5):(length(data_breakdown)+0.5)), y = c(1.5:(length(data_breakdown)-0.5), 0.5:(length(data_breakdown)-0.5))), 1, function(x) add_cell_border(x[1], x[1]+1, x[2], x[2]+1,
                                                                                                                                                                                                                        border_col = phs_colours("phs-liberty-10")))
    ) %>%
    layout(
      annotations = list(
        x = 53,
        y = length(data_breakdown)/2,
        text = ~Season,
        showarrow = F,
        textangle = 90,
        font = list(size = 14),
        height = 14,
        xanchor = "center",
        yanchor = "middle"
      )
    )
  
  if(include_text_annotation){
    
    heatmap_prev_season <- heatmap_prev_season %>%
      layout(
        annotations = list(
          x = ~Weekord,
          y = ~as.numeric(Breakdown),
          text = ~round_half_up(Value, text_annotation_dp),
          font = list(size = 6, color = "white"),
          showarrow = FALSE
        )
      )
    
  }
  
  # Data for current season
  data_curr_season <- data %>%
    filter(Season == heatmap_seasons[2]) %>%
    mutate(Breakdown = factor(Breakdown)) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  # Ensure the correct colours are selected for activity levels in the data
  act_levels_curr_season <- as.numeric(unique(sort(data_curr_season$ActivityLevel)))
  activity_level_colours_curr_season <- c(activity_level_colours[act_levels_curr_season],
                                          "#a6a6a6")
  
  # Create a heat map using Plotly
  heatmap_curr_season <- plot_ly(
    data = data_curr_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~as.numeric(ActivityLevelDelay),
    colors = activity_level_colours_curr_season,
    alpha = 0.5,
    showscale = FALSE,
    type = "heatmap",
    hovertext = ~ paste0("Season: ", unique(data_curr_season$Season), "<br>",
                         "Week number: ", ISOWeek, "<br>", 
                         breakdown_hover, Breakdown_hover, "<br>",
                         "Z-score: ", Value, Provisional, "<br>",
                         "Activity level: ", ActivityLevel, Provisional),
    hoverinfo = "text"
  ) %>%
    layout(
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 100, t = 5),
      title = "",
      xaxis = list(title = list(text = "Week number",
                                standoff = 10L),
                   ticktext = mem_isoweeks[c(TRUE, FALSE)], 
                   tickvals = mem_week_order[c(TRUE, FALSE)],
                   tickmode = "array",
                   dtick = 1,
                   showgrid = F),
      yaxis = list(showline = FALSE,
                   showaxisticks = F,
                   title = "", 
                   autorange = "reversed",
                   ticktext = data_breakdown, 
                   dtick = 1,
                   tickvals = c(1:length(data_breakdown)),
                   showgrid = F),
      shapes = apply(expand.grid(x = c(0.5:51.5, (length(data_breakdown)-0.5):(length(data_breakdown)+0.5)), y = c(1.5:(length(data_breakdown)-0.5), 0.5:(length(data_breakdown)-0.5))), 1, function(x) add_cell_border(x[1], x[1]+1, x[2], x[2]+1,
                                                                                                                                                                                                                        border_col = phs_colours("phs-liberty-10")))
    ) %>%
    layout(
      annotations = list(
        x = 53,
        y = length(data_breakdown)/2,
        text = ~Season,
        showarrow = F,
        textangle = 90,
        font = list(size = 14),
        height = 14,
        xanchor = "center",
        yanchor = "middle"
      )
    )
  
  if(include_text_annotation){
    
    heatmap_curr_season <- heatmap_curr_season %>%
      layout(
        annotations = list(
          x = ~Weekord,
          y = ~as.numeric(Breakdown),
          text = ~round_half_up(Value, text_annotation_dp),
          font = list(size = 6, color = "white"),
          showarrow = FALSE
        )
      )
    
  }
  
  # Add static legend
  heatmap_curr_season <- heatmap_curr_season %>%
    layout(
      images = list(  
        list(  
          source =  raster2uri(mem_legend),  
          xref = "paper",  
          yref = "paper",  
          x = 0.5,  
          y = -0.6,  
          sizex = 0.4,  
          sizey = 0.3,  
          xanchor="center",  
          yanchor="bottom" 
        )
      ))
  
  # Arrange the heatmaps in a subplot (one above the other)
  subplot_heatmap <- subplot(
    heatmap_prev_season, heatmap_curr_season,
    nrows = 2,
    titleX = TRUE,
    titleY = TRUE # Display the Y-axis title for the subplot
  ) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(subplot_heatmap)
  
}
