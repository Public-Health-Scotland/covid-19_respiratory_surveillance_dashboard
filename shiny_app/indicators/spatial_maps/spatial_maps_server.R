# Low threshold
map_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == input$map_pathogen_filter) %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
map_moderate_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen==  input$map_pathogen_filter) %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
map_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == input$map_pathogen_filter) %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
map_extraordinary_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == input$map_pathogen_filter) %>%
  select(ExtraordinaryThreshold) %>%
  distinct() %>%
  .$ExtraordinaryThreshold %>%
  round_half_up(2)





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

# update the varible rv_fuel_poverty
observeEvent(input$employees_living_wage_cw_map_shape_click,{
  rv_employees_living_wage_cw(input$employees_living_wage_cw_map_shape_click$id)
  
  updateSelectizeInput(session, "employees_living_wage_cw_LA_input",
                       #label = paste("Select input label", length(x)),
                       choices = input$employees_living_wage_cw_map_shape_click$id)
})



# Influenza MEM plot
output$map_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
    filter(Pathogen == input$map_pathogen_filter) %>%
    create_mem_linechart()
  
})