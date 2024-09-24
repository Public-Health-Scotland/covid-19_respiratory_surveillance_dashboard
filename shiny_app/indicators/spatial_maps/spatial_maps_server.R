

output$mem_map_two_seasons <- renderLeaflet({
  Two_Seasons_Pathogens_MEM_HB_Polygons %>% 
    filter(Pathogen == input$map_pathogen_filter) %>%
    filter(Season == input$map_season_filter) %>%
    filter(WeekEnding == input$map_date_filter %>% as.Date(format = "%d %b %y")) %>%
    create_mem_hb_map()
})


# 
# Update Week Ending Date based on season selection
observeEvent(input$map_season_filter, {
  updatePickerInput(session, inputId = "map_date_filter",
                    choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                        filter(Season == input$map_season_filter) %>%
                        .$WeekEnding %>%
                        unique() %>%
                        as.Date() %>%
                        format("%d %b %y")},
                    selected = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                        filter(Season == input$map_season_filter) %>%
                        .$WeekEnding %>%
                        max() %>%
                        as.Date() %>%
                        format("%d %b %y")})
})