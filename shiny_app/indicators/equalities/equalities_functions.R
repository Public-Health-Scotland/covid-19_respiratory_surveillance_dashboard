

make_equalities_admission_ethnicity_plot <- function(data){


  data %<>%
   # arrange(desc(WeekEnding)) %>%
    mutate(Proportion = round_half_up(Proportion,2))

  yaxis_plots[["title"]] <- ""
  xaxis_plots[["title"]] <- "Percentage of admissions (%)"

  # Adding slider
 # xaxis_plots[["rangeslider"]] <- list(type = "date")
 # yaxis_plots[["fixedrange"]] <- FALSE


  p <- plot_ly(data) %>%
    add_trace(x = ~Proportion, y = ~EthnicGroup,
              type="bar", orientation = "h",
              color=~Season,
              colors=phs_colours(c("phs-blue", "phs-purple")),
              hovertemplate = ~paste0('<b>Season</b>:', Season, "<br>",
                                      '<b>Ethnic Group</b>: %{y}<br>',
                                      '<b>Percentage (%)</b>: %{x}')
    ) %>%
    layout(margin = list(b = 100, t = 5, l = 150),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}

make_equalities_admission_simd_plot <- function(data){


  data %<>%
  # arrange(desc(WeekEnding)) %>%
  mutate(Proportion = round_half_up(Proportion,2))


  yaxis_plots[["title"]] <- ""
  xaxis_plots[["title"]] <- "Percentage of admissions (%)"

  # Adding slider
  #xaxis_plots[["rangeslider"]] <- list(type = "date")
  #yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~Proportion, y = ~SIMD,
              type="bar", orientation = "h",
              color=~Season,
              colors=phs_colours(c("phs-blue", "phs-purple")),
              hovertemplate = ~paste0('<b>Season</b>:', Season, "<br>",
                                      '<b>Deprivation quintile</b>: %{y}<br>',
                                      '<b>Percentage (%)</b>: %{x}')
    ) %>%
    layout(margin = list(b = 100, t = 5, l = 150),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}



