tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_seasonal_coronavirus_mem"),
           linebreaks(1),
           h1("Other seasonal coronaviruses"),
           p("Seasonal Coronaviruses (not COVID-19) are a group of viruses that typically cause mild to moderate",
             "upper respiratory tract infections, such as the common cold, but can cause lower-respiratory",
             "tract illnesses such as pneumonia and bronchitis. Infection can occur in people of all ages.",
             "Seasonal coronaviruses have an annual seasonality and typically circulate in the winter months."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  ####  start map section ##########
  fluidRow(width = 12,
           tagList(h2(textOutput("seasonal_coronavirus_map_with_selected_date")))),# fluidrow
  
  fluidRow(
    width = 12,# mem healthboard maps
    sliderInput(inputId = "seasonal_coronavirus_week_slider",
                label = "Use this date-slider to look at infection levels in previous weeks",
                min = min(Season_Pathogens_MEM_HB_Polygons$Weekord), 
                max = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
                value = max(Season_Pathogens_MEM_HB_Polygons$Weekord),
                step=1  ),
    fluidRow(
      width = 12,
      #tagList(h2(textOutput("seasonal_coronavirus_mem_selected_map_date"))),
      box("placeholder",   width = 8, leafletOutput("seasonal_coronavirus_map_dynamic_header")),
      linebreaks(1)
    )), # fluid row
  #### end map section ##########
  
  fluidRow(width = 12,
           tagList(h2("Seasonal Coronavirus incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_mem_age_modal"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
 )