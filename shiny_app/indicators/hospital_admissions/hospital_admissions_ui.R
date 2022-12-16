tagList(
  fluidRow(width = 12,
           h1("COVID-19 hospital admissions"),
           linebreaks(2)),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Hospital Admissions",
                           tagList(h3("Number of COVID-19 admissions to hospital"),
                                   tags$div(class = "headline",
                                            h3(glue("Figures from week ending {Admissions_AgeBD %>% tail(1) %>%
                                                    .$WeekOfAdmission %>%
                                                    format('%d %b %y')}")),
                                            valueBox(value = {Admissions_AgeBD %>% tail(1) %>%
                                                .$TotalInfections %>%
                                                format(big.mark = ",")},
                                                subtitle = "Latest 7 day total",
                                                color = "blue",
                                                icon = icon_no_warning_fn("arrow-up")),
                                            valueBox(value = {Admissions_AgeSex %>% tail(1) %>%
                                                .$TotalInfections %>%
                                                format(big.mark = ",")},
                                                subtitle = "Cumulative total",
                                                color = "blue",
                                                icon = icon_no_warning_fn("hospital-user")),
                                            # These linebreaks are here to make the banner big enough to
                                            # include all the valueBoxes
                                            linebreaks(6))),

                           tagList(h3("Daily number of COVID-19 hospital admissions")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(plotlyOutput("hospital_admissions_plot"))),
                                  tabPanel("Data",
                                           tagList(dataTableOutput("hospital_admissions_table")))

                           ),

                           tagList(h3("Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)")),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(plotlyOutput("hospital_admissions_simd_plot"))),
                                  tabPanel("Data",
                                           tagList(dataTableOutput("hospital_admissions_simd_table")))

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
                                                    plotlyOutput("hospital_admissions_los_plot"),
                                                   linebreaks(3))),
                                  tabPanel("Data",
                                           tagList(dataTableOutput("hospital_admissions_los_table")))

                           )

                           ),

                  tabPanel("Hospital Admissions by Ethnicity",
                           tagList(h3("Admissions to hospital 'with' COVID-19 by ethnicity"),
                                   h4(strong("These data will next be updated in March 2023.")),
                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(h5("Click on legend to select or deselect categories:"),
                                                   h5("\U2022 Single click on an item in the legend to remove it from the plot"),
                                                   h5("\U2022 Double click on an item in the legend to view only that line"),
                                             br(),
                                             h3("Admissions to hospital 'with' COVID-19 by ethnicity - Cases"),
                                             plotlyOutput("hospital_admissions_ethnicity_plot"),
                                             h3("Admissions to hospital 'with' COVID-19 by ethnicity - Percentage"),
                                             plotlyOutput("hospital_admissions_ethnicity_perc_plot"))),
                                  tabPanel("Data",
                                           dataTableOutput("hospital_admissions_ethnicity_table"))))),


                  tabPanel("ICU Admissions",
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
                                                icon = icon_no_warning_fn("arrow-up")),
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
                                           tagList(plotlyOutput("icu_admissions_plot"))),
                                  tabPanel("Data",
                                           tagList(dataTableOutput("icu_admissions_table")))

                           ))
           )
  ),
  # Padding out the bottom of the page
  fluidRow(height="200px", width=12, linebreaks(5))

)