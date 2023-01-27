
tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory"),
           h1("Other respiratory illnesses"),
           p("This is the epidemiological information on seasonal respiratory infection activity in Scotland (excluding COVID-19). "),
           linebreaks(2)
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
