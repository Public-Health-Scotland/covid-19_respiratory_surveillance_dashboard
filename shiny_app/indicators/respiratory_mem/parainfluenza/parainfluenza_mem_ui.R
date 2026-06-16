tagList(
  fluidRow(width = 12,
           tagList(h2("Laboratory-confirmed parainfluenza incidence per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_mem_modal"),
                            withNavySpinner(plotlyOutput("parainfluenza_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Laboratory-confirmed parainfluenza incidence per 100,000 population by NHS Health Board"))),

fluidRow(
  p("Public Health Scotland have paused reporting of NHS Board-specific activity data for pathogens which do not have ",
    "uniform testing policies across different Health Board areas. This is because different testing practices by Health Board may ",
    "have an impact on incidence rates and therefore has implications for smaller Health Board areas, particularly for ",
    "calculation of activity threshold levels."),
  linebreaks(1)
),

  fluidRow(width = 12,
           tagList(h2("Laboratory-confirmed parainfluenza incidence per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_mem_age_modal"),
                            withNavySpinner(plotlyOutput("parainfluenza_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)
