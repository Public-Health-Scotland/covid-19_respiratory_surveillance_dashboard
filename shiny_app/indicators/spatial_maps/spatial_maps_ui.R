  
  ####  start map section ##########

tagList(
  fluidRow(width = 12,
         #  metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1), 
           h2("Pathogen incidence rates per 100,000 population by NHS Health Board"),
           p("This section displays a map of activity levels for each respiratory pathogen",
             "(except COVID-19) within NHS Health Boards. The map shows the same data presented in",
             "the 'Incident Rate by Health Board' within each 'Respiratory pathogens' section" , 
             "but with a clearer geospatial understanding of these activity levels."),
           #linebreaks(1)
           ),



  fluidRow(width = 12,
           tagList(h3("Use these filter to select a respiratory pathogen and time period"))),# fluidrow

  
  
  
  fluidRow(
    column(width = 4,# pathogen
           pickerInput(inputId = "map_pathogen_filter",
                       label = "Respiratory pathogen",
                       choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                           .$Pathogen %>%
                           unique()}, selected = "Influenza") ),#column
  column(width =4,     #season
         pickerInput(inputId = "map_season_filter",
                     label = "Respiratory season",
                     choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%  .$Season %>%   unique()},
                    selected = "2023/2024")),
  column(width =4, #  week ending
         pickerInput(inputId = "map_date_filter",
                   label ="Week ending date",
                   choices={Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                      filter(Season=="2023/2024") %>%
                       .$WeekEnding %>% unique()%>%as.Date() %>%  format("%d %b %y")},
                   selected= {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                     filter(Season == "2023/2024") %>%
                       .$WeekEnding %>% max() %>% as.Date() %>% format("%d %b %y")})

                   ),# column
  ),#fluidrow

    fluidRow( width = 12,
              type="pills",
              tabPanel("geo_spatial_v6",
                       tagList(linebreaks(1)),
                       altTextUI("map_mem_modal"),
                       withNavySpinner(leafletOutput("mem_map_two_seasons",
                                                     width = "100%",height="750px")),
                      # withNavySpinner(plotlyOutput("map_mem_plot"))
                      )
    ),# fluid row
    linebreaks(1)
)# tag list
