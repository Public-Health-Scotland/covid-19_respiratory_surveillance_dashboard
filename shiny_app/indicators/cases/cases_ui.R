tagList(

  fluidRow(width = 12,
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Estimated infections",
                    tagList(h3("Estimated COVID-19 infection rate"),
                            h4("ONS covid infection survey"),
                            tags$div(class = "headline",
                                     h3(glue("Figures from week ending {ONS %>% tail(1) %>%
                .$EndDate %>% convert_opendata_date() %>%  format('%d %b %y')}")),
                                     valueBox(value = {ONS %>% tail(1) %>%
                                         .$EstimatedRatio},
                                         subtitle = "Estimated prevalence",
                                         color = "blue",
                                         icon = icon_no_warning_fn("viruses")),
                                     valueBox(value = {ONS %>% tail(1) %>%
                                         .$EstimatedCases %>%
                                         format(big.mark = ",")},
                                         subtitle = "Estimated cases",
                                         color = "blue",
                                         icon = icon_no_warning_fn("people-group")),
                                     valueBox(value = {ONS %>% tail(1) %>%
                                         .$OfficialPositivityEstimate %>% round_half_up(1) %>%
                                         paste0("%")},
                                         subtitle = "Estimated positivity",
                                         color = "blue",
                                         icon = icon_no_warning_fn("percent")),
                                     # These linebreaks are here to make the banner big enough to
                                     # include all the valueBoxes
                                     linebreaks(6)),
                            fluidRow(height="600px", width =12, linebreaks(4)),
                            plotlyOutput("ons_cases_plot"))),
           tabPanel("R number",
                    tagList(h3("Estimated COVID-19 R number"),
                            tags$div(class = "headline",
                                     h3(glue("Figures from reporting date {R_Number %>% tail(1) %>%
                .$Date %>% convert_opendata_date() %>% format('%d %b %y')}")),
                                     valueBox(value = {R_Number %>% tail(1) %>%
                                         .$LowerBound},
                                         subtitle = "Lower R number estimate",
                                         color = "blue",
                                         icon = icon_no_warning_fn("arrows-down-to-line")),
                                     valueBox(value = {R_Number %>% tail(1) %>%
                                         .$UpperBound},
                                         subtitle = "Upper R number estimate",
                                         color = "blue",
                                         icon = icon_no_warning_fn("arrows-up-to-line")),
                            # These linebreaks are here to make the banner big enough to
                            # include all the valueBoxes
                            linebreaks(6)
                            ), #div
                            fluidRow(height="600px", width =12, linebreaks(4)),
                            plotlyOutput("r_number_plot"))),
           tabPanel("Wastewater",
                    tagList(h3("Seven day average trend in wastewater COVID-19"),
                            tags$div(class = "headline",
                                     h3(glue("Seven day average from week ending {Wastewater %>% tail(1) %>%
                .$Date %>% convert_opendata_date() %>% format('%d %b %y')}")),
                                     valueBox(value = {Wastewater %>% tail(1) %>%
                                         .$WastewaterSevenDayAverageMgc %>%
                                         signif(3) %>%
                                         paste("Mgc/p/d")},
                                         subtitle = "COVID-19 wastewater level",
                                         color = "blue",
                                         icon = icon_no_warning_fn("faucet-drip")),
                            # These linebreaks are here to make the banner big enough to
                            # include all the valueBoxes
                            linebreaks(6)
                            ), #div
                            fluidRow(height="600px", width =12, linebreaks(4)),
                            plotlyOutput("wastewater_plot")))
        ) #tabBox
  ), # fluid row

  fluidRow(height="600px", width =12, linebreaks(4)),

  fluidRow(width = 12,
      tabBox(width = NULL, type = "pills",
            tabPanel("Plot",
                      tagList(h3("Reported COVID-19 cases"),
                                 plotlyOutput("reported_cases_plot"))),
            tabPanel("Data",
                      tagList(h3("Reported COVID-19 cases data"),
                              dataTableOutput("reported_cases_table"))))
  ) #fluidrow

)#taglist
