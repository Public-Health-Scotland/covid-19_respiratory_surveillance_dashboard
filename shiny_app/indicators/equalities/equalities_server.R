
metadataButtonServer(id="equalities",
                     panel="Equalities",
                     parent = session)



altTextServer("equalities_admission_modal",
              title = "Equalities admissions",
              content = tags$ul(tags$li("This is a plot of the percentage of hospital admissions by selected indicator (ethnic group or deprivation quintile)",
                                        "for the selected pathogen (COVID-19, influenza or RSV)."),
                                tags$li("There is two drop downs above the chart, the left one allows you to select",
                                        "a pathogen for plotting, the right one allows you to select an indicator.",
                                        "The default selection is COVID-19 and ethnic group"),
                                tags$li("The x axis is the percentage of admissions"),
                                tags$li("The y axis is the groupings for the selected indicator"),
                                tags$li("The plot is a horizontal bar chart for each indicator grouping, where there",
                                        "are two bars that correspond to last and the current season."),
                                tags$li("There is a blue bar which shows the percentage of hospital admissions for the latest season."),
                                tags$li("There is a purple bar which shows the percentage of admissions for the current season.")
              )
)


output$equalities_admission_plot_title <- renderUI({h2(glue("Pecentage of ",tolower(input$equalities_select_pathogen),
                                                            " hospital admissions by ",
                                                        tolower(input$equalities_select_indicator)))})


# Plots ----
#observeEvent(input$equalities_select_indicator | input$equalities_select_pathogen, {

output$equalities_admission_plot <- renderPlotly ({


  if(input$equalities_select_indicator == "Ethnicity"){

    Admissions_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen,
             Season %in% equality_seasons) %>%
      make_equalities_admission_ethnicity_plot()

  } else {

    Admissions_Simd %>%
      filter(Pathogen == input$equalities_select_pathogen,
             Season %in% equality_seasons) %>%
      make_equalities_admission_simd_plot()

  }

})

#})

#Data tables ----

output$equalities_admission_table <- renderDataTable({

  if(input$equalities_select_indicator == "Ethnicity"){

    Admissions_Ethnicity %>%
      filter(Pathogen == input$equalities_select_pathogen) %>%
      select(Season, Pathogen, EthnicGroup, Proportion) %>%
      dplyr::rename('Ethnic Group' = EthnicGroup,
                    'Percentage (%)' = Proportion) %>%
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


