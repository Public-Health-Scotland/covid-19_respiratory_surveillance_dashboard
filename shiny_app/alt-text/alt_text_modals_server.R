####################### Modals #######################

altTextServer <- function(id, title, content) {

  moduleServer(
    id,
    function(input, output, session) {

      modal <- modalDialog(
        h3(title),
        p(content),
        size = "l",
        easyClose = TRUE, fade=TRUE, footer = modalButton("Close (Esc)")
      )

      observeEvent(input$alttext, { showModal(modal) })

    }
  )

}

# To make a new alt text button create an alt text server object here and then
# add corresponding ui component where you want the button to appear

# e.g. corresponding ui for ons_cases_modal is altTextUI("ons_cases_modal")
#      in indicators/cases/cases_ui.R
ons_cases_modal <- altTextServer("ons_cases_modal",
                                 title = "Estimated COVID-19 infection rate",
                                 content = "This plot shows the ONS covid infection ...")


reported_cases_modal <- altTextServer("reported_cases_modal",
                                      title = "Reported COVID-19 cases",
                                      content = "This plot shows ...")

hospital_admissions_modal <- altTextServer("hospital_admissions_modal",
                                           title = "Daily number of COVID-19 hospital admissions",
                                           content = "This plot shows ... ")

hospital_admissions_simd_modal <- altTextServer("hospital_admissions_simd_modal",
                                           title = "Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)",
                                           content = "This plot shows ... ")

hospital_admissions_los_modal <- altTextServer("hospital_admissions_los_modal",
                                           title = "Length of stay of acute COVID-19 hospital admissions",
                                           content = "This plot shows ... ")

hospital_admissions_ethnicity_modal <- altTextServer("hospital_admissions_ethnicity_modal",
                                               title = "Admissions to hospital 'with' COVID-19 by ethnicity",
                                               content = "This plot shows ... ")

icu_admissions_modal <- altTextServer("icu_admissions_modal",
                                       title = "Daily number of COVID-19 ICU admissions",
                                       content = "This plot shows ... ")


