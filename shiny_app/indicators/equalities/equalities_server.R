
altTextServer("equalities_admission_modal",
              title = "Equalities admissions",
              content = tags$ul(tags$li("This is a plot of the number of reported COVID-19 cases each week."),
                                tags$li("The x axis is the week ending date"),
                                tags$li("The y axis is the number of reported cases"),
                                tags$li("There is a navy blue trace which shows the number of reported cases each week."),
                                tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                        "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                        "the second marks the change in testing policy on 1 May 2022.")
              )
)


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


