tagList(
  fluidRow(width=12, h1("Viral respiratory diseases (including influenza and COVID-19) surveillance in Scotland"),
           linebreaks(1)), #fluidRow

  fluidRow(width = 12,
           tagList(h2("National respiratory surveillance in Scotland (number of cases)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("cases_intro_table"))),
               fluidRow(
                 width=12, linebreaks(1))
           ), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Hospital admissions")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("hosp_adms_intro_table"))),
           linebreaks(1),
           box(width = NULL,
               withNavySpinner(
                 plotlyOutput("hosp_adms_intro_plot"))),
           fluidRow(
             width=12, linebreaks(1))
  ), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Number of patients in hospital")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("inpatients_intro_table"))),
           fluidRow(
             width=12, linebreaks(5))
  )




) #tagList



