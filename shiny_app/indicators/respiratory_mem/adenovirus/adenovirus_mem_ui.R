tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_adenovirus_mem"),
           #linebreaks(1),
           h1("Adenovirus"),
           p("Adenoviruses most commonly present as respiratory infections but can also",
             "cause gastrointestinal infections and infect the lining of the eyes (conjunctivitis),",
             "the urinary tract, and the nervous system. They are very contagious and are",
             "relatively resistant to common disinfectants. Adenoviruses do not follow a seasonal",
             "pattern and circulate all year round."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_age_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)
