#create map

metadataButtonServer(id="maps_wastewater_metadata",
                     panel="Wastewater",
                     parent = session)

output$wastewater_spatial_map <- renderLeaflet({
  # select week to display 
  filtered_data = HB_Polygons %>% 
    filter(End==input$selected_week)
  
  WW_HB_Polygons <- create_wastewater_hb_map(hb_data= filtered_data, site_data=site_lat_long_sf)
  
})
#data for the data table
site_data = site_lat_long %>% 
  select(health_board,site_name)


output$sites_table = renderDataTable({
  #select health board to display
  filtered_data <- site_lat_long %>% 
    filter(health_board==input$selected_nhs_board)
  datatable(
    filtered_data %>% 
      select(health_board,site_name) %>% #select the columns needed
      dplyr::rename('Wastewater Treatment Work' = site_name) %>% #rename the columns
      dplyr::rename('NHS Health Board' = health_board),
    rownames = FALSE,
    options = list(
      dom = 't',        # Only show the table body
      paging = FALSE,   # Disable pagination
      searching = FALSE,# Disable search box
      ordering = FALSE,  # Disable sorting arrows
      columnDefs = list(
        list(width = "50%", class = "dt-right", targets = 1)
      )
    )
  )
  
})