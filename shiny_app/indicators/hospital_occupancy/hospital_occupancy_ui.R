tagList(
  fluidRow(width = 12,
           actionButton("jump_to_metadata_hospital_occupancy",
                        label = "Metadata",
                        class = "metadata-btn",
                        icon = icon_no_warning_fn("file-pen")
                        ),
           h1("Hospital occupancy"),
           linebreaks(2)),

  fluidRow(tagList(tags$div(class = "headline",
                            h3(glue("Figures from week ending {Occupancy_Hospital %>% tail(1) %>%
                                                    .$Date %>% convert_opendata_date() %>%format('%d %b %y')}")),
                            valueBox(value = {Occupancy_Hospital %>% tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with COVID-19 in hospital",
                                color = "blue",
                                icon = icon_no_warning_fn("hospital")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with COVID-19 in Intensive Care Units (ICU) for 28 days or less",
                                color = "blue",
                                icon = icon_no_warning_fn("bed")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with COVID-19 in Intensive Care Units (ICU) for more than 28 days",
                                color = "blue",
                                icon = icon_no_warning_fn("bed-pulse")),
                            # These linebreaks are here to make the banner big enough to
                            # include all the valueBoxes
                            linebreaks(7))
                   ), # tagList
           linebreaks(1)), # fluidRow


  fluidRow(width = 12,
           tabBox(width = NULL,
                  height = 650,
                  type = "pills",
                  tabPanel("Plot",
                           tagList(h3("Number of patients with COVID-19 in hospital"),
                                   linebreaks(1),
                                   altTextUI("hospital_occupancy_modal"),
                                   withSpinner(plotlyOutput("hospital_occupancy_plot"))
                                   ) # taglist
                           ), # tabpanel


                  tabPanel("Data",
                           tagList(h3("Number of patients with COVID-19 in hospital data"),
                                   withSpinner(dataTableOutput("hospital_occupancy_table"))
                                   ) # taglist
                           ) # tabpanel
                  ) #tabbox

          ), # fluid row

  fluidRow(height = "50px", br()),

  fluidRow(width = 12,
           tabBox(width = NULL,
                  height = 650,
                  type = "pills",
                  tabPanel("Plot",
                           tagList(h3("7 day average number of patients with COVID-19 in Intensive Care Units (ICU)"),
                                   linebreaks(1),
                                   altTextUI("icu_occupancy_modal"),

                                   withSpinner(plotlyOutput("icu_occupancy_plot"))
                           ) # taglist
                  ), # tabpanel

                  tabPanel("Data",
                           tagList(h3("Number of patients with COVID-19 in Intensive Care Units (ICU) data"),
                                   withSpinner(dataTableOutput("ICU_occupancy_table"))
                           ) # taglist
                  ) # tabpanel
           ) #tabbox

  ), # fluid row

  fluidRow(height = "50px", br())

) # taglist


