tagList(
  fluidRow(width = 12,

           metadataButtonUI("equalities"),
           # linebreaks(1),
           h1("Equalities"),
           p("Paragraph about equalities here."),
           #             "More information on NHS24 can be found…"),
           linebreaks(1)
  ),

  fluidRow(width = 12,
           column(6, pickerInput("equalities_select_pathogen",
                                 label = "Select pathogen",
                                 choices = c("COVID-19", "Influenza", "RSV"),
                                 selected = "COVID-19"
           ) # pickerInput
           ), # column
           column(6, pickerInput("equalities_select_indicator",
                                 label = "Select indicator",
                                 choices = c("Ethnicity", "SIMD"),
                                 selected = "Ethnicity") # pickerInput
           )
  ),

  fluidRow(width = 12,
           tagList(h2("Equalities admissions"),
                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(linebreaks(1),
                                           altTextUI("equalities_admission_modal"),
                                           withNavySpinner(plotlyOutput("equalities_admission_plot")),
                                           fluidRow(
                                             width=12, linebreaks(5))))
                          #tabPanel("Data",
                          #         tagList(
                          #           withNavySpinner(dataTableOutput("reported_cases_table"))
                          #         ) # tagList
                          #) # tabPanel
                   ) # tabBox
           ) # tagList
  ) #fluidrow

)



