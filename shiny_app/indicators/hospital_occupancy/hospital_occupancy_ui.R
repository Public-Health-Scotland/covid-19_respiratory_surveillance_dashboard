tagList(

  fluidRow(width = 12,
           h1("Hospital Occupancy"),
           linebreaks(2)),

  fluidRow(tagList(tags$div(class = "headline",
                            h3(glue("Figures from week ending {Occupancy_Hospital %>% tail(1) %>%
                                                    .$Date %>% convert_opendata_date() %>%format('%d %b %y')}")),
                            valueBox(value = {Occupancy_Hospital %>% tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with covid in hospital in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("hospital")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with covid in ICU for 28 days or less in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("bed")),
                            valueBox(value = {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
                                .$SevenDayAverage},
                                subtitle = "7 day average number of patients with covid in ICU for more than 28 days in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("bed-pulse")))
                   ), # tagList
           linebreaks(5)), # fluidRow


  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Hospital occupancy",
                           tagList(h3("Number of patients with covid in hospital"),
                                   withSpinner(plotlyOutput("hospital_occupancy_plot"))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("ICU occupancy",
                           tagList(h3("Number of patients with covid in ICU"),
                                   withSpinner(plotlyOutput("icu_occupancy_plot"))
                                   ) # taglist
                           ), # tabpanel


                  tabPanel("Hospital occupancy data",
                           tagList(h3("Number of patients with covid in hospital data"),
                                   withSpinner(dataTableOutput("hospital_occupancy_table"))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("ICU occupancy data",
                           tagList(h3("Number of patients with covid in ICU data"),
                                   withSpinner(dataTableOutput("ICU_occupancy_table"))
                           ) # taglist
                  ) # tabpanel
                  ) #tabbox

          ) # fluid row

) # taglist


