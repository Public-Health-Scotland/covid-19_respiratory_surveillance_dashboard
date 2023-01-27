#### Respiratory module server ----


# Module server ----
respiratoryServer <- function(id) {

  moduleServer(
    id,
    function(input, output, session) {

      flu_or_nonflu = id

      # Checking one of flu or nonflu is chosen
      stopifnot(flu_or_nonflu %in% c("flu", "nonflu"))

      if(flu_or_nonflu == "flu"){
        flu_long = "influenza"
      } else {
        flu_long = "non-influenza"
      }


      # headline figures
      output$respiratory_headline_figures_subtype_count <- renderValueBox ({

        organism_summary_total <- Respiratory_Summary %>%
          filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
          filter(Breakdown == input$respiratory_headline_subtype) %>%
          .$Count

        valueBox(value = organism_summary_total,
                 subtitle = glue("cases of {input$respiratory_headline_subtype} in Scotland"),
                 color = "teal",
                 icon = icon_no_warning_fn("virus"),
                 width = NULL)

      })

      output$respiratory_headline_figures_healthboard_count <- renderValueBox ({

        organism_summary_total <- Respiratory_Summary %>%
          filter(SummaryMeasure == "Healthboard_Total" & FluOrNonFlu == flu_or_nonflu) %>%
          filter(get_hb_name(Breakdown) == input$respiratory_headline_healthboard) %>%
          .$Rate

        valueBox(value = organism_summary_total,
                 subtitle = glue("{flu_long} cases per 10,000 people in {input$respiratory_headline_healthboard}"),
                 color = "teal",
                 icon = icon_no_warning_fn("house-medical"),
                 width = NULL)

      })

      # selecting input for seeing rate or number for plots
      # only show rates if healthboards are there but can show number of cases for scotland
      # Update dataset choices based off indicator choice
      observeEvent(input$respiratory_select_healthboard,
                   {

                     if(input$respiratory_select_healthboard == "Scotland"){

                       updatePickerInput(session, inputId = "respiratory_y_axis_plots",
                                         label = "Select whether you would like to see population rates or total number of cases",
                                         choices = c("Number of cases", "Rate per 100,000"),
                                         selected = "Number of cases"
                       )

                     } else {

                       updatePickerInput(session, inputId = "respiratory_y_axis_plots",
                                         label = "Select whether you would like to see population rates or total number of cases",
                                         choices = c("Rate per 100,000"),
                                         selected = "Rate per 100,000"

                       )

                     }

                   }
      )

      observeEvent(input$respiratory_season,
                   {
                     updatePickerInput(session, inputId = "respiratory_date",
                                       choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                       selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

                   }
      )


      # make trend over time plot. Plot shows the rate/number of flu cases by subtype over time for the whole dataset.
      output$respiratory_over_time_plot <- renderPlotly({

        Respiratory_AllData %>%
          filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
          select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
          make_respiratory_trend_over_time_plot(., y_axis_title = input$respiratory_y_axis_plots)

      })

      # plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
      output$respiratory_by_season_plot = renderPlotly({

        Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          select_y_axis(., yaxis = input$respiratory_y_axis_plots) %>%
          filter_by_organism(., organism = input$respiratory_select_subtype,
                             healthboard = input$respiratory_select_healthboard) %>%
          make_respiratory_trend_by_season_plot_function(., y_axis_title = input$respiratory_y_axis_plots)

      })

      # plot that shows the breakdown by age/sex/age and sex
      output$respiratory_age_sex_plot = renderPlotly({

        Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter_by_sex_age(., season = input$respiratory_season,
                            date = {input$respiratory_date %>% as.Date(format="%d %b %y")},
                            breakdown = input$respiratory_select_age_sex_breakdown) %>%
          make_age_sex_plot(., breakdown = input$respiratory_select_age_sex_breakdown)

      })

      # Data tables

      output$respiratory_over_time_table <- renderDataTable ({

        if(input$respiratory_select_healthboard == "Scotland"){

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Count, Rate) %>%
            arrange(desc(Date), Organism) %>%
            rename(`Week Ending` = Date,
                   `Number of cases` = Count,
                   `Rate per 100,000` = Rate) %>%
            make_table()

        } else{

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Rate) %>%
            arrange(desc(Date), Organism) %>%
            rename(`Week Ending` = Date,
                   `Rate per 100,000` = Rate) %>%
            make_table()

        }

      })

      # Flu by season table
      output$respiratory_by_season_table <- renderDataTable ({

        if(input$respiratory_select_healthboard == "Scotland"){

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            arrange(desc(Date), Organism) %>%
            select(Season, Week, Organism, Count, Rate) %>%
            rename(`Number of cases` = Count,
                   `Rate per 100,000` = Rate) %>%
            make_table()

        } else{

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            arrange(desc(Date), Organism) %>%
            select(Season, Week, Organism, Rate) %>%
            rename(`Rate per 100,000` = Rate) %>%
            make_table()

        }

      })


      # Flu by age/sex/age and sex
      output$respiratory_age_sex_table = renderDataTable({

        flu_age <- Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(scotland_by_age_flag == 1) %>%
          mutate(Sex = "All") %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          rename(`Week Ending` = Date,
                 `Age Group` = AgeGroup,
                 `Rate per 100,000` = Rate)

        flu_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(scotland_by_sex_flag == 1) %>%
          mutate(AgeGroup = "All") %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          rename(`Week Ending` = Date,
                 `Age Group` = AgeGroup,
                 `Rate per 100,000` = Rate)

        flu_age_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(scotland_by_age_sex_flag == 1) %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          arrange(desc(Date), AgeGroup, Sex) %>%
          rename(`Week Ending` = Date,
                 `Age Group` = AgeGroup,
                 `Rate per 100,000` = Rate) %>%
          bind_rows(flu_age, flu_sex) %>%
          make_table()

      })

    }
  )

}







