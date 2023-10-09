tagList(
  fluidRow(width = 12,

           metadataButtonUI("archive"),
          
           linebreaks(1),
           #h1("Archive"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tagList(h2("Estimated COVID-19 infection rate"),
                   h4("(ONS covid infection survey)"),
                   p("The Office for National Statistics (ONS) published their",
                     tags$a(href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/24march2023", "final COVID-19 Infection Survey report (external website)",  target="_blank"), " on 24 March 2023."),
                   tags$div(class = "headline",
                            h3(glue("Figures from week ending {ONS %>% tail(1) %>%
                .$EndDate %>% convert_opendata_date() %>%  format('%d %b %y')}")),
                            valueBox(value = {ONS %>% tail(1) %>%
                                .$EstimatedRatio},
                                subtitle = "Estimated prevalence",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            valueBox(value = {ONS %>% tail(1) %>%
                                .$LowerCIRatio},
                                subtitle = "Lower 95% confidence interval",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            valueBox(value = {ONS %>% tail(1) %>%
                                .$UpperCIRatio},
                                subtitle = "Upper 95% confidence interval",
                                color = "navy",
                                icon = icon_no_warning_fn("viruses")),
                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page")
                   )
           ),
           linebreaks(1)),

  fluidRow(width=12,
           box(width = NULL,
               altTextUI("ons_cases_modal"),
               withNavySpinner(plotlyOutput("ons_cases_plot")),
               fluidRow(
                 width=12, linebreaks(5))
           )),

  fluidRow(
    width =12, br()),

  fluidRow(width=12,
           tagList(h2("Number of COVID-19 admissions to Intensive Care Units (ICU)"),
                   tags$div(class = "headline",
                            h3("Weekly totals from last three weeks"),
                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                filter(row_number() == nrow(ICU_weekly)) %>% .$NewCovidAdmissionsPerWeek},
                                subtitle = glue("Week ending {names(icu_headlines)[[1]]}"),
                                color = "navy",
                                icon = icon_no_warning_fn("calendar-week")),
                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                filter(row_number() == nrow(ICU_weekly)-1) %>% .$NewCovidAdmissionsPerWeek},
                                subtitle = glue("Week ending {names(icu_headlines)[[2]]}"),
                                color = "navy",
                                icon = icon_no_warning_fn("calendar-week")),
                            valueBox(value = {ICU_weekly %>% mutate(NewCovidAdmissionsPerWeek = ifelse(is.na(NewCovidAdmissionsPerWeek),
                                                                                                       "*", NewCovidAdmissionsPerWeek)) %>%
                                filter(row_number() == nrow(ICU_weekly)-2) %>% .$NewCovidAdmissionsPerWeek},
                                subtitle = glue("Week ending {names(icu_headlines)[[3]]}"),
                                color = "navy",
                                icon = icon_no_warning_fn("calendar-week")),
                            #h4(uiOutput("disclosure_statement")),
                            #h4("Therefore, the latest week is not included in the chart below."),
                            h4("From 08 June 2023, these data are no longer updated and will be monitored internally by PHS as part of routine surveillance"),
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

  fluidRow(
    width =12, br()),

  fluidRow(width = 12,
           tagList(h2("7 day average number of patients with COVID-19 in Intensive Care Units (ICU)"),
                   tags$div(class = "headline",
                            h3(glue("Figures from week ending {Occupancy_ICU %>%
                                              mutate(Date = convert_opendata_date(Date)) %>%
                                              filter(Date <= floor_date(today(), 'week')) %>%
                                              tail(1) %>%
                                             .$Date %>% format('%d %b %y')}")),
                            fluidRow(column(12,valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "in ICU for 28 days or less",
                                color = "navy",
                                icon = icon_no_warning_fn("bed")),
                                valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
                                    .$SevenDayAverage},
                                    subtitle = "in ICU for more than 28 days",
                                    color = "navy",
                                    icon = icon_no_warning_fn("bed-pulse")))),
                            # This text is hidden by css but helps pad the box at the bottom
                            # h6("hidden text for padding page"),
                            # linebreaks(6),
                            p("From 08 May 2023, manual data collections from NHS Boards on the number of patients in ICU paused. These data are no longer updated. "),
                            br()
                   )),
           linebreaks(1)),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Plot",
                           tagList(linebreaks(1),
                                   altTextUI("icu_occupancy_modal"),
                                   linebreaks(1),
                                   withNavySpinner(plotlyOutput("icu_occupancy_plot")),
                                   linebreaks(4)
                           ) # taglist
                  ), # tabpanel

                  tabPanel("Data",
                           tagList(h3("Number of patients with COVID-19 in Intensive Care Units (ICU) data"),
                                   withNavySpinner(dataTableOutput("ICU_occupancy_table"))
                           ) # taglist
                  ) # tabpanel
           ) #tabbox

  ), # fluid row

  fluidRow(
    br())
)



