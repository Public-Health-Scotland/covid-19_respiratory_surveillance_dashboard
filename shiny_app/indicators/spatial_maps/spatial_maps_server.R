seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons <- seasons$Season


altTextServer("map_mem_modal",
              title = "Pathogen incidence rates per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li("This is a map showing the rate of infection per 100,000 population for a selected respiratory pathogen in each NHS Heatlh Board."),
                                tags$li("The information is displayed for a selected pathogen, respiratory season and week. ",
                               tags$li(glue("There is drop-down menu option to choose one of the ",
                                            "following respiratory pathogens: influenza - type A or B ,",
                                            "respiratory syncytial virus, adenovirus, human metapneumovirus, ",
                                            "mycoplasma pneumoniae, parainfluenza virus, rhinovirus or seasonal coronavirus.")),
                               tags$li(glue("There is drop-down menu option to choose either season ", seasons[5], " or ", seasons[6], ".")),
                               tags$li(glue("There is drop-down menu option to choose the week ending.")),
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

