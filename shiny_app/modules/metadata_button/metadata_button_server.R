#### Metadata button server ----


metadataButtonServer <- function(id, panel, parent){

  moduleServer(id,
               function(input, output, session){

                 observeEvent(input$jump_to_metadata,
                              {updateTabsetPanel(session = parent, "intabset", selected = "metadata")
                               updateCollapse(session = parent, "notes_collapse", open = panel)
                                })

               })


}

cases_metadata_button <- metadataButtonServer(id="cases",
                                              panel="Cases",
                                              parent = session)

hospital_admissions_metadata_button <- metadataButtonServer(id="hospital_admissions",
                                                            panel="Hospital admissions",
                                                            parent = session)

hospital_occupancy_metadata_button <- metadataButtonServer(id="hospital_occupancy",
                                                           panel="Hospital occupancy",
                                                           parent = session)

vaccines_metadata_button <- metadataButtonServer(id="vaccines",
                                              panel="Vaccine wastage",
                                              parent = session)


download_metadata_button <- metadataButtonServer(id="download",
                                                 panel="Cases",
                                                 parent = session)

