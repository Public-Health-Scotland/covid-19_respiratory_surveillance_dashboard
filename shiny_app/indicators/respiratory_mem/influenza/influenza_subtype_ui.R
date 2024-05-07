tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_influenza_subtype"),
           linebreaks(1),
           #h1("Influenza by subtype"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    tags$div(class = "headline",
                             h3(glue("Influenza cases by NHS Health Board and subtype")),
                             h4(glue("during week {this_week_iso} (ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                    .$DateThisWeek %>% format('%d %b %y')})")),
                             linebreaks(1),
                             column(6,
                                    tagList(
                                      pickerInput("respiratory_headline_subtype",
                                                  label = glue("Select subtype"),
                                                  choices = {Respiratory_Summary_Factor %>%
                                                      filter(FluOrNonFlu == "flu" & SummaryMeasure == "Scotland_by_Organism_Total") %>%
                                                      arrange(desc(Breakdown) )%>% # makes drop down default to match value box at top of tab
                                                      .$Breakdown %>% unique() %>% as.character()}),
                                      withNavySpinner(valueBoxOutput("respiratory_headline_figures_subtype_count", width = NULL))
                                    )
                             ),
                             column(6,
                                    tagList(
                                      pickerInput("respiratory_headline_healthboard",
                                                  label = "Select a NHS Health Board",
                                                  choices = {Respiratory_HB %>%
                                                      .$HBName %>% unique() %>% sort()}
                                      ),  # pickerInput
                                      withNavySpinner(valueBoxOutput("respiratory_headline_figures_healthboard_count", width = NULL))
                                    ) # tagList
                             ), # column

                             # This text is hidden by css but helps pad the box at the bottom
                             h6("hidden text for padding page")
                    ) # headline
           ),
           linebreaks(1)
  ),


  fluidRow(width = 12,
           tagList(h2("Trends of influenza cases in Scotland"))),



  # select healthboard and rate/number for plots and data
  fluidRow(width = 12,
           column(6, pickerInput("respiratory_select_healthboard",
                                            label = "Select geography (Scotland/NHS Health Board)",
                                            choices = c("Scotland", {Respiratory_AllData %>%
                                                filter(!is.na(HealthboardCode)) %>%
                                                .$HealthboardCode %>% unique() %>% get_hb_name() %>% .[.!="NHS Scotland"]})
                      ) # pickerInput
                      ), # column
           column(6, pickerInput("respiratory_y_axis_plots",
                                            label = p("Select number of cases or rate in population",
                                                      popify(bsButton("resp-cases-info",
                                                                      label = HTML(glue(
                                                                        "<label class='sr-only'>Click button for more information</label>")),
                                                                      icon = icon("circle-info"),
                                                                      size = "default"),
                                                             title = "",
                                                             content = paste("Number of cases are only available at ",
                                                                             "Scotland level.", "<br>", "<br>",
                                                                             strong("Click again to close.")),
                                                             placement = "top",
                                                             trigger = "click",
                                                             options = list(id = "resp-cases-info",
                                                                            container = "body", html = "true"))),
                                            choices = c("Number of cases", "Rate per 100,000"),
                                            selected = "Number of cases") # pickerInput
                      )
                    ),


  fluidRow(width = 12,
           tagList(uiOutput("respiratory_over_time_title"),#h3(glue("Influenza cases over time by subtype")),

                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(
                                     linebreaks(1),
                                     altTextUI("respiratory_over_time_modal"),
                                     withNavySpinner(plotlyOutput("respiratory_over_time_plot")))),
                          tabPanel("Data",
                                   withNavySpinner(dataTableOutput("respiratory_over_time_table")))
                   ) # tabbox
           ) # taglist)
  ),

  fluidRow(width = 12,
           linebreaks(2)),

  fluidRow(width = 12,
           tagList(uiOutput("respiratory_by_season_title"),#h3(glue("Influenza cases over time by season")),

                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(
                                     linebreaks(1),
                                     # adding selection forsubtype
                                     fluidRow(
                                       column(6, pickerInput("respiratory_select_subtype",
                                                             label = glue("Select which subtype you would like to see"),
                                                             choices = {Respiratory_AllData %>%
                                                                 filter(FluOrNonFlu == "flu" & !is.na(Organism)) %>% 
                                                               arrange(desc(Organism)) %>%  # makes drop down default to match value box at top of tab
                                                                 filter(!(FluOrNonFlu == "flu" & Organism == "Total")) %>%.$Organism %>% unique() %>% as.character()}) # pickerInput
                                       ) # column
                                     ), # fluidRow
                                     altTextUI("respiratory_by_season_modal"),
                                     withNavySpinner(plotlyOutput("respiratory_by_season_plot"))
                                   ) # tagList
                          ), # tabPanel
                          tabPanel("Data",
                                   withNavySpinner(dataTableOutput("respiratory_by_season_table")))
                   ) # tabbox
           )#, # tagList
  ),

  fluidRow(width = 12,
           linebreaks(2))

  )
