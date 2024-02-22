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
  
  fluidRow(width = 12, # dynamic title for selected pathogen above map of hb mems
           tagList(h2(textOutput("hb_mem_cases_title"))),
          # linebreaks(1),
           fluidRow(width=12, linebreaks(1)),
           h4("Use filter to see the latest incident rates for each pathogen (excludes Covid-19)")
  ), # fluidRow
  
 fluidRow(width = 12,# mem healthboard maps
    pickerInput(inputId = "pathogen_filter",
                label = "",
                choices = {Intro_Pathogens_MEM_HB %>%
                    .$Pathogen %>%
                    unique()},
                selected = "Influenza"),
    fluidRow(width = 8,
      column(width=4, align = "left", tagList(textOutput("map_prev_week_title"))),
      column(width=4, align = "left", tagList(textOutput("map_this_week_title")))
      ),
    fluidRow(width=8,
      box(width= 4, leafletOutput("hb_mem_map_prev_week")),
      box(width= 4, leafletOutput("hb_mem_map"))),
    fluidRow(width=12, linebreaks(1))
        ), #fluidRow   mem healthboard    

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
           tagList(h2("Number of inpatients with COVID-19 in hospital (seven day average)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("inpatients_intro_table"))),
           fluidRow(
             width=12, linebreaks(5))
  )

) #tagList