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

jumpToTabButtonServer(id="cases_from_summary",
                      location="cases",
                      parent = session)

jumpToTabButtonServer(id="hospital_admissions_from_summary",
                      location="hospital_admissions",
                      parent = session)

jumpToTabButtonServer(id="hospital_occupancy_from_summary",
                      location="hospital_occupancy",
                      parent = session)

jumpToTabButtonServer(id="respiratory_from_summary",
                      location="respiratory",
                      parent = session)

