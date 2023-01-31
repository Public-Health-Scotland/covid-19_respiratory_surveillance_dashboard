tagList(
  fluidRow(width = 12,

           metadataButtonUI("cases"),
           h1("COVID-19 cases"),
           linebreaks(2)),

  fluidRow(width = 12,
               tagList(h2("Estimated COVID-19 infection rate"),
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
                                     # This text is hidden by css but helps pad the box at the bottom
                                     p("hidden text for padding page")
                                     )
                       ),
           linebreaks(1)),

  fluidRow(width=12,
           box(width = NULL,
                  altTextUI("ons_cases_modal"),
                  withNavySpinner(plotlyOutput("ons_cases_plot")),
                  fluidRow(
                  width=12, linebreaks(5))
                  )),

  fluidRow(
    width =12, br()),

  fluidRow(width = 12,
                  tagList(h2("Seven day average trend in wastewater COVID-19"),
                          tags$div(class = "headline",
                                   h3(glue("Figure from week ending {Wastewater %>% tail(1) %>%
                .$Date %>% convert_opendata_date() %>% format('%d %b %y')}")),
                                   valueBox(value = {Wastewater %>% tail(1) %>%
                                       .$WastewaterSevenDayAverageMgc %>%
                                       signif(3) %>%
                                       paste("Mgc/p/d")},
                                       subtitle = "COVID-19 wastewater level",
                                       color = "purple",
                                       icon = icon_no_warning_fn("faucet-drip")),
                                   # This text is hidden by css but helps pad the box at the bottom
                                   p("hidden text for padding page"))),
           linebreaks(1)),


  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("wastewater_modal"),
                            withNavySpinner(plotlyOutput("wastewater_plot")),
                            fluidRow(
                              width=12, linebreaks(5)))),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("wastewater_table"))
                            ) # tagList
                    ) # tabPanel

           ) # tabBox
    ), # fluidRow

  fluidRow(
    width = 12, br()),


  fluidRow(width = 12,
      tagList(h2("Reported COVID-19 cases"),
      tabBox(width = NULL,
             type = "pills",
            tabPanel("Plot",
                      tagList(linebreaks(1),
                              altTextUI("reported_cases_modal"),
                              withNavySpinner(plotlyOutput("reported_cases_plot")),
                              fluidRow(
                                width=12, linebreaks(5)))),
            tabPanel("Data",
                      tagList(
                              withNavySpinner(dataTableOutput("reported_cases_table"))
                              ) # tagList
                     ) # tabPanel
            ) # tabBox
           ) # tagList
  ), #fluidrow

  # Padding out the bottom of the page
  fluidRow(
    width=12, linebreaks(5))

)#taglist
