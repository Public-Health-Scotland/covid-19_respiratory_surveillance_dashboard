tagList(

  fluidRow(width = 12,
    tabBox(width = NULL, type = "pills",
          tabPanel("Plot",
                  tagList(h3("Reported COVID-19 cases"),
                          plotlyOutput("reported_cases_plot"))),
           tabPanel("Data",
                  tagList(h3("Reported COVID-19 cases data"),
                          dataTableOutput("reported_cases_table"))))
  ),

  fluidRow(height="600px", width =12, linebreaks(4)),


  fluidRow(width = 12,
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Estimated infections",
                    tagList(h3("Estimated COVID-19 infection rate"),
                            h4("ONS covid infection survey"),
                            plotlyOutput("ons_cases_plot"))),
           tabPanel("R number",
                    tagList(h3("Estimated COVID-19 R number"),
                            plotlyOutput("r_number_plot"))),
           tabPanel("Wastewater",
                    tagList(h3("Wastewater"),
                            plotlyOutput("wastewater_plot")))
        ) #tabBox
  )


  )
