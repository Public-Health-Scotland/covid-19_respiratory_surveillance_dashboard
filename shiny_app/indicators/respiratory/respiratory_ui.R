
tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory"),
           linebreaks(1),
           h1("Respiratory infection activity (excluding COVID-19)"),
           p("*Please note that 'non-influenza' refers to all respiratory",
             " infections excluding influenza and COVID-19"),
           linebreaks(1)
           ), # fluidRow

  fluidRow(width = 12,
           tabBox(width = NULL,
                  type = "pills",

                  ###### FLU PANEL #####
                  respiratoryUI("flu"),
                  ###### NON FLU PANEL #####
                  respiratoryUI("nonflu")

           ) # tabbox
        ), # fluidrow

  # Padding out the bottom of the page
  fluidRow(
    width=12, linebreaks(5))

)
