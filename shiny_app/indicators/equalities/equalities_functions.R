
palette <- c("#3F3685", "#9B4393", "#0078D4", "#83BB26", "#948DA3", "#1E7F84", "#C73918", "#6B5C85", "#80BCEA")

make_equalities_admission_ethnicity_plot <- function(data){
  
  
  data %<>%
    # arrange(desc(WeekEnding)) %>%
    mutate(Proportion = round_half_up(Rate,2)) %>% 
    mutate(col = case_match(EthnicDesc,
                            "African" ~ palette[1],
                            "Asian (inc. Scottish/British)" ~ palette[2],
                            "Caribbean or Black" ~ palette[3],
                            "Mixed/Multiple" ~ palette[4],
                            "Not Known" ~ palette[5],
                            "Other" ~ palette[6],
                            "White" ~ palette[7]))%>% 
    arrange(desc(EthnicDesc))
  
  
  yaxis_plots[["title"]] <- ""
  xaxis_plots[["title"]] <- "Rate of admission, per 1,000 population"
  
  # Adding slider
  # xaxis_plots[["rangeslider"]] <- list(type = "date")
  # yaxis_plots[["fixedrange"]] <- FALSE
  
  
  p <- plot_ly(data,x = ~Rate, y = c(~EthnicDesc,~EthnicGroup),
              type="bar", orientation = "h",
              marker = list(color = ~col),
              hovertemplate = ~paste0('<b>Season</b>:', Season, "<br>",
                                      '<b>Ethnic Group</b>: %{y}<br>',
                                      '<b>Rate</b>: %{x}'),
              name = " "
    ) %>%
    layout(margin = list(b = 10, t = 5, l = 200),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  
  p <- 
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

#################---

#Cases
make_equalities_cases_ethnicity_plot <- function(data){
  
  
  data %<>%
    # arrange(desc(WeekEnding)) %>%
    mutate(Rate = round_half_up(Rate,2)) %>% 
    mutate(col = case_match(EthnicDesc,
                            "African" ~ palette[1],
                            "Asian (inc. Scottish/British)" ~ palette[2],
                            "Caribbean or Black" ~ palette[3],
                            "Mixed/Multiple" ~ palette[4],
                            "Not Known" ~ palette[5],
                            "Other" ~ palette[6],
                            "White" ~ palette[7])) %>% 
    arrange(desc(EthnicDesc))
  
  yaxis_plots[["title"]] <- ""
  xaxis_plots[["title"]] <- "Rate of cases, per 1,000 population"
  
  # Adding slider
  # xaxis_plots[["rangeslider"]] <- list(type = "date")
  # yaxis_plots[["fixedrange"]] <- FALSE
  
  
  p <- plot_ly(data,x = ~Rate, y = c(~EthnicDesc,~EthnicGroup),
               type="bar", orientation = "h",
               marker = list(color = ~col),
               hovertemplate = ~paste0('<b>Season</b>:', Season, "<br>",
                                       '<b>Ethnic Group</b>: %{y}<br>',
                                       '<b>Rate</b>: %{x}'),
               name = " "
  ) %>%
    layout(margin = list(b = 10, t = 5, l = 200),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)
  
  
  p <- 
    return(p)
  
}

make_equalities_cases_simd_plot <- function(data){
  
  
  data %<>%
    # arrange(desc(WeekEnding)) %>%
    mutate(Proportion = round_half_up(Proportion,2))
  
  
  yaxis_plots[["title"]] <- ""
  xaxis_plots[["title"]] <- "Percentage of cases (%)"
  
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