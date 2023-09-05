tagList(
  fluidRow(width = 12,
           
           metadataButtonUI("mortality_euromomo"),
           linebreaks(1),
           h1("Euromomo (all-cause mortality)"),
           linebreaks(1)),
  
  fluidRow(width = 12,
           tagList(h2("Weekly all-cause excess mortality (Euromomo, z-scores)"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("euromomo_mem_modal"),
                            withNavySpinner(plotlyOutput("euromomo_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("euromomo_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("Weekly all-cause excess mortality (Euromomo, z-scores) by age group"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("euromomo_mem_age_modal"),
                            withNavySpinner(plotlyOutput("euromomo_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("euromomo_mem_age_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
)
  