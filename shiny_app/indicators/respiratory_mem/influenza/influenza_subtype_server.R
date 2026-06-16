
# Alt text ----
altTextServer("respiratory_over_time_modal",
              title = glue("Laboratory-confirmed influenza cases by subtype"),
              content = tags$ul(
                tags$li(glue("This is a stacked bar chart plot of laboratory-confirmed influenza cases",
                             " by subtype within a given NHS Health Board",
                             " for a selected respiratory season.")),
                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                tags$li(glue("The laboratory-confirmed cases are presented as a rate, i.e. the number of people with ",
                        "influenza for every 100,000 people in that NHS Health Board.")),
                tags$li("For Scotland there is an option to view the absolute number of cases."),
                tags$li("The y axis is either the rate of cases or the number of cases."),
              )
)

altTextServer("respiratory_by_season_modal",
              title =  glue("Laboratory-confirmed influenza cases over time by season"),
              content = tags$ul(
                tags$li(glue("This is a plot of the laboratory-confirmed influenza cases for a given subtype",
                             " over each season.")),
                tags$li(glue("There is a trace for each season, starting in ", recent_six_seasons[1], ".")),
                tags$li("The x axis is the isoweek. Week 40 is typically the start of October and when the winter respiratory season starts"),
                tags$li(glue("The y axis is the rate of laboratory-confirmed cases of the chosen influenza subtype in a given NHS health board.")),
                tags$li("For Scotland there is an option to view the absolute number of cases."))
)


# Headline figures ----
output$respiratory_headline_figures_subtype_count <- renderValueBox ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
    filter(Breakdown == input$respiratory_headline_subtype) %>%
    .$Count %>% format(big.mark=",")

  valueBox(value = organism_summary_total,
           subtitle = glue("laboratory-confirmed cases of {input$respiratory_headline_subtype} in Scotland"),
           color = "navy",
           icon = icon_no_warning_fn("virus"),
           width = NULL)

})

output$respiratory_headline_figures_healthboard_count <- renderValueBox ({

  organism_summary_total <- Respiratory_HB %>%
    filter(HBName == input$respiratory_headline_healthboard) %>%
    filter(Pathogen == input$respiratory_headline_subtype) %>%
    tail(1) %>%
    .$RatePer100000 %>%
    format(big.mark=",")

  valueBox(value = organism_summary_total,
           subtitle = glue("{input$respiratory_headline_subtype} laboratory-confirmed cases per 100,000 people in {input$respiratory_headline_healthboard}"),
           color = "navy",
           icon = icon_no_warning_fn("house-medical"),
           width = NULL)

})


# Plots ----
# make trend over time plot.
# Plot shows the rate/number of cases by subtype over time for the whole dataset.
output$respiratory_over_time_plot <- renderPlotly({

  Respiratory_AllData %>%
    filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>% # respiratory functions
    filter(FluOrNonFlu == "flu") %>%
    filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)" & Organism!= "Influenza - Type A or B") %>%
    filter(Season== input$respiratory_select_season) %>% 
    group_by(Date) %>% 
    mutate(total_cases  = sum(Count)) %>% 
    ungroup() %>% 
    select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
    arrange(Date) %>%
    make_respiratory_trend_over_time_plot(., y_axis_title = input$respiratory_y_axis_plots) # respiratory functions
})


output$respiratory_over_time_title <- renderUI({h3(glue("Laboratory-confirmed influenza cases by subtype in ",
                                                        input$respiratory_select_healthboard, " in Season ",
                                                        input$respiratory_select_season))})

# plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
output$respiratory_by_season_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(Season %in% recent_six_seasons) %>%
    select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
    filter_by_organism(., organism = input$respiratory_select_subtype,
                       healthboard = input$respiratory_select_healthboard) %>%
    make_respiratory_trend_by_season_plot_function(., y_axis_title = input$respiratory_y_axis_plots)# respiratory functions

})


output$respiratory_by_season_title <- renderUI({h3(glue("Laboratory-confirmed influenza cases over time by season in ",
                                                        input$respiratory_select_healthboard))})


# Data tables ----

output$respiratory_over_time_table <- renderDataTable ({
  if(input$respiratory_select_healthboard == "Scotland"){
    Respiratory_AllData %>%
      filter(Season == input$respiratory_select_season, 
             Healthboard == input$respiratory_select_healthboard,
             FluOrNonFlu == "flu",
             Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>% 
      arrange(desc(Date), Organism) %>%
      select(Season, Week,Healthboard, Organism, Count, Rate) %>%
      mutate(Week = as.character(Week),
             Week = factor(Week, levels = c(1:53)),
             Season = factor(Season, levels = unique(Season))) %>%
      dplyr::rename(`ISO week` = Week,
                    "NHS Health Board" =Healthboard,
                    "Number of cases" = Count,
                    !!quo_name(stringr::str_to_title("subtype") ) := "Organism",
                    "Rate per 100,000" = Rate) %>%
      make_table(filter_cols = c(1,2,3,4),
                 add_separator_cols = c(5),
                 add_separator_cols_1dp = c(6))
    
  } else {
    Respiratory_AllData %>%
      filter(organism_by_hb_flag == 1) %>% 
     mutate(Healthboard = get_hb_name(HealthboardCode)) %>% 
     filter(Season == input$respiratory_select_season, 
            Healthboard == input$respiratory_select_healthboard,
            FluOrNonFlu == "flu",
            Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>% 
      arrange(desc(Date), Organism) %>%
      select(Season, Week,Healthboard, Organism, Rate) %>%
      mutate(Week = as.character(Week),
             Week = factor(Week, levels = c(1:53)),
             Season = factor(Season, levels = unique(Season))) %>%
      dplyr::rename(`ISO week` = Week,
                    "NHS Health Board" =Healthboard,
                    "Rate per 100,000" = Rate,
                    !!quo_name(stringr::str_to_title("subtype") ) :="Organism") %>%
      make_table(filter_cols = c(2))
    
  }
})

# Flu by season table
output$respiratory_by_season_table <- renderDataTable ({

  if(input$respiratory_select_healthboard == "Scotland"){
    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
      filter(Season %in% recent_six_seasons) %>%
      arrange(desc(Date), Organism) %>%
      select(Season, Week, Organism, Count, Rate) %>%
      dplyr::rename("Number of cases" = "Count",
                    !!quo_name(stringr::str_to_title("subtype") ) := "Organism",
                    "Rate per 100,000" = "Rate") %>%
      mutate(Week = as.character(Week),
             Week = factor(Week, levels = c(1:53)),
             Season = factor(Season, levels = unique(Season))) %>%
      dplyr::rename(`ISO week` = Week) %>%
      make_table(filter_cols = c(1,2,3),
                 add_separator_cols = c(4),
                 add_separator_cols_1dp = c(5))

  } else {

    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
      filter(Season %in% recent_six_seasons) %>%
      arrange(desc(Date), Organism) %>%
      select(Season, Week, Organism, Rate) %>%
      dplyr::rename("Rate per 100,000" = "Rate",
                    !!quo_name(stringr::str_to_title("subtype") ) :="Organism") %>%
      mutate(Week = as.character(Week),
             Week = factor(Week, levels = c(1:53)),
             Season = factor(Season, levels = unique(Season))) %>%
      dplyr::rename(`ISO week` = Week) %>%
      make_table(filter_cols = c(1,2,3))

  }

})



# Update dataset choices based off indicator choice
observeEvent(input$respiratory_select_healthboard,
             {

               if(input$respiratory_select_healthboard == "Scotland"){

                 updatePickerInput(session, inputId = "respiratory_y_axis_plots",
                                   choices = c("Number of cases", "Rate per 100,000"),
                                   selected = "Number of cases"
                 )

               } else {

                 updatePickerInput(session, inputId = "respiratory_y_axis_plots",
                                   choices = c("Rate per 100,000"),
                                   selected = "Rate per 100,000"

                 )

               }

             }
)
