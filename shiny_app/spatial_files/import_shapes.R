#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RStudio Workbench is strictly for use by Public Health Scotland staff and     
# authorised users only, and is governed by the Acceptable Usage Policy https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md.
#
# This is a shared resource and is hosted on a pay-as-you-go cloud computing
# platform.  Your usage will incur direct financial cost to Public Health
# Scotland.  As such, please ensure
#
#   1. that this session is appropriately sized with the minimum number of CPUs
#      and memory required for the size and scale of your analysis;
#   2. the code you write in this script is optimal and only writes out the
#      data required, nothing more.
#   3. you close this session when not in use; idle sessions still cost PHS
#      money!
#
# For further guidance, please see https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Specify the path to your shapefile (.shp) without the file extension

Shapefile_path="/conf/C19_Test_and_Protect/Analyst Space/Iain (Analyst Space)/covid-19_respiratory_surveillance_dashboard/shiny_app/spatial_files/"

# import  polygons
#hb_polygons<-st_read(dsn=shapefile_path, layer="SG_NHS_HealthBoards_2019")


# Read the shapefile
HB_Polygons <- st_read(dsn = shapefile_path,layer="SG_NHS_HealthBoards_2019")
# Plot the original and simplified polygons
plot(HB_Polygons, main = "Original Polygon", col = "blue")
# Specify a tolerance value for simplification
tolerance <- 500 # You can adjust this value based on your needs


# Simplify the polygon
Simplified_HB_Polygons <- st_simplify(HB_Polygons, dTolerance = tolerance) %>% 
  rename(HB=HBCode) %>% 
  select(-HBName)

plot(Simplified_HB_Polygons , col = "red")


# take hb mems and filter to last week
Intro_Pathogens_MEM_HB <-Respiratory_Pathogens_MEM_HB %>% 
  filter(WeekEnding==max(WeekEnding))


Intro_Pathogens_MEM_HB_Polygons<-left_join(Simplified_HB_Polygons, Intro_Pathogens_MEM_HB,
                                     by="HB")



plot(Intro_Pathogens_MEM_HB_Polygons)

Intro_Pathogens_MEM_HB_Polygons%<>%
  filter(Pathogen=="Influenza")

# Transforming to WGS84 (EPSG:4326)
Intro_Pathogens_MEM_HB_Polygons <- st_transform(Intro_Pathogens_MEM_HB_Polygons, crs = 4326)


leaflet(Intro_Pathogens_MEM_HB_Polygons ) %>%
  setView(lng = -2, lat = 56.8, zoom = 6.25) %>% # zoom 5.25 to include Shetland 6.25 mainland Scot
  addTiles() %>% 
  addPolygons(weight = 1, smoothFactor = 0.5,
              fillColor =activity_level_colours,
              opacity = 0.5, fillOpacity = 0.7,
              color = "white",
              dashArray = "5",
              popup = labels,
              highlightOptions =  highlightOptions(color = "white", weight = 2,
                                                   bringToFront = TRUE),
              layerId = ~code) #%>%
  # addLegend("bottomright", pal = pal, values = ~measure_value,
  #           title = paste0("Percent of Employees (%)", "<br> in ", input$employees_living_wage_cw_year),
  #           labFormat = labelFormat(suffix  = "%"),
  #           opacity = 1
  #)

# HealthBoardOfTreatment_polygons<-simplified_hb_polygons %>% 
#   #mutate(HealthBoardOfTreatment=paste("NHS ",HBName)) %>% 
#   mutate(HealthBoardOfTreatment = recode(HBName,
#                               "Ayrshire and Arran"= "NHS Ayrshire and Arran",
#                               "Borders"= "NHS Borders",
#                               "Dumfries and Galloway"= "NHS Dumfries and Galloway",
#                               "Fife"= "NHS Fife",
#                               "Forth Valley"= "NHS Forth Valley",
#                               "Grampian" = "NHS Grampian",
#                               "Greater Glasgow and Clyde" = "NHS Greater Glasgow and Clyde",
#                               "Highland"= "NHS Highland",
#                               "Lanarkshire"= "NHS Lanarkshire",
#                               "Lothian"= "NHS Lothian",
#                               "Orkney" = "NHS Orkney",
#                               "Shetland"= "NHS Shetland",
#                               "Tayside" = "NHS Tayside",
#                               "Western Isles"= "NHS Western Isles"))
#                               
# 
# 
# Admissions_HB_only_3wks<-Admissions_HB_3wks %>% 
#   filter(HealthBoardOfTreatment!="Scotland"& HealthBoardOfTreatment!="Golden Jubilee National Hospital")
# 
# Admission_HB_3wks_Polygon<-left_join(HealthBoardOfTreatment_polygons, Admissions_HB_only_3wks,
#                                      by="HealthBoardOfTreatment")
# 
# 
# plot(Admission_HB_3wks_Polygon)
# 
# #### scotland only
# 
# AdmissionsScotland_3wks<-Admissions_HB_3wks %>% 
#   filter(HealthBoardOfTreatment=="Scotland")
# 
# 
# # Union the simplified polygons
# scot_one_polygon <- st_union(HealthBoardOfTreatment_polygons, by = "HealthBoardOfTreatment")
# 
# scot_polygons <-scot_one_polygon %>%
#   mutate(code="S9200003",
#          HealthBoardOfTreatment="Scotland")
# # Plot the unioned polygons in green
# plot(scot_one_polygon, col = "green")
# 
# 
# 
# 
# Admission_Scot_3wks_Polygon<-left_join(scot_one_polygon , dmissions_Scot_only_3wks,
#                                      by="HealthBoardOfTreatment")
# 
# 
# 
# 
# # Union polygons based on a grouping variable
# scot_one_polygon <- st_union(HealthBoardOfTreatment_polygons, by = "HealthBoardOfTreatment")

# Calculate summary statistics (e.g., sum of an attribute) using dplyr
# summary_df <- HealthBoardOfTreatment_polygons %>%
#   group_by(HealthBoardOfTreatment) %>%
#   summarize(SumAttribute = sum(AttributeToSum))
# 
# # Merge the summary data frame with the unioned geometry
# final_df <- st_sf(scot_one_polygon, summary_df)
# 
# # Plot the result
# plot(final_df)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# ca <- readOGR(dsn = paste0("/conf/linkage/output/lookups/Unicode/Geography/Shapefiles/", "Council Area 2019"),
#               layer = "pub_las")
# ca@data <- ca@data %>% select(local_auth, code) #
# 
# 
# 
# hb_polygons_v2<- hb_polygons %>%
#   clean_names() %>%
#   plot()
