tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_adenovirus_mem"),
           #linebreaks(1),
           h1("Adenovirus"),
           p("Adenoviruses most commonly present as respiratory infections but can also",
             "cause gastrointestinal infections and infect the lining of the eyes (conjunctivitis),",
             "the urinary tract, and the nervous system. They are very contagious and are",
             "relatively resistant to common disinfectants. Adenoviruses do not follow a seasonal",
             "pattern and circulate all year round."),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  ####  start map section ##########
  fluidRow(width = 12,
           tagList(h2(textOutput("adenovirus_map_dynamic_header")))),# fluidrow
  
  fluidRow(
    width = 12,
    h5("Please season and week ending."),
    pickerInput(inputId = "selected_season",
                label = "Select a respiratory season",
                choices = {Respiratory_Pathogens_MEM_HB_This_Season %>%
                    #arrange(AgeGroup) %>%
                    .$Season %>%
                    unique()},
                selected = "2023/2024"),

    # dateRangeInput(inputId = "adenovirus_week_slider",
    #                label ="Select Date Range",
    #                start = max(respiratory_pathogens_MEM_hb$WeekBeginning),
    #                end =  max(respiratory_pathogens_MEM_hb$WeekEnding)),
    
    # Use dateInput instead of dateRangeInput to select only the week ending date
    dateInput(inputId = "adenovirus_week_slider",
              label ="Select Week Ending Date",
              value = max(Season_Pathogens_MEM_HB_Polygons$WeekEnding),
              min = min(Season_Pathogens_MEM_HB_Polygons$WeekEnding),
              max =  max(Season_Pathogens_MEM_HB_Polygons$WeekEnding),
              format = "yyyy-mm-dd",
              startview = "month",
              weekstart = 1),
    # sliderInput(inputId = "adenovirus_week_slider",
    #             label = "Use this date-slider to look at infection levels in previous weeks",
    #             min = min(Season_Pathogens_MEM_HB_Polygons$WeekEnding), 
    #             max = max(Season_Pathogens_MEM_HB_Polygons$WeekEnding),
    #             value = max(Season_Pathogens_MEM_HB_Polygons$WeekEnding),
    #             step=1),
   # dateInput("date", "Select a Date"),
    fluidRow(
      width = 12,
      #tagList(h2(textOutput("flu_mem_selected_map_date"))),
      box("placeholder",   width = 8, leafletOutput("adenovirus_mem_map_this_season")),
    )), # fluid row
  
  ### end map section ##########
  fluidRow(width = 12,
           tagList(h2("Adenovirus incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("adenovirus_mem_age_modal"),
                            withNavySpinner(plotlyOutput("adenovirus_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("adenovirus_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
  
)
