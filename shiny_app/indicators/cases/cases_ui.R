tagList(
  fluidRow(width = 12,
           actionButton("jump_to_metadata_cases",
                        label = "Metadata",
                        class = "metadata-btn",
                        icon = icon_no_warning_fn("file-pen")
                        ),
           h1("COVID-19 cases"),
           linebreaks(2)),

  fluidRow(width = 12,
    tabBox(width = NULL,
           height = NULL,
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
                                         color = "purple",
                                         icon = icon_no_warning_fn("viruses")),
                                     valueBox(value = {ONS %>% tail(1) %>%
                                         .$LowerCIRatio},
                                         subtitle = "Lower 95% confidence interval",
                                         color = "purple",
                                         icon = icon_no_warning_fn("arrows-down-to-line")),
                                     valueBox(value = {ONS %>% tail(1) %>%
                                         .$UpperCIRatio},
                                         subtitle = "Upper 95% confidence interval",
                                         color = "purple",
                                         icon = icon_no_warning_fn("arrows-up-to-line")),
                                     # These linebreaks are here to make the banner big enough to
                                     # include all the valueBoxes
                                     linebreaks(6)),
                            fluidRow(
                              width=12, linebreaks(3)),
                            altTextUI("ons_cases_modal"),
                            withSpinner(plotlyOutput("ons_cases_plot")),
                            fluidRow(
                              width=12, linebreaks(5))
                            )),
           tabPanel("R number",
                    tagList(h3("Estimated COVID-19 R number"),
                            tags$div(class = "headline",
                                     h3(glue("Figures from reporting date {R_Number %>% tail(1) %>%
                .$Date %>% convert_opendata_date() %>% format('%d %b %y')}")),
                                     valueBox(value = {R_Number %>% tail(1) %>%
                                         .$LowerBound},
                                         subtitle = "Lower R number estimate",
                                         color = "purple",
                                         icon = icon_no_warning_fn("arrows-down-to-line")),
                                     valueBox(value = {R_Number %>% tail(1) %>%
                                         .$UpperBound},
                                         subtitle = "Upper R number estimate",
                                         color = "purple",
                                         icon = icon_no_warning_fn("arrows-up-to-line")),
                            # These linebreaks are here to make the banner big enough to
                            # include all the valueBoxes
                            linebreaks(6)
                            ), #div
                            fluidRow(
                                     width =12, linebreaks(3)),
                            altTextUI("r_number_modal"),
                            withSpinner(plotlyOutput("r_number_plot"))),
                    fluidRow(
                      width=12, linebreaks(5))),
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
                                         color = "purple",
                                         icon = icon_no_warning_fn("faucet-drip")),
                            # These linebreaks are here to make the banner big enough to
                            # include all the valueBoxes
                            linebreaks(6)
                            ), #div
                            fluidRow(
                                     width =12, linebreaks(3)),
                            altTextUI("wastewater_modal"),
                            withSpinner(plotlyOutput("wastewater_plot"))),
                    fluidRow(
                      width=12, linebreaks(5)))
        ) #tabBox
  ), # fluid row

  fluidRow(
    width =12, br()),

  fluidRow(width = 12,
      tabBox(width = NULL,
             type = "pills",
            tabPanel("Plot",
                      tagList(h3("Reported COVID-19 cases"),
                                 altTextUI("reported_cases_modal"),
                                 withSpinner(plotlyOutput("reported_cases_plot")),
                              fluidRow(
                                width=12, linebreaks(5)))),
            tabPanel("Data",
                      tagList(h3("Reported COVID-19 cases data"),
                              withSpinner(dataTableOutput("reported_cases_table")))))
  ), #fluidrow

  # Padding out the bottom of the page
  fluidRow(
    width=12, linebreaks(5))

)#taglist
