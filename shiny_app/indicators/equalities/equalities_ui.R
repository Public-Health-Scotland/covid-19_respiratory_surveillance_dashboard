tagList(
  fluidRow(width = 12,

           metadataButtonUI("equalities"),
           # linebreaks(1),
           h1("Equalities"),
           p("This tab offers insights into acute hospital admissions for selected respiratory pathogens,",
             "comparing current and previous seasons*. Data is available by ethnic group and deprivation",
             "quintile (measured by the Scottish Index of Multiple Deprivation – SIMD).",
             "From May 2024, PHS has updated its approach to presenting these data.",
             "All previous analyses have been archived."),
           p("*defined seasonal respiratory period (Week 40 to Week 20, Oct to May)."),
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
                                 choices = c("Ethnicity", "Deprivation quintile (SIMD)"),
                                 selected = "Ethnicity") # pickerInput
           )
  ),

  fluidRow(width = 12,
           tagList(uiOutput("equalities_admission_plot_title"),
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



