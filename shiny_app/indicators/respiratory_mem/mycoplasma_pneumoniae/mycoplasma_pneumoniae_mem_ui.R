tagList(
  fluidRow(width = 12,
           
           metadataButtonUI("respiratory_mycoplasma_pneumoniae_mem"),
           #linebreaks(1),
           h1("Mycoplasma pneumoniae"),
           p("Mycoplasma pneumoniae is a bacterium that only infects humans. It typically ",
             "causes mild infections of the upper respiratory tract, resulting in cold-like ",
             "symptoms. Mycoplasma pneumoniae is most frequently seen in school-age children ",
             "and young adults, but individuals of any age may be infected. Infections peak in ",
             "winter, usually between late December and February, but Mycoplasma pneumoniae ",
             "circulates throughout the year."), 
           linebreaks(1)),
  
  fluidRow(width = 12,
           tagList(h2("Mycoplasma pneumoniae incidence rate per 100,000 population in Scotland"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("mycoplasma_pneumoniae_mem_modal"),
                            withNavySpinner(plotlyOutput("mycoplasma_pneumoniae_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("mycoplasma_pneumoniae_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("Mycoplasma pneumoniae incidence rate per 100,000 population by NHS Health Board"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("mycoplasma_pneumoniae_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("mycoplasma_pneumoniae_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("mycoplasma_pneumoniae_mem_hb_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  ####  start map section ##########
  fluidRow(width = 12,
           tagList(h2(textOutput("mycoplasma_pneumoniae_map_dynamic_header")))),# fluidrow
  
  fluidRow(
    width = 12,# mem healthboard maps
    sliderInput(inputId = "mycoplasma_pneumoniae_week_slider",
                label = "Use this date-slider to look at infection levels in previous weeks",
                min = min(Season_Pathogens_MEM_HB_Polygons$Weekord), 
                max = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
                value = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
                step=1  ),
    fluidRow(
      width = 12,
      #tagList(h2(textOutput("flu_mem_selected_map_date"))),
      box("placeholder",   width = 8, leafletOutput("mycoplasma_pneumoniae_mem_map_this_season")),
    )), # fluid row
  
  #### end map section ##########
  fluidRow(width = 12,
           tagList(h2("Mycoplasma pneumoniae incidence rate per 100,000 population by age group"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("mycoplasma_pneumoniae_mem_age_modal"),
                            withNavySpinner(plotlyOutput("mycoplasma_pneumoniae_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("mycoplasma_pneumoniae_mem_age_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ) # fluidRow
  )