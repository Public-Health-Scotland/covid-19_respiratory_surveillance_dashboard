#### Respiratory module UI ----

respiratoryUI <- function(id) {

  ns <- NS(id)

  flu_or_nonflu <- id

  # Checking one of flu or nonflu is chosen
  stopifnot(flu_or_nonflu %in% c("flu", "nonflu"))

  if(flu_or_nonflu == "flu"){
    name_long = "influenza"
    strain_name = "subtype"
  } else {
    name_long = "other respiratory pathogens*"
    strain_name = "pathogen"
  }

  tabPanel(stringr::str_to_sentence(name_long),
           # headline figures for the week in Scotland
           tagList(h2(glue("Summary of {name_long} cases in Scotland")),
                   tags$div(class = "headline",
                            h3(glue("Total number of {name_long} cases in Scotland over the last two weeks")),
                            # this week total number
                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                .$CountThisWeek %>% format(big.mark=",")},
                                subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                color = "teal",
                                icon = icon_no_warning_fn("calendar-week")),
                            # previous week total number
                            valueBox(value = {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                .$CountPreviousWeek %>% format(big.mark=",")},
                                subtitle = glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                                .$DatePreviousWeek %>% format('%d %b %y')}"),
                                color = "teal",
                                icon = icon_no_warning_fn("calendar-week")),
                            # percentage difference between the previous weeks
                            valueBox(value = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                                  .$PercentageDifference}%"),
                                     subtitle = glue("{Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                                     .$ChangeFactor %>% str_to_sentence()} in the last week"),
                                     color = "teal",
                                     icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                         .$icon})),
                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page")
                            ), # headline

                   # headline figures for the week by subtype (scotland totals) and healthboard
                   tags$div(class = "headline",
                            h3(glue("{stringr::str_to_sentence(name_long)} cases by NHS Health Board and {strain_name}")),
                            h4(glue("during week {this_week_iso} (ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                    .$DateThisWeek %>% format('%d %b %y')})")),
                            linebreaks(1),
                            column(6,
                                   tagList(
                                     pickerInput(ns("respiratory_headline_subtype"),
                                                 label = glue("Select {strain_name}"),
                                                 choices = {Respiratory_Summary_Factor %>%
                                                     filter(FluOrNonFlu == flu_or_nonflu & SummaryMeasure == "Scotland_by_Organism_Total") %>%
                                                      arrange(Breakdown) %>%
                                                     .$Breakdown %>% unique() %>% as.character()}),
                                     withNavySpinner(valueBoxOutput(ns("respiratory_headline_figures_subtype_count"), width = NULL))
                                   )
                            ),
                            column(6,
                                   tagList(
                                     pickerInput(ns("respiratory_headline_healthboard"),
                                                 label = "Select a NHS Health Board",
                                                 choices = {Respiratory_HB %>%
                                                   .$HBName %>% unique() %>% sort()}
                                     ),  # pickerInput
                                     withNavySpinner(valueBoxOutput(ns("respiratory_headline_figures_healthboard_count"), width = NULL))
                                   ) # tagList
                            ), # column

                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page")
                            ) # headline
                   ), # tagList

           fluidRow(
             linebreaks(3)),


           tagList(h2(glue("Trends of {name_long} cases in Scotland"))),

           # select healthboard and rate/number for plots and data
           fluidRow(
             column(6, pickerInput(ns("respiratory_select_healthboard"),
                                   label = "Select geography (Scotland/NHS Health Board)",
                                   choices = c("Scotland", {Respiratory_AllData %>%
                                       filter(!is.na(HealthboardCode)) %>%
                                       .$HealthboardCode %>% unique() %>% get_hb_name() %>% .[.!="NHS Scotland"]})
             ) # pickerInput
             ), # column
             column(6, pickerInput(ns("respiratory_y_axis_plots"),
                                   label = p("Select number of cases or rate in population",
                                             popify(bsButton(ns("resp-cases-info"),
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

           # plot and data for cases by subtype over time
           tagList(h3(glue("{stringr::str_to_sentence(name_long)} cases over time by {strain_name}")),

                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(
                                     linebreaks(1),
                                     altTextUI(ns("respiratory_over_time_modal")),
                                     withNavySpinner(plotlyOutput(ns("respiratory_over_time_plot"))))),
                          tabPanel("Data",
                                   withNavySpinner(dataTableOutput(ns("respiratory_over_time_table"))))
                   ) # tabbox
           ), # taglist

           tagList(h3(glue("{stringr::str_to_sentence(name_long)} cases over time by season")),

                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(
                                     linebreaks(1),
                                     # adding selection forsubtype
                                     fluidRow(
                                       column(6, pickerInput(ns("respiratory_select_subtype"),
                                                             label = glue("Select which {strain_name} you would like to see"),
                                                             choices = {Respiratory_AllData %>%
                                                                 filter(FluOrNonFlu == flu_or_nonflu & !is.na(Organism)) %>% arrange(Organism) %>%
                                                                 filter(!(FluOrNonFlu == "flu" & Organism == "Total")) %>%.$Organism %>% unique() %>% as.character()}) # pickerInput
                                       ) # column
                                     ), # fluidRow
                                     altTextUI(ns("respiratory_by_season_modal")),
                                     withNavySpinner(plotlyOutput(ns("respiratory_by_season_plot")))
                                   ) # tagList
                          ), # tabPanel
                          tabPanel("Data",
                                   withNavySpinner(dataTableOutput(ns("respiratory_by_season_table"))))
                   ) # tabbox
           ), # tagList

           tagList(h3(glue("{stringr::str_to_sentence(name_long)} cases by age and/or sex in Scotland")),

                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(
                                     linebreaks(1),
                                     # adding selection for flu subtype
                                     fluidRow(
                                       column(4, pickerInput(ns("respiratory_season"),
                                                             label = "Select a season",
                                                             choices = {Respiratory_AllData %>% filter(FluOrNonFlu == flu_or_nonflu) %>%
                                                                 .$Season %>% unique()},
                                                             selected = "2022/23")
                                       ),
                                       column(4, pickerInput(ns("respiratory_date"),
                                                             label = "Select date",
                                                             choices = {Respiratory_AllData %>% filter(Season == "2022/23") %>%
                                                                 .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                                             selected = {Respiratory_AllData %>% filter(Season == "2022/23") %>%
                                                                 .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                                       ),
                                       column(4, pickerInput(ns("respiratory_select_age_sex_breakdown"),
                                                             label = "Select the plot breakdown",
                                                             choices = c("Age", "Sex", "Age + Sex"),
                                                             selected = "Age")
                                       )
                                     ),
                                     altTextUI(ns("respiratory_age_sex_modal")),
                                     withNavySpinner(plotlyOutput(ns("respiratory_age_sex_plot")))
                                   ) # tagList
                          ), # tabPanel
                          tabPanel("Data",
                                   withNavySpinner(dataTableOutput(ns("respiratory_age_sex_table"))))
                   ) # tabbox
           ) # tagList
           )

}


