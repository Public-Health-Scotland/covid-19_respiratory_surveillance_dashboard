
metadataButtonServer(id="respiratory_influenza_mem",
                     panel="Respiratory infection activity",
                     parent = session)

# Low threshold
influenza_low_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(LowThreshold) %>%
  distinct() %>%
  .$LowThreshold %>%
  round_half_up(2)

# Moderate threshold
influenza_moderate_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(MediumThreshold) %>%
  distinct() %>%
  .$MediumThreshold %>%
  round_half_up(2)

# High threshold
influenza_high_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(HighThreshold) %>%
  distinct() %>%
  .$HighThreshold %>%
  round_half_up(2)

# Extraordinary
influenza_extraordinary_threshold <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(ExtraordinaryThreshold) %>%
  distinct() %>%
  .$ExtraordinaryThreshold %>%
  round_half_up(2)

# # Get seasons used in line chart
# seasons_1 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Pathogen == "Influenza") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct() %>%
#   tail(6)
# seasons_2 <- Respiratory_Pathogens_MEM_Scot %>%
#   filter(Season == "2010/2011") %>%
#   filter(Pathogen == "Influenza") %>%
#   select(Season) %>%
#   arrange(Season) %>%
#   distinct()
# seasons <- bind_rows(seasons_2, seasons_1)
# seasons <- seasons$Season

# Get seasons used in line chart
seasons <- Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen == "Influenza") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(6)
seasons <- seasons$Season



altTextServer("influenza_mem_modal",
              title = "Influenza incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of influenza infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the rate of influenza infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", and ",
                                             seasons[6], ".")),
                                tags$li(glue("Activity levels for influenza based on MEM thresholds are represented by different coloured panels on the plot. ",
                                        "The activity levels and MEM thresholds for influenza are: ",
                                        "Baseline (< ", influenza_low_threshold, "), ",
                                        "Low (", influenza_low_threshold, "-", influenza_moderate_threshold-0.01, "), ",
                                        "Moderate (", influenza_moderate_threshold, "-", influenza_high_threshold-0.01, "), ",
                                        "High (", influenza_high_threshold, "-", influenza_extraordinary_threshold-0.01, "), and ",
                                        "Extraordinary (>= ", influenza_extraordinary_threshold, ").")),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))

altTextServer("influenza_mem_hb_modal",
              title = "Influenza incidence rate per 100,000 population by NHS Health Board",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of influenza infection per 100,000 population by NHS Health Board for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the NHS Health Board."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller NHS Health Boards. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to NHS Health Boards ",
                                        "with larger populations."),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


altTextServer("influenza_mem_age_modal",
              title = "Influenza incidence rate per 100,000 population by age group",
              content = tags$ul(tags$li(glue("This is a plot showing the rate of influenza infection per 100,000 population by age group for seasons ",
                                             seasons[5], " and ", seasons[6], ".")),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the age group."),
                                tags$li("Each cell is coloured according to the activity level: Baseline, Low, Moderate, High, or Extraordinary."),
                                tags$li("Caution should be taken when interpreting the activity levels (and MEM thresholds) for smaller age groups. ",
                                        "The swab positivity rate shows greater fluctuation as a result of the lower number of samples taken relative ",
                                        "to the population size; this has the effect of generating small or large incidence rates compared to age groups ",
                                        "with larger populations."),
                                tags$li("By November 2023, all Community Acute Respiratory Infection (CARI) data were removed from the",
                                        "overall number of laboratory-confirmed episodes. Changes to activity level thresholds for other",
                                        "respiratory pathogens were minimal. Influenza activity level thresholds were not affected by this exclusion.")))


# Influenza MEM table
output$influenza_mem_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2,4))
})

# Influenza MEM by HB table
output$influenza_mem_hb_table <- renderDataTable({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, HBName, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           HBName = factor(HBName),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `NHS Health Board`= HBName,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})

# Influenza MEM by Age table
output$influenza_mem_age_table <- renderDataTable({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    filter(Season %in% seasons) %>%
    arrange(desc(WeekEnding)) %>%
    select(Season, ISOWeek, AgeGroup, RatePer100000, ActivityLevel) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek),
           AgeGroup = factor(AgeGroup, levels = mem_age_groups_full),
           ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    rename(`ISO Week` = ISOWeek,
           `Age Group`= AgeGroup,
           `Rate per 100,000` = RatePer100000,
           `Activity Level` = ActivityLevel) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3,5))
})


# Influenza MEM plot
output$influenza_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    create_mem_linechart()

})

# Influenza MEM by HB plot
output$influenza_mem_hb_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_HB %>%
    filter(Pathogen == "Influenza") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "HBCode")

})


# Influenza MEM by Age plot
output$influenza_mem_age_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Age %>%
    filter(Pathogen == "Influenza") %>%
    mutate(ActivityLevel = factor(ActivityLevel, levels = activity_levels)) %>%
    create_mem_heatmap(breakdown_variable = "AgeGroup")

})

### Age and sex plot ###

altTextServer("influenza_age_sex",
              title = glue("Influenza cases by age and/or sex in Scotland"),
              content = tags$ul(
                tags$li(glue("This is a plot of the total influenza cases in Scotland.")),
                tags$li("The information is displayed for a selected season and week."),
                tags$li("One of three different plots is displayed depending on the breakdown",
                        "selected: either Age; Sex; or Age + Sex."),
                tags$li("All three plots show rate per 100,000 people on the y axis."),
                tags$li("For the x axis the first plot shows age group, the second shows",
                        "sex, and the third shows age group and sex."),
                tags$li("The first plot (Age) is a bubble plot. This is a scatter plot",
                        "where both the position and the area of the circle correspond",
                        "to the rate per 100,000 people."),
                tags$li("The second and third plots are bar charts where the left hand column",
                        "corresponds to female (F) and the right hand column to male (M).")
                # tags$li("The youngest and oldest groups have the highest rates of illness.")
              )
)

# plot that shows the breakdown by age/sex/age and sex
output$influenza_age_sex_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter_by_sex_age(., season = input$respiratory_season,
                      date = {input$respiratory_date %>% as.Date(format="%d %b %y")},
                      breakdown = input$respiratory_select_age_sex_breakdown) %>%
    make_age_sex_plot(., breakdown = input$respiratory_select_age_sex_breakdown)

})

# Flu by age/sex/age and sex
output$influenza_age_sex_table = renderDataTable({

  flu_age <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_age_flag == 1) %>%
    mutate(Sex = "All") %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate")

  flu_sex <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_sex_flag == 1) %>%
    mutate(AgeGroup = "All") %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate")

  flu_age_sex <- Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(scotland_by_age_sex_flag == 1) %>%
    select(Season, Date, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    arrange(desc(Date), AgeGroup, Sex) %>%
    dplyr::rename("Week ending" = "Date",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate") %>%
    bind_rows(flu_age, flu_sex) %>%
    mutate(Sex = factor(Sex, levels = c("All", "F", "M")),
           `Age group` = factor(`Age group`, levels =
                                  c("All", "<1", "1-4", "5-14",
                                    "15-44", "45-64", "65-74", "75+"))) %>%
    arrange(desc(`Week ending`), `Age group`, Sex) %>%
    make_table(add_separator_cols_1dp = c(5),
               filter_cols = c(1,3,4))

})

observeEvent(input$respiratory_season,
             {
               updatePickerInput(session, inputId = "respiratory_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)


##### create a map #############

### respiratory  mem levels  by Health board for the last two weeks
# all users need to add .Rprofile to their project files and may need to run the library installation script
# nb only need sf, sp and leaflet packages
# joining of  simplified polygon shape file of HB2019 areas done in set-up.

# still to do:
# create dynamic sub headers to place above two maps displaying the dates
# could create function for generating the two maps, but not at this stage.
# remove map zoom as two maps are independent of each other and could be confusing
# finalse instruction text above or below maps
# final layout of popups and hover elements


# create dynamic map section title- pathogen text driven by pull down
# output$hb_mem_cases_title <- renderText({
#   paste("Map of", input$pathogen_filter, 
#         "incidence rates per 100,000 population by NHS Health Board")
# })
# create dynamic sub headers to place above two maps displaying the dates


map_this_week_flu_date <- Intro_Pathogens_MEM_HB %>%
  tail(1) %>% select(WeekEnding) 
map_this_week_flu_date$WeekEnding<- format(map_this_week_flu_date$WeekEnding, "%d %b %y")


map_prev_week_flu_date <- Intro_Pathogens_MEM_HB_Prev_Week %>%
  tail(1)  %>% select(WeekEnding) 
map_prev_week_flu_date$WeekEnding<- format(map_prev_week_flu_date$WeekEnding, "%d %b %y")

output$map_this_week_title_flu <- renderText({
  paste("Influenza incidence rates for week ending", map_this_week_flu_date$WeekEnding)
})

output$map_prev_week_title_flu <- renderText({
  paste0("Influenza incidence rates (", map_prev_week_flu_date$WeekEnding, ")")
})
# create the Leaflet map for current week
output$flu_mem_map_this_week <- renderLeaflet({
  
  Flu_MEM_HB_Polygons_filter_this_week <- Intro_Pathogens_MEM_HB_Polygons%>%
    filter(Pathogen == "Influenza") 
  
  leaflet(Flu_MEM_HB_Polygons_filter_this_week) %>%
    setView(lng = -4.3, lat = 57.7, zoom = 5.25) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(weight = 1,smoothFactor = 0.5,fillColor = ~ActivityLevelColour,
                opacity = 0.6,
                fillOpacity = 0.6,
                color = "grey",
                dashArray = "0",
                popup = ~paste0("Season: ", Season, "<br>","Week number: ", ISOWeek, "<br>",
                                "(Week ending: </b>", format(WeekEnding, "%d %b %y"), ")<br>",
                                "Health Board: ", HBName, "<br>",
                                "Rate per 100,000: ", RatePer100000, 
                                "<br>","Activity level: ", ActivityLevel),
                label = ~paste0("Activity level: ", ActivityLevel),
                labelOptions = labelOptions(noHide = FALSE, direction = "auto"),
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE) ) %>% 
    addLegend(position = "bottomright",colors = activity_level_colours,
              labels = activity_levels,title = "MEM Activity Level",
              labFormat = labelFormat()) })

# create the Leaflet map for previous week
output$flu_mem_map_prev_week <- renderLeaflet({
  Flu_MEM_HB_Polygons_filter_prev_week <- Intro_Pathogens_MEM_HB_Prev_Week_Polygons%>%
    filter(Pathogen == "Influenza")
  
  leaflet(Flu_MEM_HB_Polygons_filter_prev_week) %>%
    setView(lng = -4.3, lat = 57.7, zoom = 5.25) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(weight = 1,smoothFactor = 0.5,fillColor = ~ActivityLevelColour,
                opacity = 0.6,
                fillOpacity = 0.6,
                color = "grey",
                dashArray = "0",
                popup = ~paste0("Season: ", Season, "<br>","Week number: ", ISOWeek, "<br>",
                                "(Week ending: </b>", format(WeekEnding, "%d %b %y"), ")<br>",
                                "Health Board: ", HBName, "<br>",
                                "Rate per 100,000: ", RatePer100000, "<br>",
                                "Activity level: ", ActivityLevel),
                label = ~paste0("Healthboard: ", HBName),
                labelOptions = labelOptions(noHide = FALSE, direction = "auto"),
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE) ) %>% 
    addLegend(position = "bottomright",colors = activity_level_colours,
              labels = activity_levels,title = "MEM Activity Level",
              labFormat = labelFormat() )
})

##########

