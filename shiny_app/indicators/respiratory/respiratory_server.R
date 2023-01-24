########## FLU -----

# headline figures

output$respiratory_flu_headline_figures_subtype <- renderText ({

  input$respiratory_flu_headline_subtype

})

output$respiratory_flu_headline_figures_subtype_count <- renderValueBox ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
    filter(Breakdown == input$respiratory_flu_headline_subtype) %>%
    .$Count

  valueBox(value = organism_summary_total,
           subtitle = glue("of {input$respiratory_flu_headline_subtype} influenza cases in Scotland during week",
                           " {this_week_iso} (beginning {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                           .$DateThisWeek %>% format('%d %b %y')})"),
           color = "teal",
           icon = icon_no_warning_fn("virus"),
           width = NULL)

})

output$respiratory_flu_headline_figures_healthboard_count <- renderValueBox ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Healthboard_Total" & FluOrNonFlu == "flu") %>%
    filter(phsmethods::match_area(Breakdown) == input$respiratory_flu_headline_healthboard) %>%
    .$Count

  valueBox(value = organism_summary_total,
           subtitle = glue("influenza cases in {input$respiratory_flu_headline_healthboard} during week",
                          " {this_week_iso} (beginning {Respiratory_Summary_Totals %>%
                             filter(FluOrNonFlu == 'flu') %>%
                             .$DateThisWeek %>% format('%d %b %y')})"),
           color = "teal",
           icon = icon_no_warning_fn("virus"),
           width = NULL)

})

# selecting input for seeing rate or number for plots
# only show rates if healthboards are there but can show number of cases for scotland
# Update dataset choices based off indicator choice
observeEvent(input$respiratory_flu_select_healthboard,
             {

               if(input$respiratory_flu_select_healthboard == "Scotland"){

                 updatePickerInput(session, inputId = "respiratory_flu_y_axis_plots",
                                   label = "Select whether you would like to see flu rates or total number of cases",
                                   choices = c("Number of cases", "Rate per 100,000"),
                                   selected = "Number of cases"
                 )

               } else {

                 updatePickerInput(session, inputId = "respiratory_flu_y_axis_plots",
                                   label = "Select whether you would like to see flu rates or total number of cases",
                                   choices = c("Rate per 100,000"),
                                   selected = "Rate per 100,000"

                 )

               }

             }
)

observeEvent(input$respiratory_flu_season,
             {
               updatePickerInput(session, inputId = "respiratory_flu_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_flu_season) %>% .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_flu_season) %>% .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)


# make trend over time plot. Plot shows the rate/number of flu cases by subtype over time for the whole dataset.
output$respiratory_flu_over_time_plot <- renderPlotly({

  Respiratory_AllData %>%
    filter_over_time_plot_function(healthboard = input$respiratory_flu_select_healthboard) %>%
    filter(FluOrNonFlu == "flu") %>%
    filter(Organism != "Total" & Organism != "Influenza - Type A (any subtype)") %>%
    # filter(date >= input$slider_date[1] & date <= input$slider_date[2]) %>%
    select_y_axis(., yaxis = input$respiratory_flu_y_axis_plots) %>%
    make_respiratory_trend_over_time_plot(., y_axis_title = input$respiratory_flu_y_axis_plots)

})

# plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
output$respiratory_flu_by_season_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    select_y_axis(., yaxis = input$respiratory_flu_y_axis_plots) %>%
    filter_by_organism(., organism = input$respiratory_select_flu_subtype,
                       healthboard = input$respiratory_flu_select_healthboard) %>%
    make_respiratory_trend_by_season_plot_function(., y_axis_title = input$respiratory_flu_y_axis_plots)

})

# plot that shows the breakdown by age/sex/age and sex
output$respiratory_flu_age_sex_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "flu") %>%
    filter_by_sex_age(., season = input$respiratory_flu_season,
                      date = {input$respiratory_flu_date %>% as.Date(format="%d %b %y")},
                      breakdown = input$respiratory_flu_select_age_sex_breakdown) %>%
    make_age_sex_plot(., breakdown = input$respiratory_flu_select_age_sex_breakdown)

})


####### NON FLU -----

# headline figures

output$respiratory_nonflu_headline_figures_subtype <- renderText ({

  input$respiratory_nonflu_headline_subtype

})

output$respiratory_nonflu_headline_figures_subtype_count <- renderText ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Scotland_by_Organism_Total") %>%
    filter(Breakdown == input$respiratory_nonflu_headline_subtype)

  organism_summary_total$Count

})

output$respiratory_nonflu_headline_figures_healthboard_count <- renderText ({

  organism_summary_total <- Respiratory_Summary %>%
    filter(SummaryMeasure == "Healthboard_Total" & FluOrNonFlu == "nonflu") %>%
    filter(Breakdown == input$respiratory_nonflu_headline_healthboard)

  organism_summary_total$Count

})

# selecting input for seeing rate or number for plots
# only show rates if healthboards are there but can show number of cases for scotland
# Update dataset choices based off indicator choice
observeEvent(input$respiratory_nonflu_select_healthboard,
             {

               if(input$respiratory_nonflu_select_healthboard == "Scotland"){

                 updatePickerInput(session, inputId = "respiratory_nonflu_y_axis_plots",
                                   label = "Select whether you would like to see flu rates or total number of cases",
                                   choices = c("Number of cases", "Rate per 100,000"),
                                   selected = "Number of cases"
                 )

               } else {

                 updatePickerInput(session, inputId = "respiratory_nonflu_y_axis_plots",
                                   label = "Select whether you would like to see flu rates or total number of cases",
                                   choices = c("Rate per 100,000"),
                                   selected = "Rate per 100,000"

                 )

               }

             }
)

observeEvent(input$respiratory_nonflu_season,
             {
               updatePickerInput(session, inputId = "respiratory_nonflu_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_nonflu_season) %>% .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_nonflu_season) %>% .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)

# make trend over time plot. Plot shows the rate/number of flu cases by subtype over time for the whole dataset.
output$respiratory_nonflu_over_time_plot <- renderPlotly({

  Respiratory_AllData %>%
    filter_over_time_plot_function(healthboard = input$respiratory_nonflu_select_healthboard) %>%
    filter(FluOrNonFlu == "nonflu") %>%
    filter(Organism != "Total") %>%
    # filter(date >= input$slider_date[1] & date <= input$slider_date[2]) %>%
    select_y_axis(., yaxis = input$respiratory_nonflu_y_axis_plots) %>%
    make_respiratory_trend_over_time_plot(., y_axis_title = input$respiratory_nonflu_y_axis_plots)

})

# plot showing the number/rate of flu cases by season. Can filter by organism selected by the user
output$respiratory_nonflu_by_season_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "nonflu") %>%
    select_y_axis(., yaxis = input$respiratory_nonflu_y_axis_plots) %>%
    filter_by_organism(., organism = input$respiratory_select_nonflu_subtype, healthboard = input$respiratory_nonflu_select_healthboard) %>%
    make_respiratory_trend_by_season_plot_function(., y_axis_title = input$respiratory_nonflu_y_axis_plots)

})

# plot that shows the breakdown by age/sex/age and sex
output$respiratory_nonflu_age_sex_plot = renderPlotly({

  Respiratory_AllData %>%
    filter(FluOrNonFlu == "nonflu") %>%
    filter_by_sex_age(., season = input$respiratory_nonflu_season,
                      date = {input$respiratory_nonflu_date %>% as.Date(format="%d %b %y")},
                      breakdown = input$respiratory_nonflu_select_age_sex_breakdown) %>%
    make_age_sex_plot(., breakdown = input$respiratory_nonflu_select_age_sex_breakdown)

})







