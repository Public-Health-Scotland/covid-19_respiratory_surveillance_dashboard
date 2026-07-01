
##############################################.
# DATA FILTERS ----
##############################################.

select_y_axis <- function(data, yaxis) {

  new_data <- data %>%
    mutate(y_axis = case_when(yaxis == "Number of cases" ~ Count,
                              yaxis == "Rate per 100,000" ~ RatePer100000))
 new_data
}


#############################################.
# PLOTS -----
#############################################.

# this plot makes a plot showing the rate/number of cases for each by each subtype
make_respiratory_trend_over_time_plot <- function(data, y_axis_title) {

  
  # ### Create test data
  # data <- data %>%
  #   mutate(ISOWeek = as.numeric(ISOWeek))
  # 
  # if(unique(data$Season) == "2025/26"){
  # 
  #   data_2526_wk53 <- data %>%
  #     filter(ISOWeek == 52) %>%
  #     mutate(ISOWeek = 53)
  # 
  #   data <- data %>%
  #     bind_rows(data_2526_wk53) %>%
  #     arrange(WeekEnding, ISOWeek)
  # }
  # #####################
  

    colours <- c("#CCA2B9","#801650","#FBC3A8" , "#94AABD")#, "black")
    legend_title_name <- "Subtype"


      # Define custom order for "Organism" levels (makes legend same order as dropdowns in other charts)

  subtype_order <- c(
    "Type B", "Type A (not subtyped)","Type A(H3)",
    "Type A(H1N1)pdm09")

  # Reorder the levels of "Organism" in descending order
  data$Pathogen <- factor(data$Pathogen, levels = subtype_order)
  
  week_order <- c(seq(40, max(unique(data$ISOWeek)), 1), seq(1, 39, 1)) # put weeks in correct order for season

  xaxis_plots[["title"]] <- "ISO week"
  yaxis_plots[["title"]] <- y_axis_title

  yaxis_plots[["fixedrange"]] <- FALSE

  fig = data %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = week_order)) %>% 
    plot_ly(x = ~ISOWeek,
            y = ~y_axis,
            color = ~Pathogen,
            linetype = ~Pathogen,
            textposition = "none",
            text = ~paste0("<b>Week ending</b>: ", format(Date, "%d %b %y"), "\n",
                           "<b>Health board</b>: ", HBName, "\n",
                           "<b>", legend_title_name, "</b>: ", Pathogen, "\n",
                           "<b>", y_axis_title, "</b>: ", format(y_axis, big.mark=",")),
            hovertemplate = "%{text}",
            type="bar",
          #  mode="lines",
            colors = colours
            ) %>%
    layout(barmode = "stack",
           yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           legend=list(title=list(text=paste0('<b>', legend_title_name, '</b>')),
                       xanchor = "center",  x = 0.5, y = -0.2, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

fig

}


# this plot shows the rate/number of flu cases over the different seasons (so can easily compare differences in flu cases by season)
make_respiratory_trend_by_season_plot_function <- function(data, y_axis_title) {

  
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
  #   arrange(Season, ISOYear, ISOWeek)
  # #####################
  
  if(include_week_53){
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 53, 1), seq(1, 39, 1))
    
  } else{
    
    # put weeks in correct order for season
    week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
    
  }
  
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
      data_updated <- data %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
      
    } else{
      
      # Select season that needs updated
      data_updated <- data %>%
        filter(!Season %in% unique(data_week_53$Season)) %>%
        mutate(Weekord = ifelse(ISOWeek < 40, Weekord+1, Weekord))
      
    }
    
    # Create week 53 data
    data_updated_wk53 <- data_updated %>%
      filter(ISOWeek == 52) %>%
      mutate(ISOWeek = 53,
             Weekord = 14,
             y_axis = NA)
    
    # Add data in
    data_updated <- bind_rows(data_updated, data_updated_wk53) %>%
      arrange(Season, ISOYear, ISOWeek)
    
    # Update data
    data <- data %>%
      filter(!Season %in% unique(data_updated$Season)) %>%
      bind_rows(data_updated) %>%
      arrange(Season, ISOYear, ISOWeek)
    
  }
  data = data %>%
    #filter(ISOWeek != "53") %>%
    select(Season, Weekord, y_axis, ISOWeek, HBName) %>%
    arrange(Season, Weekord) %>%
    mutate(ISOWeek = as.character(ISOWeek),
           ISOWeek = factor(ISOWeek, levels = week_order))

  xaxis_plots[["title"]] <- "ISO week"

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title


  fig = data %>%
    plot_ly(x = ~ISOWeek,
            y = ~y_axis,
            textposition = "none",
            text = ~paste0("<b>ISO week</b>: ", ISOWeek, "\n",
                           "<b>Health board</b>: ", HBName, "\n",
                           "<b>", y_axis_title, "</b>: ", format(y_axis, big.mark=",")),
            hovertemplate = "%{text}",
            color = ~Season,
            type="scatter",
            mode="lines",
            colors=rev(season_colours[1:length(unique(data$Season))])) %>% 
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)


}



# creates a plot looking at age/sex breakdowns in scotland
make_age_sex_pyramid_plot <- function(data, title = NULL) {
  data %<>%
    mutate(RatePer100000 = case_when(
      Sex == "F" ~ -RatePer100000,
      TRUE ~ RatePer100000)) %>%
    mutate_if(is.numeric, ~replace_na(., 0)) %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("< 1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+"))) %>%
    mutate(Sex = case_when(
      Sex == "F" ~ "Female",
      Sex == "M" ~ "Male",
      TRUE ~ NA_character_
    ))

  xaxis_breaks <- pretty(c(-max(data$RatePer100000), 0, max(data$RatePer100000)))
  yaxis_ticks <- list("< 1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")
  yaxis_ticks <- list(categoryorder = "array",
                      categoryarray = c("< 1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+"))


  fig = data %>%
    plot_ly(x= ~RatePer100000,
            y= ~AgeGroup,
            color = ~Sex,
            type = 'bar',
            textposition = "none",
            text = ~paste0("<b>Season</b>: ", Season, "\n",
                           "<b>Sex</b>: ", Sex, "\n",
                           "<b>Age Group</b>: ", AgeGroup, "\n",
                           "<b>Rate per 100,000 population</b>: ", format(abs(RatePer100000), big.mark=",")),
            hoverinfo = "text",
            colors = c("#12436D", "#28A197")) %>%
    layout(
      xaxis = list(
        tickvals = xaxis_breaks,
        ticktext = abs(xaxis_breaks),
        title = "Rate per 100,000 population",
        showline = TRUE,
        linecolor = 'black',
        range = c(-max(data$RatePer100000), max(data$RatePer100000))
      ),
      yaxis = list(yaxis_ticks,
                   title = "Age Group"),
      legend = list(title = ""),
      margin = list(b = 100),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      title = title,
      barmode = 'overlay')

  fig <- fig %>%
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove)
  return(fig)
}

