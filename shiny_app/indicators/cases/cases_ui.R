tagList(
  fluidRow(width = 12,

           metadataButtonUI("cases"),
           linebreaks(1),
           h1("COVID-19 cases"),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Estimated COVID-19 infection rate"),
                   h4("(ONS covid infection survey)"),
                   p("The Office for National Statistics (ONS) published their",
                     tags$a(href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/24march2023", "final COVID-19 Infection Survey report (external website)",  target="_blank"), " on 24 March 2023."),
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
                    icon = icon_no_warning_fn("viruses")),
                valueBox(value = {ONS %>% tail(1) %>%
                    .$UpperCIRatio},
                    subtitle = "Upper 95% confidence interval",
                    color = "purple",
                    icon = icon_no_warning_fn("viruses")),
                # This text is hidden by css but helps pad the box at the bottom
                h6("hidden text for padding page")
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
