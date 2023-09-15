tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h1("Additional respiratory infection activity data on other respiratory pathogens*"),
           p("*Please note that 'other respiratory pathogens' refers to all respiratory",
             " infections excluding influenza and COVID-19"),
           linebreaks(1)),

   # fluidRow
##########summary boxes ############
   tabPanel(stringr::str_to_sentence("influenza"),
            # headline figures for the week in Scotland
            tagList(h2(glue("Summary of other pathogen* cases in Scotland")),
                    tags$div(class = "headline",
                               h3(glue("Total number of other pathogen cases in Scotland over the last two weeks")),
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
                                       icon = icon_no_warning_fn({flu_icon_headline %>% filter(FluOrNonFlu == "nonflu") %>%
                                          .$icon})),
                               # This text is hidden by css but helps pad the box at the bottom
                               h6("hidden text for padding page")
                      )),
            
            # headline figures for the week by subtype (scotland totals) and healthboard
            
            tags$div(class = "headline",
            h3(glue("Other respiratory pathogen* cases by NHS Health Board")),
            h4(glue("during week {this_week_iso} (ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                                    .$DateThisWeek %>% format('%d %b %y')})")),
            linebreaks(1),
            column(6,
                   tagList(
                     pickerInput("respiratory_headline_pathogen",
                                 label = glue("Select pathogen"),
                                 choices = {Respiratory_Summary_Factor %>%
                                     filter(FluOrNonFlu == "nonflu" & SummaryMeasure == "Scotland_by_Organism_Total") %>%
                                     arrange(Breakdown) %>%
                                     .$Breakdown %>% unique() %>% as.character()}),
                     withNavySpinner(valueBoxOutput("respiratory_headline_figures_other_pathogen_count", width = NULL))
                   )
            )
            , 
            column(6,
                   tagList(
                     pickerInput("other_headline_healthboard",
                                 label = "Select a NHS Health Board",
                                 choices = {Respiratory_HB %>%
                                     .$HBName %>% unique() %>% sort()}
                     ),  # pickerInput
                     withNavySpinner(valueBoxOutput("headline_figures_other_pathogen_healthboard_count", width = NULL))
                   ) # tagList 
            ), # column
            # This text is hidden by css but helps pad the box at the bottom
            h6("hidden text for padding page")
   ) # headline
   ),
  linebreaks(1),

############################ trend section ###############

#tabbox
fluidRow(width = 12,
         tagList(h2("Trends of other pathogen* cases in Scotland"))),

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
         tagList(uiOutput("other_pathogens_over_time_title"),#h3(glue("Influenza cases over time by subtype")),
                 
                 tabBox(width = NULL,
                        type = "pills",
                        tabPanel("Plot",
                                 tagList(
                                   linebreaks(1),
                                   altTextUI("other_pathogens_over_time"),
                                   withNavySpinner(plotlyOutput("other_pathogens_over_time_plot")))),
                        tabPanel("Data",
                                 withNavySpinner(dataTableOutput("other_pathogens_over_time_table")))
                 ) # tabbox
         ) # taglist)
),

fluidRow(width = 12,
         linebreaks(2)),
### pathogens by season #####
fluidRow(width = 12,
         tagList(uiOutput("other_pathogens_by_season_title"),
                      tabBox(width = NULL,
                             type = "pills",
                             tabPanel("Plot",
                                      tagList(
                                        linebreaks(1),
                                        # adding selection forsubtype
                                        fluidRow(
                                          column(6, pickerInput(("respiratory_select_subtype"),
                                                                label = glue("Select which pathogen you would like to see"),
                                                                choices = {Respiratory_AllData %>%
                                                                    filter(FluOrNonFlu == "nonflu" & !is.na(Organism)) %>% arrange(Organism) %>%
                                                                    filter(!(FluOrNonFlu == "nonflu" & Organism == "Total")) %>%.$Organism %>% unique() %>% as.character()}) # pickerInput
                                          ) # column
                                        ), # fluidRow
                                        altTextUI("other_pathogens_by_season"),
                                        withNavySpinner(plotlyOutput("other_pathogens_by_season_plot"))
                                      ) # tagList
                             ), # tabPanel
                             tabPanel("Data",
                                     withNavySpinner(dataTableOutput("other_pathogens_by_season_table")))
                      )
         ), # tabBox
         linebreaks(1)
), # fluidRow


fluidRow(
  tagList(tagList(uiOutput("other_pathogens_by_age_sex_title"),
   # h2(glue("Influenza cases by age and/or sex in Scotland")),
          
          tabBox(width = NULL,
                 type = "pills",
                 tabPanel("Plot",
                          tagList(
                            linebreaks(1),
                            # adding selection for flu subtype
                            fluidRow(
                              column(4, pickerInput("respiratory_season",
                                                    label = "Select a season",
                                                    choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "nonflu") %>%
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
                            altTextUI("other_pathogens_age_sex"),
                            withNavySpinner(plotlyOutput("other_pathogens_by_age_sex_plot"))
                          ) # tagList
                 ), # tabPanel
                 tabPanel("Data",
                          withNavySpinner(dataTableOutput("other_pathogens_age_sex_table")))
          ) # tabbox
  ), # tagList
  linebreaks(1)
)

)
)