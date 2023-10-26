# Functions that create MEM heatmaps and line charts

# Function that rounds a value to nearest 10
roundUp <- function(x,to=10)
{
  to*(x%/%to + as.logical(x%%to))
}

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
                                 rate_dp = 2,
                                 seasons = NULL,
                                 value_variable = "RatePer100000",
                                 y_axis_title = "Rate per 100,000 population") {

  # Rename value variable
  data <- data %>%
    rename(Value = value_variable) %>%
    mutate(Value = round_half_up(Value, rate_dp))

  # # If seasons not supplied, use two most recent seasons
  # if(is.null(seasons)){
  #   seasons_1 <- data %>%
  #     select(Season) %>%
  #     arrange(Season) %>%
  #     distinct() %>%
  #     tail(6)
  #   seasons_2 <- data %>%
  #     filter(Season == "2010/2011") %>%
  #     select(Season) %>%
  #     arrange(Season) %>%
  #     distinct()
  #   seasons <- bind_rows(seasons_2, seasons_1)
  #   seasons <- seasons$Season
  # }

  seasons <- data %>%
    select(Season) %>%
    arrange(Season) %>%
    distinct() %>%
    tail(6)
  seasons <- seasons$Season

  # Wrangle data
  data = data %>%
    filter(ISOWeek != 53) %>%
    filter(Season %in% seasons) %>%
    select(Season, ISOWeek, Weekord, Value, ActivityLevel, LowThreshold,
           MediumThreshold, HighThreshold, ExtraordinaryThreshold) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))

  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(-1,52)

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title
  yaxis_plots[["tickformat"]] <- ""

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
            line = list(width = 5),
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
                  x0 = -1,
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
                  x0 = -1,
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
                  x0 = -1,
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
                  x0 = -1,
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

  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){

    mem_linechart <- mem_linechart %>%
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

  return(mem_linechart)

}


# Create MEM heatmaps
create_mem_heatmap <- function(data = df,
                               rate_dp = 2,
                               include_text_annotation = F,
                               text_annotation_dp = 1,
                               breakdown_variable = "HBName",
                               heatmap_seasons = NULL,
                               value_variable = "RatePer100000") {

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
      mutate(Breakdown = factor(Breakdown, levels = rev(mem_age_groups))) %>%
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
    z = ~as.numeric(ActivityLevel),
    colors = activity_level_colours_prev_season,
    alpha = 0.5,
    showscale = FALSE,
    type = "heatmap",
    hovertext = ~ paste0("Season: ", unique(data_prev_season$Season), "<br>",
                         "Week number: ", ISOWeek, "<br>",
                         breakdown_hover, Breakdown_hover, "<br>",
                         "Rate: ", Value, "<br>",
                         "Activity level: ", ActivityLevel),
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
  activity_level_colours_curr_season <- activity_level_colours[act_levels_curr_season]

  # Create a heat map using Plotly
  heatmap_curr_season <- plot_ly(
    data = data_curr_season,
    x = ~Weekord,
    y = ~as.numeric(Breakdown),
    z = ~as.numeric(ActivityLevel),
    colors = activity_level_colours_curr_season,
    alpha = 0.5,
    showscale = FALSE,
    type = "heatmap",
    hovertext = ~ paste0("Season: ", unique(data_curr_season$Season), "<br>",
                         "Week number: ", ISOWeek, "<br>",
                         breakdown_hover, Breakdown_hover, "<br>",
                         "Rate: ", Value, "<br>",
                         "Activity level: ", ActivityLevel),
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

# Create Flu Adms line chart
create_flu_adms_linechart <- function(data,
                                 #rate_dp = 2,
                                 #seasons = NULL,
                                 value_variable = "Admissions",
                                 y_axis_title = "Number of hospital admissions") {

  # Rename value variable
  data <- data %>%
    rename(Value = value_variable)


  # Wrangle data
  data = data %>%
    filter(ISOWeek != 53) %>%
    select(Season, ISOWeek, Weekord, Value) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))

  # Seasons in data
  seasons <- unique(data$Season)

  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])

  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(-1,52)

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title

  xaxis_plots[["showgrid"]] <- FALSE
  yaxis_plots[["showgrid"]] <- FALSE



  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Number: ", data$Value))

  # Create plot
  flu_adms_linechart = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type="scatter",
            mode="lines",
            line = list(width = 5),
            colors = flu_hosp_adms_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")
           ) %>%


    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){

    flu_adms_linechart <- flu_adms_linechart %>%
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

  return(flu_adms_linechart)

}

# Create RSV Adms line chart
create_rsv_adms_linechart <- function(data,
                                      #rate_dp = 2,
                                      #seasons = NULL,
                                      value_variable = "Admissions",
                                      y_axis_title = "Number of hospital admissions") {

  # Rename value variable
  data <- data %>%
    rename(Value = value_variable)


  # Wrangle data
  data = data %>%
    filter(ISOWeek != 53) %>%
    select(Season, ISOWeek, Weekord, Value) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = mem_isoweeks))

  # Seasons in data
  seasons <- unique(data$Season)

  # Current season data only
  data_curr_season <- data %>%
    filter(Season %in% seasons[length(seasons)])

  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- c(-1,52)

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title

  xaxis_plots[["showgrid"]] <- FALSE
  yaxis_plots[["showgrid"]] <- FALSE



  #Text for tooltip
  tooltip_trend <- c(paste0("Season: ", data$Season,
                            "<br>", "Week number: ", data$ISOWeek,
                            "<br>", "Number: ", data$Value))

  # Create plot
  rsv_adms_linechart = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~Value,
            textposition = "none",
            text = tooltip_trend,
            hoverinfo = "text",
            color = ~Season,
            type="scatter",
            mode="lines",
            line = list(width = 5),
            colors = rsv_hosp_adms_colours) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           margin = list(b = 100, t = 5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")
    ) %>%


    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  # For first week of new season (week 40), add in a marker
  if(nrow(data_curr_season) == 1){

    rsv_adms_linechart <- rsv_adms_linechart %>%
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

  return(rsv_adms_linechart)

}



make_adms_summary_plot <- function(data){

data %<>%
  pivot_wider(names_from = CaseDefinition, values_from = Admissions)

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Week ending"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  p <- plot_ly(data, x = ~Date,
               textposition = "none",
               text = ~paste0("<b>Season</b>: ", Season, "\n",
                              "<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                              "<b>Week number</b>: ", ISOWeek, "\n",
                              "<b>Influenza</b>: ", Influenza, "\n",
                              "<b>RSV</b>: ", RSV, "\n",
                              "<b>COVID-19</b>: ", `COVID-19`, "\n"),
               hovertemplate = "%{text}",
               height = 500)%>%

    add_lines(y = ~Influenza,
              line = list(color = phs_colours("phs-blue"), dash = "dash"),
              name = 'Influenza') %>%

    add_lines(y = ~RSV,
              name = 'RSV',
              line = list(color = phs_colours("phs-green"))) %>%

    add_lines(y = ~`COVID-19`,
              name = 'Covid-19',
              line = list(color = phs_colours("phs-purple"), dash = "dot")) %>%


    # Adding vertical lines for notes on chart
    # add_lines_and_notes(dataframe = data,
    #                     ycol = "Influenza",
    #                     xs= c("2023-10-08"),
    #                     notes=c("Season 23/24"),
    #                     colors=c(phs_colours("phs-teal"))) %>%


    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}