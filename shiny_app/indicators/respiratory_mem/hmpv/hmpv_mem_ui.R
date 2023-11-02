tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_hmpv_mem"),
           #linebreaks(1),
           h1("HMPV"),
           p("Human Metapneumovirus (HMPV) is a virus associated with respiratory infections,",
             "ranging from mild symptoms to more severe illness such as bronchiolitis and",
             "pneumonia. Infection can occur in people of all ages, but commonly occurs in",
             "infants and young children. HMPV has distinct annual seasonality, with the highest",
             "transmission in the winter months."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("HMPV incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("hmpv_mem_modal"),
                            withNavySpinner(plotlyOutput("hmpv_mem_plot")),
                            )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("hmpv_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("HMPV incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("hmpv_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("hmpv_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("hmpv_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("HMPV incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("hmpv_mem_age_modal"),
                            withNavySpinner(plotlyOutput("hmpv_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("hmpv_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)
