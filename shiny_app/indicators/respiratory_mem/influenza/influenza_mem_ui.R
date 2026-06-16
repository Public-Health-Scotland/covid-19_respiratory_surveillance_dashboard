flu_cases_seasons <- 
  Respiratory_Pathogens_Test_Positivity_by_Age %>% 
  filter(pathogen == "Influenza (A or B)") %>% 
  select(season) %>% 
  unique() %>% 
  tail(6)

tagList(
  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland

                    tagList(h2(glue("Summary of laboratory-confirmed influenza cases in Scotland")),

                            tags$div(class = "headline",
                                     br(),
                                     # previous week total number
                                     valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                         .$CountPreviousWeek %>% format(big.mark=",")},
                                         subtitle = tagList(tags$strong(glue("({format(round_half_up(Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>% 
                                              .$RatePreviousWeek,1), nsmall = 1)} per 100,000)")),
                                         tags$br(),
                                              glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                .$DatePreviousWeek %>% format('%d %b %y')}")),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                         .$CountThisWeek %>% format(big.mark=",")},
                                         subtitle = tagList(tags$strong(glue("({format(round_half_up(Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>% 
                                              .$RateThisWeek,1), nsmall = 1)} per 100,000)")),
                                         tags$br(),
                                              glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                .$DateThisWeek %>% format('%d %b %y')}")),
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
           tagList(h2("Influenza percentage test positivity"),
                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(linebreaks(1),
                                           altTextUI("influenza_positivity_modal"),
                                           swabposDefinitionUI("influenza_swabpos"),
                                           withNavySpinner(plotlyOutput("influenza_positivity_plot")))),
                          tabPanel("Data",
                                   tagList(
                                     withNavySpinner(dataTableOutput("influenza_positivity_table"))
                                   ) # tagList
                          ) # tabPanel
                   ) # tabBox
           ) # tagList
  ), #fluidrow
  
  
  fluidRow(width = 12,
           tagList(h2("Influenza percentage test positivity by age"),
                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   br(),
                                   pickerInput(inputId = "test_pos_flu_age",
                                               label = "Select season",
                                               choices = {flu_cases_seasons %>% tail(6) },
                                               selected = {flu_cases_seasons %>% tail(1)}),
                                   tagList(linebreaks(1),
                                           altTextUI("flu_positivity_age_modal"),
                                           swabposDefinitionUI("flu_age_swabpos"),
                                           withNavySpinner(plotlyOutput("flu_positivity_age_plot")))),
                          tabPanel("Data",
                                   tagList(
                                     withNavySpinner(dataTableOutput("flu_positivity_age_table"))
                                   ) # tagList
                          ) # tabPanel
                   ) # tabBox
           ) # tagList
  ), #fluidrow
  
  fluidRow(width = 12,
           tagList(h2("Laboratory-confirmed influenza incidence per 100,000 population in Scotland"))),

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
           tagList(h2("Laboratory-confirmed influenza incidence per 100,000 population by NHS Health Board"))),
   

   fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("influenza_mem_hb_plot", height = "500px")),
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
           tagList(h2("Laboratory-confirmed influenza incidence per 100,000 population by age group"))),

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
    tagList(h2(glue("Laboratory-confirmed influenza cases by age and sex in Scotland")),

            tabBox(width = NULL,
                   type = "pills",
                   tabPanel("Plot",
                            tagList(
                              linebreaks(1),
                              # adding selection for flu subtype
                              fluidRow(
                                column(4, pickerInput("flu_respiratory_season",
                                                      label = "Select a season",
                                                      choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "flu") %>%
                                                          .$Season %>% unique() %>% gsub("/", "/20", .) %>% tail(6)},
                                                      selected = {Respiratory_AllData %>% filter(FluOrNonFlu == "flu") %>%
                                                          .$Season %>% unique() %>% gsub("/", "/20", .) %>% tail(1)})
                                )
                              ),
                              altTextUI("influenza_age_sex"),
                              withNavySpinner(plotlyOutput("influenza_age_sex_pyramid_plot"))
                            ) # tagList
                   ), # tabPanel
                   tabPanel("Data",
                            withNavySpinner(dataTableOutput("influenza_age_sex_pyramid_table")))
            ) # tabbox
    ), # tagList
    linebreaks(1)
  )

)
