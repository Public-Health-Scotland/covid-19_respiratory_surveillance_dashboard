tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_parainfluenza_mem"),
           linebreaks(1),
#            h1("Parainfluenza"),
#            p("Human parainfluenza virus (HPIV) is a virus that causes respiratory illness in humans.",
#              "Despite its name, parainfluenza is not related to influenza and exhibits different",
#              "characteristics. It is an important cause of upper and lower respiratory disease in",
#              "infants and young children, elderly people and people who are immunocompromised."),
# #             "Additional information can be found on the PHS page for parainfluenza."),
#            linebreaks(1)
),

  fluidRow(width = 12,
           tagList(h2("Parainfluenza incidence rate per 100,000 population in Scotland"))),

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
           tagList(h2("Parainfluenza incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("parainfluenza_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("Parainfluenza incidence rate per 100,000 population by age group"))),

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
