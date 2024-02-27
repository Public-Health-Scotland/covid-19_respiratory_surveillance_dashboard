tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_seasonal_coronavirus_mem"),
           linebreaks(1)
           ),

  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_age_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)
