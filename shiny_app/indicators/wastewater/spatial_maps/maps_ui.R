tagList(
  
  fluidRow(selectInput("selected_week","Week Ending Date: ",
                       choices=sort(unique(HB_Polygons$End),decreasing = T),
                       selected=sort(unique(HB_Polygons$End),decreasing = T)[1]),
           width=12,
           box("NHS Health Board COVID-19 wastewater viral RNA (Mgc/p/d)",withNavySpinner(leafletOutput("wastewater_spatial_map",width = "100%",height="750px"))),
           linebreaks(35),
           selectInput("selected_nhs_board","Sites that come under NHS Health Board: ",
                       choices = sort(unique(site_lat_long$health_board)),
                       selected = sort(unique(site_lat_long$health_board))[1]),
           dataTableOutput("sites_table",width="700px")
           
  )#fluidRow
)#tagList
