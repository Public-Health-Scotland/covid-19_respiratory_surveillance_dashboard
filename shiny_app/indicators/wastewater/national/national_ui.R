
tagList(

  fluidRow(width = 12,

           metadataButtonUI("national_wastewater_metadata"),
           #linebreaks(1),
           h1("Public Health Scotland - COVID-19 Wastewater Surveillance"),
           p("A national wastewater-based surveillance programme has been established for COVID-19 in Scotland ",
             "since June 2020, the country’s first pathogen-specific surveillance system of this kind. ",
             "Wastewater-based surveillance is a promising low cost means to enhance monitoring of the presence ",
             "and epidemiological activity of pathogens such as SARS-CoV-2 in the Scottish community that does ",
             "not rely on an individual accessing healthcare for testing when symptomatic."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Seven-day average national trend in COVID-19 wastewater (Week ending)"))),


  fluidRow(
    withNavySpinner(dataTableOutput("wastewater_week_ending_table"))),
  br(),
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("national_wastewater_modal"),
                            withNavySpinner(plotlyOutput("national_wastewater_plot")))),
           tabPanel("Data",
                    tagList(linebreaks(1),

                            withNavySpinner(dataTableOutput("national_wastewater_table"))
                    ) # tagList
           )),
    linebreaks(1)
    )
  )
