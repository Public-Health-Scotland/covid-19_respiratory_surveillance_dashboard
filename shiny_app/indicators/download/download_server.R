# Data download choices

# copy & rename the the weekly hospital occcupancy dataframe (keeps the original
# for other purposes) and renames variables to be consistent with Open Data
Occupancy_Weekly_Hospital<-Occupancy_Weekly_Hospital_HB %>%
  filter(HealthBoardQF== "d") %>% #filters for Scotland values
  select(WeekEnding=WeekEnding_od,
         HealthBoardOfTreatment=HealthBoardName,
         HealthBoardOfTreatmentQF=HealthBoardQF,
         InpatientsAsAtLastSunday=HospitalOccupancy,
         InpatientsAsAtLastSundayQF=HospitalOccupancyQF,
         InpatientsSevenDayAverage= SevenDayAverage,
         InpatientsSevenDayAverageQF=SevenDayAverageQF)


metadataButtonServer(id="download",
                     panel="Cases",
                     parent = session)


cases_download_choices <- list(
  "Weekly COVID-19 reported cases" = "Cases_Weekly",
  "Seven day average of wastewater sample" = "Wastewater"
  )
hospital_admissions_download_choices <- list(
  "Weekly COVID-19 hospital admissions" = "Admissions_Weekly",
  "Weekly COVID-19 hospital admissions by age group" = "Admissions_AgeBD",
  "Length of stay of COVID-19 hospital admissions" = "Length_of_Stay",
  #"Daily COVID-19 admissions to ICU" = "ICU",
  "Weekly COVID-19 admissions to ICU" = "ICU_weekly",
  "Quarterly COVID-19 hospital admissions by ethnicity" = "Ethnicity",
  "Weekly hospital admissions by SIMD" = "Admissions_SimdTrend" #, 
  # added rsv and flu admissions, but not used at this time. 
  # Will need to add dictionaries if including these 2 files
  # "Weekly influenza hospital admissions" = "Influenza_admissions",
  # "Weekly RSV hospital admissions" = "RSV_admissions"
                                          )
hospital_occupancy_download_choices <- list(
  "Weekly COVID-19 hospital occupancy" = "Occupancy_Weekly_Hospital",
  "Daily COVID-19 ICU occupancy" = "Occupancy_ICU"
)
vaccines_download_choices <- list(
  "Monthly vaccines administered and wasted" = "Vaccine_Wastage",
  "Reason for vaccine wastage in latest month" = "Vaccine_Wastage_Reason"
)
respiratory_download_choices <- list(
  "Weekly number of cases by pathogen and flu type in Scotland" = "Respiratory_Scot",
  "Weekly rate per 100,000 by pathogen, flu type and NHS Health Board" = "Respiratory_HB",
  "Weekly rate per 100,000 by pathogen, flu type and age group" = "Respiratory_Age",
  "Weekly rate per 100,000 by pathogen, flu type and sex" = "Respiratory_Sex",
  "Weekly rate per 100,000 by pathogen, flu type, age group and sex" = "Respiratory_Age_Sex"
)

choices_list <- list("COVID-19 cases" = names(cases_download_choices),
                     "Acute COVID-19 hospital admissions" = names(hospital_admissions_download_choices),
                     "COVID-19 hospital occupancy" = names(hospital_occupancy_download_choices),
                     "Respiratory infection activity" = names(respiratory_download_choices),
                     "Vaccine wastage" = names(vaccines_download_choices))

all_data_list <- Reduce(append, list(cases_download_choices, hospital_admissions_download_choices,
                                     hospital_occupancy_download_choices, vaccines_download_choices,
                                     respiratory_download_choices))

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
  file = function(){
    if(input$download_filetype == ".csv"){
      glue("{input$download_dataset}.csv")
    } else if (input$download_filetype == ".xlsx"){
      glue("{input$download_dataset}.xlsx")
    } else {
      "invalid"
    }
  },
  content = function(file) {

    if(input$download_filetype == ".csv"){
      write.csv({chosen_dataset() %>% get()},
                file,
                row.names=FALSE, na="")
    } else if (input$download_filetype == ".xlsx"){
      openxlsx::write.xlsx({chosen_dataset() %>% get()}, file)
    } else {
      shiny::validate(TRUE, "Invalid download file type selected")
    }

  })

output$data_download_summary_table <- renderDataTable({
  chosen_dataset() %>%
    get_data_dictionary() %>%
    make_table()
})

output$data_download_table <- renderDataTable({
  chosen_dataset() %>% get() %>% head(10) %>% make_table()
})


output$data_download_open_data_statement <- renderUI({

  ifelse(input$download_indicator %in% c("COVID-19 cases",
                                         "Acute COVID-19 hospital admissions",
                                         "COVID-19 hospital occupancy",
                                         "Respiratory infection activity",
                                         "Vaccine wastage"),
         tagList(p("This dataset follows the ", tags$a(href="https://www.opendata.nhs.scot/uploads/admin/PHS-Open-Data-Standards-Version-1.0.pdf",
                                  "open data standards (external website)",
                                  target="_blank"),
                   "set out by Public Health Scotland.")),
         tagList(p("")))
})





