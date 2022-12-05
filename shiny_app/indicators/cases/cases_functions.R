make_reported_cases_plot <- function(data){


  data %<>%
    mutate(Date = convert_opendata_date(Date))

  yaxis_plots[["title"]] <- "Reported cases"
  xaxis_plots[["title"]] <- "Date"


  p <- plot_ly(data, x = ~Date,
               textposition = "none",
               text = ~paste0("<b>Date</b>: ", format(Date, "%d %b %y"), "\n",
                              "<b>Reported cases</b>: ", format(NumberCasesPerDay, big.mark=","), "\n",
                              "<b>7 day average</b>: ", format(round_half_up(SevenDayAverage, 1), big.mark=","), "\n"),
               hovertemplate = "%{text}")%>%

    add_lines(y = ~NumberCasesPerDay,
             line = list(color = phs_colours("phs-blue-50")),
             name = 'Reported cases') %>%

    add_lines(y = ~SevenDayAverage, name = '7 day average',
              line = list(color = phs_colours("phs-purple"))) %>%


#Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                             ycol = "NumberCasesPerDay",
                             xs= c("2022-01-06", "2022-05-01"),
                             notes=c("From 5 Jan cases  include PCR + LFD",
                                     "Change in testing policy on 1 May"),
                             colors=c(phs_colours("phs-rust"), phs_colours("phs-teal"))) %>%


    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           height = 500) %>%

    config(displaylogo = F, displayModeBar = TRUE)#,
          # modeBarButtonsToRemove = bttn_remove )

  return(p)

}