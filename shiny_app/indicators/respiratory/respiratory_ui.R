
tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory"),
           h1("Other respiratory illnesses"),
           p("This is the epidemiological information on seasonal respiratory infection activity in Scotland (excluding COVID-19). "),
           linebreaks(2)),

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
                                                     color = "purple",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            # previous week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "flu") %>%
                                                .$CountPreviousWeek},
                                                subtitle = glue("Week beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                  .$DatePreviousWeek %>% format('%d %b %y')}"),
                                                color = "purple",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # percentage difference between the previous weeks
                                            valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                   .$PercentageDifference}%"),
                                                subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                                   .$ChangeFactor %>% str_to_title()} in influenza cases"),
                                                color = "purple",
                                                icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == "flu") %>%
                                                    .$icon})),
                                            linebreaks(8)),

                                   # headline figures for the week by subtype (scotland totals) and healthboard
                                   tags$div(class = "headline",
                                            h3("Number of influenza cases by healthboard and subtype"),
                                            column(6,
                                                   pickerInput("respiratory_flu_headline_subtype",
                                                                     label = "Select subtype",
                                                                       choices = unique({Respiratory_Summary %>%
                                                                         filter(FluOrNonFlu == "flu" & SummaryMeasure == "Scotland_by_Organism_Total") %>%
                                                                         .$Breakdown}),
                                                                     selected = "Influenza - Type A or B")),
                                            column(6,
                                                   pickerInput("respiratory_flu_headline_healthboard",
                                                                  label = "Select a healthboard",
                                                                  choices = unique({Respiratory_Summary %>%
                                                                      filter(FluOrNonFlu == "flu" & SummaryMeasure == "Healthboard_Total") %>%
                                                                      .$Breakdown %>% phsmethods::match_area()}))),
                                            fluidRow(valueBox(value = textOutput("respiratory_flu_headline_figures_subtype_count"),
                                                              subtitle = glue("of selected subtype influenza cases in Scotland during week
                                                              {this_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                              .$DateThisWeek %>% format('%d %b %y')})"),
                                                              color = "blue",
                                                              icon = icon_no_warning_fn("virus"),
                                                              width = 6),
                                                     valueBox(value = textOutput("respiratory_flu_headline_figures_healthboard_count"),
                                                              subtitle = glue("influenza cases in chosen healthboard during week
                                                              {this_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                                                               .$DateThisWeek %>% format('%d %b %y')})"),
                                                              color = "green",
                                                              icon = icon_no_warning_fn("virus"),
                                                              width = 6),
                                                     linebreaks(8)))),

                           # select healthboard and rate/number for plots and data
                           fluidRow(
                             column(6, selectizeInput("respiratory_flu_select_healthboard",
                                                      label = "Select whether you would like to see Scotland totals or choose a NHS healthboard",
                                                      choices = c("Scotland", unique({Respiratory_AllData %>% filter(!is.na(HealthboardCode)) %>% .$HealthboardCode})))),
                             column(6, uiOutput("respiratory_flu_select_yaxis"))),

                           # plot and data for Influenza cases by subtype over time
                           tagList(h3("Influenza cases over time by subtype"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_over_time_plot")))),
                                          tabPanel("Data"))),

                           tagList(h3("Influenza cases over time by season"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(6, selectizeInput("respiratory_select_flu_subtype",
                                                                                label = "Select which subtype you would like to see",
                                                                                choices = c(unique({Respiratory_AllData %>% filter(FluOrNonFlu == "flu" & !is.na(Organism)) %>% .$Organism})),
                                                                                selected = "Total"))),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_by_season_plot")))),
                                          tabPanel("Data"))),

                           tagList(h3("Influenza cases by age and/or sex in Scotland"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(4, uiOutput("respiratory_flu_select_season")),
                                                       column(4, uiOutput("respiratory_flu_select_date")),
                                                       column(4, selectizeInput("respiratory_flu_select_age_sex_breakdown",
                                                                                label = "Select the plot breakdown",
                                                                                choices = c("Age", "Sex", "Age + Sex"),
                                                                                selected = "Age"))),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_flu_age_sex_plot")))),
                                          tabPanel("Data")),
                                   linebreaks(2))),

                  ###### NON FLU PANEL ############
                  tabPanel("Non-influenza",
                           tagList(h4("Number of non-influenza cases in Scotland"),
                                   tags$div(class = "headline",
                                            h3("Total number of non-influenza cases in Scotland over the last two weeks"),
                                            # this week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                                .$CountThisWeek},
                                                subtitle = glue("Figures from week {this_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                .$DateThisWeek %>% format('%d %b %y')})"),
                                                color = "purple",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # previous week total number
                                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == "nonflu") %>%
                                                .$CountPreviousWeek},
                                                subtitle = glue("Figures from week {prev_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                .$DatePreviousWeek %>% format('%d %b %y')})"),
                                                color = "purple",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # percentage difference between the previous weeks
                                            valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                  .$PercentageDifference}%"),
                                                     subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                     .$ChangeFactor %>% str_to_title()} in influenza cases"),
                                                     color = "purple",
                                                     icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == "nonflu") %>%
                                                         .$icon})),
                                            linebreaks(8)),

                                   # headline figures for the week by subtype (scotland totals) and healthboard
                                   tags$div(class = "headline",
                                            h3("Number of non-influenza cases by healthboard and subtype"),
                                            column(6,
                                                   selectizeInput("respiratory_nonflu_headline_subtype",
                                                                  label = "Select subtype",
                                                                  choices = unique({Respiratory_Summary %>%
                                                                      filter(FluOrNonFlu == "nonflu" & SummaryMeasure == "Scotland_by_Organism_Total") %>%
                                                                      .$Breakdown}),
                                                                  selected = "Adenovirus")),
                                            column(6,
                                                   selectizeInput("respiratory_nonflu_headline_healthboard",
                                                                  label = "Select a healthboard",
                                                                  choices = unique({Respiratory_Summary %>%
                                                                      filter(FluOrNonFlu == "nonflu" & SummaryMeasure == "Healthboard_Total") %>%
                                                                      .$Breakdown}))),
                                            fluidRow(valueBox(value = textOutput("respiratory_nonflu_headline_figures_subtype_count"),
                                                              subtitle = glue("of selected subtype influenza cases in Scotland during week
                                                                              {this_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                              .$DateThisWeek %>% format('%d %b %y')})"),
                                                              color = "blue",
                                                              icon = icon_no_warning_fn("virus"),
                                                              width = 6),
                                                     valueBox(value = textOutput("respiratory_nonflu_headline_figures_healthboard_count"),
                                                              subtitle = glue("non-influenza cases in chosen healthboard during week
                                                                              {this_week_iso} (w/c {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                                                              .$DateThisWeek %>% format('%d %b %y')})"),
                                                              color = "green",
                                                              icon = icon_no_warning_fn("virus"),
                                                              width = 6),
                                                     linebreaks(8)))),

                           # select healthboard and rate/number for plots and data
                           fluidRow(
                             column(6, selectizeInput("respiratory_nonflu_select_healthboard",
                                                      label = "Select whether you would like to see Scotland totals or choose a NHS healthboard",
                                                      choices = c("Scotland", unique({Respiratory_AllData %>% filter(!is.na(HealthboardCode)) %>% .$HealthboardCode})))),
                             column(6, uiOutput("respiratory_nonflu_select_yaxis"))),

                           # plot and data for Influenza cases by subtype over time
                           tagList(h3("Non-influenza cases over time by subtype"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_over_time_plot")))),
                                          tabPanel("Data"))),

                           tagList(h3("Non-influenza cases over time by season"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(6, selectizeInput("respiratory_select_nonflu_subtype",
                                                                                label = "Select which subtype you would like to see",
                                                                                choices = c(unique({Respiratory_AllData %>% filter(FluOrNonFlu == "nonflu" & !is.na(Organism)) %>% .$Organism})),
                                                                                selected = "Total"))),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_by_season_plot")))),
                                          tabPanel("Data"))),

                           tagList(h3("Influenza cases by age and/or sex in Scotland"),

                                   tabBox(width = NULL,
                                          type = "pills",
                                          tabPanel("Plot",
                                                   tagList(
                                                     linebreaks(1),
                                                     # adding selection for flu subtype
                                                     fluidRow(
                                                       column(4, uiOutput("respiratory_nonflu_select_season")),
                                                       column(4, uiOutput("respiratory_nonflu_select_date")),
                                                       column(4, selectizeInput("respiratory_nonflu_select_age_sex_breakdown",
                                                                                label = "Select the plot breakdown",
                                                                                choices = c("Age", "Sex", "Age + Sex"),
                                                                                selected = "Age"))),
                                                     # altTextUI(""),
                                                     withNavySpinner(plotlyOutput("respiratory_nonflu_age_sex_plot")))),
                                          tabPanel("Data")),
                                   linebreaks(2)))))


)
