# Create MEM line chart
create_euromomo_mem_linechart <- function(data,
                                          rate_dp = 1,
                                          seasons = NULL,
                                          value_variable = "ZScore",
                                          y_axis_title = "Z-score") {
  
  # Latest reporting week
  latest_week <- data %>%
    tail(1) %>%
    pull(ISOWeek) %>%
    as.character()
  
  # Add a new row so the reporting-delay dashed line works.
  # This is not needed in week 42.
  if (latest_week != "42") {
    
    new_row <- data %>%
      tail(4) %>%
      head(1) %>%
      mutate(
        ActivityLevelDelay = "Reporting delay",
        new_row = "Yes"
      )
    
  } else {
    
    new_row <- data %>%
      tail(0) %>%
      mutate(new_row = "")
    
  }
  
  # Combine original data and reporting-delay row
  data <- bind_rows(data, new_row) %>%
    arrange(Season, Weekord)
  
  # Rename value variable
  data <- data %>%
    rename(Value = all_of(value_variable)) %>%
    mutate(
      Value = round_half_up(Value, rate_dp)
    )
  
  # Use the four most recent seasons if seasons are not supplied
  if (is.null(seasons)) {
    
    seasons <- data %>%
      select(Season) %>%
      arrange(Season) %>%
      distinct() %>%
      tail(4) %>%
      pull(Season)
    
  }
  
  # Wrangle data
  data <- data %>%
    filter(ISOWeek != 53) %>%
    filter(Season %in% seasons) %>%
    select(
      Season,
      ISOWeek,
      Weekord,
      Value,
      ActivityLevel,
      ActivityLevelDelay,
      new_row
    ) %>%
    arrange(Season, Weekord) %>%
    mutate(
      ISOWeek = as.character(ISOWeek),
      ISOWeek = factor(
        ISOWeek,
        levels = mem_isoweeks
      )
    )
  
  # Add reporting-delay marker to tooltip
  data <- data %>%
    mutate(
      ReportingDelay = ifelse(
        ActivityLevelDelay == "Reporting delay" &
          is.na(new_row),
        " (reporting delay) ",
        ""
      )
    )
  
  # Axis settings
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  #xaxis_plots[["range"]] <- c(0, 52)
  xaxis_plots[["type"]] <- "category"
  xaxis_plots[["categoryorder"]] <- "array"
  xaxis_plots[["categoryarray"]] <- as.character(mem_isoweeks)
  xaxis_plots[["range"]] <- c(-0.5, length(mem_isoweeks) - 0.5)
  xaxis_plots[["showgrid"]] <- FALSE
  
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  yaxis_plots[["showgrid"]] <- FALSE
  
  # Update season label for reporting-delay traces
  # data <- data %>%
  #   mutate(
  #     SeasonDelay = ifelse(
  #       ActivityLevelDelay == "Reporting delay",
  #       paste0(Season, " (Reporting delay)"),
  #       Season
  #     )
  #   )
  
  # Identify whether each observation is observed or subject to
  # reporting delay
  data <- data %>%
    mutate(
      ReportingLine = ifelse(
        ActivityLevelDelay == "Reporting delay",
        "Reporting delay",
        "Observed"
      ),
      ReportingLine = factor(
        ReportingLine,
        levels = c(
          "Observed",
          "Reporting delay"
        )
      ),
      Season = factor(
        Season,
        levels = seasons
      )
    )
  
  # Set one colour for each season
  season_colour_map <- setNames(
    rev(season_colours[seq_along(seasons)]),
    seasons
  )
  
  
  # season_delay_levels <- data %>%
  #   arrange(Season, Weekord) %>%
  #   pull(SeasonDelay) %>%
  #   unique()
  # 
  # delayed_seasons <- grep(
  #   "Reporting delay",
  #   season_delay_levels
  # )
  # 
  # # Identify the current season and reporting-delay levels
  # thick_positions <- unique(
  #   sort(
  #     c(
  #       delayed_seasons,
  #       delayed_seasons - 1
  #     )
  #   )
  # )
  # 
  # # Remove invalid positions
  # thick_positions <- thick_positions[
  #   thick_positions >= 1 &
  #     thick_positions <= length(season_delay_levels)
  # ]
  
  #thick_levels <- season_delay_levels[thick_positions]
  
  # Current-season data
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])
  
  # # ------------------------------------------------------------
  # # Latest week is not week 40, 41 or 42
  # # ------------------------------------------------------------
  # 
  # if (!latest_week %in% c("40", "41", "42")) {
  #   
  #   mem_linechart <- plot_ly(
  #     data = data,
  #     x = ~ISOWeek,
  #     y = ~Value,
  #     textposition = "none",
  #     text = ~paste0(
  #       "Season: ", Season,
  #       "<br>Week number: ", ISOWeek,
  #       "<br>Z-score: ", Value, ReportingDelay,
  #       "<br>Activity level: ", ActivityLevel,
  #       ReportingDelay
  #     ),
  #     hoverinfo = "text",
  #     color = ~Season,
  #     colors = season_colour_map,
  #     linetype = ~ReportingLine,
  #     linetypes = c(
  #       "solid",
  #       "dash"
  #     ),
  #     type = "scatter",
  #     mode = "lines",
  #     line = list(
  #       width = 1
  #     ),
  #     showlegend = FALSE
  #   ) %>%
  #     layout(
  #       yaxis = yaxis_plots,
  #       xaxis = xaxis_plots,
  #       margin = list(
  #         b = 100,
  #         t = 5
  #       ),
  #       paper_bgcolor = phs_colours("phs-liberty-10"),
  #       plot_bgcolor = phs_colours("phs-liberty-10")
  #     )
  #   
  #  
  #   
  #   # Add marker for week 40 when the latest week is week 43
  #   if (latest_week == "43") {
  #     
  #     current_season <- as.character(
  #       seasons[length(seasons)]
  #     )
  #     
  #     mem_linechart <- mem_linechart %>%
  #       add_trace(
  #         data = data %>%
  #           filter(
  #             as.character(Season) == current_season,
  #             as.character(ISOWeek) == "40",
  #             is.na(new_row)
  #           ),
  #         inherit = FALSE,
  #         x = ~ISOWeek,
  #         y = ~Value,
  #         showlegend = FALSE,
  #         type = "scatter",
  #         mode = "markers",
  #         marker = list(
  #           color = unname(
  #             season_colour_map[current_season]
  #           )
  #         ),
  #         textposition = "none",
  #         text = ~paste0(
  #           "Season: ", Season,
  #           "<br>Week number: ", ISOWeek,
  #           "<br>Z-score: ", Value, ReportingDelay,
  #           "<br>Activity level: ", ActivityLevel,
  #           ReportingDelay
  #         ),
  #         hoverinfo = "text"
  #       )
  #   }
  # }
  # 
  # 
  # # ------------------------------------------------------------
  # # Latest week is week 40 or 41
  # # ------------------------------------------------------------
  # 
  # if (latest_week %in% c("40", "41")) {
  #   
  #   mem_linechart <- plot_ly(
  #     data = data,
  #     x = ~ISOWeek,
  #     y = ~Value,
  #     textposition = "none",
  #     text = ~paste0(
  #       "Season: ", Season,
  #       "<br>Week number: ", ISOWeek,
  #       "<br>Z-score: ", Value, ReportingDelay,
  #       "<br>Activity level: ", ActivityLevel,
  #       ReportingDelay
  #     ),
  #     hoverinfo = "text",
  #     color = ~Season,
  #     colors = season_colour_map,
  #     linetype = ~ReportingLine,
  #     linetypes = c(
  #       "solid",
  #       "dash"
  #     ),
  #     type = "scatter",
  #     mode = "lines",
  #     line = list(
  #       width = 1
  #     ),
  #     showlegend = FALSE
  #   ) %>%
  #     layout(
  #       yaxis = yaxis_plots,
  #       xaxis = xaxis_plots,
  #       margin = list(
  #         b = 100,
  #         t = 5
  #       ),
  #       paper_bgcolor = phs_colours("phs-liberty-10"),
  #       plot_bgcolor = phs_colours("phs-liberty-10")
  #     )
  #   
  #   
  #   
  #   # Add current-season marker when only week 40 is available
  #   if (latest_week == "40") {
  #     
  #     current_season <- as.character(
  #       seasons[length(seasons)]
  #     )
  #     
  #     mem_linechart <- mem_linechart %>%
  #       add_trace(
  #         data = data_curr_season %>%
  #           filter(
  #             as.character(ISOWeek) == "40",
  #             is.na(new_row)
  #           ),
  #         inherit = FALSE,
  #         x = ~ISOWeek,
  #         y = ~Value,
  #         showlegend = FALSE,
  #         type = "scatter",
  #         mode = "markers",
  #         marker = list(
  #           color = unname(
  #             season_colour_map[current_season]
  #           )
  #         ),
  #         textposition = "none",
  #         text = ~paste0(
  #           "Season: ", Season,
  #           "<br>Week number: ", ISOWeek,
  #           "<br>Z-score: ", Value, ReportingDelay,
  #           "<br>Activity level: ", ActivityLevel,
  #           ReportingDelay
  #         ),
  #         hoverinfo = "text"
  #       )
  #   }
  # }
  # 
  # 
  # # ------------------------------------------------------------
  # # Latest week is week 42
  # # ------------------------------------------------------------
  # 
  # if (latest_week == "42") {
  #   
  #   mem_linechart <- plot_ly(
  #     data = data,
  #     x = ~ISOWeek,
  #     y = ~Value,
  #     textposition = "none",
  #     text = ~paste0(
  #       "Season: ", Season,
  #       "<br>Week number: ", ISOWeek,
  #       "<br>Z-score: ", Value, ReportingDelay,
  #       "<br>Activity level: ", ActivityLevel,
  #       ReportingDelay
  #     ),
  #     hoverinfo = "text",
  #     color = ~Season,
  #     colors = season_colour_map,
  #     linetype = ~ReportingLine,
  #     linetypes = c(
  #       "solid",
  #       "dash"
  #     ),
  #     type = "scatter",
  #     mode = "lines",
  #     line = list(
  #       width = 1
  #     ),
  #     showlegend = FALSE
  #   ) %>%
  #     layout(
  #       yaxis = yaxis_plots,
  #       xaxis = xaxis_plots,
  #       margin = list(
  #         b = 100,
  #         t = 5
  #       ),
  #       paper_bgcolor = phs_colours("phs-liberty-10"),
  #       plot_bgcolor = phs_colours("phs-liberty-10")
  #     )
  #   
  # 
  # }
  
  # ------------------------------------------------------------
  # Create seasonal line chart
  # ------------------------------------------------------------
  
  # Start with an empty Plotly chart
  mem_linechart <- plot_ly()
  
  # Add each season separately so that:
  #   - the legend contains only the season
  #   - observed data use a solid line
  #   - reporting-delay data use a dashed line
  #   - both parts use the same season colour
  for (season_name in as.character(seasons)) {
    
    season_colour <- unname(
      season_colour_map[season_name]
    )
    
    # ----------------------------------------------------------
    # Observed data
    # ----------------------------------------------------------
    
    observed_data <- data %>%
      filter(
        as.character(Season) == season_name,
        ReportingLine == "Observed"
      ) %>%
      arrange(Weekord)
    
    if (nrow(observed_data) > 0) {
      
      mem_linechart <- mem_linechart %>%
        add_trace(
          data = observed_data,
          inherit = FALSE,
          x = ~ISOWeek,
          y = ~Value,
          type = "scatter",
          mode = "lines",
          
          # Show only the season name in the legend
          name = season_name,
          legendgroup = season_name,
          showlegend = TRUE,
          
          line = list(
            color = season_colour,
            width = 1,
            dash = "solid"
          ),
          
          textposition = "none",
          text = ~paste0(
            "Season: ", Season,
            "<br>Week number: ", ISOWeek,
            "<br>Z-score: ", Value,
            "<br>Activity level: ", ActivityLevel
          ),
          hoverinfo = "text"
        )
    }
    
    # ----------------------------------------------------------
    # Reporting-delay data
    # ----------------------------------------------------------
    
  #   reporting_delay_data <- data %>%
  #     filter(
  #       as.character(Season) == season_name,
  #       ReportingLine == "Reporting delay"
  #     ) %>%
  #     arrange(Weekord)
  #   
  #   if (nrow(reporting_delay_data) > 0) {
  #     
  #     mem_linechart <- mem_linechart %>%
  #       add_trace(
  #         data = reporting_delay_data,
  #         inherit = FALSE,
  #         x = ~ISOWeek,
  #         y = ~Value,
  #         type = "scatter",
  #         mode = "lines",
  #         
  #         # Use the same legend group but do not add
  #         # another entry to the legend
  #         name = season_name,
  #         legendgroup = season_name,
  #         showlegend = FALSE,
  #         
  #         # Same season colour, but dashed
  #         line = list(
  #           color = season_colour,
  #           width = 1,
  #           dash = "dash"
  #         ),
  #         
  #         textposition = "none",
  #         text = ~paste0(
  #           "Season: ", Season,
  #           "<br>Week number: ", ISOWeek,
  #           "<br>Z-score: ", Value, ReportingDelay,
  #           "<br>Activity level: ", ActivityLevel,
  #           ReportingDelay
  #         ),
  #         hoverinfo = "text"
  #       )
  #   }
  # }
  
    # ----------------------------------------------------------
    # Reporting-delay data
    # ----------------------------------------------------------
    
    reporting_delay_data <- data %>%
      filter(
        as.character(Season) == season_name,
        ReportingLine == "Reporting delay"
      ) %>%
      arrange(Weekord)
    
    if (nrow(reporting_delay_data) > 0) {
      
      mem_linechart <- mem_linechart %>%
        add_trace(
          data = reporting_delay_data,
          inherit = FALSE,
          x = ~ISOWeek,
          y = ~Value,
          type = "scatter",
          mode = "lines",
          
          name = season_name,
          legendgroup = season_name,
          
          # Show the season here only if there is no observed trace
          showlegend = nrow(observed_data) == 0,
          
          line = list(
            color = season_colour,
            width = 1,
            dash = "dash"
          ),
          
          textposition = "none",
          text = ~paste0(
            "Season: ", Season,
            "<br>Week number: ", ISOWeek,
            "<br>Z-score: ", Value, ReportingDelay,
            "<br>Activity level: ", ActivityLevel,
            ReportingDelay
          ),
          hoverinfo = "text"
        )
    }
  }
  # ------------------------------------------------------------
  # Apply layout and preserve week order
  # ------------------------------------------------------------
  
  mem_linechart <- mem_linechart %>%
    layout(
      yaxis = yaxis_plots,
      xaxis = xaxis_plots,
      margin = list(
        b = 100,
        t = 5
      ),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10")
    )
  
  
  # ------------------------------------------------------------
  # Add current-season marker in week 40
  # ------------------------------------------------------------
  
  if (latest_week == "40") {
    
    current_season <- as.character(
      seasons[length(seasons)]
    )
    
    mem_linechart <- mem_linechart %>%
      add_trace(
        data = data_curr_season %>%
          filter(
            as.character(ISOWeek) == "40",
            is.na(new_row)
          ),
        inherit = FALSE,
        x = ~ISOWeek,
        y = ~Value,
        type = "scatter",
        mode = "markers",
        name = current_season,
        legendgroup = current_season,
        showlegend = FALSE,
        marker = list(
          color = unname(
            season_colour_map[current_season]
          )
        ),
        textposition = "none",
        text = ~paste0(
          "Season: ", Season,
          "<br>Week number: ", ISOWeek,
          "<br>Z-score: ", Value,
          "<br>Activity level: ", ActivityLevel
        ),
        hoverinfo = "text"
      )
  }
  
  
  # ------------------------------------------------------------
  # Add week 40 marker when latest week is week 43
  # ------------------------------------------------------------
  
  if (latest_week == "43") {
    
    current_season <- as.character(
      seasons[length(seasons)]
    )
    
    mem_linechart <- mem_linechart %>%
      add_trace(
        data = data %>%
          filter(
            as.character(Season) == current_season,
            as.character(ISOWeek) == "40",
            is.na(new_row)
          ),
        inherit = FALSE,
        x = ~ISOWeek,
        y = ~Value,
        type = "scatter",
        mode = "markers",
        name = current_season,
        legendgroup = current_season,
        showlegend = FALSE,
        marker = list(
          color = unname(
            season_colour_map[current_season]
          )
        ),
        textposition = "none",
        text = ~paste0(
          "Season: ", Season,
          "<br>Week number: ", ISOWeek,
          "<br>Z-score: ", Value,
          "<br>Activity level: ", ActivityLevel
        ),
        hoverinfo = "text"
      )
  }

  # ------------------------------------------------------------
  # Add excess mortality threshold at Z-score = 2
  # ------------------------------------------------------------
  
  threshold_data <- tibble(
    ISOWeek = factor(
      mem_isoweeks,
      levels = mem_isoweeks
    ),
    Threshold = 2
  )
  
  mem_linechart <- mem_linechart %>%
    add_trace(
      data = threshold_data,
      inherit = FALSE,
      x = ~ISOWeek,
      y = ~Threshold,
      type = "scatter",
      mode = "lines",
      name = "Excess mortality threshold",
      showlegend = TRUE,
      hoverinfo = "text",
      text = ~paste0(
        "Week number: ",
        ISOWeek,
        "<br>Excess mortality threshold: Z-score = 2"
      ),
      line = list(
        color = "#FF0000",
        width = 2,
        dash = "dash"
      )
    ) %>%
    layout(
      legend = list(
        y = 0.5,
        yanchor = "middle"
      )
    ) %>%
    config(
      displaylogo = FALSE,
      displayModeBar = TRUE,
      modeBarButtonsToRemove = bttn_remove
    )
  
  return(mem_linechart)
  
}


#------------------------#
#### Create MEM heatmaps #
#------------------------#
create_euromomo_mem_heatmap <- function(data, 
                                        rate_dp = 1,
                                        include_text_annotation = F,
                                        text_annotation_dp = 1,
                                        breakdown_variable = "AgeGroup",
                                        heatmap_seasons = NULL,
                                        value_variable = "ZScore") {
  
  # Latest reporting week
  latest_week <- data %>%
    tail(1) %>%
    .$ISOWeek %>%
    as.character()
  
  
  # Rename HB/Age variable
  # Rename value variable
  # data <- data %>%
  #   rename(Breakdown = breakdown_variable,
  #          Value = value_variable)
  
  data <- data %>%
    rename(
      Breakdown = all_of(breakdown_variable),
      Value = all_of(value_variable)
    ) %>%
    # mutate(
    #   Value = as.numeric(Value),
    #   
    #   ThresholdLevel = case_when(
    #     is.na(Value) ~ NA_real_,
    #     Value >= 2 ~ 1,
    #     TRUE ~ 0
    #   ),
    #   
    #   ThresholdLabel = case_when(
    #     is.na(Value) ~ NA_character_,
    #     Value >= 2 ~ "Excess mortality",
    #     TRUE ~ "Baseline"
    #   )
    # )
    
    mutate(
      Value = as.numeric(Value),
      
      # Update the activity level used in the hover text and data table
      ActivityLevel = case_when(
        is.na(Value) ~ ActivityLevel,
        Value >= 2 ~ "Above baseline",
        TRUE ~ "Baseline"
      ),
      
      # Reporting delay takes priority in the heatmap
      HeatmapLevel = case_when(
        ActivityLevelDelay == "Reporting delay" ~ 2,
        !is.na(Value) & Value >= 2 ~ 1,
        !is.na(Value) & Value < 2 ~ 0,
        TRUE ~ NA_real_
      ),
      
      HeatmapLabel = case_when(
        ActivityLevelDelay == "Reporting delay" ~ "Reporting delay",
        !is.na(Value) & Value >= 2 ~ "Above baseline",
        !is.na(Value) & Value < 2 ~ "Baseline",
        TRUE ~ NA_character_
      )
    )
  
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
  
  # Add in reporting delay marker
  data = data %>%
    mutate(ReportingDelay = ifelse(ActivityLevelDelay == "Reporting delay",
                                   " (reporting delay) ", ""))
  
  # Data for previous season
  data_prev_season <- data %>%
    filter(Season == heatmap_seasons[1]) %>%
    mutate(Breakdown = factor(Breakdown)) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  

  heatmap_prev_season <- plot_ly(
    data = data_prev_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~HeatmapLevel,
    
    colorscale = mem_heatmap_colour_scale,
    zmin = 0,
    zmax = 2,
    
    opacity = 0.5,
    
    showscale = FALSE,
    type = "heatmap",
    
    hovertext = ~paste0(
      "Season: ", Season,
      "<br>Week number: ", ISOWeek,
      "<br>", breakdown_hover, Breakdown_hover,
      "<br>Z-score: ", Value, coalesce(ReportingDelay, ""),
      "<br>Activity level: ", HeatmapLabel,
      coalesce(ReportingDelay, "")
    ),
    
    hoverinfo = "text"
  ) %>%
    layout(
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 100, t = 5),
      title = "",
      xaxis = list(
        title = list(
          text = "Week number",
          standoff = 10L
        ),
        ticktext = mem_isoweeks[c(TRUE, FALSE)],
        tickvals = mem_week_order[c(TRUE, FALSE)],
        tickmode = "array",
        showgrid = FALSE,
        visible = FALSE,
        dtick = 1
      ),
      yaxis = list(
        title = "",
        autorange = "reversed",
        ticktext = data_breakdown,
        tickvals = seq_along(data_breakdown),
        tickmode = "array",
        dtick = 1,
        showgrid = FALSE
      ),
      shapes = apply(
        expand.grid(
          x = c(
            0.5:51.5,
            (length(data_breakdown) - 0.5):
              (length(data_breakdown) + 0.5)
          ),
          y = c(
            1.5:(length(data_breakdown) - 0.5),
            0.5:(length(data_breakdown) - 0.5)
          )
        ),
        1,
        function(x) {
          add_cell_border(
            x[1],
            x[1] + 1,
            x[2],
            x[2] + 1,
            border_col = phs_colours("phs-liberty-10")
          )
        }
      )
    ) %>%
    layout(
      annotations = list(
        x = 53,
        y = length(data_breakdown) / 2,
        text = ~Season,
        showarrow = FALSE,
        textangle = 90,
        font = list(size = 14),
        height = 14,
        xanchor = "center",
        yanchor = "middle"
      )
    )
  
  
  
  # Data for current season
  data_curr_season <- data %>%
    filter(Season == heatmap_seasons[2]) %>%
    mutate(Breakdown = factor(Breakdown)) %>%
    mutate(Value = round_half_up(Value, rate_dp))
  
 
  # Create a heat map using Plotly

  heatmap_curr_season <- plot_ly(
    data = data_curr_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~HeatmapLevel,
    
    colorscale = mem_heatmap_colour_scale,
    zmin = 0,
    zmax = 2,
    
    opacity =0.5,
    
    showscale = FALSE,
    type = "heatmap",
    
    hovertext = ~paste0(
      "Season: ", Season,
      "<br>Week number: ", ISOWeek,
      "<br>", breakdown_hover, Breakdown_hover,
      "<br>Z-score: ", Value, ReportingDelay,
      "<br>Activity level: ", HeatmapLabel,
      ReportingDelay
    ),
    
    hoverinfo = "text"
  ) %>%
    layout(
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 100, t = 5),
      title = "",
      xaxis = list(
        title = list(
          text = "Week number",
          standoff = 10L
        ),
        ticktext = mem_isoweeks[c(TRUE, FALSE)],
        tickvals = mem_week_order[c(TRUE, FALSE)],
        tickmode = "array",
        dtick = 1,
        showgrid = FALSE
      ),
      yaxis = list(
        showline = FALSE,
        showaxisticks = FALSE,
        title = "",
        autorange = "reversed",
        ticktext = data_breakdown,
        tickvals = seq_along(data_breakdown),
        dtick = 1,
        showgrid = FALSE
      ),
      shapes = apply(
        expand.grid(
          x = c(
            0.5:51.5,
            (length(data_breakdown) - 0.5):
              (length(data_breakdown) + 0.5)
          ),
          y = c(
            1.5:(length(data_breakdown) - 0.5),
            0.5:(length(data_breakdown) - 0.5)
          )
        ),
        1,
        function(x) {
          add_cell_border(
            x[1],
            x[1] + 1,
            x[2],
            x[2] + 1,
            border_col = phs_colours("phs-liberty-10")
          )
        }
      )
    ) %>%
    layout(
      annotations = list(
        x = 53,
        y = length(data_breakdown) / 2,
        text = ~Season,
        showarrow = FALSE,
        textangle = 90,
        font = list(size = 14),
        height = 14,
        xanchor = "center",
        yanchor = "middle"
      )
    )
  
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
