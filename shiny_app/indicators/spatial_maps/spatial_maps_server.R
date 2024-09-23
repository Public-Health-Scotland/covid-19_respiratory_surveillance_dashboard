# 
# metadataButtonServer(id="respiratory_rsv_mem",
#                      panel="Respiratory infection activity",
#                      parent = session)
# 
# 
# 


##### create a map #############


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



# Create a date slider reactive expression "adenovirus_map_selected_date"
mem_map_date_filter <- reactive({
  selected_week <- input$map_date_filter
  map_selected_date <- Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
    filter(Pathogen == "Adenovirus" & HBName=="NHS Western Isles") %>% # i.e. 1 x HB and 1 x pathogen
    filter(WeekEnding== selected_week) %>%
    select(WeekEnding) %>%
    mutate(WeekEnding=as.Date(WeekEnding))
  map_selected_date$WeekEnding <- format(map_selected_date$WeekEnding, "%d %b %y")
  map_selected_date
})


output$mem_map_two_seasons <- renderLeaflet({
  filtered_data  <- Two_Seasons_Pathogens_MEM_HB_Polygons %>%
 #  filter(Season==input$map_season_filter) %>%
   filter(Pathogen == input$map_pathogen_filter) %>%
    filter(WeekEnding== input$map_date_filter)%>% 
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