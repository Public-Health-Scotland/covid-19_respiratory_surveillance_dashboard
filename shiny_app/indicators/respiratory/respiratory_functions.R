
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
    colours <- c(phs_colours(c("phs-purple", "phs-teal", "phs-green", "phs-rust")), "black")
    linestyles <- c("solid", "solid", "solid", "dash", "dot")

    legend_title_name <- "Subtype"
    }

  data %<>% arrange(Date, Organism) %>%
    # Need to apply factor again to drop out the levels not present in this selection
    mutate(Organism = factor(Organism))

  xaxis_plots[["title"]] <- "Week ending"
  yaxis_plots[["title"]] <- y_axis_title

  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  fig = data %>%
    plot_ly(x = ~Date,
            y = ~y_axis,
            color = ~Organism,
            linetype = ~Organism,
            textposition = "none",
            text = ~paste0("<b>Week ending</b>: ", format(Date, "%d %b %y"), "\n",
                           "<b>Health board</b>: ", get_hb_name(HealthboardCode), "\n",
                           "<b>", legend_title_name, "</b>: ", Organism, "\n",
                           "<b>", y_axis_title, "</b>: ", format(y_axis, big.mark=",")),
            hovertemplate = "%{text}",
            type="scatter",
            mode="lines",
            linetypes = linestyles,
            colors = colours
            ) %>%
    layout(yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           legend=list(title=list(text=paste0('<b>', legend_title_name, '</b>'))),
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

  xaxis_plots[["rangeslider"]] <- list(type = "date")
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
            linetype = ~Season,
            type="scatter",
            mode="lines",
            linetypes = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot", "solid"),
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
make_age_sex_plot <- function(data, breakdown, title = NULL) {

  if(breakdown == "Age") {

    fig = data %>%
      plot_ly(x= ~AgeGroup,
              y= ~Rate,
              size = ~Rate,
              name = "Cases",
              marker = list(opacity = 0.8, sizemode = 'area',
                            sizemin = 1, sizeref =0.1,
                            color = phs_colours("phs-teal")),
              textposition = "none",
              text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                             "<b>Age group</b>: ", AgeGroup, "\n",
                             "<b>Rate per 100,000</b>: ", format(Rate, big.mark=",")),
              hovertemplate = "%{text}",
              type = 'scatter',
              mode = 'markers') %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          showline = FALSE,
                          showlegend = T),
             xaxis = list(title = "Age Group"),
             title = title,
             paper_bgcolor = phs_colours("phs-liberty-10"),
             plot_bgcolor = phs_colours("phs-liberty-10"))

  } else if(breakdown == "Sex") {

    fig = data %>%
      plot_ly(x= ~Sex,
              y= ~Rate,
              color = ~Sex,
              textposition = "none",
              hoverinfo = "none",
              type = 'bar',
              colors = phs_colours(c('phs-teal', 'phs-teal-50'))) %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          showline = FALSE,
                          fixedrange=TRUE,
                          range = c(0,max(data$Rate)),
                          showlegend = T),
             xaxis = list(title = "Sex"),
             title = title,
             paper_bgcolor = phs_colours("phs-liberty-10"),
             plot_bgcolor = phs_colours("phs-liberty-10"))

  } else if(breakdown == "Age + Sex") {

    fig = data %>%
      plot_ly(x= ~AgeGroup,
              y= ~Rate,
              color = ~Sex,
              type = 'bar',
              textposition = "none",
              text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                             "<b>Sex</b>: ", Sex, "\n",
                             "<b>Age group</b>: ", AgeGroup, "\n",
                             "<b>Rate per 100,000</b>: ", format(Rate, big.mark=",")),
              hovertemplate = "%{text}",
              colors = phs_colours(c("phs-teal", "phs-teal-50"))) %>%
      layout(yaxis = list(title = "Rate per 100,000",
                          showline = FALSE,
                          fixedrange=TRUE,
                          range = c(0,max(data$y_axis)),
                          showlegend = T),
             xaxis = list(title = "Age group"),
             title = title,
             paper_bgcolor = phs_colours("phs-liberty-10"),
             plot_bgcolor = phs_colours("phs-liberty-10"))


  }

  fig <- fig %>%
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove)

  return(fig)


}

# creates a plot looking at age/sex breakdowns in scotland
make_age_sex_pyramid_plot <- function(data, title = NULL) {

  data %<>%
    mutate(Rate = case_when(
      Sex == "F" ~ -Rate,
      TRUE ~ Rate)) %>%
  mutate_if(is.numeric, ~replace_na(., 0)) %>%
    mutate(AgeGroup = as.factor(AgeGroup))

  xaxis_breaks <- pretty(c(-max(data$Rate), 0, max(data$Rate)))
  yaxis_ticks <- list("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")

  fig = data %>%
    plot_ly(x= ~Rate,
            y= ~AgeGroup,
            color = ~Sex,
            type = 'bar',
            textposition = "none",
            text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                           "<b>Sex</b>: ", Sex, "\n",
                           "<b>Age group</b>: ", AgeGroup, "\n",
                           "<b>Rate per 100,000</b>: ", format(Rate, big.mark=",")),
            hovertemplate = "%{text}",
            colors = phs_colours(c("phs-purple", "phs-magenta"))) %>%
    layout(
      xaxis = list(
        tickvals = xaxis_breaks,
        ticktext = abs(xaxis_breaks),
        title = "Rate per 100,000",
        showline = TRUE,
        linecolor = 'black',
        range = c(-max(data$Rate), max(data$Rate))
      ),
      yaxis = list(
        tickmode = "array",
        title = "Age Group",
        tickvals = yaxis_ticks,
        ticktext= yaxis_ticks,
        showline = TRUE,
        linecolor = 'black',
        range = levels(factor(data$AgeGroup))
      ),
      legend = list(title = ""),
      annotations = list(
        x = 0,
        y = 1.05,
        xref = 'paper',
        yref = 'paper',
        text = "Age Group vs. Number of People",
        showarrow = FALSE,
        font = list(size = 16)
      ),
      margin = list(b = 100),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      title = title,
      barmode = 'overlay')
    # layout(yaxis = list(title = "AgeGroup",
    #                     showline = FALSE,
    #                     fixedrange=TRUE,
    #                     range = c(0,max(data$y_axis)),
    #                     showlegend = T),
          # xaxis = list(title = "Rate per 100,000"),
           #title = title,




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







