
tagList(
  fluidRow(
    tags$head(
      tags$style(HTML("
      .control-label {
        color: black;
      }
    "))),
    metadataButtonUI("la_wastewater_metadata"),
    h1("COVID-19 Wastewater Surveillance"),
    p("Wastewater-based surveillance is a promising low cost means to enhance monitoring of ",
      "the presence and epidemiological activity of pathogens such as SARS-CoV-2 in the ",
      "Scottish community that does not rely on an individual accessing healthcare for testing ",
      "when symptomatic. This programme has been running in Scotland since June 2020 for ",
      "Covid-19, when it became the country’s first pathogen-specific surveillance system of ",
      "this kind. Data is available at National, NHS Health Board and Local Authority areas ",
      "based on location of Wastewater Treatment Works (WWTW). "),
    linebreaks(1),
    fluidRow(width = 12,
             tagList(h2("Average trends in COVID-19 wastewater RNA by Local Authority"))),
    linebreaks(1),
    selectInput("selected_area", "Select Local Authority of interest:", 
                choices = sort(unique(COVID_Wastewater_CA_table$council_area)),
                selected = sort(unique(COVID_Wastewater_CA_table$council_area))[1]),
    tabBox(width=NULL,
           type="pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("CA_modal"),
                            withNavySpinner(plotlyOutput("council_area_plot")),
                            fluidRow(column(
                              width=12, linebreaks(1),
                            )))),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            
                            withNavySpinner(dataTableOutput("council_area_table"))
                            
                    )
           )
    ),
    linebreaks(1)
    
  )
)#taglist