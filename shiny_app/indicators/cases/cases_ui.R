tagList(
  fluidRow(width = 12,

           metadataButtonUI("cases"),
           linebreaks(1),
           h1("COVID-19 cases"),
           linebreaks(1)),

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
                    color = "navy",
                    icon = icon_no_warning_fn("faucet-drip")),
                # This text is hidden by css but helps pad the box at the bottom
                h6("hidden text for padding page"))),
           linebreaks(1)),


  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("wastewater_modal"),
                            withNavySpinner(plotlyOutput("wastewater_plot")),
                            fluidRow(column(
                              width=12, linebreaks(5),
                              p("Wastewater concentration levels remain at low levels and week to week changes should be interpreted with caution."),
                            )))),
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
