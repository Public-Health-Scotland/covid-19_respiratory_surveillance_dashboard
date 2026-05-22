
##############################################.
# DATA FILTERS ----
##############################################.

# filter data by healthboard
respiratory_filter_by_healthboard = function(data, healthboard) {

  if (healthboard == "Scotland"){
    filtered_data = data %>%
      filter(Healthboard == "Scotland")
  } else {

    filtered_data = data %>%
      filter(get_hb_name(HealthboardCode) == healthboard)

  }

  return(filtered_data)

}


filter_by_organism = function(data, organism_input, healthboard) {

  data = data %>%
    respiratory_filter_by_healthboard(healthboard)

  if(organism_input == "Total" & healthboard == "Scotland") {

    filtered_data = data %>%
      filter(total_number_flag == 1)

  } else if(organism_input == "Total" & healthboard != "Scotland") {

    filtered_data = data %>%
      filter(hb_flag == 1)

  } else if(organism_input != "Total" & healthboard == "Scotland") {

    filtered_data = data %>%
      filter(scotland_by_organism_flag == 1 & Organism == organism_input)

  } else if(organism_input != "Total" & healthboard != "Scotland") {

    filtered_data = data %>%
      filter(organism_by_hb_flag == 1 & Organism == organism_input)

  }

  return(filtered_data)

}

filter_over_time_plot_function <- function(data, healthboard) {

  data = data %>%
    respiratory_filter_by_healthboard(healthboard)

  if(healthboard == "Scotland") {

    filtered_data = data %>%
      filter(!(FluOrNonFlu == "flu" & Organism == "Total")) %>%
      filter(scotland_by_organism_flag == 1 | Organism == "Total")

  } else if(healthboard != "Scotland") {

    filtered_data = data %>%
      filter(!(FluOrNonFlu == "flu" & Organism == "Total")) %>%
      filter(organism_by_hb_flag == 1 | Organism == "Total")

  }

  return(filtered_data)

}

select_y_axis <- function(data, yaxis) {

  new_data <- data %>%
    mutate(y_axis = case_when(yaxis == "Number of cases" ~ Count,
                              yaxis == "Rate per 100,000" ~ Rate))

}


#############################################.
# PLOTS -----
#############################################.

# this plot makes a plot showing the rate/number of cases for each by each subtype
make_respiratory_trend_over_time_plot <- function(data, y_axis_title) {

  # Checking whether flu or non flu
  if("Adenovirus" %in% data$Organism){
    # nonflu
    colours <- c(phs_colours(c("phs-blue", "phs-rust", "phs-magenta",
                               "phs-green", "phs-teal", "phs-purple")), "black")
    linestyles <- c("dashdot", "longdashdot", "dash", "longdash", "solid", "dot", "solid")

    legend_title_name <- "Pathogen"

    } else {
    #flu
    colours <- c(phs_colours(c("phs-purple","phs-magenta","phs-green" , "phs-blue-80"  )), "black")
    legend_title_name <- "Subtype"
    }

      # Define custom order for "Organism" levels (makes legend same order as dropdowns in other charts)

  subtype_order <- c(
    "Influenza - Type B", "Influenza - Type A (not subtyped)","Influenza - Type A(H3)",
    "Influenza - Type A(H1N1)pdm09",
    "Influenza - Type A (any subtype)"
    )

  # Reorder the levels of "Organism" in descending order
  data$Organism <- factor(data$Organism, levels = subtype_order)
  
  week_order <- c(seq(40, 52, 1), seq(1, 39, 1)) # put weeks in correct order for season

  xaxis_plots[["title"]] <- "ISO week"
  yaxis_plots[["title"]] <- y_axis_title

  yaxis_plots[["fixedrange"]] <- FALSE

  fig = data %>%
    arrange(Season, Weekord) %>%
    mutate(Week = as.character(Week),
           Week = factor(Week, levels = week_order)) %>% 
    plot_ly(x = ~Week,
            y = ~y_axis,
            color = ~Organism,
            linetype = ~Organism,
            textposition = "none",
            text = ~paste0("<b>Week ending</b>: ", format(Date, "%d %b %y"), "\n",
                           "<b>Health board</b>: ", get_hb_name(HealthboardCode), "\n",
                           "<b>", legend_title_name, "</b>: ", Organism, "\n",
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


}

# this plot shows the rate/number of flu cases over the different seasons (so can easily compare differences in flu cases by season)
make_respiratory_trend_by_season_plot_function <- function(data, y_axis_title) {

  # put weeks in correct order for season
  week_order <- c(seq(40, 52, 1), seq(1, 39, 1))

  data = data %>%
    filter(Week != "53") %>%
    select(Season, Weekord, y_axis, Week, HealthboardCode) %>%
    arrange(Season, Weekord) %>%
    mutate(Week = as.character(Week),
           Week = factor(Week, levels = week_order))

  xaxis_plots[["title"]] <- "ISO week"

  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE
  yaxis_plots[["title"]] <- y_axis_title


  fig = data %>%
    plot_ly(x = ~Week,
            y = ~y_axis,
            textposition = "none",
            text = ~paste0("<b>ISO week</b>: ", Week, "\n",
                           "<b>Health board</b>: ", get_hb_name(HealthboardCode), "\n",
                           "<b>", y_axis_title, "</b>: ", format(y_axis, big.mark=",")),
            hovertemplate = "%{text}",
            color = ~Season,
#            linetype = ~Season,
            type="scatter",
            mode="lines",
#            linetypes = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot", "solid"),
            colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-rust',
                                   'phs-blue', 'phs-green', 'phs-graphite'))) %>%
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
    mutate(Rate = case_when(
      Sex == "F" ~ -Rate,
      TRUE ~ Rate)) %>%
    mutate_if(is.numeric, ~replace_na(., 0)) %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+"))) %>%
    mutate(Sex = case_when(
      Sex == "F" ~ "Female",
      Sex == "M" ~ "Male",
      TRUE ~ NA_character_
    ))

  xaxis_breaks <- pretty(c(-max(data$Rate), 0, max(data$Rate)))
  yaxis_ticks <- list("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")
  yaxis_ticks <- list(categoryorder = "array",
                      categoryarray = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+"))


  fig = data %>%
    plot_ly(x= ~Rate,
            y= ~AgeGroup,
            color = ~Sex,
            type = 'bar',
            textposition = "none",
            text = ~paste0("<b>Season</b>: ", Season, "\n",
                           "<b>Sex</b>: ", Sex, "\n",
                           "<b>Age Group</b>: ", AgeGroup, "\n",
                           "<b>Rate per 100,000 population</b>: ", format(abs(Rate), big.mark=",")),
            hoverinfo = "text",
            #hovertemplate = "%{text}",
            colors = phs_colours(c("phs-purple", "phs-magenta"))) %>%
    layout(
      xaxis = list(
        tickvals = xaxis_breaks,
        ticktext = abs(xaxis_breaks),
        title = "Rate per 100,000 population",
        showline = TRUE,
        linecolor = 'black',
        range = c(-max(data$Rate), max(data$Rate))
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

