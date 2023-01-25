
tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory"),
           h1("Other respiratory illnesses"),
           p("This is the epidemiological information on seasonal respiratory infection activity in Scotland (excluding COVID-19). "),
           linebreaks(2)
           ), # fluidRow

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",

                  ###### FLU PANEL #####
                  tabPanel("Influenza",
                           # headline figures for influenza in the week in Scotland
                           tagList(h4("Number of influenza cases in Scotland"),
                                   tags$div(class = "headline",
                                            h3("Total number of influenza cases in Scotland over the last two weeks"),
                                            # this week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "flu") %>%
                                                .$CountThisWeek},
                                                     subtitle = glue("Week beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                        .$DateThisWeek %>% format('%d %b %y')}"),
                                                     color = "teal",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            # previous week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "flu") %>%
                                                .$CountPreviousWeek},
                                                subtitle = glue("Week beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                  .$DatePreviousWeek %>% format('%d %b %y')}"),
                                                color = "teal",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # percentage difference between the previous weeks
                                            valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                   .$PercentageDifference}%"),
                                                subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                   .$ChangeFactor %>% str_to_title()} in influenza cases"),
                                                color = "teal",
                                                icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == "flu") %>%
                                                    .$icon})),
                                            linebreaks(7)
                                            ), # headline

                                   # headline figures for the week by subtype (scotland totals) and healthboard
                                   tags$div(class = "headline",
                                            h3("Number of influenza cases by healthboard and subtype"),
                                            h4(glue("during week {this_week_iso} (beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                              .$DateThisWeek %>% format('%d %b %y')})")),
                                            linebreaks(1),
                                            column(6,
                                                   tagList(
                                                     pickerInput("respiratory_flu_headline_subtype",
                                                                       label = "Select subtype",
                                                                         choices = {Respiratory_Summary %>%
                                                                           filter(FluOrNonFlu == "flu" & SummaryMeasure == "Scotland_by_Organism_Total") %>% arrange(Breakdown) %>%
                                                                           .$Breakdown %>% unique() %>% as.character()},
                                                                       selected = "Influenza - Type A or B"),
                                                     withNavySpinner(valueBoxOutput("respiratory_flu_headline_figures_subtype_count", width = NULL))
                                                   )
                                                   ),
                                            column(6,
                                                   tagList(
                                                     pickerInput("respiratory_flu_headline_healthboard",
                                                                    label = "Select a healthboard",
                                                                    choices = {Respiratory_Summary %>%
                                                                        filter(FluOrNonFlu == "flu" & SummaryMeasure == "Healthboard_Total") %>%
                                                                        .$Breakdown %>% unique() %>% phsmethods::match_area()}
                                                                 ),  # pickerInput
                                                     withNavySpinner(valueBoxOutput("respiratory_flu_headline_figures_healthboard_count", width = NULL))
                                                   ) # tagList
                                                   ), # column

                                                        linebreaks(10)
                                            ) # headline
                           ), # tagList

                           fluidRow(
                             width=12, linebreaks(3)),

                           # select healthboard and rate/number for plots and data
                           fluidRow(
                             column(6, pickerInput("respiratory_flu_select_healthboard",
                                                      label = "Select whether you would like to see Scotland totals or choose a NHS healthboard",
                                                      choices = c("Scotland", {Respiratory_AllData %>%
                                                          filter(!is.na(HealthboardCode)) %>% .$HealthboardCode %>% unique() %>% phsmethods::match_area()})
                                                   ) # pickerInput
                                    ), # column
                             column(6, pickerInput("respiratory_flu_y_axis_plots",
                                                   label = "Select whether you would like to see flu rates or total number of cases",
                                                   choices = c("Number of cases", "Rate per 100,000"),
                                                   selected = "Number of cases") # pickerInput
                                    ) # column
                             ),

                           # plot and data for Influenza cases by subtype over time
                           tagList(h3("Influenza cases over time by subtype"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     altTextUI("respiratory_flu_over_time_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_over_time_plot")))),
                                          tabPanel("Data",
                                                   withNavySpinner(dataTableOutput("respiratory_flu_over_time_table")))
                                          ) # tabbox
                                   ), # taglist

                           tagList(h3("Influenza cases over time by season"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(6, pickerInput("respiratory_select_flu_subtype",
                                                                                label = "Select which subtype you would like to see",
                                                                                choices = {Respiratory_AllData %>%
                                                                                    filter(FluOrNonFlu == "flu" & !is.na(Organism)) %>% arrange(Organism) %>%
                                                                                    .$Organism %>% unique() %>% as.character()},
                                                                                selected = "Total") # pickerInput
                                                              ) # column
                                                       ), # fluidRow
                                                     altTextUI("respiratory_flu_by_season_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_by_season_plot"))
                                                     ) # tagList
                                                   ), # tabPanel
                                          tabPanel("Data")
                                          ) # tabbox
                                   ), # tagList

                           tagList(h3("Influenza cases by age and/or sex in Scotland"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(4, pickerInput("respiratory_flu_season",
                                                                                label = "Select a season",
                                                                                choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "flu") %>% .$Season %>% unique()},
                                                                                selected = "2022/23")
                                                              ),
                                                       column(4, pickerInput("respiratory_flu_date",
                                                                                label = "Select date",
                                                                                choices = {Respiratory_AllData %>% filter(Season == "2022/23") %>% .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                                                                selected = {Respiratory_AllData %>% filter(Season == "2022/23") %>% .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                                                              ),
                                                       column(4, pickerInput("respiratory_flu_select_age_sex_breakdown",
                                                                                label = "Select the plot breakdown",
                                                                                choices = c("Age", "Sex", "Age + Sex"),
                                                                                selected = "Age")
                                                              )
                                                       ),
                                                     altTextUI("respiratory_flu_age_sex_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_age_sex_plot"))
                                                     ) # tagList
                                                   ), # tabPanel
                                          tabPanel("Data")
                                          ) # tabbox
                                   ) # tagList
                           ),

                  ###### NON FLU PANEL ############
                  tabPanel("Non-influenza",
                           # headline figures for non-influenza in the week in Scotland
                           tagList(h4("Number of non-influenza cases in Scotland"),
                                   tags$div(class = "headline",
                                            h3("Total number of non-influenza cases in Scotland over the last two weeks"),
                                            # this week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                                .$CountThisWeek},
                                                subtitle = glue("Week beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                                color = "teal",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # previous week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                                .$CountPreviousWeek},
                                                subtitle = glue("Week beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                .$DatePreviousWeek %>% format('%d %b %y')}"),
                                                color = "teal",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # percentage difference between the previous weeks
                                            valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                  .$PercentageDifference}%"),
                                                     subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                     .$ChangeFactor %>% str_to_title()} in influenza cases"),
                                                     color = "teal",
                                                     icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == "nonflu") %>%
                                                         .$icon})),
                                            linebreaks(8)
                                            ), # headline

                                   # headline figures for the week by subtype (scotland totals) and healthboard
                                   tags$div(class = "headline",
                                            h3("Number of non-influenza cases by healthboard and subtype"),
                                            h4(glue("during week {this_week_iso} (beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                    .$DateThisWeek %>% format('%d %b %y')})")),
                                            linebreaks(1),
                                            column(6,
                                                   tagList(
                                                     pickerInput("respiratory_nonflu_headline_subtype",
                                                                 label = "Select subtype",
                                                                 choices = {Respiratory_Summary %>%
                                                                     filter(FluOrNonFlu == "nonflu" & SummaryMeasure == "Scotland_by_Organism_Total") %>% arrange(Breakdown) %>%
                                                                     .$Breakdown %>% unique() %>% as.character()},
                                                                 selected = "Adenovirus"),
                                                     withNavySpinner(valueBoxOutput("respiratory_nonflu_headline_figures_subtype_count", width = NULL))
                                                   )
                                            ),
                                            column(6,
                                                   tagList(
                                                     pickerInput("respiratory_nonflu_headline_healthboard",
                                                                 label = "Select a healthboard",
                                                                 choices = {Respiratory_Summary %>%
                                                                     filter(FluOrNonFlu == "nonflu" & SummaryMeasure == "Healthboard_Total") %>%
                                                                     .$Breakdown %>% unique() %>% phsmethods::match_area()}
                                                     ),  # pickerInput
                                                     withNavySpinner(valueBoxOutput("respiratory_nonflu_headline_figures_healthboard_count", width = NULL))
                                                   ) # tagList
                                            ), # column

                                            linebreaks(10)
                                            ) # headline
                                   ), # tagList

                           fluidRow(
                             width=12, linebreaks(5)),

                           # select healthboard and rate/number for plots and data
                           fluidRow(
                             column(6, pickerInput("respiratory_nonflu_select_healthboard",
                                                   label = "Select whether you would like to see Scotland totals or choose a NHS healthboard",
                                                   choices = c("Scotland", {Respiratory_AllData %>%
                                                       filter(!is.na(HealthboardCode)) %>% .$HealthboardCode %>% unique() %>% phsmethods::match_area()})
                             ) # pickerInput
                             ), # column
                             column(6, pickerInput("respiratory_nonflu_y_axis_plots",
                                                   label = "Select whether you would like to see flu rates or total number of cases",
                                                   choices = c("Number of cases", "Rate per 100,000"),
                                                   selected = "Number of cases") # pickerInput
                             ) # column
                           ),

                           # plot and data for Non-influenza cases by subtype over time
                           tagList(h3("Non-influenza cases over time by subtype"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     altTextUI("respiratory_nonflu_over_time_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_over_time_plot")))),
                                          tabPanel("Data")
                                   ) # tabbox
                           ), # taglist

                           tagList(h3("Non-influenza cases over time by season"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(6, pickerInput("respiratory_select_nonflu_subtype",
                                                                             label = "Select which subtype you would like to see",
                                                                             choices = {Respiratory_AllData %>%
                                                                                 filter(FluOrNonFlu == "nonflu" & !is.na(Organism)) %>%
                                                                                 .$Organism %>% unique()},
                                                                             selected = "Total") # pickerInput
                                                       ) # column
                                                     ), # fluidRow
                                                     altTextUI("respiratory_nonflu_by_season_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_by_season_plot"))
                                                   ) # tagList
                                          ), # tabPanel
                                          tabPanel("Data")
                                   ) # tabbox
                           ), # tagList

                           tagList(h3("Non-influenza cases by age and/or sex in Scotland"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(4, pickerInput("respiratory_nonflu_season",
                                                                             label = "Select a season",
                                                                             choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "nonflu") %>% .$Season %>% unique()},
                                                                             selected = "2022/23")
                                                       ),
                                                       column(4, pickerInput("respiratory_nonflu_date",
                                                                             label = "Select date",
                                                                             choices = {Respiratory_AllData %>% filter(Season == "2022/23") %>% .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                                                             selected = {Respiratory_AllData %>% filter(Season == "2022/23") %>% .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                                                       ),
                                                       column(4, pickerInput("respiratory_nonflu_select_age_sex_breakdown",
                                                                             label = "Select the plot breakdown",
                                                                             choices = c("Age", "Sex", "Age + Sex"),
                                                                             selected = "Age")
                                                       )
                                                     ),
                                                     altTextUI("respiratory_nonflu_age_sex_modal"),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_age_sex_plot"))
                                                   ) # tagList
                                          ), # tabPanel
                                          tabPanel("Data")
                                   ) # tabbox
                           ) # tagList
                           ) # tabpanel
           ) # tabbox
        ), # fluidrow

  # Padding out the bottom of the page
  fluidRow(
    width=12, linebreaks(5))

)
