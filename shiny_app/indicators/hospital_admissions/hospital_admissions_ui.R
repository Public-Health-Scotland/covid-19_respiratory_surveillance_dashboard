tagList(
  fluidRow(width = 12,
           actionButton("jump_to_metadata_hospital_admissions",
                        label = "Metadata",
                        class = "metadata-btn",
                        icon = icon_no_warning_fn("file-pen")
           ),
           h1("COVID-19 hospital admissions"),
           linebreaks(2)),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Hospital admissions",
                           tagList(h3("Number of COVID-19 admissions to hospital"),
                                   tags$div(class = "headline",
                                            h3("Admissions from last three weeks"),

                                            valueBox(value = {admissions_headlines[[1]]},
                                                subtitle = glue("Week ending {names(admissions_headlines)[[1]]} - provisional"),
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
                                            # These linebreaks are here to make the banner big enough to
                                            # include all the valueBoxes
                                            linebreaks(6))),

                           tagList(h3("Daily number of COVID-19 hospital admissions")),

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

                           tagList(h3("Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_simd_modal"),
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

                           tagList(h3("Length of stay of acute COVID-19 hospital admissions")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(h5("Use the drop-down menu to select an age group of interest."),
                                                   h5("Please note that in cases where there are no hospital admissions, there will be a gap in the chart."),
                                                    pickerInput(inputId = "los_age", width = "100%",
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

                  tabPanel("Hospital admissions by ethnicity",
                           tagList(h3("Admissions to hospital 'with' COVID-19 by ethnicity"),
                                   h4(strong("These data will next be updated in March 2023.")),
                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             h3("Admissions to hospital 'with' COVID-19 by ethnicity"),
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
                           ), # tabpanel


                  tabPanel("ICU admissions",
                           tagList(h3("Number of COVID-19 admissions to Intensive Care Units (ICU)"),
                                   tags$div(class = "headline",
                                            h3("ICU admissions from last three weeks"),
                                            valueBox(value = {icu_headlines[[1]]},
                                                subtitle = glue("Week ending {names(icu_headlines)[[1]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {icu_headlines[[2]]},
                                                subtitle = glue("Week ending {names(icu_headlines)[[2]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {icu_headlines[[3]] %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {names(icu_headlines)[[3]]}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            # These linebreaks are here to make the banner big enough to
                                            # include all the valueBoxes
                                            linebreaks(6))),
                           tagList(h3("Daily number of COVID-19 admissions to Intensive Care Units (ICU)")),

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

                           ))
           )
  ),
  # Padding out the bottom of the page
  fluidRow(height="200px", width=12, linebreaks(5))

)