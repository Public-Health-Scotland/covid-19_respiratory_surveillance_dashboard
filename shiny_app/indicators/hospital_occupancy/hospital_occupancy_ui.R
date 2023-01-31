tagList(
  fluidRow(width = 12,
           metadataButtonUI("hospital_occupancy"),
           h1("Hospital occupancy (inpatients)"),
           linebreaks(2)),



  fluidRow(width = 12,
           tagList(h2("Number of inpatients with COVID-19 in hospital"),
                tags$div(class = "headline",
                                     h3(glue("Hospital occupancy (inpatients) on the Sunday of the latest three weeks available")),
                                     valueBox(value = {occupancy_headlines[[1]]$HospitalOccupancy},
                                         subtitle = glue("As at {names(occupancy_headlines)[[1]]}"),
                                         color = "fuchsia",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     valueBox(value = {occupancy_headlines[[2]]$HospitalOccupancy},
                                         subtitle = glue("As at {names(occupancy_headlines)[[2]]}"),
                                         color = "fuchsia",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     valueBox(value = {occupancy_headlines[[3]]$HospitalOccupancy},
                                         subtitle = glue("As at {names(occupancy_headlines)[[3]]}"),
                                         color = "fuchsia",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     p("hidden text for padding page"))),
           linebreaks(1)),

  fluidRow(
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Plot",
                           tagList(linebreaks(1),
                                   altTextUI("hospital_occupancy_modal"),
                                   withNavySpinner(plotlyOutput("hospital_occupancy_plot")),
                           fluidRow(
                             width=12, linebreaks(5))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("Data",
                           tagList(h3("Number of inpatients with COVID-19 in hospital data"),
                                   withNavySpinner(dataTableOutput("hospital_occupancy_table"))
                                   ) # taglist
                           ) # tabpanel
                  ) #tabbox

          ), # fluid row

  fluidRow(
           br()),

  fluidRow(width = 12,
           tagList(h2("7 day average number of patients with COVID-19 in Intensive Care Units (ICU)"),
                   tags$div(class = "headline",
                            h3(glue("Figures from week ending {Occupancy_Hospital %>% tail(1) %>%
                                             .$Date %>% convert_opendata_date() %>%format('%d %b %y')}")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "in ICU for 28 days or less",
                                color = "fuchsia",
                                icon = icon_no_warning_fn("bed")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "in ICU for more than 28 days",
                                color = "fuchsia",
                                icon = icon_no_warning_fn("bed-pulse")),
                            # This text is hidden by css but helps pad the box at the bottom
                            p("hidden text for padding page"))),
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

) # taglist


