tagList(
  fluidRow(width = 12,

           metadataButtonUI("nhs24_mem"),
           linebreaks(1),
           h1("NHS24 Calls Incidence Rates"),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("NHS24 calls incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("NHS24 calls incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("NHS24 calls incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_age_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)



