#### Respiratory module server ----

respiratoryServer <- function(id) {

  moduleServer(
    id,
    function(input, output, session) {

      flu_or_nonflu = id

      # Checking one of flu or nonflu is chosen
      stopifnot(flu_or_nonflu %in% c("flu", "nonflu"))

      if(flu_or_nonflu == "flu"){
        name_long = "influenza"
        strain_name = "subtype"
      } else {
        name_long = "non-influenza"
        strain_name = "pathogen"
      }

      # Alt text ----
      altTextServer("respiratory_over_time_modal",
                    title = glue("{str_to_title(name_long)} cases over time by {strain_name}"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of the {name_long} cases in a given NHS health board",
                              " over time.")),
                      tags$li("The cases are presented as a rate, i.e. the number of people with",
                              glue("{name_long} for every 10,000 people in that NHS health board.")),
                      tags$li("For Scotland there is an option to view the absolute number of cases."),
                      tags$li("The x axis is the date, commencing 02 Oct 2016."),
                      tags$li("The y axis is either the rate of cases or the number of cases."),
                      tags$li(glue("There is a trace for each {strain_name} of {name_long}."))
                      #tags$li("The trend is that each winter there is a peak in cases.")
                    )
      )

      altTextServer("respiratory_by_season_modal",
                    title =  glue("{str_to_title(name_long)} cases over time by season"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of the {name_long} cases for a given {strain_name}",
                              " over each season.")),
                      tags$li("There is a trace for each season, starting in 2016/2017."),
                      tags$li("The x axis is the isoweek. The first isoweek is the first week of the year (in January)",
                              "and the 52nd isoweek is the last week of the year."),
                      tags$li(glue("The y axis is the rate of cases of the chosen {name_long} {strain_name} in Scotland.")))
                    #  tags$li("The trend is that each winter there is a peak in cases. The peak was",
                    #          "highest in 2017/2018 at about 2,800 cases.")
                   # )
      )

      altTextServer("respiratory_age_sex_modal",
                    title = glue("{str_to_title(name_long)} cases by age and/or sex in Scotland"),
                    content = tags$ul(
                      tags$li(glue("This is a plot of the total {name_long} cases in Scotland.")),
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


      # Headline figures ----
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
                 subtitle = glue("{name_long} cases per 10,000 people in {input$respiratory_headline_healthboard}"),
                 color = "teal",
                 icon = icon_no_warning_fn("house-medical"),
                 width = NULL)

      })

      # Observe events ----
      # selecting input for seeing rate or number for plots
      # only show rates if healthboards are there but can show number of cases for scotland
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

      observeEvent(input$respiratory_season,
                   {
                     updatePickerInput(session, inputId = "respiratory_date",
                                       choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                       selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                           .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

                   }
      )


      # Plots ----
      # make trend over time plot.
      # Plot shows the rate/number of cases by subtype over time for the whole dataset.
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

      # Data tables ----

      output$respiratory_over_time_table <- renderDataTable ({


        if(input$respiratory_select_healthboard == "Scotland"){

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Count, Rate) %>%
            arrange(desc(Date), Organism) %>%
            dplyr::rename("Week ending" = "Date",
                          !!quo_name(stringr::str_to_title(strain_name) ) :="Organism",
                          "Number of cases" = "Count",
                          "Rate per 100,000" ="Rate") %>%
            make_table()

        } else {

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
            select(Date, Organism, Rate) %>%
            arrange(desc(Date), Organism) %>%
            dplyr::rename("Week ending" = "Date",
                          !!quo_name(stringr::str_to_title(strain_name) ) :="Organism",
                          "Rate per 100,000" = "Rate") %>%
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
            dplyr::rename("Number of cases" = "Count",
                          !!quo_name(stringr::str_to_title(strain_name) ) := "Organism",
                          "Rate per 100,000" = "Rate") %>%
            mutate(Week = as.character(Week),
                   Week = factor(Week, levels = c(1:53)),
                   Season = factor(Season, levels = unique(Season))) %>%
            make_table()

        } else {

          Respiratory_AllData %>%
            filter_over_time_plot_function(healthboard = input$respiratory_select_healthboard) %>%
            filter(FluOrNonFlu == flu_or_nonflu) %>%
            arrange(desc(Date), Organism) %>%
            select(Season, Week, Organism, Rate) %>%
            dplyr::rename("Rate per 100,000" = "Rate",
                          !!quo_name(stringr::str_to_title(strain_name) ) :="Organism") %>%
            mutate(Week = as.character(Week),
                   Week = factor(Week, levels = c(1:53)),
                   Season = factor(Season, levels = unique(Season))) %>%
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
          dplyr::rename("Week ending" = "Date",
                        "Age group" = "AgeGroup",
                        "Rate per 100,000" = "Rate")

        flu_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(scotland_by_sex_flag == 1) %>%
          mutate(AgeGroup = "All") %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
          dplyr::rename("Week ending" = "Date",
                        "Age group" = "AgeGroup",
                        "Rate per 100,000" = "Rate")

        flu_age_sex <- Respiratory_AllData %>%
          filter(FluOrNonFlu == flu_or_nonflu) %>%
          filter(scotland_by_age_sex_flag == 1) %>%
          select(Season, Date, AgeGroup, Sex, Rate) %>%
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
          make_table()

      })

    }
  )

}







