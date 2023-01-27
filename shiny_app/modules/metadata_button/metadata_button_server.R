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


