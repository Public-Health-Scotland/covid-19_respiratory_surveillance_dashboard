
make_vaccine_wastage_plot <- function(data){


  data %<>%
    mutate(Month = convert_opendata_date(Month))

  yaxis_plots[["title"]] <- "Number of doses"
  xaxis_plots[["title"]] <- "Month"

  p <- plot_ly(data, x = ~Month, y = ~NumberOfDosesAdministered,
               type = 'bar',
               textposition = "none",
               text = ~paste0("<b>Month</b>: ", format(Month, "%b %y"), "\n",
                              "<b>Doses administered</b>: ", format(NumberOfDosesAdministered, big.mark=","), "\n",
                              "<b>Doses wasted</b>: ", format(NumberOfDosesWasted, big.mark=","), "\n",
                              "<b>Percentage wasted</b>: ", PercentageWasted, "%\n"),
               name = 'Doses administered',
               marker = list(color = phs_colours("phs-magenta-50")),
               hovertemplate = "%{text}")%>%

    add_trace(y = ~NumberOfDosesWasted, name = 'Doses wasted',
              marker = list(color = phs_colours("phs-purple"))) %>%

    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           barmode = 'stack') %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

make_vaccine_wastage_reason_plot <- function(data){

  data %<>%
    arrange(ReasonForWastagePc)

  yaxis_plots[["title"]] <- "Reason for Wastage"
  xaxis_plots[["title"]] <- "Percentage (%)"
  xaxis_plots[["ticksuffix"]] <- "%"

  p <- plot_ly(data, x = ~ReasonForWastagePc, y = ~reorder(ReasonForWastage,
                                                           ReasonForWastagePc),
               type = 'bar',
               orientation = "h",
               textposition = "none",
               text = ~paste0("<b>Reason For Wastage</b>: ", ReasonForWastage, "\n",
                              "<b>Percentage</b>: ", ReasonForWastagePc, "%\n"),
               name = 'Reason for Wastage',
               marker = list(color = phs_colours("phs-teal-50")),
               hovertemplate = "%{text}") %>%

    layout(margin = list(b = 80, t = 5),
         #  bargap = 0.8,
           height = 300,
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5)) %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

