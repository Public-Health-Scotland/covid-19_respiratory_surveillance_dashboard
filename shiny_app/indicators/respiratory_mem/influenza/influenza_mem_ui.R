tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_influenza_mem"),
           linebreaks(1),
           #h1("Influenza Incidence Rates"),
           #p("Influenza, or flu, is a common infectious viral illness caused by influenza viruses.",
             #"Influenza can cause mild to severe illness with symptoms including fever (38°C or above),",
             #"cough, body aches, and fatigue. Influenza has a different presentation than the common",
             #"cold, with symptoms starting more suddenly, presenting more severely, and lasting longer.",
             #"Influenza can be caught all year round but is more common in the winter months.",
             #"Additional information can be found on the PHS page for influenza."),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Summary of influenza cases in Scotland")),
                            tags$div(class = "headline",
                                     h3(glue("Total number of influenza cases in Scotland over the last two weeks")),
                                     # this week total number
                                     valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "flu") %>%
                                         .$CountThisWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "flu") %>%
                                         .$CountPreviousWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                .$DatePreviousWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                  .$PercentageDifference}%"),
                                              subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                     .$ChangeFactor %>% str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == 'flu') %>%
                                                  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline

  fluidRow(width = 12,
           tagList(h2("Influenza incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_mem_modal"),
                            withNavySpinner(plotlyOutput("influenza_mem_plot")),
                            )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Influenza incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("influenza_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("Influenza incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_mem_age_modal"),
                            withNavySpinner(plotlyOutput("influenza_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(
    tagList(h2(glue("Influenza cases by age and/or sex in Scotland")),

            tabBox(width = NULL,
                   type = "pills",
                   tabPanel("Plot",
                            tagList(
                              linebreaks(1),
                              # adding selection for flu subtype
                              fluidRow(
                                column(4, pickerInput("respiratory_season",
                                                      label = "Select a season",
                                                      choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "flu") %>%
                                                          .$Season %>% unique()},
                                                      selected = "2022/23")
                                ),
                                column(4, pickerInput("respiratory_date",
                                                      label = "Select date",
                                                      choices = {Respiratory_AllData %>% filter(Season == "2022/23") %>%
                                                          .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                                      selected = {Respiratory_AllData %>% filter(Season == "2022/23") %>%
                                                          .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                                ),
                                column(4, pickerInput("respiratory_select_age_sex_breakdown",
                                                      label = "Select the plot breakdown",
                                                      choices = c("Age", "Sex", "Age + Sex"),
                                                      selected = "Age")
                                )
                              ),
                              altTextUI("influenza_age_sex"),
                              withNavySpinner(plotlyOutput("influenza_age_sex_plot"))
                            ) # tagList
                   ), # tabPanel
                   tabPanel("Data",
                            withNavySpinner(dataTableOutput("influenza_age_sex_table")))
            ) # tabbox
    ), # tagList
    linebreaks(1)
  )

)
