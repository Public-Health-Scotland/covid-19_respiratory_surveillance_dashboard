
mem_map_pathogen_filter <-reactive({
  selected_pathogen == input$map_pathogen_filter 
  map_selected_pathogen<- Two_Seasons_Pathogens_MEM_HB_Polygons %>% 
     filter(Pathogen == input$map_pathogen_filter) %>% 
    select(Pathogen) %>% 
    mutate(Pathogen = factor(Pathogen,
                       levels = c("Influenza",
                                  "Respiratory syncytial virus",
                                  "Adenovirus",
                                  "Human metapneumovirus",
                                  "Mycoplasma pneumoniae",
                                  "Parainfluenza virus",
                                  "Rhinovirus",
                                  "Seasonal Coronavirus (non-COVID-19)"  )))
})


mem_map_season_filter <-reactive({
  selected_season == input$map_season_filter
  map_selected_season<- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
    filter(Season== input$map_season_filter) %>% 
    select(Sesaon) %>% 
    mutate(Season = factor(Season, levels = c("2023/2024","2022/2023"  )))
}) 

map_iso_week_ending <- reactive({
  selected_week <- input$map_iso_week_filter
  map_selected_date <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
   # filter(Pathogen == "Adenovirus" & HBName=="NHS Western Isles") %>% # i.e. 1 x HB and 1 x pathogen
    filter(ISOWeekSelector== selected_week) %>%
    select(ISOWeekSelector)
  
  # map_selected_date
})

output$mem_map_two_seasons <- renderLeaflet({
  filtered_data  <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
   filter(Season==input$map_season_filter) %>%
   filter(Pathogen == input$map_pathogen_filter) %>%
    filter(latest_isoweek_map== input$map_iso_week_filter)%>% 
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