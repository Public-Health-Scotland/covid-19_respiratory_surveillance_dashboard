tagList(
  fluidRow(width = 12,
           
           metadataButtonUI("mortality_euromomo"),
           linebreaks(1),
           h1("All-Cause Excess Mortality (Euromomo)"),
           p("All-cause excess mortality is defined as a statistically significant increase ",
             "in the number of deaths reported over the expected number for a given point in time. ",
             "This calculation allows for a weekly variation in the number of deaths registered and ",
             "takes account of deaths registered retrospectively. PHS use the European monitoring of ",
             "excess mortality (", 
             tags$a(href="https://www.euromomo.eu/", "Euromomo (external website)",
                    target="_blank"),
             ") system to estimate weekly all-cause excess mortality, which is presented as z-scores. ",
             "This data is subject to adjustment by statistical methods to allow comparison between ",
             "seasons, reporting delays, and public holidays. All-cause excess mortality is reported two ",
             "weeks after the week of the occurrence of the deaths to allow for reporting delay. ",
             "For more information, please refer to the ",
             actionLink("jump_to_metadata_page", "Metadata"),
             "section."),
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
  