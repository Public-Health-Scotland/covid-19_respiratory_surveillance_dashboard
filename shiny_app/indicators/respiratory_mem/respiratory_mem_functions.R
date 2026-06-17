# Functions that create MEM heatmaps and line charts

# Function that rounds a value to nearest 10
# roundUp <- function(x,to=10)
# {
#   to*(x%/%to + as.logical(x%%to))
# }

# Function to add border around each box
add_cell_border <- function(x0, x1, y0, y1, border_col = "white") {
  list(
    type = "rect",
    x0 = x0,
    x1 = x1,
    y0 = y0,
    y1 = y1,
    line = list(color = border_col, width = 1)
  )
}

# Create MEM line chart
create_mem_linechart <- function(data,
                                 rate_dp = 1,
                                 seasons = NULL,
                                 value_variable = "RatePer100000",
                                 y_axis_title = "Rate per 100,000 population") {
  
  # ### Create test data
  # data_2526 <- data %>%
  #   filter(Season == "2025/2026" | Season == "2025/26") %>%
  #   mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOWeek == 52) %>%
  #   mutate(ISOWeek = 53,
  #          Weekord = 14)
  # 
  # data <- data %>%
  #   filter(Season != "2025/2026" & Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, Year, ISOWeek)
  # #####################
  
  # Rename value variable
  data <- data %>%
    rename(Value = value_variable) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
  seasons <- data %>%
    select(Season) %>%
    arrange(Season) %>%
    distinct() %>%
    tail(6)
  seasons <- seasons$Season
  
  # Drop week 53 if required
  if(!include_week_53){
    
    data = data %>%
      filter(ISOWeek != 53)
    
  }

  # Wrangle data
  data = data %>%
    filter(Season %in% seasons) %>%
    select(Season, ISOWeek, Weekord, Value, ActivityLevel, LowThreshold,
           MediumThreshold, HighThreshold, VeryHighThreshold) %>%
    arrange(Season, Weekord)
  
  # Add in missing week 53 if required (will create gaps in graphs)
  if(include_week_53 & non_week_53_gap){

    # Season with week 53
    data_week_53 <- data %>%
      filter(ISOWeek == 53)

    # If no rows, add in for all seasons
    if(nrow(data_week_53) == 0){

      # Select season that needs updated
      data_updated <- data %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))

    } else{

      # Select season that needs updated
      data_updated <- data %>%
        filter(Season != unique(data_week_53$Season)) %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord + 1, Weekord))

    }

    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOWeek == 52) %>%
      mutate(ISOWeek = 53,
             Weekord = 14,
             Value = NA,
             ActivityLevel = "NA")

    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Season, Weekord)

    # Update data
    data <- data %>%
      filter(!Season %in% unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
      arrange(Season, Weekord)

  }
  
  # Wrangle data
  data = data %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))
  
  
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(0,max(mem_isoweeks))
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  yaxis_plots[["tickformat"]] <- ""
  
  xaxis_plots[["showgrid"]] <- FALSE
  yaxis_plots[["showgrid"]] <- FALSE
  
  # Get thresholds
  baseline_max <- unique(data$LowThreshold)
  low_max <- unique(data$MediumThreshold)
  medium_max <- unique(data$HighThreshold)
  high_max <- unique(data$VeryHighThreshold)
  very_high_max <- max(pretty(c(data$Value, 1.1*high_max)), na.rm = T)
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Rate: ", data$Value,
                            "<br>", "Activity level: ", data$ActivityLevel))
  
  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])

  # Create plot
  mem_linechart = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type="scatter",
            mode="lines",
            colors = mem_line_colours) %>%
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
                  x0 = -1,
                  x1 = max(mem_isoweeks),
                  xref = "x",
                  y0 = 0,
                  y1 = baseline_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[2],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = -1,
                  x1 = max(mem_isoweeks),
                  xref = "x",
                  y0 = baseline_max,
                  y1 = low_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[3],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = -1,
                  x1 = max(mem_isoweeks),
                  xref = "x",
                  y0 = low_max,
                  y1 = medium_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[4],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = -1,
                  x1 = max(mem_isoweeks),
                  xref = "x",
                  y0 = medium_max,
                  y1 = high_max,
                  yref = "y",
                  layer = "below"),
             list(type = "rect",
                  fillcolor = activity_level_colours[5],
                  line = list(color = "transparent"),
                  opacity = 0.5,
                  x0 = -1,
                  x1 = max(mem_isoweeks),
                  xref = "x",
                  y0 = high_max,
                  y1 = very_high_max,
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
  
  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){
    
    mem_linechart <- mem_linechart %>%
      add_trace(data = data_curr_season,
                x = ~ISOWeek,
                y = ~Value,
                showlegend = F,
                color = ~Season,
                colors = "black",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend,
                hoverinfo = "text")
  }
  
  return(mem_linechart)
  
}


# Create MEM heatmaps



## Helper function for heatmap_plots

make_season_plot <- function(
    df_season,
    data_breakdown,
    breakdown_hover_label,
    include_text_annotation,
    rate_dp,
    text_annotation_dp,
    # mem_isoweeks_plot,
    # mem_week_order_plot,
    x_visibility = TRUE
) {
  
  act_levels <- sort(unique(df_season$ActivityLevel))
  activity_cols <- activity_level_colours[as.numeric(act_levels)]
  
  df_season <- df_season %>%
    mutate(
      Breakdown = factor(Breakdown),
      ActivityLevel = factor(ActivityLevel, levels = act_levels),
      Value = round_half_up(Value, rate_dp)
    )
  
  p <- plot_ly(
    data = df_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~as.numeric(ActivityLevel),
    colors = activity_cols,
    type = "heatmap",
    alpha = 0.5,
    showscale = FALSE,
    hovertext = ~ paste0(
      "Season: ", Season, "<br>",
      "Week number: ", ISOWeek, "<br>",
      breakdown_hover_label, Breakdown_hover, "<br>",
      "Rate: ", Value, "<br>",
      "Activity level: ", ActivityLevel
    ),
    hoverinfo = "text"
  ) %>% 
    layout(
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 100, t = 5),
      xaxis = list(
        title = "",
        ticktext = mem_isoweeks[c(TRUE, FALSE)],
        tickvals = mem_week_order[c(TRUE, FALSE)],
        tickmode = "array",
        dtick = 1,
        showgrid = FALSE,
        visible = x_visibility
      ),
      yaxis = list(
        title = "",  # ✅ y‑axis label removed entirely
        autorange = "reversed",
        ticktext = data_breakdown,
        tickvals = seq_along(data_breakdown),
        dtick = 1,
        showgrid = FALSE,
        showline = FALSE
      ),
      shapes = apply(expand.grid(x = c(0.5:(max(mem_isoweeks)-0.5), (length(data_breakdown)-0.5):(length(data_breakdown)+0.5)), y = c(1.5:(length(data_breakdown)-0.5), 0.5:(length(data_breakdown)-0.5))), 1, function(x) add_cell_border(x[1], x[1]+1, x[2], x[2]+1,
                                                                                                                                                                                                                        border_col = phs_colours("phs-liberty-10")))
      
    ) %>%
    layout(
      annotations = list(
        x = max(mem_isoweeks)+1,
        y = length(data_breakdown) / 2,
        text = unique(df_season$Season),
        showarrow = FALSE,
        textangle = 90,
        font = list(size = 14)
      )
    )
  
  if (include_text_annotation) {
    p <- p %>%
      add_annotations(
        x = df_season$Weekord,
        y = as.numeric(df_season$Breakdown),
        text = round_half_up(df_season$Value, text_annotation_dp),
        showarrow = FALSE,
        font = list(size = 6, color = "white")
      )
  }
  
  return(p)
}


create_mem_heatmap <- function(
    data = df,
    rate_dp = 1,
    include_text_annotation = FALSE,
    text_annotation_dp = 1,
    breakdown_variable = "HBName",
    heatmap_seasons = NULL,
    value_variable = "RatePer100000"
) {

  # ### Create test data
  # data_2526 <- data %>%
  #   filter(Season == "2025/2026" | Season == "2025/26") %>%
  #   mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOWeek == 52) %>%
  #   mutate(ISOWeek = 53,
  #          Weekord = 14)
  # 
  # data <- data %>%
  #   filter(Season != "2025/2026" & Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, Year, ISOWeek)
  # #####################
  
  # Drop week 53 if required
  if(!include_week_53){
    
    data = data %>%
      filter(ISOWeek != 53)
    
  }
  
  data <- data %>%
    rename(Breakdown = all_of(breakdown_variable),
           Value = all_of(value_variable))
  
  # Pick seasons
  if (is.null(heatmap_seasons)) {
    heatmap_seasons <- data %>%
      distinct(Season) %>%
      arrange(Season) %>%
      pull(Season) %>%
      tail(2)
  }
  
  # Breakdown handling
  if (breakdown_variable == "AgeGroup") {
    data <- data %>%
      mutate(
        Breakdown = gsub(" years", "", Breakdown),
        Breakdown = factor(Breakdown, levels = rev(mem_age_groups)),
        Breakdown_hover = Breakdown
      )
    breakdown_hover_label <- "Age group: "
  } else {
    data <- data %>%
      mutate(
        Breakdown_hover = Breakdown
      )
    breakdown_hover_label <- "NHS Health Board: "
  }
  
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
             ActivityLevel = "NA")

    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Weekord, Breakdown)

    # Update data
    data <- data %>%
      filter(!Season == unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels))

  }
  
  # Create plots using external helper
  prev_plot <- make_season_plot(
    df_season = data %>% filter(Season == heatmap_seasons[1]),
    data_breakdown = data_breakdown,
    breakdown_hover_label = breakdown_hover_label,
    include_text_annotation = include_text_annotation,
    rate_dp = rate_dp,
    text_annotation_dp = text_annotation_dp,
    x_visibility = FALSE
  )
  
  curr_plot <- make_season_plot(
    df_season = data %>% filter(Season == heatmap_seasons[2]),
    data_breakdown = data_breakdown,
    breakdown_hover_label = breakdown_hover_label,
    include_text_annotation = include_text_annotation,
    rate_dp = rate_dp,
    text_annotation_dp = text_annotation_dp
  )
  
  # Attach static legend
  legend_y <- ifelse(breakdown_variable %in% c("HBCode", "HBName"), -0.5, -0.7)
  
  curr_plot <- curr_plot %>%
    layout(
      images = list(
        list(
          source = raster2uri(mem_legend),
          xref = "paper", yref = "paper",
          x = 0.5, y = legend_y,
          sizex = 0.4, sizey = 0.3,
          xanchor = "center", yanchor = "bottom"
        )
      )
    )
  
  # Combine into subplot
  subplot(prev_plot, curr_plot, nrows = 2) %>%
    config(displaylogo = FALSE,
           displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
}



# Create pathogeb Adms line chart
create_pathogen_adms_linechart <- function(data,
                                      value_variable = "RatePer100000",
                                      y_axis_title = "Rate of hospital admissions<br>per 100,000 population") {
  
  # ### Create test data
  # data_2526 <- data %>%
  #   filter(Season == "2025/2026" | Season == "2025/26") %>%
  #   mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOWeek == 52) %>%
  #   mutate(ISOWeek = 53,
  #          Weekord = 14)
  # 
  # data <- data %>%
  #   filter(Season != "2025/2026" & Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, Year, ISOWeek)
  # #####################
  
  if(include_week_53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  # Rename value variable
  data <- data %>%
    rename(Value = value_variable)
  
  # Remove week 53 if required
  if(!include_week_53){
    
    data = data %>%
      filter(ISOWeek != 53)
    
  }
  
  # Add in missing week 53 if required (will create gaps in graphs)
  if(include_week_53 & non_week_53_gap){
    
    # Season with week 53
    data_week_53 <- data %>%
      filter(ISOWeek == 53)
    
    # If no rows, add in for all seasons
    if(nrow(data_week_53) == 0){
      
      # Select season that needs updated
      data_updated <- data
      
    } else{
      
      # Select season that needs updated
      data_updated <- data %>%
        filter(Season != unique(data_week_53$Season))
      
    }
    
    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOWeek == 52) %>%
      mutate(ISOWeek = 53,
             Value = NA,
             Weekord = 14)
    
    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Season, Year, ISOWeek)
    
    # Update data
    data <- data %>%
      filter(!Season %in% unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      arrange(Season, Year, ISOWeek)
    
  }
  
  # Wrangle data
  data = data %>%
    select(Season, ISOWeek, Weekord, Value) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))
  
  # Seasons in data
  seasons <- unique(data$Season) %>% 
    tail(6)
  
  # Filter to six seasons
  data <- data %>%
    filter(Season %in% seasons)
  
  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])
  
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(0,max(week_order))
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  yaxis_plots$tickmode <- "auto"
  yaxis_plots[["tickformat"]] <- NULL
  
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Rate: ", round(data$Value, 1)))
  
  # Create plot
  pathogen_adms_linechart = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type="scatter",
            mode="lines",
            colors = flu_hosp_adms_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           legend = list(y = 0.5,
                         yanchor = 'middle')
    ) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){
    
    pathogen_adms_linechart <- pathogen_adms_linechart %>%
      add_trace(data = data_curr_season,
                x = ~ISOWeek,
                y = ~Value,
                showlegend = F,
                color = ~Season,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend,
                hoverinfo = "text")
  }
  
  return(pathogen_adms_linechart)
  
}

# Create pathogen age Adms line chart
create_pathogen_adms_age_linechart <- function(data){
  
  # ### Create test data
  # data <- data %>%
  #   mutate(week = as.numeric(week))
  # 
  # data_2526 <- data %>%
  #   filter(Season == "2025/26")
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(week == 52) %>%
  #   mutate(week = 53)
  # 
  # data <- data %>%
  #   filter(Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, week)
  # #####################
  
  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(unique(data$Season), 1, 4), "-12-31"))) == 53 | max(data$week) == 53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  # put weeks in correct order for season
  #week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
  
  plot_data <- data %>%  
    mutate(WeekNumber = as.numeric(substr(week, nchar(week) - 1, nchar(week))),
           WeekNumber = factor(WeekNumber, levels = week_order), 
           age_band = factor(age_band, levels = c("<1", "1-4", "5-14",
                                                  "15-44", "45-64", "65-74",  "75+", "Total"),
                             labels = c("<1", "1 to 4", "5 to 14",
                                        "15 to 44", "45 to 64", "65 to 74",  "75+", "All ages"))) %>% 
    arrange(Season, WeekNumber)

  
  # Text for tooltip
  tooltip_trend <- paste0(#"Season: ", plot_data$Season, "<br>",
    "Week number: ", plot_data$WeekNumber, "<br>",
    "Age group: ", plot_data$age_band, "<br>",
    "Admission rate per 100k: ", round(plot_data$rate, 1), "<br>")
  
  xaxis_plots[["title"]] <- 'Week Number'
  yaxis_plots[["title"]] <- "Rate of hospital admissions<br>per 100,000 population"
  xaxis_plots[["dtick"]] <- 2
  yaxis_plots[["tickformat"]] <- NULL
  xaxis_plots[["range"]] <- list(-0.5, max(week_order)+0.5)
  
  
  ## Add as two separate traces to enable 'All ages' to be shown as the default trace
  p <- plot_ly(plot_data) %>%
    add_trace(data = plot_data[plot_data$age_band!="All ages",],
              x = ~WeekNumber, y = ~rate, split = ~age_band, 
              type="scatter", mode="lines",
              color=~age_band,
              colors=phs_colours(c("phs-blue", "phs-rust", "phs-green",
                                   "phs-purple", "phs-blue-50", "phs-magenta", "phs-teal")),
              textposition = "none",
              text = tooltip_trend[plot_data$age_band!="All ages"],
              hoverinfo = "text",
              visible = "legendonly"
    ) %>%
    add_trace(data = plot_data[plot_data$age_band=="All ages",],
              x = ~WeekNumber, y = ~rate, split = ~age_band, 
              type="scatter", mode="lines",
              color=~age_band,
              colors=phs_colours(c("phs-graphite-50")),
              textposition = "none",
              text = tooltip_trend[plot_data$age_band=="All ages"],
              hoverinfo = "text"
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  # For first week of new season (week 40), add in a marker
  if(length(unique(plot_data$week_ending)) == 1){
    
    p <- p %>%
      add_trace(data = plot_data[plot_data$age_band!="All ages",],
                x = ~WeekNumber,
                y = ~rate,
                showlegend = F,
                color = ~age_band,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend[plot_data$age_band!="All ages"],
                hoverinfo = "text",
                visible = "legendonly") %>% 
      add_trace(data = plot_data[plot_data$age_band=="All ages",],
                x = ~WeekNumber,
                y = ~rate,
                showlegend = F,
                color = ~age_band,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend[plot_data$age_band=="All ages"],
                hoverinfo = "text")     }
  
  return(p)
  
}

# Create pathogen HB Adms line chart
create_pathogen_adms_hb_linechart <- function(data){
  
  # ### Create test data
  # data <- data %>%
  #   mutate(ISOweek = as.numeric(ISOweek))
  # 
  # if(min(data$WeekEnding) == "2025-10-05"){
  # 
  #   data_2526_wk53 <- data %>%
  #     filter(ISOweek == 52) %>%
  #     mutate(ISOweek = 53)
  # 
  #   data <- data %>%
  #     bind_rows(data_2526_wk53) %>%
  #     arrange(WeekEnding, ISOweek)
  # }
  # #####################
  
  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(min(data$WeekEnding), 1, 4), "-12-31"))) == 53 | max(data$ISOweek) == 53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  plot_data <- data %>% 
    mutate(WeekNumber = as.numeric(ISOweek),
           WeekNumber = factor(WeekNumber, levels = week_order)) %>%
    arrange(WeekNumber)
  
  plot_data <- plot_data %>%
    mutate(rate = round_half_up(RateAdmissionsPerWeek,1))
  
  tooltip_trend <- paste0(
    "Week number: ", plot_data$WeekNumber, "<br>",
    "NHS Health Board: ", plot_data$HBName, "<br>",
    "Admission rate per 100,000 population: ", round_half_up(plot_data$RateAdmissionsPerWeek, 1), "<br>")
  
  yaxis_plots[["title"]] <- "Rate of hospital admissions<br>per 100,000 population"
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- list(-0.5, max(week_order)+0.5)
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["tickformat"]] <- NULL
  
  # Define a named color vector
  hb_colours <- c(
    "Scotland" = "black",
    "NHS Ayrshire and Arran" = "#12436D",
    "NHS Borders" = "#94AABD",
    "NHS Dumfries and Galloway" = "#28A197",
    "NHS Fife" = "#B4DEDB",
    "NHS Forth Valley" = "#801650",
    "NHS Grampian" = "#CCA2B9",
    "NHS Greater Glasgow and Clyde" = "#F46A25",
    "NHS Highland" = "#FBC3A8",
    "NHS Lanarkshire" = "#3D3D3D",
    "NHS Lothian" = "#A8A8A8",
    "NHS Orkney" = "#3E8ECC",
    "NHS Shetland" = "#A8CCE8",
    "NHS Tayside" = "#3F085C",
    "NHS Western Isles" = "#A285D1"
  )
  
  
  
  p <- plot_ly(plot_data) %>%
    add_trace(data = plot_data[plot_data$HBName!= "Scotland", ],
              x = ~WeekNumber, y = ~RateAdmissionsPerWeek, split = ~HBName, text = ~HBName,
              type = "scatter", mode = "lines",
              color = ~HBName,
              colors = hb_colours,
              hovertemplate = paste0('<b>Week number</b>: %{x}<br>',
                                     '<b>NHS Health Board</b>: %{text}<br>',
                                     '<b>Admission rate per 100,000 population</b>: %{y}'),
              textposition = "none",
              visible = "legendonly"
    ) %>%
    add_trace(data = plot_data[plot_data$HBName == "Scotland", ],
              x = ~WeekNumber, y = ~RateAdmissionsPerWeek, split = ~HBName, text = ~HBName,
              type = "scatter", mode = "lines",
              color = ~HBName,
              colors = hb_colours,
              hovertemplate = paste0('<b>Week number</b>: %{x}<br>',
                                     '<b>NHS Health Board</b>: %{text}<br>',
                                     '<b>Admission rate per 100,000 population</b>: %{y}'),
              textposition = "none"
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
}


make_adms_summary_plot <- function(data){

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  
  # Define a named color vector
  path_colours <- c(
    "COVID-19" = "#F46A25",
    "Influenza" = "#801650",
    "Respiratory syncytial virus" = "#28A197",
    "Adenovirus" = "#12436D",
    "Human Metapneumovirus" = "#B4DEDB",
    "Mycoplasma Pneumoniae" = "#3F085C",
    "Parainfluenza" = "#A285D1",
    "Rhinovirus" = "#A8CCE8",
    "Seasonal Coronavirus (non-COVID-19)" = "#3E8ECC"
  )
  
  p <- plot_ly(data) %>% 
    
    add_trace(x = ~WeekEnding, y = ~NumberAdmissionsPerWeek, split = ~Pathogen,
              type = "scatter", mode = "lines",
              color = ~Pathogen,
              colors = path_colours,
              text = ~paste0("<b>Season</b>:", Season, "\n",
                            "<b>Date</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                            "<b>Week number</b>: ", ISOweek, "\n",
                            "<b>Pathogen</b>: ", Pathogen, "\n"),
              hovertemplate = "%{text}",
              showlegend=TRUE) %>% 
    
    
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}



create_cari_linechart <- function(data){
  
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  
  p <- plot_ly(data = data,
               x=~WeekEnding,
               textposition = "none") %>%
    add_trace(y=~SwabPositivityLCL,
              type = "scatter",
              mode = "lines",
              line = list(color = 'transparent'),
              name = "Lower confidence interval",
              showlegend = TRUE,
              hoverinfo = "none",
              textposition = "none",
              legendgroup = "z_confidence_interval") %>%
    add_trace(y=~SwabPositivityUCL,
              type = "scatter",
              mode = "lines",
              fill = 'tonexty',
              fillcolor = phsstyles::phs_colours("phs-liberty-30"),
              line = list(color = 'transparent'),
              name = "Upper confidence interval",
              showlegend = TRUE,
              hoverinfo = "none",
              textposition = "none",
              legendgroup = "z_confidence_interval") %>%
    add_trace(y=~SwabPositivity,
              type = "scatter",
              mode = "lines",
              name = "Test positivity",
              line = list(color = "black"),
              showlegend = TRUE,
              text = ~paste0("<b>Week ending</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                             "<b>Number of positive samples</b>: ", format(PositiveSamples, big.mark=","), "\n",
                             "<b>Number of samples</b>: ", format(TotalSamples, big.mark=","), "\n",
                             "<b>Test positivity</b>: ", round_half_up(SwabPositivity,1), "%\n",
                             "<b>95% confidence interval</b>: ", round_half_up(SwabPositivityLCL,1),
                             "% - ", round_half_up(SwabPositivityUCL,1), "%"),
              hovertemplate = "%{text}",
              textposition = "none",
              legendgroup = "rate") %>%
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           hoverlabel = list(align = "left"),
           hovermode = "x"
    ) %>%
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove)
  return(p)
  
}



# Create pathogen occupancy line chart
create_pathogen_occupancy_linechart <- function(data,
                                           value_variable = "SevenDayAverageInpatients",
                                           y_axis_title = "Number of patients in hospital\n (7 day average)") {
  
  # ### Create test data
  # data_2526 <- data %>%
  #   filter(Season == "2025/2026" | Season == "2025/26")
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOweek == 52) %>%
  #   mutate(ISOweek = 53)
  # 
  # data <- data %>%
  #   filter(Season != "2025/2026" & Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, ISOyear, ISOweek)
  # #####################
  
  if(include_week_53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  # Rename value variable
  data <- data %>%
    rename(Value = value_variable)
  
  # Remove week 53 if required
  if(!include_week_53){
    
    data = data %>%
      filter(ISOweek != 53)
    
  }
  
  # Add in missing week 53 if required (will create gaps in graphs)
  if(include_week_53 & non_week_53_gap){
    
    # Season with week 53
    data_week_53 <- data %>%
      filter(ISOweek == 53)
    
    # If no rows, add in for all seasons
    if(nrow(data_week_53) == 0){
      
      # Select season that needs updated
      data_updated <- data
      
    } else{
      
      # Select season that needs updated
      data_updated <- data %>%
        filter(Season != unique(data_week_53$Season))
      
    }
    
    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOweek == 52) %>%
      mutate(ISOweek = 53,
             Value = NA)
    
    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Season, ISOyear, ISOweek)
    
    # Update data
    data <- data %>%
      filter(!Season %in% unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      arrange(Season, ISOyear, ISOweek)
    
  }
  
  # Wrangle data
  data = data %>%
    select(Season, ISOweek, Value) %>%
    mutate(ISOweek = factor(ISOweek, levels = mem_isoweeks)) %>% 
    arrange(Season, ISOweek)
    
  
  # Seasons in data
  seasons <- unique(data$Season)
  
  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])
  
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(0,52)
  
  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOweek,
                            "<br>", "Number of patients in hospital (7 day average): ", data$Value))
  
  # Create plot
  pathogen_occupancy_linechart = data %>%
    plot_ly(x = ~ISOweek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type="scatter",
            mode="lines",
            colors = flu_hosp_adms_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           legend = list(y = 0.5,
                         yanchor = 'middle')
    ) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  
  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){
    
    pathogen_occupancy_linechart <- pathogen_occupancy_linechart %>%
      add_trace(data = data_curr_season,
                x = ~ISOweek,
                y = ~Value,
                showlegend = F,
                color = ~Season,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend,
                hoverinfo = "text")
  }
  
  return(pathogen_occupancy_linechart)
  
}


create_pathogen_occupancy_hb_linechart <- function(data,
                                                   value_variable = "SevenDayAverageInpatients",
                                                   y_axis_title = "Number of patients in hospital\n (7 day average)") {
  
  # ### Create test data
  # data <- data %>%
  #   mutate(ISOweek = as.numeric(ISOweek))
  # 
  # if(unique(data$Season) == "2025/26"){
  # 
  #   data_2526_wk53 <- data %>%
  #     filter(ISOweek == 52) %>%
  #     mutate(ISOweek = 53)
  # 
  #   data <- data %>%
  #     bind_rows(data_2526_wk53) %>%
  #     arrange(WeekEnding, ISOweek)
  # }
  # #####################
  
  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(unique(data$Season), 1, 4), "-12-31"))) == 53 | max(data$ISOweek) == 53){
    
    # put weeks in correct order for season
    mem_isoweeks <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    mem_isoweeks <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  # Define the desired ISO week ordering (numeric)
  mem_isoweeks_chr <- as.character(mem_isoweeks)
  
  # Rename the value column when provided as a string
  data <- data %>%
    dplyr::rename(Value = !!rlang::sym(value_variable))
  
  # NHS colours
  hb_colours <- c(
    "Scotland" = "black",
    "NHS Ayrshire and Arran" = "#12436D",
    "NHS Borders" = "#94AABD",
    "NHS Dumfries and Galloway" = "#28A197",
    "NHS Fife" = "#B4DEDB",
    "NHS Forth Valley" = "#801650",
    "NHS Grampian" = "#CCA2B9",
    "NHS Greater Glasgow and Clyde" = "#F46A25",
    "NHS Highland" = "#FBC3A8",
    "NHS Lanarkshire" = "#3D3D3D",
    "NHS Lothian" = "#A8A8A8",
    "NHS Orkney" = "#3E8ECC",
    "NHS Shetland" = "#A8CCE8",
    "NHS Tayside" = "#3F085C",
    "NHS Western Isles" = "#A285D1"
  )
  
  # ---- Data wrangling: numeric x with custom order ----
  data <- data %>%
    dplyr::arrange(desc(WeekEnding), desc(ISOweek)) %>% 
    dplyr::select(Season, ISOweek, Value, HBName) %>%
    dplyr::mutate(
      # Numeric position in the desired order (1..52)
      ISOWeek_idx = match(ISOweek, mem_isoweeks),
      # Keep week label for tooltips
      ISOWeek_lab = as.character(ISOweek)
    )
  
  # ---- Axes: numeric x with full tick labels for 40..52,1..39 ----
  
  tick_positions <- seq(1, length(mem_isoweeks), by = 2)         # 1,3,5,...,51
  tick_labels    <- mem_isoweeks_chr[tick_positions]      
  
  
  xaxis_plots <- list(
    title    = "Week number",
    type     = "linear",
    tickmode = "array",
    tickvals = tick_positions,
    ticktext = tick_labels,         # "40","41",...,"39"
    range    = c(1, length(mem_isoweeks)) # ensures full sequence is shown
  )
  
  yaxis_plots <- list(
    fixedrange = FALSE,
    rangemode = "tozero",
    title = y_axis_title,
    tickformat = NULL,
    range = c(0, NA)  # Always start at zero
  )
  
  # Tooltip text
  tooltip_trend <- paste0(
    "Season: ", data$Season,
    "<br>", "Week number: ", data$ISOWeek_lab,
    "<br>", "NHS Health Board: ", data$HBName,
    "<br>", "Number of patients in hospital\n(7 day average) : ", data$Value
  )
  
  # ---- Plot: use numeric x (ISOWeek_idx) ----
  pathogen_occupancy_hb_linechart <- plotly::plot_ly(data) %>%
    plotly::add_trace(
      data = data[data$HBName != "Scotland", ],
      x = ~ISOWeek_idx, y = ~Value, color = ~HBName,
      colors = hb_colours,
      type = "scatter", mode = "lines",
     text = ~HBName,                      # used in hovertemplate as %{text}
     customdata = data$ISOWeek_lab[data$HBName != "Scotland"], # %{customdata}
     hovertemplate = paste0(
       '<b>Week number</b>: %{customdata}<br>',
       '<b>NHS Health Board</b>: %{text}<br>',
       '<b>Number of patients in hospital\n(7 day average) </b>: %{y}'
     ),
     hoverinfo = "text",
     visible = "legendonly"
    ) %>%
    plotly::add_trace(
      data = data[data$HBName == "Scotland", ],
      x = ~ISOWeek_idx, y = ~Value, color = ~HBName,
      colors = hb_colours,
      type = "scatter", mode = "lines",
      text = ~HBName,
      customdata = data$ISOWeek_lab[data$HBName == "Scotland"],
      hovertemplate = paste0(
        '<b>Week number</b>: %{customdata}<br>',
        '<b>NHS Health Board</b>: %{text}<br>',
        '<b>Number of patients in hospital\n(7 day average) </b>: %{y}'
      ),
      hoverinfo = "text"
    ) %>%
    plotly::layout(
      margin = list(b = 100, t = 5),
      yaxis = yaxis_plots, xaxis = xaxis_plots,
      legend = list(x = 0.99, y = 0.5),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10")
    ) %>%
    plotly::config(
      displaylogo = FALSE, 
      displayModeBar = TRUE,
      modeBarButtonsToRemove = bttn_remove
    )
  
  return(pathogen_occupancy_hb_linechart)
}





create_cari_age_linechart2 <- function(data){
  
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  
  
  # Define a named color vector
  age_colours <- c(
    "All ages" = "black",
    "0-4 years" = "#12436D",
    "5-14 years" = "#28A197",
    "15-44 years" = "#801650",
    "45-64 years" = "#F46A25",
    "65-74 years" = "#3F085C",
    "75+ years" = "#3E8ECC"
  )
  
  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~SwabPositivity, split = ~AgeGroup, #text=~HBName,
              type="scatter", mode="lines",
              color=~AgeGroup,
              colors=age_colours,
              text = ~paste0("<b>Week ending</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                             "<b>Age group</b>: ", AgeGroup, "\n",
                             "<b>Number of positive samples</b>: ", format(PositiveSamples, big.mark=","), "\n",
                             "<b>Number of samples</b>: ", format(TotalSamples, big.mark=","), "\n",
                             "<b>Test positivity</b>: ", round_half_up(SwabPositivity,1), "%\n",
                             "<b>95% confidence interval</b>: ", round_half_up(SwabPositivityLCL,1),
                             "% - ", round_half_up(SwabPositivityUCL,1), "%"),
              hovertemplate = "%{text}",
              showlegend = TRUE
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           showlegend = TRUE) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}


create_cari_hb_linechart <- function(data){
  
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  
  # Define a named color vector
  hb_colours <- c(
    "Scotland" = "black",
    "NHS Ayrshire & Arran" = "#12436D",
    "NHS Borders" = "#94AABD",
    "NHS Dumfries & Galloway" = "#28A197",
    "NHS Fife" = "#B4DEDB",
    "NHS Forth Valley" = "#801650",
    "NHS Grampian" = "#CCA2B9",
    "NHS Greater Glasgow & Clyde" = "#F46A25",
    "NHS Highland" = "#FBC3A8",
    "NHS Lanarkshire" = "#3D3D3D",
    "NHS Lothian" = "#A8A8A8",
    "NHS Orkney" = "#3E8ECC",
    "NHS Shetland" = "#A8CCE8",
    "NHS Tayside" = "#3F085C",
    "NHS Western Isles" = "#A285D1"
  )
  
  
  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~SwabPositivity, split = ~HBName, #text=~HBName,
              type="scatter", mode="lines",
              color=~HBName,
              colors=hb_colours,
              text = ~paste0("<b>Week ending</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                             "<b>NHS Health Board</b>: ", HBName, "\n",
                             "<b>Number of positive samples</b>: ", format(PositiveSamples, big.mark=","), "\n",
                             "<b>Number of samples</b>: ", format(TotalSamples, big.mark=","), "\n",
                             "<b>Test positivity</b>: ", round_half_up(SwabPositivity,1), "%\n",
                             "<b>95% confidence interval</b>: ", round_half_up(SwabPositivityLCL,1),
                             "% - ", round_half_up(SwabPositivityUCL,1), "%"),
              hovertemplate = "%{text}",
              showlegend = TRUE
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           showlegend = TRUE) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}


create_cari_pathogen_linechart <- function(data){
  
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  
  # Define a named color vector
  path_colours <- c(
    "Any pathogen" = "#A8A8A8",
    "COVID-19" = "#F46A25",
    "Influenza" = "#801650",
    "Respiratory Syncytial Virus" = "#28A197",
    "Adenovirus" = "#12436D",
    "Human Metapneumovirus" = "#B4DEDB",
    "Mycoplasma Pneumoniae" = "#3F085C",
    "Parainfluenza" = "#A285D1",
    "Rhinovirus" = "#A8CCE8",
    "Seasonal Coronavirus (non-COVID-19)" = "#3E8ECC"
  )
  
  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~SwabPositivity, split = ~Pathogen, #text=~HBName,
              type="scatter", mode="lines",
              color=~Pathogen,
              colors=path_colours,
              text = ~paste0("<b>Week ending</b>: ", format(WeekEnding, "%d %b %y"), "\n",
                             "<b>Pathogen</b>: ", Pathogen, "\n",
                             "<b>Test positivity</b>: ", round_half_up(SwabPositivity,1), "%"),
              hovertemplate = "%{text}",
              showlegend = TRUE
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           showlegend = TRUE) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}



create_cari_subtype_barchart <- function(data){
  
  yaxis_plots[["title"]] <- "Number of positive samples"
  xaxis_plots[["title"]] <- "Week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE

  # Define a named color vector
  subtype_colours <- c(
    "Type A (H1N1)" = "#801650",
    "Type A (H3N2)" = "#F46A25",
    "Type A (not subtyped)" = "#3F085C",
    "Type B" = "#3E8ECC",
    "HPIV-1" = "#28A197",
    "HPIV-2" = "#801650",
    "HPIV-3" = "#F46A25",
    "HPIV-4" = "#3F085C",
    "HCoV-229e (alpha)" = "#28A197",
    "HCoV-NL63 (alpha)" = "#801650",
    "HCoV-OC43 (beta)" = "#F46A25", 
    "Untyped" = "#3F085C"
  )

  data <- data %>%
    mutate(Pathogen = factor(Pathogen, levels = rev(sort(unique(data$Pathogen)))))
  
  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~PositiveSamples, split = ~Pathogen, text=~Pathogen,
              type="bar",
              color=~Pathogen,
              colors=subtype_colours,
              textposition = "none",
              hovertemplate = paste0('<b>Week ending</b>: %{x}<br>',
                                     '<b>Type/Subtype</b>: %{text}<br>',
                                     '<b>Positive samples</b>: %{y}')
    ) %>%
    layout(barmode = "stack",
           margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  p
  
  return(p)
  
}

create_cari_duodetection_chart_stacked <- function(data){
  
  # ### Create test data
  # data <- data %>%
  #   mutate(ISOWeekNo = as.numeric(ISOWeekNo))
  # 
  # data_2526 <- data %>%
  #   filter(Season == "2025/26") %>%
  #   mutate(ISOWeekNo = as.numeric(ISOWeekNo))
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOWeekNo == 52) %>%
  #   mutate(ISOWeekNo = 53)
  # 
  # data <- data %>%
  #   filter(Season != "2025/26") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(Season, Year, ISOWeekNo)
  # #####################

  # Check if season has 53 isoweeks
  if(isoweek(ymd(paste0(substr(unique(data$Season), 1, 4), "-12-31"))) == 53 | max(data$ISOWeekNo) == 53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
  yaxis_plots[["title"]] <- "Percentage (%)"
  xaxis_plots[["title"]] <- "ISO Week"
  
  xaxis_plots[["range"]] <- c(min(data$WeekEnding), max(data$WeekEnding))
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  yaxis_plots[["range"]] <- c(0,100)
  xaxis_plots[["range"]] <- list(-0.5, max(week_order)-0.5)
  
  duodetection_colours <- c(
    "Adenovirus" = "#12436D",
    "COVID-19" = "#F46A25",
    "Human Metapneumovirus" = "#B4DEDB",
    "Influenza A" = "#801650",
    "Influenza B" = "#CCA2B9",
    "Mycoplasma Pneumoniae" = "#3F085C",
    "Parainfluenza" = "#A285D1",
    "Respiratory Syncytial Virus" = "#28A197",
    "Rhinovirus" = "#A8CCE8",
    "Seasonal Coronavirus (non-COVID-19)" = "#3E8ECC"
  )
  
  factor_levels <- unique(data$pathogen)
  
  data <- data %>%
    mutate(pathogen = factor(pathogen, levels = factor_levels)) %>%
    arrange(WeekEnding, pathogen) %>% 
    mutate(ISOWeekNo = factor(ISOWeekNo, levels=week_order))
  
  p <- plot_ly()
  
  for(path in factor_levels){
    
    data_sub <- data %>% filter(pathogen == path)
    
    p <- p %>%
      add_trace(
        data = data_sub,
        x = ~ISOWeekNo,
        y = ~perc,
        type = "bar",
        name = path,
        marker = list(color = duodetection_colours[path]),
        hovertemplate = 
          paste0(
            ifelse(path == "Adenovirus", "Week number: %{x}", ""),
            "<br>Pathogen: ", path,
            "<br>Percentage: %{y:.1f}%",
            "<extra></extra>"
          )
        
      )
  }
  
  p <- p %>%
    layout(
      barmode = "stack",
      margin = list(b = 100, t = 5),
      xaxis = xaxis_plots,
      yaxis = yaxis_plots,
      legend = list(x = 100, y = 0.5, traceorder = "reversed"),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      hovermode = "x"
    ) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  
  return(p)
}


create_cari_codetection_age_linechart <- function(data){
  
  yaxis_plots[["title"]] <- "Percentage of positive\nsamples (%)"
  xaxis_plots[["title"]] <- "Four-week ending"
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["ticksuffix"]] <- "%"
  
  # Define a named color vector
  age_colours <- c(
    "All ages" = "#A8A8A8",
    "0-4 years" = "#12436D",
    "5-14 years" = "#28A197",
    "15-44 years" = "#801650",
    "45-64 years" = "#F46A25",
    "65+ years" = "#A285D1"
  )
  
  p <- plot_ly(data) %>%
    add_trace(x = ~FourWeekEnding, y = ~perc, split = ~AgeGroup, 
              type="scatter", mode="lines",
              color=~AgeGroup,
              colors=age_colours,
              text = paste("Four-week ending:", format(data$FourWeekEnding, "%d %b %y"),
                           "<br>Age group:", data$AgeGroup,
                           "<br>Percentage:", round(data$perc, 1), "%"),
              hoverinfo = 'text'
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10"),
           showlegend = TRUE) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}

## Create test positivity charts for Influenza, Covid and RSV

create_test_pos_seasons_linechart <- function(data, pathogen_type){
  
  # ### Create test data for week 53
  # data_2526 <- data %>%
  #   filter(season == "2025/2026")
  # 
  # data_2526_wk53 <- data_2526 %>%
  #   filter(ISOweek == 52) %>%
  #   mutate(ISOweek = 53)
  # 
  # data <- data %>%
  #   filter(season != "2025/2026") %>%
  #   bind_rows(data_2526) %>%
  #   bind_rows(data_2526_wk53) %>%
  #   arrange(season, year, ISOweek)
  # ################################

  if(include_week_53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }

  # Select correct number of seasons to plot
  no_seasons <- case_when(pathogen_type == "Covid-19" ~ 4,
                          pathogen_type == "RSV" ~ 6,
                          pathogen_type == "Influenza (A or B)" ~ 6)
  
  seasons <- data %>%
    select(season) %>%
    arrange(season) %>%
    distinct() %>%
    tail(no_seasons)
  seasons <- seasons$season 
  
  # Remove week 53, if required
  if(!include_week_53){
    
    data <- data %>%
      filter(ISOweek != 53)
    
  }

  # Select pathogen and seasons
  data = data %>%
    filter(pathogen == pathogen_type &
           season %in% seasons) 
  
  # Add in missing week 53 if required (will create gaps in graphs)
  if(include_week_53 & non_week_53_gap){

    # Season with week 53
    data_week_53 <- data %>%
      filter(ISOweek == 53)

    # If no rows, add in for all seasons
    if(nrow(data_week_53) == 0){

      # Select season that needs updated
      data_updated <- data

    } else{

      # Select season that needs updated
      data_updated <- data %>%
        filter(season != unique(data_week_53$season))

    }

    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOweek == 52) %>%
      mutate(ISOweek = 53,
             positive_count = NA,
             total_samples = NA,
             positivity_percentage = NA)

    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(season, year, ISOweek)

    # Update data
    data <- data %>%
      filter(!season %in% unique(data_updated$season)) %>%
      bind_rows(data_updated) %>%
      arrange(season, year, ISOweek)

  }
  
  data = data %>%
    mutate(ISOweek = as.character(ISOweek),
           ISOweek = factor(ISOweek, levels = week_order), 
           WeekOrd = as.numeric(ISOweek)) %>%
    arrange(season, WeekOrd) 
  
  # Current season data only
  data_curr_season <- data %>%
    filter(season %in% seasons[length(seasons)])
  
  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$season,
                            "<br>", "Week number: ", data$ISOweek,
                            "<br>", "Test positivity: ", round(data$positivity_percentage,1), "%"))
  
  yaxis_plots[["title"]] <- "Test positivity (%)"
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- list(-0.5, max(week_order)-0.5)
  
  # Line below hashed to remove slider
  yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~ISOweek, y = ~positivity_percentage, split = ~season, #text=~season,
              type="scatter", mode="lines",
              color=~season,
              colors=phs_colours(c("phs-blue", "phs-rust", "phs-green",
                                   "phs-purple", "phs-blue-50", "phs-magenta")),
              textposition = "none",
              text = tooltip_trend,
              hoverinfo = "text"
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){
    
    p <- p %>%
      add_trace(data = data_curr_season,
                x = ~ISOweek,
                y = ~positivity_percentage,
                showlegend = F,
                color = ~season,
                colors = "#FF0000",
                type = "scatter",
                mode = 'markers',
                textposition = "none",
                text = tooltip_trend,
                hoverinfo = "text") }
  
  
  return(p)
  
}

