# Create MEM line chart
create_euromomo_mem_linechart <- function(data, 
                                          rate_dp = 1,
                                          seasons = NULL,
                                          value_variable = "ZScore",
                                          y_axis_title = "Z-score") {
  
  data <- Respiratory_Euromomo %>%
    filter(AgeGroup == "All Ages")
  
  # Test data
  data_2526 <- data %>%
    filter(Season == "2025/26") %>%
    mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
  
  data_2526_wk53 <- data_2526 %>%
    filter(ISOWeek == 52) %>%
    mutate(ISOWeek = 53,
           Weekord = 14)
  
  data <- data %>%
    filter(Season != "2025/26") %>%
    bind_rows(data_2526) %>%
    bind_rows(data_2526_wk53) %>%
    arrange(Season, Year, ISOWeek)
  
  rate_dp = 1
  seasons = NULL
  value_variable = "ZScore"
  y_axis_title = "Z-score"
  
  # Drop week 53 if required
  if(!include_week_53){
    
    data = data %>%
      filter(ISOWeek != 53)
    
  }
  
  # Latest reporting week
  latest_week <- data %>%
    tail(1) %>%
    .$ISOWeek %>%
    as.character()
  
  # Add in a new row so that dashed line works (not needed in week 42)
  if(latest_week != 42){
    new_row <- data %>%
      tail(4) %>%
      head(1) %>%
      mutate(ActivityLevelDelay = "Reporting delay",
             new_row = "Yes")
  } else{
    new_row <- data %>%
      tail(0) %>%
      mutate(new_row = "")
  }
  
  # Combine
  data <- bind_rows(data, new_row) %>%
    arrange(Season, Weekord)
  
  # Rename value variable
  data <- data %>%
    rename(Value = value_variable) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
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
    #filter(ISOWeek != 53) %>%
    filter(Season %in% seasons) %>%
    select(Season, ISOWeek, Weekord, Value, ActivityLevel, ActivityLevelDelay, LowThreshold, 
           MediumThreshold, HighThreshold, ExtraordinaryThreshold, new_row) %>%
    arrange(Season, Weekord) 
  
  # # Add in missing week 53 if required (will create gaps in graphs)
  # if(include_week_53){
  # 
  #   # Season with week 53
  #   data_week_53 <- data %>%
  #     filter(ISOWeek == 53)
  # 
  #   # If no rows, add in for all seasons
  #   if(nrow(data_week_53) == 0){
  # 
  #     # Select season that needs updated
  #     data_updated <- data %>%
  #       mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))
  # 
  #   } else{
  # 
  #     # Select season that needs updated
  #     data_updated <- data %>%
  #       filter(Season != unique(data_week_53$Season)) %>%
  #       mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))
  # 
  #   }
  # 
  #   # Create week 53 data
  #   data_updated_wk53 <- data_updated %>%
  #     filter(ISOWeek == 52) %>%
  #     mutate(ISOWeek = 53,
  #            Weekord = 14,
  #            Value = NA,
  #            ActivityLevel = "NA")
  # 
  #   # Add data in
  #   data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
  #     arrange(Season, Weekord)
  # 
  #   # Update data
  #   data <- data %>%
  #     filter(!Season %in% unique(data_updated$Season)) %>%
  #     bind_rows(data_updated) %>%
  #     mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
  #     arrange(Season, Weekord)
  # 
  # }
  
  data = data %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))
  
  # Add in reporting delay marker
  data = data %>%
    mutate(ReportingDelay = ifelse(ActivityLevelDelay == "Reporting delay" & is.na(new_row),
                                   " (reporting delay) ", ""))
  
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(0,max(mem_isoweeks))
  
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
  extraordinary_max <- max(pretty(c(data$Value, high_max)), na.rm = T)
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Z-score: ", data$Value, data$ReportingDelay,
                            "<br>", "Activity level: ", data$ActivityLevel, data$ReportingDelay))
  
  # Update for reporting delay
  data = data %>%
    mutate(SeasonDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                                paste0(Season, " (Reporting delay)"), Season))
  
  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])
  
  week_template <- data.frame(seq(1:max(mem_isoweeks)))
  names(week_template) <- "ISOWeek"
  week_template <- week_template %>%
    mutate(ISOWeek = factor(ISOWeek, levels = c(40:max(mem_isoweeks),1:39)))
  
  # If latest week isn't week 40 or 41
  if(!latest_week %in% c("40", "41", "42")){
    
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
#              line = list(width = 5),
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
            y = -0.35,  
            sizex = 0.4,  
            sizey = 0.3,  
            xanchor="center",  
            yanchor="bottom" 
          )
        ),
        legend = list(y = 0.5,
                      yanchor = 'middle')) %>%
      
      config(displaylogo = FALSE, displayModeBar = TRUE,
             modeBarButtonsToRemove = bttn_remove)
    
    # If latest week is 43
    if(latest_week == "43"){
      
      mem_linechart <- mem_linechart %>%
        add_trace(data = data %>% filter(Season == seasons[length(seasons)] & 
                                           ISOWeek == "40" & is.na(new_row)),
                  x = ~ISOWeek,
                  y = ~Value,
                  showlegend = F,
                  color = ~SeasonDelay,
                  colors = "#12436D",
                  type = "scatter",
                  mode = 'markers',
                  textposition = "none",
                  text = tooltip_trend[length(tooltip_trend)-4],
                  hoverinfo = "text")
      
    }
  }
  
  # If latest week is week 40
  if(latest_week %in% c("40", "41")){
    
    
    # Create plot
    mem_linechart = data %>%
      plot_ly(x = ~ISOWeek,
              y = ~Value,
              textposition = "none",
              #text = tooltip_trend[-length(tooltip_trend)],
              text = tooltip_trend,
              hoverinfo = "text",
              color = ~SeasonDelay,
              type="scatter",
              mode="lines",
              line = list(width = 5),
              linetype = ~SeasonDelay,
              linetypes = c("solid", "solid", "solid", "dot", "dot"),
              colors = c("#3F085C","#F46A25", "#801650", "#801650", "#12436D")) %>%
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
            y = -0.35,  
            sizex = 0.4,  
            sizey = 0.3,  
            xanchor="center",  
            yanchor="bottom" 
          )
        ),
        legend = list(y = 0.5,
                      yanchor = 'middle')) %>%
      
      config(displaylogo = FALSE, displayModeBar = TRUE,
             modeBarButtonsToRemove = bttn_remove)
    
    if(latest_week == "40"){
      
      mem_linechart <- mem_linechart %>%
        add_trace(data = data_curr_season,
                  x = ~ISOWeek,
                  y = ~Value,
                  showlegend = F,
                  color = ~SeasonDelay,
                  colors = "#12436D",
                  type = "scatter",
                  mode = 'markers',
                  textposition = "none",
                  text = tooltip_trend,
                  hoverinfo = "text")
    }
    
  }
  
  # If latest week is week 42
  if(latest_week == "42"){
    
    # Create plot
    mem_linechart = data %>%
      plot_ly(x = ~ISOWeek,
              y = ~Value,
              textposition = "none",
              #text = tooltip_trend[-length(tooltip_trend)],
              text = tooltip_trend,
              hoverinfo = "text",
              color = ~SeasonDelay,
              type="scatter",
              mode="lines",
              line = list(width = 5),
              linetype = ~SeasonDelay,
              linetypes = c("solid", "solid", "solid", "dot"),
              colors = c("#3F085C","#F46A25", "#801650", "#12436D")) %>%
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
        ),
        legend = list(y = 0.5,
                      yanchor = 'middle')) %>%
      
      config(displaylogo = FALSE, displayModeBar = TRUE,
             modeBarButtonsToRemove = bttn_remove)
    
  }
  
  return(mem_linechart)
  
}


# Create MEM heatmaps
create_euromomo_mem_heatmap <- function(data, 
                                        rate_dp = 1,
                                        include_text_annotation = F,
                                        text_annotation_dp = 1,
                                        breakdown_variable = "AgeGroup",
                                        heatmap_seasons = NULL,
                                        value_variable = "ZScore") {
  
  data <-  Respiratory_Euromomo %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels),
           ActivityLevelDelay = factor(ActivityLevelDelay, levels = c(activity_levels,
                                                                      "Reporting delay")))
  
  rate_dp = 1
  include_text_annotation = F
  text_annotation_dp = 1
  breakdown_variable = "AgeGroup"
  heatmap_seasons = NULL
  value_variable = "ZScore"
  
  data_2526 <- data %>%
    filter(Season == "2025/26") %>%
    mutate(Weekord = ifelse(ISOWeek >= 1 & ISOWeek <= 39, Weekord+1, Weekord))
  
  test <- data_2526 %>%
    filter(ISOWeek == 52) %>%
    mutate(ISOWeek = 53,
           Weekord = 14)
  
  data_2526 <- bind_rows(data_2526, test) %>%
    arrange(Weekord)
  
  data <- data %>%
    filter(Season != "2025/26") %>%
    bind_rows(data_2526)

  rate_dp = 1
  include_text_annotation = FALSE
  text_annotation_dp = 1
  breakdown_variable = "AgeGroup"
  heatmap_seasons = NULL
  value_variable = "ZScore"

  #heatmap_seasons = c("2019/2020", "2020/2021")
  
  # Latest reporting week
  latest_week <- data %>%
    tail(1) %>%
    .$ISOWeek %>%
    as.character()
  
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
  
  # Update if week 53 is present
  if(include_week_53){

    # Season with week 53
    data_week_53 <- data %>%
      filter(Season %in% heatmap_seasons) %>%
      filter(ISOWeek == 53)

    # If no rows, add in for all seasons
    if(nrow(data_week_53) == 0){

      # Select season that needs updated
      data_updated <- data %>%
        filter(Season %in% heatmap_seasons) %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))

    } else{

      # Select season that needs updated
      data_updated <- data %>%
        filter(Season %in% heatmap_seasons & Season != unique(data_week_53$Season)) %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))

    }

    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOWeek == 52) %>%
      mutate(ISOWeek = 53,
             Weekord = 14,
             WeekBeginning = NA,
             WeekEnding = NA,
             Value = NA,
             ActivityLevel = "NA",
             ActivityLevelDelay = "NA")

    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Weekord, Breakdown)

    # Update data
    data <- data %>%
      filter(!Season == unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
      mutate(ActivityLevelDelay = factor(ActivityLevelDelay, levels = c(activity_levels, "Reporting delay")))

  }
  
  # Add in reporting delay marker
  data = data %>%
    mutate(ReportingDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                                   " (reporting delay) ", ""))
  
  # Data for previous season
  data_prev_season <- data %>%
    filter(Season == heatmap_seasons[1]) %>%
    mutate(Breakdown = factor(Breakdown)) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  # Ensure the correct colours are selected for activity levels in the data
  act_levels_prev_season <- unique(sort(data_prev_season$ActivityLevelDelay))
  act_levels_prev_season_numeric <- as.numeric(act_levels_prev_season)
  activity_level_colours_prev_season <- euromomo_activity_level_colours[act_levels_prev_season_numeric]
  
  data_prev_season <- data_prev_season %>%
    mutate(ActivityLevelDelay = factor(ActivityLevelDelay, levels = act_levels_prev_season))
  
  
  
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
                         "Z-score: ", Value, ReportingDelay, "<br>",
                         "Activity level: ", ActivityLevel, ReportingDelay),
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
      shapes = apply(expand.grid(x = c(0.5:(max(mem_isoweeks)-0.5), (length(data_breakdown)-0.5):(length(data_breakdown)+0.5)), y = c(1.5:(length(data_breakdown)-0.5), 0.5:(length(data_breakdown)-0.5))), 1, function(x) add_cell_border(x[1], x[1]+1, x[2], x[2]+1,
                                                                                                                                                                                                                        border_col = phs_colours("phs-liberty-10")))
    ) %>%
    layout(
      annotations = list(
        x = max(mem_isoweeks)+1,
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
  act_levels_curr_season <- unique(sort(data_curr_season$ActivityLevelDelay))
  act_levels_curr_season_numeric <- as.numeric(act_levels_curr_season)
  activity_level_colours_curr_season <- euromomo_activity_level_colours[act_levels_curr_season_numeric]
  
  data_curr_season <- data_curr_season %>%
    mutate(ActivityLevelDelay = factor(ActivityLevelDelay, levels = act_levels_curr_season))
  
  
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
                         "Z-score: ", Value, ReportingDelay, "<br>",
                         "Activity level: ", ActivityLevel, ReportingDelay),
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
          source =  raster2uri(euromomo_age_mem_legend),  
          xref = "paper",  
          yref = "paper",  
          x = 0.5,  
          y = -0.7,  
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
