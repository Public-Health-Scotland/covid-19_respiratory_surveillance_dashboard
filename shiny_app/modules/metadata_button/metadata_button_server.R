#### Metadata button server ----


metadataButtonServer <- function(id, panel, parent){

  moduleServer(id,
               function(input, output, session){

                 observeEvent(input$jump_to_metadata,
                              {
                                updateTabsetPanel(session = parent, "intabset", selected = "metadata")
                                updateCollapse(session = parent, "notes_collapse", open = panel)

                                })

               })


}

metadataButtonServer(id="cases",
                    panel="Cases",
                    parent = session)

metadataButtonServer(id="hospital_admissions",
                    panel="Hospital admissions",
                    parent = session)

metadataButtonServer(id="hospital_occupancy",
                     panel="Hospital occupancy",
                     parent = session)

metadataButtonServer(id="respiratory",
                    panel="Respiratory",
                    parent = session)

metadataButtonServer(id="download",
                     panel="Cases",
                     parent = session)

