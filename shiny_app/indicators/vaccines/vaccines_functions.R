
make_vaccine_wastage_plot <- function(data){


  data %<>%
    mutate(Month = convert_opendata_date(Month),
           TotalDoses = NumberOfDosesAdministered + NumberOfDosesWasted)

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
               marker = list(color = phs_colours("phs-blue-80"),
                             line = list(width=.5,
                                         color = 'rgb(0,0,0)'),
                             pattern = list(shape = "")),
               hovertemplate = "%{text}")%>%

    add_trace(y = ~NumberOfDosesWasted, name = 'Doses wasted',
              marker = list(color = phs_colors("phs-rust"),
                            pattern = list(shape = "/",
                                           bgcolor = phs_colours("phs-rust-10"),
                                           solidity = "0.8"))) %>%

    # Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                        ycol = c("TotalDoses"),
                        xs= c("2021-12-01"),
                        notes=c("Before Dec 21 doses 1 & 2 only"),
                        colors= c(phs_colours("phs-purple"))) %>%

    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           barmode = 'stack',
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

make_vaccine_wastage_reason_plot <- function(data){

  data %<>%
    arrange(ReasonForWastagePc) %>%
    mutate(ReasonForWastage = str_to_sentence(ReasonForWastage))

  yaxis_plots[["title"]] <- "Reason for wastage"
  xaxis_plots[["title"]] <- "Percentage (%)"
  xaxis_plots[["ticksuffix"]] <- "%"

  p <- plot_ly(data, x = ~ReasonForWastagePc, y = ~reorder(ReasonForWastage,
                                                           ReasonForWastagePc),
               type = 'bar',
               orientation = "h",
               textposition = "none",
               text = ~paste0("<b>Reason for wastage</b>: ", ReasonForWastage, "\n",
                              "<b>Percentage</b>: ", ReasonForWastagePc, "%\n"),
               name = 'Reason for wastage',
               marker = list(color = phs_colours("phs-blue-80")),
               hovertemplate = "%{text}") %>%

    layout(margin = list(b = 80, t = 5),
         #  bargap = 0.8,
           height = 300,
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
         paper_bgcolor = phs_colours("phs-liberty-10"),
         plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}

