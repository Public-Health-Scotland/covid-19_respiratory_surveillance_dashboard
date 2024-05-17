tagList(
  fluidRow(width = 12,

           metadataButtonUI("cases"),
           linebreaks(1),
           # h1("COVID-19 cases"),
           # p("Coronavirus disease (COVID-19) is an infectious disease caused by the SARS-CoV-2 virus.",
           #   "The most common symptoms are fever, chills, and sore throat. Anyone can get sick with",
           #   "COVID-19 but most people will recover without treatment. As yet, COVID-19 has not been",
           #   "shown to follow the same seasonal patterns as other respiratory pathogens.",
           #   "Additional information can be found on the PHS page for" , tags$a(href = "https://publichealthscotland.scot/our-areas-of-work/conditions-and-diseases/covid-19/",
           #                                                                      "COVID-19"), "."),
           # linebreaks(1)
           ),

  fluidRow(width = 12,
           tagList(h2("Estimated COVID-19 infection rate"),
                   h4("(ONS winter covid infection survey)"),
                   p("Further SARS-CoV-2 prevalence results are available in the UKHSA report on Winter CIS, which can be found on their website",
                     tags$a(href="https://www.gov.uk/government/statistics/winter-coronavirus-covid-19-infection-study-estimates-of-epidemiological-characteristics-england-and-scotland-2023-to-2024", "UKHSA Winter Coronavirus Infection Study (external website)",  target="_blank"), "."),
                   p("Winter CIS survey closed on 06 March 2024 with the final report published 14 March 2024"),
                   tags$div(class = "headline",
                            h3(glue("Figures from week ending {Winter_CIS %>% tail(1) %>%
                .$EndDate %>% convert_opendata_date() %>%  format('%d %b %y')}")),
                            valueBox(value = {Winter_CIS %>% tail(1) %>%
                                .$EstimatedRatio},
                                subtitle = "Estimated prevalence",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            valueBox(value = {Winter_CIS %>% tail(1) %>%
                                .$LowerCIRatio},
                                subtitle = "Lower 95% confidence interval",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            valueBox(value = {Winter_CIS %>% tail(1) %>%
                                .$UpperCIRatio},
                                subtitle = "Upper 95% confidence interval",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page")
                   )
           ),
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
                              p("Wastewater data analyses for COVID-19 are produced by",
                                "PHS Wastewater Analysis Group for the Wastewater Monitoring Programme in Scotland,",
                                "which is operated by Scottish Government in partnership with",
                                "Scottish Water and the Scottish Environment Protection Agency."),

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
