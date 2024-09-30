# all this section related to creating maps. 
# If hashtagged out its method development and not to be brought over to a new branch #####


map_last_season <- Respiratory_Pathogens_MEM_HB_Two_Seasons%>%
  filter(Pathogen == "Influenza" & HBName == "NHS Ayrshire and Arran") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  head(1)

map_this_season <- Respiratory_Pathogens_MEM_HB_Two_Seasons%>%
  filter(Pathogen == "Influenza" & HBName == "NHS Ayrshire and Arran") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(1)

#map_two_seasons <- map_two_seasons$Season
map_last_season <- map_last_season$Season
map_this_season <-map_this_season$Season

altTextServer("map_mem_modal",
              title = "Pathogen incidence rates per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li("This is a map showing the rate of infection per 100,000 population for a selected respiratory pathogen in each NHS Heatlh Board."),
                                tags$li("The information is displayed for a selected pathogen, respiratory season and week. ",
                               tags$li(glue("There is drop-down menu option to choose one of the ",
                                            "following respiratory pathogens: influenza - type A or B ,",
                                            "respiratory syncytial virus, adenovirus, human metapneumovirus, ",
                                            "mycoplasma pneumoniae, parainfluenza virus, rhinovirus or seasonal coronavirus.")),
                               tags$li(glue("There is drop-down menu option to choose either season ", map_last_season, " or ", map_this_season, ".")),
                               tags$li(glue("There is drop-down menu option to choose the week. The dates listed are by week ending and limited by the selected season.")),
                               tags$li(glue("NHS Health Boards are coloured by the selected pathogen's MEM thresholds." )),
                               tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion."))))

output$mem_map_two_seasons <- renderLeaflet({
  Two_Seasons_Pathogens_MEM_HB_Polygons %>% 
    filter(Pathogen == input$map_pathogen_filter) %>%
    filter(Season == input$map_season_filter) %>%
    filter(WeekEnding == input$map_date_filter %>% as.Date(format = "%d %b %y")) %>%
    create_mem_hb_map() # function stored in respiratory_mem_functions.R
})


# 
# Update Week Ending Date based on season selection
observeEvent(input$map_season_filter, {
  updatePickerInput(session, inputId = "map_date_filter",
                    choices = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                        filter(Season == input$map_season_filter) %>%
                        .$WeekEnding %>% unique() %>%
                        as.Date() %>% format("%d %b %y")},
                    selected = {Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
                        filter(Season == input$map_season_filter) %>%
                        .$WeekEnding %>%  max() %>%
                        as.Date() %>% format("%d %b %y")})
})
#### additional map options in development ####
# observeEvent(input$map_HB_filter, {
#   selected_HB <- input$Two_Seasons_Pathogens_MEM_HB_Polygons_shape_click$id
#   
#   # Update the variable for the health board (assuming id exists)
#   updateSelectizeInput(session, "map_mem_plot",
#                        choices = selected_HB)
# })
# output$map_mem_plot <- renderPlotly({
#   Respiratory_Pathogens_MEM_HB_Two_Seasons %>%
#     filter(Pathogen == input$map_pathogen_filter) %>%
#     filter(HBName== input$map_HB_filter) %>% 
#     create_mem_linechart()
# })
# 
