tagList(

  fluidRow(width = 12,
           h1("Hospital Occupancy"),
           linebreaks(2)),

  fluidRow(tagList(tags$div(class = "headline",
                            h3(glue("Figures from week ending {Occupancy %>% tail(1) %>%
                                                    .$Date %>%  format('%d %b %y')}")),
                            valueBox(value = {Occupancy %>% tail(1) %>%
                                .$HospitalOccupancy},
                                subtitle = "Number of patients with covid in hospital in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("hospital")),
                            valueBox(value = {Occupancy %>% tail(1) %>%
                                .$ICUOccupancy28OrLess},
                                subtitle = "Number of patients with covid in ICU for 28 days or less in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("bed")),
                            valueBox(value = {Occupancy %>% tail(1) %>%
                                .$ICUOccupancy28OrMore},
                                subtitle = "Number of patients with covid in ICU for more than 28 days in Scotland",
                                color = "blue",
                                icon = icon_no_warning_fn("bed-pulse")))
                   ), # tagList
           linebreaks(5)), # fluidRow

  fluidRow(width = 12,
           selectizeInput("occupancy_healthboard",
                          label = "Select location for plots",
                          choices = unique(Occupancy$LocationName),
                          selected = "Scotland")), #fluidrow

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",
                  tabPanel("Hospital Occupancy",
                           tagList(h3("Number of patients with covid in hospital"),
                                   withSpinner(plotlyOutput("hospital_occupancy_plot"))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("ICU Occupancy (28 days or less)",
                           tagList(h3("Number of patients with covid in ICU (28 days or less)"),
                                   withSpinner(plotlyOutput("icu_occupancy_less_28_plot"))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("ICU Occupancy (28 days or more)",
                           tagList(h3("Number of patients with covid in ICU (more than 28 days)"),
                                   withSpinner(plotlyOutput("icu_occupancy_more_28_plot"))
                                   ) # taglist
                           ), # tabpanel

                  tabPanel("Data",
                           tagList(h3("Number of patients with covid in hospital and ICU data"),
                                   withSpinner(dataTableOutput("occupancy_table"))
                                   ) # taglist
                           ) # tabpanel
                  ) #tabbox

          ) # fluid row

) # taglist


