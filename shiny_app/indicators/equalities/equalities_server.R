metadataButtonServer(id="equalities",
                     panel="Equalities",
                     parent = session)


#altText for hospital admissions
altTextServer("equalities_admission_modal",
              title = "Equalities admissions",
              content = tags$ul(tags$li("This is a plot of the percentage of hospital admissions by selected indicator (ethnic group or deprivation quintile)",
                                        "for the selected pathogen (COVID-19, Influenza or RSV)."),
                                tags$li("There are two drop downs above the chart, the left one allows you to select",
                                        "a pathogen for plotting, the right one allows you to select an indicator.",
                                        "The default selection is COVID-19 and ethnicity"),
                                tags$li("The x axis is the percentage of admissions"),
                                tags$li("The y axis is the groupings for the selected indicator"),
                                tags$li("The plot is a horizontal bar chart for each indicator grouping, where there",
                                        "are two bars that correspond to last and the current season for SIMD."),
                                tags$li("The ethnicity chart is showing data for the latest season.")
                               # tags$li("There is a blue bar which shows the percentage of hospital admissions for the latest season."),
                                #tags$li("There is a purple bar which shows the percentage of admissions for the current season.")
              )
)

#altText for cases
altTextServer("equalities_cases_modal",
              title = "Equalities cases",
              content = tags$ul(tags$li("This is a plot of the percentage of cases by selected indicator (ethnic group or deprivation quintile)",
                                        "for the selected pathogen (COVID-19, Influenza or RSV)."),
                                tags$li("There are two drop downs above the chart, the left one allows you to select",
                                        "a pathogen for plotting, the right one allows you to select an indicator.",
                                        "The default selection is COVID-19 and ethnicity"),
                                tags$li("The x axis is the percentage of cases"),
                                tags$li("The y axis is the groupings for the selected indicator"),
                                tags$li("The plot is a horizontal bar chart for each indicator grouping, where there",
                                        "are two bars that correspond to last and the current season for SIMD."),
                                tags$li("The ethnicity chart is showing data for the latest season.")
                              #  tags$li("There is a blue bar which shows the percentage of hospital admissions for the latest season."),
                               # tags$li("There is a purple bar which shows the percentage of admissions for the current season.")
              )
)

#plot title for hosp admissions
observeEvent(input$equalities_select_pathogen,{
  observeEvent(input$equalities_select_indicator,{
    
    pathogen_selection <- input$equalities_select_pathogen
    indicator_selection <- input$equalities_select_indicator
    
    if (input$equalities_select_pathogen %in% c("COVID-19", "RSV")) {
      pathogen_selection <- pathogen_selection
      
    }else{
      
      pathogen_selection <- tolower(pathogen_selection)
    }
    
    output$equalities_admission_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
                                                                " hospital admissions by ",
                                                                tolower(input$equalities_select_indicator)))})
    
    if (input$equalities_select_indicator == "Ethnicity") {
      indicator_selection <- tolower(indicator_selection)
      output$equalities_admission_plot_title <- renderUI({h2(glue("Rate of ",{pathogen_selection},
                                                                  " hospital admissions by ",
                                                                  {indicator_selection}))})
    }else{
      
      indicator_selection <- "deprivation quintile (SIMD)"
      output$equalities_admission_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
                                                                  " hospital admissions by ",
                                                                  {indicator_selection}))})
    }
    
   # output$equalities_admission_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
    #                                                            " hospital admissions by ",
     #                                                           {indicator_selection}))})
    
  })
})

#plot title for cases
observeEvent(input$equalities_select_pathogen,{
  observeEvent(input$equalities_select_indicator,{
    
    pathogen_selection <- input$equalities_select_pathogen
    indicator_selection <- input$equalities_select_indicator
    
    if (input$equalities_select_pathogen %in% c("COVID-19", "RSV")) {
      pathogen_selection <- pathogen_selection
      
    }else{
      
      pathogen_selection <- tolower(pathogen_selection)
    }
    
    output$equalities_cases_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
                                                                " cases by ",
                                                                tolower(input$equalities_select_indicator)))})
    
    if (input$equalities_select_indicator == "Ethnicity") {
      indicator_selection <- tolower(indicator_selection)
      output$equalities_cases_plot_title <- renderUI({h2(glue("Rate of ",{pathogen_selection},
                                                              " cases by ",
                                                              {indicator_selection}))})
      
    }else{
      
      indicator_selection <- "deprivation quintile (SIMD)"
      output$equalities_cases_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
                                                              " cases by ",
                                                              {indicator_selection}))})
      
    }
    
    # output$equalities_cases_plot_title <- renderUI({h2(glue("Percentage of ",{pathogen_selection},
    #                                                             " cases by ",
    #                                                             {indicator_selection}))})
    # 
  })
})

# Plots ----
#observeEvent(input$equalities_select_indicator | input$equalities_select_pathogen, {

#hosp admissions
output$equalities_admission_plot <- renderPlotly ({
  
  
  if(input$equalities_select_indicator == "Ethnicity"){
    
    Admissions_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen,
         Season == equality_seasons[2]) %>% #only showing latest season
         #    Season %in% equality_seasons) %>%
     
      make_equalities_admission_ethnicity_plot()
    
  } else {
    
    Admissions_Simd %>%
      filter(Pathogen == input$equalities_select_pathogen,
             Season %in% equality_seasons) %>%
      make_equalities_admission_simd_plot()
    
  }
  
})

#cases
output$equalities_cases_plot <- renderPlotly ({
  
  
  if(input$equalities_select_indicator == "Ethnicity"){
    
    Cases_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen,
             Season == equality_seasons[2]) %>% #only showing latest season
      #    Season %in% equality_seasons) %>%
      
      make_equalities_cases_ethnicity_plot()
    
  } else {
    
    Cases_Simd %>%
      filter(Pathogen == input$equalities_select_pathogen,
             Season %in% equality_seasons) %>%
      make_equalities_cases_simd_plot()
    
  }
  
})
#})

#Data tables ----

#admissions
output$equalities_admission_table <- renderDataTable({
  
  if(input$equalities_select_indicator == "Ethnicity"){
    
    Admissions_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen) %>%
      select(Season, Pathogen, EthnicGroup, Rate) %>%
      dplyr::rename('Ethnic Group' = EthnicGroup,
                    'Rate' = Rate) %>%
      arrange(desc(Season)) %>%
      make_table(add_separator_cols_2dp = 4)
  } else {
    
    Admissions_Simd %>%
      filter(Pathogen == input$equalities_select_pathogen) %>%
      select(Season, Pathogen, SIMD, Proportion) %>%
      dplyr::rename('Deprivation quintile' = SIMD,
                    'Percentage (%)' = Proportion) %>%
      arrange(desc(Season)) %>%
      make_table(add_separator_cols_2dp = 4)
  }
  
})

#cases
output$equalities_cases_table <- renderDataTable({
  
  if(input$equalities_select_indicator == "Ethnicity"){
    
    Cases_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen) %>%
      select(Season, Pathogen, EthnicGroup, Proportion) %>%
      dplyr::rename('Ethnic Group' = EthnicGroup,
                    'Percentage (%)' = Proportion) %>%
      arrange(desc(Season)) %>%
      make_table(add_separator_cols_2dp = 4)
  } else {
    
    Cases_Simd %>%
      filter(Pathogen == input$equalities_select_pathogen) %>%
      select(Season, Pathogen, SIMD, Proportion) %>%
      dplyr::rename('Deprivation quintile' = SIMD,
                    'Percentage (%)' = Proportion) %>%
      arrange(desc(Season)) %>%
      make_table(add_separator_cols_2dp = 4)
  }
  
})
