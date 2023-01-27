## Server for buttons which jump to a specific tab

jumpToTabButtonServer <- function(id,
                                  location, # e.g. hospital_admissions
                                  parent){

  moduleServer(id,
               function(input, output, session){

                 observeEvent(input$jump_to_tab,
                              {updateTabsetPanel(session = parent, "intabset", selected = location)
                              })

               })


}

