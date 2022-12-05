# Data download choices

cases_download_choices <- list(
  "Daily COVID-19 reported cases" = Cases,
  "ONS infection survey cases estimates" = ONS
  )
hospital_admissions_download_choices <- list(
  "Daily COVID-19 hospital admissions" = Admissions,
  "Weekly COVID-19 hospital admissions by age group" = Admissions_AgeBD,
  "Length of stay of COVID-19 hospital admissions" = Length_of_Stay,
  "Daily COVID-19 admissions to ICU" = ICU,
  "Quarterly COVID-19 hospital admissions by ethnicity" = Ethnicity #,
 # "Weekly hospital admissions by SIMD" = SIMD_trend
                                          )
hospital_occupancy_download_choices <- list(

)
vaccines_download_choices <- list(
  "Monthly vaccines administered and wasted" = Vaccine_Wastage,
  "Reason for vaccine wastage in latest month" = Vaccine_Wastage_Reason
)

choices_list <- list("COVID-19 cases" = names(cases_download_choices),
                     "COVID-19 hospital admissions" = names(hospital_admissions_download_choices),
                     "COVID-19 hospital occupancy" = names(hospital_occupancy_download_choices),
                     "Vaccine wastage" = names(vaccines_download_choices))

all_data_list <- Reduce(append, list(cases_download_choices, hospital_admissions_download_choices,
                                     hospital_occupancy_download_choices, vaccines_download_choices))

# Update dataset choices based off indicator choice
observeEvent(input$download_indicator,
             {

               updatePickerInput(session, inputId = "download_dataset",
                                 choices = choices_list[[input$download_indicator]]
                                 )
             })

# Pick chosen dataset
chosen_dataset <- reactive({

  all_data_list[[input$download_dataset]]

})


# Download button
output$data_download_output <- downloadHandler(
  filename = function(){
    if(input$download_filetype == ".csv"){
      glue("{input$download_indicator}.csv")
    } else if (input$download_filetype == ".xlsx"){
      glue("{input$download_indicator}.xlsx")
    } else {
      "invalid"
    }
  },
  content = function(file) {

    if(input$download_filetype == ".csv"){
      write.csv(chosen_dataset(),
                file,
                row.names=FALSE)
    } else if (input$download_filetype == ".xlsx"){
      openxlsx::write.xlsx(chosen_dataset(), file)
    } else {
      validate(TRUE, "Invalid download file type selected")
    }

  })

output$data_download_summary <- renderPrint({
  chosen_dataset() %>% summary()
})

output$data_download_table <- renderDataTable({
  chosen_dataset() %>% head(10) %>% make_table()
})








