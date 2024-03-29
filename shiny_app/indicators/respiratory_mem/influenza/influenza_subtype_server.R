
metadataButtonServer(id="respiratory_influenza_subtype",
                     panel="Respiratory infection activity",
                     parent = session)


# Alt text ----
altTextServer("respiratory_over_time_modal",
              title = glue("Influenza cases over time by subtype"),
              content = tags$ul(
                tags$li(glue("This is a plot of the influenza cases in a given NHS health board",
                             " over time.")),
                tags$li("The cases are presented as a rate, i.e. the number of people with",
                        glue("influenza for every 100,000 people in that NHS health board.")),
                tags$li("For Scotland there is an option to view the absolute number of cases."),
                tags$li("The x axis is the date, commencing 02 Oct 2016."),
                tags$li("The y axis is either the rate of cases or the number of cases."),
                tags$li(glue("There is a trace for each subtype of influenza."))
                #tags$li("The trend is that each winter there is a peak in cases.")
              )
)

altTextServer("respiratory_by_season_modal",
              title =  glue("Influenza cases over time by season"),
              content = tags$ul(
                tags$li(glue("This is a plot of the influenza cases for a given subtype",
                             " over each season.")),
                tags$li("There is a trace for each season, starting in 2016/2017."),
                tags$li("The x axis is the isoweek. Week 40 is typically the start of October and when the winter respiratory season starts"),
                tags$li(glue("The y axis is the rate of cases of the chosen influenza subtype in a given NHS health board.")),
                tags$li("For Scotland there is an option to view the absolute number of cases."))
              #  tags$li("The trend is that each winter there is a peak in cases. The peak was",
              #          "highest in 2017/2018 at about 2,800 cases.")
              # )
)


# Headline figures ----
output$respiratory_headline_figures_subtype_count <- renderValueBox ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
    filter(Breakdown == input$respiratory_headline_subtype) %>%
    .$Count %>% format(big.mark=",")

  valueBox(value = organism_summary_total,
           subtitle = glue("cases of {input$respiratory_headline_subtype} in Scotland"),
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
           subtitle = glue("{input$respiratory_headline_subtype} cases per 100,000 people in {input$respiratory_headline_healthboard}"),
           color = "navy",
           icon = icon_no_warning_fn("house-medical"),
           width = NULL)

})


# Plots ----
# make trend over time plot.
# Plot shows the rate/number of cases by subtype over time for the whole dataset.
output$respiratory_over_time_plot <- renderPlotly({

  Respiratory_AllData %>%
    filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
    select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
    make_respiratory_trend_over_time_plot(., y_axis_title = input$respiratory_y_axis_plots)


})


output$respiratory_over_time_title <- renderUI({h3(glue("Influenza cases over time by subtype in ",
                                                        input$respiratory_select_healthboard))})

# plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
output$respiratory_by_season_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
    filter_by_organism(., organism = input$respiratory_select_subtype,
                       healthboard = input$respiratory_select_healthboard) %>%
    make_respiratory_trend_by_season_plot_function(., y_axis_title = input$respiratory_y_axis_plots)

})


output$respiratory_by_season_title <- renderUI({h3(glue("Influenza cases over time by season in ",
                                                        input$respiratory_select_healthboard))})


# Data tables ----

output$respiratory_over_time_table <- renderDataTable ({


  if(input$respiratory_select_healthboard == "Scotland"){

    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
      filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
      select(Date, Organism, Count, Rate) %>%
      # Re make this as a factor to remove unused levels
      mutate(Organism = factor(Organism)) %>%
      arrange(desc(Date), Organism) %>%
      dplyr::rename("Week ending" = "Date",
                    !!quo_name(stringr::str_to_title("subtype") ) :="Organism",
                    "Number of cases" = "Count",
                    "Rate per 100,000" ="Rate") %>%
      make_table(add_separator_cols = 3,
                 filter_cols = 2)

  } else {

    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
      filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
      select(Date, Organism, Rate) %>%
      # Re make this as a factor to remove unused levels
      mutate(Organism = factor(Organism)) %>%
      arrange(desc(Date), Organism) %>%
      dplyr::rename("Week ending" = "Date",
                    !!quo_name(stringr::str_to_title("subtype") ) :="Organism",
                    "Rate per 100,000" = "Rate") %>%
      make_table(add_separator_cols = 3,
                 filter_cols = 2)

  }

})

# Flu by season table
output$respiratory_by_season_table <- renderDataTable ({

  if(input$respiratory_select_healthboard == "Scotland"){

    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
      arrange(desc(Date), Organism) %>%
      select(Season, Week, Organism, Count, Rate) %>%
      dplyr::rename("Number of cases" = "Count",
                    !!quo_name(stringr::str_to_title("subtype") ) := "Organism",
                    "Rate per 100,000" = "Rate") %>%
      mutate(Week = as.character(Week),
             Week = factor(Week, levels = c(1:53)),
             Season = factor(Season, levels = unique(Season))) %>%
      dplyr::rename(`ISO week` = Week) %>%
      make_table(filter_cols = c(1,2,3))

  } else {

    Respiratory_AllData %>%
      filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
      filter(FluOrNonFlu == "flu") %>%
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
