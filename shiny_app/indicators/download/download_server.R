# Data download choices

metadataButtonServer(id="download",
                     panel="Cases",
                     parent = session)


output$download_open_data <- renderUI({
  tagList(#h3("Open data"),
          tags$a(img(src = "open-data-logo.png", height = 30,
                     alt ="Go to Scottish Health and Social Care Open Data platform (external site)"),
                 href = "https://www.opendata.nhs.scot",
                 target = "_blank"),
          p(""),
          p("The ", tags$a(href="https://www.opendata.nhs.scot",
                           "Scottish Health and Social Care Open Data platform (external website)", target="_blank"),
            "gives access to statistics and reference data for information and re-use. ",
            "The platform is managed by Public Health Scotland. ",
            "Data is released under the Open Government Licence."),
          p("You can download viral respiratory disease data presented in this dashboard from the ",
            tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
                   "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website)", target="_blank"),
            ".")
  ) # tagList
  
})


