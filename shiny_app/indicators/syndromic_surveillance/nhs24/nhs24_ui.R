tagList(
  fluidRow(width = 12,

           metadataButtonUI("nhs24_mem"),
           linebreaks(1),
           h1("NHS24 Calls for Respiratory Symptoms"),
           p("NHS24 is a telephone service operated by NHS Scotland to triage patients with an urgent,",
             "but not life-threatening, need for medical attention. Trends in calls to NHS24, for",
             "respiratory symptoms, are compared against historic data to assess activity levels of acute",
             "respiratory illness in the community. As NHS24 is often patients first contact with the NHS,",
             "increases in activity will be reported here before they are detected by other surveillance",
             "systems, thus it can act as an early warning system for acute respiratory infections.",
             "More information on NHS24 can be found…"),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland"))),

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

  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) by NHS Health Board"))),
  #
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_hb_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_hb_plot")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_hb_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) by age group"))),

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



