tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_rhinovirus_mem"),
           #linebreaks(1),
           h1("Rhinovirus"),
           p("Rhinoviruses are the most frequent cause of the common cold worldwide.",
             "Most infections are mild, with symptoms including coughs, sneezing, and",
             "nasal congestion but can lead to severe illness such as bronchitis, sinusitis,",
             "or pneumonia. Rhinoviruses circulate year-round, with peaks in autumn and spring."),
#             "Additional information can be found on the PHS page for rhinovirus."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Rhinovirus incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rhinovirus_mem_modal"),
                            withNavySpinner(plotlyOutput("rhinovirus_mem_plot")),
                            )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rhinovirus_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Rhinovirus incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rhinovirus_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("rhinovirus_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rhinovirus_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

####  start map section ##########
fluidRow(width = 12,
         tagList(h2(textOutput("rhinovirus_map_dynamic_header")))),# fluidrow

fluidRow(
  width = 12,# mem healthboard maps
  sliderInput(inputId = "rhinovirus_week_slider",
              label = "Use this date-slider to look at infection levels in previous weeks",
              min = min(Season_Pathogens_MEM_HB_Polygons$Weekord), 
              max = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
              value = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
              step=1  ),
  fluidRow(
    width = 12,
    box("placeholder",   width = 8, leafletOutput("rhinovirus_mem_map_this_season")),
    linebreaks(1)
  )), # fluid row
#### end map section ##########

  fluidRow(width = 12,
           tagList(h2("Rhinovirus incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rhinovirus_mem_age_modal"),
                            withNavySpinner(plotlyOutput("rhinovirus_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rhinovirus_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
)
