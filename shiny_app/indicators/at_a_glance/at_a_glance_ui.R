tagList(
  fluidRow(width=12, h1("Viral respiratory diseases (including influenza and COVID-19) surveillance in Scotland"),
           linebreaks(1)), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Number and rate of respiratory pathogen cases (week ending)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("cases_intro_table"))),
               fluidRow(
                 width=12, linebreaks(1)),
           p("Please refer to metadata tab for further information on testing policies."),
           ), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Number and rate of acute hospital admissions due to COVID-19, influenza and RSV (week ending)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("hosp_adms_intro_table"))),
           linebreaks(1),
           tagList(h2("Number of acute hospital admissions due to COVID-19, influenza and RSV")),
           linebreaks(1)),

  fluidRow(width=12,
           box(width = NULL,
               altTextUI("adms_summary_modal"),
               withNavySpinner(
                 plotlyOutput("hosp_adms_intro_plot")),
           fluidRow(
             width=12, linebreaks(5)))
  ), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Number of inpatients with COVID-19 in hospital")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("inpatients_intro_table"))),
           fluidRow(
             width=12, linebreaks(5))
  )




) #tagList



