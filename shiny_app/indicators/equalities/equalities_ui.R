tagList(
  fluidRow(width = 12,

           metadataButtonUI("equalities"),
           # linebreaks(1),
           h1("Equalities"),
           p("This tab offers insights into the distribution of cases and acute hospital admissions for the selected pathogen,",
             "comparing current and previous seasons. Data is broken down by ethnic group and deprivation",
             "quintile (as measured by the Scottish Index of Multiple Deprivation – SIMD).",
             "From May 2024, PHS has updated its methodology for recording the ethnic groups",
             "of individuals using a more comprehensive lookup. All previous analyses have been archived."),
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
                                             width=12, linebreaks(1)))),
                          tabPanel("Data",
                                   tagList(
                                     withNavySpinner(dataTableOutput("equalities_admission_table"))
                                   ) # tagList
                          ) # tabPanel
                   ) # tabBox
           ) # tagList
  ) #fluidrow

)



