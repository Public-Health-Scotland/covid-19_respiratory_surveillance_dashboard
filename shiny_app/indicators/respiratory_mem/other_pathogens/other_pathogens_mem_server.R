metadataButtonServer(id="other_pathogens_mem",
                     panel="Respiratory infection activity",
                     parent = session)
      
      # Alt text ----
      altTextServer("other_pathogens_over_time",
                    title = glue("Other respiratory pathogens* cases over time by pathogen"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of the other respiratory pathogens* cases in a given NHS health board",
                                   " over time.")),
                      tags$li("The cases are presented as a rate, i.e. the number of people with",
                              glue("other respiratory pathogens* for every 100,000 people in that NHS health board.")),
                      tags$li("For Scotland there is an option to view the absolute number of cases."),
                      tags$li("The x axis is the date, commencing 02 Oct 2016."),
                      tags$li("The y axis is either the rate of cases or the number of cases."),
                      tags$li(glue("There is a trace for each respiratory pathogen."))
                      #tags$li("The trend is that each winter there is a peak in cases.")
                    )
      )
      
      altTextServer("other_pathogens_by_season",
                    title =  glue("Other respiratory pathogens* cases over time by season"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of other respiratory pathogens* cases for a given pathogen",
                                   " over each season.")),
                      tags$li("There is a trace for each season, starting in 2016/2017."),
                      tags$li("The x axis is the isoweek. The first isoweek is the first week of the year (in January)",
                              "and the 52nd isoweek is the last week of the year."),
                      tags$li(glue("The y axis is the rate of cases of the chosen respiratory pathogen in Scotland.")))
                    #  tags$li("The trend is that each winter there is a peak in cases. The peak was",
                    #          "highest in 2017/2018 at about 2,800 cases.")
                    # )
      )
      
      altTextServer("other_pathogens_age_sex",
                    title = glue("Other respiratory pathogens* cases by age and/or sex in Scotland"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of the total other respiratory pathogens* cases in Scotland.")),
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
      
      
      ##### Headline figures ----
      output$respiratory_headline_figures_other_pathogen_count <- renderValueBox ({
        
        organism_summary_total <- Respiratory_Summary %>%
          filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
          filter(Breakdown == input$respiratory_headline_pathogen) %>%
          .$Count %>% format(big.mark=",")
        
        valueBox(value = organism_summary_total,
                 subtitle = glue("cases of {input$respiratory_headline_pathogen} in Scotland"),
                 color = "teal",
                 icon = icon_no_warning_fn("virus"),
                 width = NULL)
        
      })

      output$headline_figures_other_pathogen_healthboard_count <- renderValueBox ({
        
        organism_summary_total <- Respiratory_HB %>%
          filter(HBName == input$other_headline_healthboard) %>%#changed this
          filter(Pathogen == input$respiratory_headline_pathogen) %>% 
          tail(1) %>%
          .$RatePer100000 %>% 
          format(big.mark=",")
        
        valueBox(value = organism_summary_total,
                 subtitle = glue("{input$respiratory_headline_pathogen} cases per 100,000 people in {input$other_headline_healthboard}"),
                 color = "teal",
                 icon = icon_no_warning_fn("house-medical"),
                 width = NULL)
        
      })
      
    #  
      
      ########## Observe events ##########
      # selecting input for seeing rate or number for plots
      # only show rates if healthboards are there but can show number of cases for scotland
      # Update dataset choices based off indicator choice
      observeEvent(input$other_pathogens_select_healthboard,
                   {
                     if(input$other_pathogens_select_healthboard == "Scotland"){
                       
                       updatePickerInput(session, inputId = "other_pathogens_y_axis_plots",
                                         choices = c("Number of cases", "Rate per 100,000"),
                                         selected = "Number of cases"
                       )
                       
                     } else {
                       
                       updatePickerInput(session, inputId = "other_pathogens_y_axis_plots",
                                         choices = c("Rate per 100,000"),
                                         selected = "Rate per 100,000"
                                         
                       )
                       
                     }
                     
                   }
      )
      
      observeEvent(input$respiratory_season,
                   {
                     updatePickerInput(session, inputId = "other_pathogens_date",
                                       choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                       selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                     
                   }
      )
      
      
      #####################
      # Observe events ----
      # selecting input for seeing rate or number for plots
      # only show rates if healthboards are there but can show number of cases for scotland
      # Update dataset choices based off indicator choice
      observeEvent(input$other_pathogens_select_healthboard,
                   {
                     
                     if(input$other_pathogens_select_healthboard == "Scotland"){
                       
                       updatePickerInput(session, inputId = "other_pathogens_y_axis_plots",
                                         choices = c("Number of cases", "Rate per 100,000"),
                                         selected = "Number of cases"
                       )
                       
                     } else {
                       
                       updatePickerInput(session, inputId = "other_pathogens_y_axis_plots",
                                         choices = c("Rate per 100,000"),
                                         selected = "Rate per 100,000"
                                         
                       )
                       
                     }
                     
                   }
      )
      
      observeEvent(input$other_pathogens_season,
                   {
                     updatePickerInput(session, inputId = "other_pathogens_date",
                                       choices = {Respiratory_AllData %>% filter(Season == input$other_pathogens_season) %>%
                                           .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                       selected = {Respiratory_AllData %>% filter(Season == input$other_pathogens_season) %>%
                                           .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})
                     
                   }
      )
      
      #############
      
      
      # Plots ----
      # make trend over time plot.
      # Plot shows the rate/number of cases by subtype over time for the whole dataset.
      output$other_pathogens_over_time_plot <- renderPlotly({
        
        Respiratory_AllData %>%
          filter_over_time_plot_function(healthboard = input$other_pathogens_select_healthboard) %>%
          filter(FluOrNonFlu == "nonflu") %>%
          filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
          select_y_axis(., yaxis = input$other_pathogens_y_axis_plots) %>%
          make_respiratory_trend_over_time_plot(., y_axis_title = input$other_pathogens_y_axis_plots)
        
      })
      
      
      output$other_pathogens_over_time_title <- renderUI({h3(glue("Other respiratory pathogens* cases over time ", 
                                                              input$other_pathogens_select_healthboard))})
      
      # plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
      output$other_pathogens_by_season_plot = renderPlotly({
        
        Respiratory_AllData %>%
          filter(FluOrNonFlu == "nonflu") %>%
          select_y_axis(., yaxis = input$other_pathogens_y_axis_plots) %>%
          filter_by_organism(., organism = input$other_pathogens_select_subtype,
                             healthboard = input$other_pathogens_select_healthboard) %>% #address
          make_respiratory_trend_by_season_plot_function(., y_axis_title = input$other_pathogens_y_axis_plots)
        
      })
      
      
      # plot that shows the breakdown by age/sex/age and sex
      output$other_pathogens_by_age_sex_plot = renderPlotly({
        
        Respiratory_AllData %>%
          filter(FluOrNonFlu == "nonflu") %>% 
          filter_by_sex_age(., season = input$other_pathogens_season,
                            date = {input$other_pathogens_date %>% as.Date(format="%d %b %y")},
                            breakdown = input$other_pathogens_age_sex_breakdown) %>%
          make_age_sex_plot(., breakdown = input$other_pathogens_age_sex_breakdown)
        
      })

      output$other_pathogens_by_season_title <- renderUI({h3(glue("Other respiratory pathogens* cases over time by season in ", 
                                                              input$other_pathogens_select_healthboard))})
      
      output$other_pathogens_by_age_sex_title <- renderUI({h3("Other respiratory pathogens* cases by age and/or sex in Scotland")})
      
      # Data tables ----
      
      output$other_pathogens_over_time_table <- renderDataTable ({
        
        
        if(input$respiratory_select_healthboard == "Scotland"){
          
          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$other_pathogens_select_healthboard) %>%
            filter(FluOrNonFlu == "nonflu") %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Count, Rate) %>%
            # Re make this as a factor to remove unused levels
            mutate(Organism = factor(Organism)) %>%
            arrange(desc(Date), Organism) %>%
            dplyr::rename("Week ending" = "Date",
                          "Pathogen"="Organism",
                          "Number of cases" = "Count",
                          "Rate per 100,000" ="Rate") %>%
            make_table(add_separator_cols = 3,
                       filter_cols = 2)
          
        } else {
          
          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$other_pathogens_select_healthboard) %>%
            filter(FluOrNonFlu == "nonflu") %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Rate) %>%
            # Re make this as a factor to remove unused levels
            mutate(Organism = factor(Organism)) %>%
            arrange(desc(Date), Organism) %>%
            dplyr::rename("Week ending" = "Date",
                          "Pathogen" :="Organism",
                          "Rate per 100,000" = "Rate") %>%
            make_table(add_separator_cols = 3,
                       filter_cols = 2)
          
        }
        
      })
      
      # Flu by season table
      output$other_pathogens_by_season_table <- renderDataTable ({
        
        if(input$other_pathogens_select_healthboard == "Scotland"){
          
          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$other_pathogens_select_healthboard) %>%
            filter(FluOrNonFlu == "nonflu") %>%
            arrange(desc(Date), Organism) %>%
            select(Season, Week, Organism, Count, Rate) %>%
            dplyr::rename("Number of cases" = "Count",
                          "Pathogen" = "Organism",
                          "Rate per 100,000" = "Rate") %>%
            mutate(Week = as.character(Week),
                   Week = factor(Week, levels = c(1:53)),
                   Season = factor(Season, levels = unique(Season))) %>%
            dplyr::rename(`ISO week` = Week) %>%
            make_table(filter_cols = c(1,2,3))
          
        } else {
          
          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$other_pathogens_select_healthboard) %>%
            filter(FluOrNonFlu == "nonflu") %>%
            arrange(desc(Date), Organism) %>%
            select(Season, Week, Organism, Rate) %>%
            dplyr::rename("Rate per 100,000" = "Rate",
                          "Pathogen" ="Organism") %>%
            mutate(Week = as.character(Week),
                   Week = factor(Week, levels = c(1:53)),
                   Season = factor(Season, levels = unique(Season))) %>%
            dplyr::rename(`ISO week` = Week) %>%
            make_table(filter_cols = c(1,2,3))
          
        }
        
      })
      
      
      # Flu by age/sex/age and sex
      output$other_pathogens_age_sex_table = renderDataTable({
        
        flu_age <- Respiratory_AllData %>%
          filter(FluOrNonFlu == "nonflu") %>%
          filter(scotland_by_age_flag == 1) %>%
          mutate(Sex = "All") %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          mutate(Season = factor(Season)) %>%
          dplyr::rename("Week ending" = "Date",
                        "Age group" = "AgeGroup",
                        "Rate per 100,000" = "Rate")
        
        flu_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == "nonflu") %>%
          filter(scotland_by_sex_flag == 1) %>%
          mutate(AgeGroup = "All") %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          mutate(Season = factor(Season)) %>%
          dplyr::rename("Week ending" = "Date",
                        "Age group" = "AgeGroup",
                        "Rate per 100,000" = "Rate")
        
        flu_age_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == "nonflu") %>%
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
          make_table(filter_cols = c(1,3,4))
        
      })
      