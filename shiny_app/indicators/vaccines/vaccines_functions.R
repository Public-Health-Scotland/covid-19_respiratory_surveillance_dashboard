
make_vaccine_wastage_plot <- function(data){


  data %<>%
    mutate(Month = convert_opendata_date(Month))

  yaxis_plots[["title"]] <- "Number of doses"
  xaxis_plots[["title"]] <- "Month"

  p <- plot_ly(data, x = ~Month, y = ~NumberOfDosesAdministered,
               type = 'bar',
               text = ~paste0("<b>Month</b>: ", format(Month, "%b %y"), "\n",
                              "<b>Doses administered</b>: ", format(NumberOfDosesAdministered, big.mark=","), "\n",
                              "<b>Doses wasted</b>: ", format(NumberOfDosesWasted, big.mark=","), "\n",
                              "<b>Percentage wasted</b>: ", PercentageWasted, "%\n"),
               name = 'Doses administered',
               color = phs_colors("phs-teal"),
               hovertemplate = "%{text}")%>%

    add_trace(y = ~NumberOfDosesWasted, name = 'Doses wasted',
              color = phs_colors("phs-blue")) %>%

    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           barmode = 'stack') %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

