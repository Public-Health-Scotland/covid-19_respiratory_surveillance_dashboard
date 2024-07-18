
tagList(
  fluidRow(
    tags$head(
      tags$style(HTML("
      .control-label {
        color: black;
      }
    "))),
    metadataButtonUI("la_wastewater_metadata"),
    fluidRow(width = 12,
             tagList(h2("Average trends in COVID-19 wastewater RNA by Local authority"))),
    linebreaks(1),
    selectInput("selected_area", "Local Authority of interest:", 
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