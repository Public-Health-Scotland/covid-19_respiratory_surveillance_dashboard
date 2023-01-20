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

cases_from_summary <- jumpToTabButtonServer(id="cases_from_summary",
                                            location="cases",
                                            parent = session)

hospital_admissions_from_summary <- jumpToTabButtonServer(id="hospital_admissions_from_summary",
                                                          location="hospital_admissions",
                                                          parent = session)

hospital_occupancy_from_summary <- jumpToTabButtonServer(id="hospital_occupancy_from_summary",
                                                          location="hospital_occupancy",
                                                          parent = session)

vaccines_from_summary <- jumpToTabButtonServer(id="vaccines_from_summary",
                                                         location="vaccines",
                                                         parent = session)

