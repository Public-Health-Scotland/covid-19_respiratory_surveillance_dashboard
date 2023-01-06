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



