
###########################
### HOSPITAL ADMISSIONS ###
###########################

# Weekly  Hospital Admissions plot
# need to  split the last week of admission data from the rest of the data and flag it as provisional
# BUT to show it as a line on the chart - need to slice the last 2 week's of data (i.e a start & end date)
# BUT to allow the hover text for the last data point of the **non-provisional** data  to show
# the provisional data must show a gap on the x-axis. This is done by creating
# a proxy start date (i.e. Sunday plus one) for the plotted provisional data. 
# to further complicate things the  provisional data's hover text needs to only appear over the last Sunday, 
# (i.e.not over the proxy Monday date point). To do this the  wrangle creates **a 3rd dataframe**
# that only contains the last Sunday's datafor use asthe hover text (but it has no line element)


# Weekly Admissions by SIMD plot
make_hospital_admissions_simd_plot <- function(data){

  # put weeks in correct order for season
  week_order <- c(seq(40, 52, 1), seq(1, 39, 1))
  
  data <- data %>%  
    mutate(WeekNumber = as.numeric(substr(week, nchar(week) - 1, nchar(week))),
           WeekNumber = factor(WeekNumber, levels = week_order))

  yaxis_plots[["title"]] <- "Rate of hospital admissions<br>per 100,000 population"
  xaxis_plots[["title"]] <- "Week number"
  xaxis_plots[["dtick"]] <- 2
  xaxis_plots[["range"]] <- list(-0.5, 52.5)
  yaxis_plots[["tickformat"]] <- NULL
  
  # Adding slider
  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~WeekNumber, y = ~RateAdmissionsPerWeek, split = ~SIMD, text=~SIMD,
              type="scatter", mode="lines",
              color=~SIMD,
              colors=phs_colours(c("phs-rust", "phs-liberty-30", "phs-liberty-30",
                                   "phs-liberty-30", "phs-blue")),
              linetype = ~SIMD,
              linetypes = c("dash", "solid", "solid", "solid", "dot"),
              hovertemplate = paste0('<b>Week number</b>: %{x}<br>',
                                     '<b>SIMD quintile</b>: %{text}<br>',
                                     '<b>Admission rate per 100k</b>: %{y}')
    ) %>%
    layout(margin = list(b = 50, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.3, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}

# Hospital Admissions LOS plot

make_hospital_admissions_los_plot <- function(data){
  table <- data 
  
  tooltip_trend <- paste0("Season: ", table$Season, "<br>",
                          "Age group: ", table$AgeGroup, "<br>",
                          "Average Length of Stay: ", round(table$AverageLengthOfStay, 1), " days<br>",
                          #,
                          "95% CI: ", round(table$ci_lower, 1), " - ", round(table$ci_upper, 1), " days")
  
  
  xaxis_plots[["title"]] <- 'Age group'
  yaxis_plots[["title"]] <- 'Percentage of admissions'
  yaxis_plots[["ticksuffix"]] <- "%"
 
  p <- table %>%
    plot_ly(
      x = ~AgeGroup,
      y = ~AverageLengthOfStay,
      type = 'scatter',
      mode = 'markers',
      text = tooltip_trend,
      hoverinfo = "text",
      marker = list(size = 15, color = "#3F3685")
      , error_y = list(
        type = "data",
        symmetric = FALSE,
        array = ~ci_upper - AverageLengthOfStay,
        arrayminus = ~AverageLengthOfStay - ci_lower,
        color = "black",
        thickness = 1.5,
        width = 5)
          ) %>%
    layout(
      yaxis = list(
        title = "Average Length of Stay (days)",
        showgrid = FALSE,
        zeroline = FALSE,
        showline = TRUE,
        linecolor = "black",
        linewidth = 1
      ),
      xaxis = list(
        title = "Age Groups",
        showgrid = FALSE,
        zeroline = FALSE,
        showline = TRUE,
        linecolor = "black",
        linewidth = 1
      ),
      paper_bgcolor = phs_colours("phs-liberty-10"),
      plot_bgcolor = phs_colours("phs-liberty-10"),
      margin = list(b = 80, t = 5)
    ) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  return(p)
  
}



make_admissions_age_table <- function(data) {
  
  data %>% 
    mutate(week_ending = as_date(week_ending)) %>% 
    arrange(desc(week_ending)) %>%
    select(week_ending, age_band, Admissions,
           rate)  %>% 
    rename(`Week Ending` = week_ending,
           `Age Group` = age_band,
           `Number of Admissions` = Admissions,
           `Admission Rate per 100k` = rate) %>% 
    make_table(filter_cols = c(1,2),
               add_separator_cols = c(3),
               add_separator_cols_1dp = c(4))
}
