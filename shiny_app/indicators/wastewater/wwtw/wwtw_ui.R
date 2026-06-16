tagList(
  fluidRow(
    tags$head(
      tags$style(HTML("
      .control-label {
        color: black;
      }
    "))),
    h1("COVID-19 Wastewater Surveillance"),
   p("Data for individual Waste Water Treatment Works (WWTW) can be downloaded from the PHS Open Data platform ",
     tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
            "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website).", target="_blank"),
   
    p(strong("Due to the dynamic nature of the data, reported figures may be subject to change in future releases."))  )
)# taglist
)#fluid row 