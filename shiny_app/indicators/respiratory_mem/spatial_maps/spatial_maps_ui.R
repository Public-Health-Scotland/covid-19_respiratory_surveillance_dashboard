
latest_isoweek_map <- Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
  tail(1) %>%
  .$ISOWeekSelector


tagList(
 # useShinyjs(),  # Initialize shinyjs
  
  # # Date input for week ending selection
  # fluidRow(
  #   width = 12,
  #   dateInput(inputId = "map_week_ending",
  #             label = "Select Week Ending Date", 
  #             value = Sys.Date(),
  #             format = "yyyy-mm-dd")
  
  # 
  fluidRow(width = 12,
         #  metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h1("Pathogen Incidence Rates by NHS Health Board"),
           p("This is a tab of maps. Lorem ipsum dolor sit amet, consectetur",
             "adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"),
           linebreaks(1)
           ),

    fluidRow(width = 12,
           tagList(h3("Use these filter to select pathogen and time period"))),

  
  ####  start map section ##########
  #  fluidRow(width = 12,
  # #          tagList(h2(textOutput("adenovirus_map_dynamic_header")))),# fluidrow
  # 
  fluidRow( 
    column(width = 4,# mem pathogen
           pickerInput(inputId = "map_pathogen_filter",  
                       label = "Select pathogen",
                       choices = {Two_Seasons_Pathogens_MEM_HB_Polygons %>%
                           .$Pathogen %>%
                           unique()}, selected = "Influenza") ),#column
    column(width =4,     #mem season
           pickerInput(inputId = "map_season_filter",
                       label = "Select a respiratory season",
                       choices = {Two_Seasons_Pathogens_MEM_HB_Polygons %>%  
                           .$Season %>%   
                           unique()},    selected = "2023/2024")),# column
    column(width = 4,# mem pathogen
           pickerInput(inputId = "map_iso_week_filter",  
                       label = "Select ISO week",
                       choices = {Two_Seasons_Pathogens_MEM_HB_Polygons %>%
                           .$ISOWeekSelector %>%
                           unique()}, 
                       selected = latest_isoweek_map) ),# column
  ),
  
  fluidRow( width = 12,
              box("A dynamic map place holder",   width = 12,
                  leafletOutput("mem_map_two_seasons",
                                width = "100%",height="750px")),
    linebreaks(1),
    )# fluidrow
)# tag list