HB_table_edited = COVID_Wastewater_HB_table %>% 
  filter(!health_board %in% c("AllSites", "28Sites")) 

HB_scotland = COVID_Wastewater_HB_table %>% 
  filter(health_board=="AllSites")




tagList(
  fluidRow(
    tags$head(
      tags$style(HTML("
      .control-label {
        color: black;
      }
    "))),
    metadataButtonUI("hb_wastewater_metadata"),
    fluidRow(width = 12,
             tagList(h2("Average trends in COVID-19 wastewater RNA by NHS Health Board"))),
    linebreaks(1),
    selectInput("selected_board", "NHS Health Board of interest:", 
                choices = sort(unique(HB_table_edited$health_board)),
                selected = sort(unique(HB_table_edited$health_board))[1]),
    tabBox(width=NULL,
           type="pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("HB_modal"),
                            withNavySpinner(plotlyOutput("health_board_plot")),
                            fluidRow(column(
                              width=12, linebreaks(1),
                            )))),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            
                            withNavySpinner(dataTableOutput("health_board_table"))
                            
                    )
           )
    ),
    linebreaks(1)
    
  )
)#taglist