tagList(
  fluidRow(width = 12,
           h1("COVID-19 hospital admissions"),
           linebreaks(2)),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Hospital admissions",
                           tagList(h3("Number of COVID-19 admissions to hospital"),
                                   tags$div(class = "headline",
                                            h3("Admissions from last three weeks"),

                                            valueBox(value = {Admissions_AgeBD %>% tail(12) %>%
                                                filter(AgeGroup == "Total") %>%
                                                .$TotalInfections %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {Admissions_AgeBD %>% tail(1) %>%
                                                    .$WeekOfAdmission %>%
                                                    format('%d %b %y')} - provisional"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {Admissions_AgeBD%>% tail(24) %>% head(12) %>%
                                                filter(AgeGroup == "Total") %>%
                                                .$TotalInfections %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {Admissions_AgeBD %>% tail(24) %>% head(1) %>%
                                                    .$WeekOfAdmission %>%
                                                    format('%d %b %y')}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("hospital-user")),
                                            valueBox(value = {Admissions_AgeBD%>% tail(36) %>% head(12) %>%
                                                filter(AgeGroup == "Total") %>%
                                                .$TotalInfections %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {Admissions_AgeBD %>% tail(36) %>% head(1) %>%
                                                    .$WeekOfAdmission %>%
                                                    format('%d %b %y')}"),
                                                color = "blue",
                                                icon = icon_no_warning_fn("hospital-user")),
                                            # These linebreaks are here to make the banner big enough to
                                            # include all the valueBoxes
                                            linebreaks(6))),

                           tagList(h3("Daily number of COVID-19 hospital admissions")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             withSpinner(plotlyOutput("hospital_admissions_plot")))
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withSpinner(dataTableOutput("hospital_admissions_table")))
                                           )

                           ),

                           tagList(h3("Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             withSpinner(
                                               plotlyOutput("hospital_admissions_simd_plot"))
                                            )
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withSpinner(
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
                                                    withSpinner(
                                                      plotlyOutput("hospital_admissions_los_plot")
                                                      ),
                                                   linebreaks(3))),
                                  tabPanel("Data",
                                           tagList(
                                             withSpinner(
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
                                             withSpinner(
                                               plotlyOutput("hospital_admissions_ethnicity_plot")
                                               )
                                          )
                                              ),
                                  tabPanel("Data",
                                           withSpinner(
                                               dataTableOutput("hospital_admissions_ethnicity_table")
                                               )
                                  ) # tabpanel
                                           ) # tabbox
                           ) # taglist
                           ), # tabpanel


                  tabPanel("ICU admissions",
                           tagList(h3("Number of COVID-19 admissions to ICU"),
                                   tags$div(class = "headline",
                                            h3(glue("Figures from week ending {ICU %>% tail(1) %>%
                                                    .$DateFirstICUAdmission %>%
                                                    convert_opendata_date() %>%
                                                    format('%d %b %y')}")),
                                            valueBox(value = {ICU %>% tail(7) %>%
                                                .$NewCovidAdmissionsPerDay %>%
                                                sum() %>%
                                                format(big.mark = ",")},
                                                subtitle = "Latest 7 day total",
                                                color = "blue",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {ICU_AgeSex %>% tail(1) %>%
                                                .$CovidAdmissionsToICU %>%
                                                format(big.mark = ",")},
                                                subtitle = "Cumulative total",
                                                color = "blue",
                                                icon = icon_no_warning_fn("bed-pulse")),
                                            # These linebreaks are here to make the banner big enough to
                                            # include all the valueBoxes
                                            linebreaks(6))),
                           tagList(h3("Daily number of COVID-19 ICU admissions")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             withSpinner(
                                               plotlyOutput("icu_admissions_plot"))
                                             )
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withSpinner(
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