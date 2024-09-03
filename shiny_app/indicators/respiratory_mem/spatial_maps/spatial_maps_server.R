# 
# metadataButtonServer(id="respiratory_rsv_mem",
#                      panel="Respiratory infection activity",
#                      parent = session)
# 
# 
# 


##### create a map #############

# server <- function(input, output, session) {
#   
#   observe({
#     # Prepare available dates as character strings
#     available_dates <- as.character(unique(respiratory_pathogens_MEM_hb$WeekEnding))
#     
#     # Pass available dates to the JavaScript function
#     runjs(sprintf("shinyjs.disableDates(%s);", jsonlite::toJSON(available_dates)))
#   })
# }
server <- function(input, output, session) {
  
  observe({
    # Prepare available dates as character strings
    available_dates <- as.character(unique(Respiratory_Pathogens_MEM_HB_Two_Seasons$WeekEnding))
    
    # Generate JavaScript to disable dates not in the available_dates array
    js_code <- sprintf("
      var availableDates = %s;
      var dateInput = document.querySelector('.shiny-date-input input');
      
    flatpickr(dateInput, {
        enable: availableDates.map(date => new Date(date)),
        dateFormat: 'Y-m-d'
      });
    ", jsonlite::toJSON(available_dates))
    
    # Run the JavaScript to apply the filtering
    runjs(js_code)
  })
}


mem_map_pathogen_filter <- Respiratory_Pathogens_MEM_HB_Two_Seasons%>%
 # filter(Pathogen == input$map_season_filter)%>% 
  mutate(Pathogen = factor(Pathogen,
                           levels = c("Influenza","Respiratory syncytial virus",
                                      "Adenovirus",
                                      "Human metapneumovirus",
                                      "Mycoplasma pneumoniae",
                                      "Parainfluenza virus",
                                      "Rhinovirus",
                                      "Seasonal Coronavirus (non-COVID-19)"  )))
# 
# mem_map_season_filter <- Respiratory_Pathogens_MEM_HB_Two_Seasons %>% 
#   mutate(Season = factor(Season,
#                            levels = c("2023/2024","2022/2023"  )))

map_iso_week_ending <- reactive({
  selected_week <- input$ISOWeekSelector
  map_selected_date <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
    filter(Pathogen == "Adenovirus" & HBName=="NHS Western Isles") %>% # i.e. 1 x HB and 1 x pathogen
    filter(ISOWeekSelector== selected_week) %>%
    select(ISOWeekSelector)
  # %>%
  #   mutate(WeekEnding=as.Date(WeekEnding))
  # map_selected_date$WeekEnding <- format(map_selected_date$WeekEnding, "%d %b %y")
  map_selected_date
})

# Create a date slider reactive expression "adenovirus_map_selected_date"
# map_week_ending <- reactive({
#   selected_week <- input$map_week_ending
#   map_selected_date <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
#     filter(Pathogen == "Adenovirus" & HBName=="NHS Western Isles") %>% # i.e. 1 x HB and 1 x pathogen
#     filter(WeekEnding== selected_week) %>%
#     select(WeekEnding) %>%
#     mutate(WeekEnding=as.Date(WeekEnding))
#   map_selected_date$WeekEnding <- format(map_selected_date$WeekEnding, "%d %b %y")
#   map_selected_date
# })


output$mem_map_two_seasons <- renderLeaflet({
  filtered_data  <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
 #  filter(Season==input$map_season_filter) %>%
   filter(Pathogen == input$map_pathogen_filter) %>%
    filter(WeekEnding== input$map_week_ending)%>% 
   # Check if filtered data is not empty
    #     if (nrow(filtered_data) == 0) {
    #   leaflet() %>%
    #     addTiles() %>%
    #     addLabelOnlyMarkers(lng = 0, lat = 0, label = "No data available for the selected filters.")
    # } else {
    #   create_mem_hb_map(filtered_data)
    # }
  create_mem_hb_map()
})