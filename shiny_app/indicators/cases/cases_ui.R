tagList(

  tabBox(width = NULL, type = "pills",
         tabPanel("Plot",
                  tagList(h3("Reported COVID-19 cases"),
                          plotlyOutput("reported_cases_plot"))),
         tabPanel("Data",
                  tagList(h3("Reported COVID-19 cases data"),
                          dataTableOutput("reported_cases_table"))))
)