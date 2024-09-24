
tagList(
  fluidRow(width = 12,
         #  metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h2("Pathogen Incidence Rates by NHS Health Board"),
           p("This is a tab of maps. Lorem ipsum dolor sit amet, consectetur",
             "adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore"),
           #linebreaks(1)
           ),



  fluidRow(width = 12,
           tagList(h3("Use these filter to select pathogen and time period"))),

  
  ####  start map section ##########

  fluidRow(
    column(width = 4,# pathogen
           pickerInput(inputId = "map_pathogen_filter",
                       label = "Select a pathogen",
                       choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                           .$Pathogen %>%
                           unique()}, selected = "Influenza") ),#column
  column(width =4,     #season
         pickerInput(inputId = "map_season_filter",
                     label = "Select a respiratory season",
                     choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%  .$Season %>%   unique()},
                    selected = "2023/2024")),
  column(width =4, #  week ending
         pickerInput(inputId = "map_date_filter",
                   label ="Select Week Ending Date",
                   choices={Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                      filter(Season=="2023/2024") %>%
                       .$WeekEnding %>% unique()%>%as.Date() %>%  format("%d %b %y")},
                   selected= {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                     filter(Season == "2023/2024") %>%
                       .$WeekEnding %>% max() %>% as.Date() %>% format("%d %b %y")})

                   ),# column
  ),#fluidrow
    fluidRow( width = 12,
              box("geo_spatial_v6", 
                  width = 12,
                  leafletOutput("mem_map_two_seasons",width = "100%",height="750px"))
    ),# fluid row
    linebreaks(1)
)# tag list
