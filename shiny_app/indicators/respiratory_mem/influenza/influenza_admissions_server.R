
metadataButtonServer(id="respiratory_influenza_admissions",
                     panel="Respiratory infection activity",
                     parent = session)



# Recent weeks admissions

influenza_admissions_recent_week <- Influenza_admissions %>%
  tail(4) %>%
  #select(-Rate_per_100000) %>%
  pivot_wider(names_from = Flu_type_AB,
              values_from = admissions) %>%
  clean_names %>%
  mutate(influenza_total_admissions = influenza_a + influenza_b) %>%
  mutate(DateLastWeek = .$date_plot[1],
         DateThisWeek = .$date_plot[2],
         AdmissionsLastWeek = .$influenza_total_admissions[1],
         AdmissionsThisWeek = .$influenza_total_admissions[2],
         PercentageDifference = round((AdmissionsThisWeek/AdmissionsLastWeek - 1)*100, digits = 2)) %>%
  mutate(ChangeFactor = case_when(
    PercentageDifference < 0 ~ "Decrease",
    PercentageDifference > 0 ~ "Increase",
    TRUE                     ~ "No change")
  ) %>%
    select(DateLastWeek, DateThisWeek, AdmissionsLastWeek, AdmissionsThisWeek, PercentageDifference, ChangeFactor) %>%
    head(1)



altTextServer("influenza_mem_modal",
              title = "Influenza incidence rate per 100,000 population",
              content = tags$ul(tags$li("This is a plot showing the rate of influenza infection per 100,000 population in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "The first ISO week is the first week of the year (in January) and the 52nd ISO week is the last week of the year."),
                                tags$li("The y axis shows the rate of influenza infection per 100,000 population."),
                                tags$li(glue("There is a trace for each of the following seasons: ", seasons[1], ", ",
                                             seasons[2], ", ", seasons[3], ", ", seasons[4], ", ", seasons[5], ", ",
                                             seasons[6], ", and ", seasons[7], ".")),
                                tags$li(glue("Activity levels for influenza based on MEM thresholds are represented by different coloured panels on the plot. ",
                                        "The activity levels and MEM thresholds for influenza are: ",
                                        "Baseline (< ", influenza_low_threshold, "), ",
                                        "Low (", influenza_low_threshold, "-", influenza_moderate_threshold-0.01, "), ",
                                        "Moderate (", influenza_moderate_threshold, "-", influenza_high_threshold-0.01, "), ",
                                        "High (", influenza_high_threshold, "-", influenza_extraordinary_threshold-0.01, "), and ",
                                        "Extraordinary (>= ", influenza_extraordinary_threshold, ")."))))



# Influenza admissions table
output$influenza_admissions_table <- renderDataTable({
  Influenza_admissions %>%
    arrange(desc(date_plot)) %>%
    select(week, admissions) %>%
    group_by(week) %>%
    summarise(Admissions = sum(admissions)) %>%
    rename('ISO Week' = week) #%>%
    #make_table(add_separator_cols_2dp = c(3),
    #           filter_cols = c(1,2,4))
})


# Influenza MEM plot
output$influenza_mem_plot <- renderPlotly({
  Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen == "Influenza") %>%
    create_mem_linechart()

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



