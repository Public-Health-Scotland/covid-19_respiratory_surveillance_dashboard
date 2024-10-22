tagList(
  
  fluidRow(metadataButtonUI("maps_wastewater_metadata"),
           h1("COVID-19 Wastewater Surveillance"),
           p("Wastewater-based surveillance is a promising low cost means to enhance monitoring of ",
             "the presence and epidemiological activity of pathogens such as SARS-CoV-2 in the ",
             "Scottish community that does not rely on an individual accessing healthcare for testing ",
             "when symptomatic. This programme has been running in Scotland since June 2020 for ",
             "Covid-19, when it became the country’s first pathogen-specific surveillance system of ",
             "this kind. Data is available at National, NHS Health Board and Local Authority areas ",
             "based on location of Wastewater Treatment Works (WWTW). "),
           linebreaks(1),
           selectInput("selected_week","Use the drop-down menu to select week ending of interest.",
                       choices=sort(unique(HB_Polygons$End),decreasing = T),
                       selected=sort(unique(HB_Polygons$End),decreasing = T)[1]),
           width=12,
           box("NHS Health Board COVID-19 wastewater viral RNA (Mgc/p/d)",withNavySpinner(leafletOutput("wastewater_spatial_map",width = "100%",height="750px"))),
           linebreaks(35),
           selectInput("selected_nhs_board","Select NHS Health Board of interest to see wastewater treatment works within area.",
                       choices = sort(unique(site_lat_long$health_board)),
                       selected = sort(unique(site_lat_long$health_board))[1]),
           dataTableOutput("sites_table",width="700px")
           
  )#fluidRow
)#tagList
