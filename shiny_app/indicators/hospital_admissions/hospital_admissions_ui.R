tagList(
  fluidRow(width = 12,
           metadataButtonUI("hospital_admissions"),
           linebreaks(1),
           h1("Acute COVID-19 hospital admissions"),
           linebreaks(1)),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Acute hospital admissions",
                           tagList(h2("Number of acute COVID-19 admissions to hospital"),
                                   tags$div(class = "headline",
                                            h3("Weekly totals from last three weeks"),

                                            valueBox(value = glue("{admissions_headlines[[1]]}*"),
                                                     subtitle = glue("Week ending {names(admissions_headlines)[[1]]}"),
                                                     color = "blue",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {admissions_headlines[[2]] %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {names(admissions_headlines)[[2]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {admissions_headlines[[3]] %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {names(admissions_headlines)[[3]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            h4("* provisional figures",
                                               actionButton("glossary",
                                                            label = "Go to glossary",
                                                            icon = icon_no_warning_fn("paper-plane")
                                                            ),
                                               h6("hidden text for padding page")
                                               )
                                            ),


                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_modal"),
                                             withNavySpinner(plotlyOutput("hospital_admissions_plot")))
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(dataTableOutput("hospital_admissions_table")))
                                           )

                           ),

                           tagList(h2("Weekly number of acute COVID-19 hospital admissions by deprivation category (SIMD)"))

                           ),
                           br(),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_simd_modal"),
                                             actionButton("btn_modal_simd",
                                                          label = "What is SIMD?",
                                                          class = "simd-btn",
                                                          icon = icon_no_warning_fn("circle-question")
                                             ),
                                             withNavySpinner(
                                               plotlyOutput("hospital_admissions_simd_plot"))
                                            )
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(
                                               dataTableOutput("hospital_admissions_simd_table"))
                                            )
                                           )

                           ),

                           tagList(h2("Length of stay of acute COVID-19 hospital admissions"),
                                   tags$div(class = "headline",
                                            h3(glue("Median length of stay of acute COVID-19 hospital admissions for 4 week period {los_date_start %>% format('%d %b %y')} to {los_date_end%>% format('%d %b %y')} ")),

                                            valueBox(value = glue("{Length_of_Stay_Median %>% filter(AgeGroup == 'All Ages') %>%
                                                .$MedianLengthOfStay %>%round_half_up(1)} days"),
                                                     subtitle = glue("All ages"),
                                                     color = "blue",
                                                     icon = icon_no_warning_fn("clock")),
                                            valueBox(value = glue("{los_median_min$MedianLengthOfStay %>% round_half_up(1)} days"),
                                                subtitle = glue("Shortest median stay ({los_median_min$AgeGroup})"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("clock")),
                                            valueBox(value = glue("{los_median_max$MedianLengthOfStay %>% round_half_up(1)} days"),
                                                subtitle = glue("Longest median stay ({los_median_max$AgeGroup})"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("clock")),
                                            # This text is hidden by css but helps pad the box at the bottom
                                            h6("hidden text for padding page"))),
                           br(),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(h5("Use the drop-down menu to select an age group of interest."),

                                                   h5("Please note that in cases where there are no hospital admissions, there will be a gap in the chart."),
                                                    pickerInput(inputId = "los_age",
                                                         label = "Select Age Group",
                                                         choices = {Length_of_Stay %>%
                                                             arrange(AgeGroup) %>%
                                                             .$AgeGroup %>%
                                                             unique()},
                                                         selected = "All Ages"),
                                                   altTextUI("hospital_admissions_los_modal"),
                                                    withNavySpinner(
                                                      plotlyOutput("hospital_admissions_los_plot")
                                                      ),
                                                   linebreaks(3))),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(
                                               dataTableOutput("hospital_admissions_los_table"))
                                            )
                                           )
                           )

                           ),

                  tabPanel("ICU admissions",
                           tagList(h2("Number of COVID-19 admissions to Intensive Care Units (ICU)"),
                                   tags$div(class = "headline",
                                            h3("Weekly totals from last three weeks"),
                                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                                filter(row_number() == nrow(ICU_weekly)) %>% .$NewCovidAdmissionsPerWeek},
                                                     subtitle = glue("Week ending {names(icu_headlines)[[1]]}"),
                                                     color = "blue",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                                filter(row_number() == nrow(ICU_weekly)-1) %>% .$NewCovidAdmissionsPerWeek},
                                                     subtitle = glue("Week ending {names(icu_headlines)[[2]]}"),
                                                     color = "blue",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                                filter(row_number() == nrow(ICU_weekly)-2) %>% .$NewCovidAdmissionsPerWeek},
                                                subtitle = glue("Week ending {names(icu_headlines)[[3]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            h4(uiOutput("disclosure_statement")),
                                            h4("Therefore, the latest week is not included in the chart below."),
                                            #h4("* indicates value has been suppressed according to PHS Statistical Disclosure Control Protocol"),
                                            # This text is hidden by css but helps pad the box at the bottom
                                            h6("hidden text for padding page"))),

                           linebreaks(1),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("icu_admissions_modal"),
                                             withNavySpinner(
                                               plotlyOutput("icu_admissions_plot"))
                                           )
                                  ),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(
                                               dataTableOutput("icu_admissions_table")
                                             )
                                           )
                                  ) # tabpanel

                           )),

                  tabPanel("Acute hospital admissions by ethnicity",
                           tagList(h2("Number of acute COVID-19 admissions to hospital by ethnicity"),
                                   h4(strong("These data will next be updated in August 2023.")),
                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_ethnicity_modal"),
                                             withNavySpinner(
                                               plotlyOutput("hospital_admissions_ethnicity_plot")
                                               )
                                          )
                                              ),
                                  tabPanel("Data",
                                           withNavySpinner(
                                               dataTableOutput("hospital_admissions_ethnicity_table")
                                               )
                                  ) # tabpanel
                                           ) # tabbox
                           ) # taglist
                           ) # tabpanel
           )
  ),
  # Padding out the bottom of the page
  fluidRow(height="200px", width=12, linebreaks(5))

)
