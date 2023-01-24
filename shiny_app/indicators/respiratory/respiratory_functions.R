
##############################################.
# DATA FILTERS ----
##############################################.

# filter data by healthboard
respiratory_filter_by_healthboard = function(data, healthboard) {

  filtered_data = data %>%
    filter(phsmethods::match_area(HealthboardCode) == healthboard)

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
      filter(scotland_by_organism_flag == 1)

  } else if(healthboard != "Scotland") {

    filtered_data = data %>%
      filter(organism_by_hb_flag == 1)

  }

  return(filtered_data)

}

filter_by_sex_age = function(data, season, date, breakdown) {

  filtered_data <- data %>%
    filter(Season == season & Date == date)

  if(breakdown == "Age") {

    filtered_data = filtered_data %>%
      filter(scotland_by_age_flag == 1)


  } else if(breakdown == "Sex") {

    filtered_data = filtered_data %>%
      filter(scotland_by_sex_flag == 1)


  } else if(breakdown == "Age + Sex") {

    filtered_data = filtered_data %>%
      filter(scotland_by_age_sex_flag == 1)

  }

}


select_y_axis <- function(data, yaxis) {

  new_data <- data %>%
    mutate(y_axis = case_when(yaxis == "Number of cases" ~ Count,
                              yaxis == "Rate per 100,000" ~ Rate))

}


#############################################.
# PLOTS -----
#############################################.

# this plot shows the rate/number of flu cases over the different seasons (so can easily compare differences in flu cases by season)
make_respiratory_trend_by_season_plot_function <- function(data, y_axis_title) {

  # put weeks in correct order for season

  week_order <- c(seq(40, 52, 1), seq(1, 39, 1))

  data = data %>%
    select(Season, Weekord, y_axis, Week) %>%
    arrange(Season, Weekord) %>%
    mutate(Week = as.character(Week),
           Week = factor(Week, levels = week_order))

  xaxis_plots[["title"]] <- "Isoweek"

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  fig = data %>%
    plot_ly(x = ~Week,
            y = ~y_axis,
            color = ~Season,
            type="scatter",
            mode="lines+markers",
            colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-blue', 'phs-green', 'phs-graphite'))) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)


}


# this plot makes a plot showing the rate/number of cases for each by each subtype
make_respiratory_trend_over_time_plot <- function(data, y_axis_title) {


  xaxis_plots[["title"]] <- "Date"
  yaxis_plots[["title"]] <- y_axis_title

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  fig = data %>%
    plot_ly(x = ~Date,
            y = ~y_axis,
            color = ~Organism,
            type="scatter",
            mode="lines+markers",
            colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-blue', 'phs-green', 'phs-graphite'))) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)


}

# creates a plot looking at age/sex breakdowns in scotland
age_sex_plot <- function(data, breakdown, title = NULL) {

  if(breakdown == "Age") {

    fig = data %>%
      plot_ly(x= ~AgeGroup,
              y= ~Rate,
              size = ~Rate,
              colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-blue', 'phs-green', 'phs-graphite')),
              marker = list(opacity = 0.5, sizemode = 'diameter'),
              type = 'scatter',
              mode = 'markers') %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          tickfont = list(size=14),
                          titlefont = list(size=18),
                          showline = FALSE,
                          showlegend = T),
             xaxis = list(title = "Age Group",
                          tickfont = list(size=14),
                          titlefont = list(size=18)),
             title = title)

  } else if(breakdown == "Sex") {

    fig = data %>%
      plot_ly(x= ~Sex,
              y= ~Rate,
              color = ~Sex,
              type = 'bar',
              colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-blue', 'phs-green', 'phs-graphite'))) %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          tickfont = list(size=14),
                          titlefont = list(size=18),
                          showline = FALSE,
                          fixedrange=TRUE,
                          range = c(0,max(data$Rate)),
                          showlegend = T),
             xaxis = list(title = "Sex",
                          tickfont = list(size=14),
                          titlefont = list(size=18)),
             title = title)

  } else if(breakdown == "Age + Sex") {

    fig = data %>%
      plot_ly(x= ~AgeGroup,
              y= ~Rate,
              color = ~Sex,
              type = 'bar',
              colors = phs_colours(c('phs-purple', 'phs-magenta', 'phs-teal', 'phs-blue', 'phs-green', 'phs-graphite'))) %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          tickfont = list(size=14),
                          titlefont = list(size=18),
                          showline = FALSE,
                          fixedrange=TRUE,
                          range = c(0,max(data$y_axis)),
                          showlegend = T),
             xaxis = list(title = "Age group",
                          tickfont = list(size=14),
                          titlefont = list(size=18)),
             title = title)


  }

  fig <- fig %>%
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove)

  return(fig)


}




##############################################
# TABLES ----
##############################################.

# Inputs:
# data = the data table you'd like to style in DT
# names = a vector of stylised names. leave blank if pre-prepared
datatable_style_summary = function(data) {

  data %>%
    DT::datatable(rownames = FALSE,
                  filter = "none",
                  options = list(
                    dom="t",
                    initComplete = JS(
                      "function(settings, json) {",
                      "$(this.api().table().header()).css({'background-color': '#C5C3DA',
        'color': '#3F3685'});",
                      "}"),
                    "pageLength" = 15

                  )) %>%
    formatStyle(., columns = 1,
                fontWeight = "bold",
                color = "#3F3685",
                backgroundColor = "#C5C3DA") %>%
    formatStyle(., columns = 2:5,
                color = "black") %>%
    formatStyle(., columns = 6,
                color = "black",
                backgroundColor = styleInterval(c(0, 10, 20, 50, 100, 500, 1000, Inf),
                                                c("#ffffcc", '#ffeda0', '#fed976', "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#bd0026", "#800026")))

}


