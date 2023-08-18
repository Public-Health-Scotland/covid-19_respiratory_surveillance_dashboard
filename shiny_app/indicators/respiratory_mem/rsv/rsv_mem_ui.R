tagList(
  fluidRow(width = 12,
           
           metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h1("RSV Incidence Rates"),
           linebreaks(1)),

    fluidRow(width = 12,
             tabPanel(stringr::str_to_sentence("influenza"),
                      # headline figures for the week in Scotland
                      tagList(h2(glue("Summary of **Non-flu** cases in Scotland")),
                              tags$div(class = "headline",
                                       h3(glue("Total number of **Non-flu** cases in Scotland over the last two weeks")),
                                       # this week total number
                                       valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                           .$CountThisWeek %>% format(big.mark=",")},
                                           subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                           color = "teal",
                                           icon = icon_no_warning_fn("calendar-week")),
                                       # previous week total number
                                       valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                           .$CountPreviousWeek %>% format(big.mark=",")},
                                           subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                .$DatePreviousWeek %>% format('%d %b %y')}"),
                                           color = "teal",
                                           icon = icon_no_warning_fn("calendar-week")),
                                       # percentage difference between the previous weeks
                                       valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                  .$PercentageDifference}%"),
                                                subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                     .$ChangeFactor %>% str_to_sentence()} in the last week"),
                                                color = "teal",
                                                icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                    .$icon})),
                                       # This text is hidden by css but helps pad the box at the bottom
                                       h6("hidden text for padding page")
                              )))), # headline
    
  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population in Scotland"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_plot")),
                            )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population by NHS Health Board"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_mem_hb_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population by age group"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_age_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_age_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  )#, # fluidRow
  
)
                   