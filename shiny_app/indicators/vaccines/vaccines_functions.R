
make_vaccine_wastage_plot <- function(data){


  data %<>%
    mutate(Month = convert_opendata_date(Month))

  yaxis_plots[["title"]] <- "Number of doses"
  xaxis_plots[["title"]] <- "Month"

  p <- plot_ly(data, x = ~Month, y = ~NumberOfDosesAdministered,
               type = 'bar', text = ~PercentageWasted,
               name = 'Number of doses administered',
               color = phs_colors("phs-teal"),
               hovertemplate = paste0('<b>Month</b>: %{x}<br>',
                                      '<b>Percentage wasted</b>: %{text}<br>'))%>%

    add_trace(y = ~NumberOfDosesWasted, name = 'Number of doses wasted',
              color = phs_colors("phs-blue")) %>%

    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),barmode = 'stack') %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

