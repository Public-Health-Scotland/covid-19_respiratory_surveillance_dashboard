

tagList(
  useShinyjs(),  # Initialize shinyjs
  
  # Date input for week ending selection
  fluidRow(
    width = 12,
    dateInput(inputId = "map_week_ending",
              label = "Select Week Ending Date", 
              value = Sys.Date(),
              format = "yyyy-mm-dd")
  ),
  
  fluidRow(width = 12,
         #  metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h1("Pathogen Incidence Rates by NHS Health Board"),
           p("This is a tab of maps. Lorem ipsum dolor sit amet, consectetur",
             "adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"),
           #linebreaks(1)
           ),



  fluidRow(width = 12,
           tagList(h2("Use these filter to select pathogen and time period"))),

  
  ####  start map section ##########
  #  fluidRow(width = 12,
  # #          tagList(h2(textOutput("adenovirus_map_dynamic_header")))),# fluidrow
  # 
  fluidRow( 
    column(width = 4,# mem pathogen
           pickerInput(inputId = "map_pathogen_filter",  
                       label = "Select pathogen",
                       choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                           .$Pathogen %>%
                           unique()}, selected = "Influenza") ),#column
  # column(width =4,     #mem season  
  #        pickerInput(inputId = "map_season_filter",
  #                    label = "Select a respiratory season",
  #                    choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%  .$Season %>%   unique()},
  #                   selected = "2023/2024")),
  column(width =4, # mem week ending
         dateInput(inputId = "map_date_filter",
                   label ="Select Date",
                   value = max(Respiratory_Pathogens_MEM_HB_Two_Seasons$WeekEnding),
                   # min = min(Respiratory_Pathogens_MEM_HB_Two_Seasons$WeekEnding),
                   # max =  max(Respiratory_Pathogens_MEM_HB_Two_Seasons$WeekEnding),
                   format = "yyyy-mm-dd",
                   startview = "month",
                   weekstart = 1)),# column
  ),#fluidrow
    fluidRow( width = 12,
              box("A dynamic map place holder",   width = 12,
                  leafletOutput("mem_map_two_seasons",width = "100%",height="750px"))
    ),# fluid row
    linebreaks(1)
)# tag list
