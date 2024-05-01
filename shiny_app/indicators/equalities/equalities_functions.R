

make_equalities_admission_ethnicity_plot <- function(data){


  #data %<>%
   # arrange(desc(WeekEnding)) %>%
   # mutate(WeekEnding = convert_opendata_date(WeekEnding))

  yaxis_plots[["title"]] <- "Ethnicity"
  xaxis_plots[["title"]] <- "Proportion of admissions"

  # Adding slider
 # xaxis_plots[["rangeslider"]] <- list(type = "date")
 # yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~Proportion, y = ~EthnicGroup,
              type="bar", orientation = "h",
              color=~Season,
              colors=phs_colours(c("phs-blue", "phs-purple")),
              hovertemplate = paste0('<b>Ethnicity</b>: %{y}<br>',
                                     '<b>Season</b>: %{text}<br>',
                                     '<b>Proportion</b>: %{x}')
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}

make_equalities_admission_simd_plot <- function(data){


  #data %<>%
  # arrange(desc(WeekEnding)) %>%
  # mutate(WeekEnding = convert_opendata_date(WeekEnding))

  yaxis_plots[["title"]] <- "SIMD"
  xaxis_plots[["title"]] <- "Proportion of admissions"

  # Adding slider
  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  #yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~Proportion, y = ~SIMD,
              type="bar", orientation = "h",
              color=~Season,
              colors=phs_colours(c("phs-blue", "phs-purple")),
              hovertemplate = paste0('<b>SIMD</b>: %{y}<br>',
                                     '<b>Season</b>: %{text}<br>',
                                     '<b>Proportion</b>: %{x}')
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}



