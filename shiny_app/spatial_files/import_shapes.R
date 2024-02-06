#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RStudio Workbench is strictly for use by Public Health Scotland staff and     
# authorised users only, and is governed by the Acceptable Usage Policy https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_acceptable_use_policy.md.
#
# This is a shared resource and is hosted on a pay-as-you-go cloud computingdata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAABzElEQVR42u2Wy07CQBhGeRl3iF2Bz+DaRE0UNsYn0Z2vIE+hxLglMZq4IwYpV4G23JGrLS7GOTWsDEzbNMZFJ/l3c843l6bzx2L/aWhaaiehJTPxRPIysZe6DlIuKx24PIXuaqmDw+Ozm9u7e71QeHVKpbIIUrA4cOFU7vToJJOVkK3rFVEu/1SlUvVVaw4HLpxbd87R5HIPOlC1WhO1Wl3U6w23Go13T7WeD4sDF07cG4O5l2LxzQFC0my2RKvVFu22Icv0WIbLwOLAJZ2ruLZ/tXnH8qNgtUBITLMjOp2e6Hb7otcbeCrmwsDiwIUT99ZgJhqG5cL9/lAMh2MxGn2I8XjiqZgLA4sDF05lMKsEGAxGrmgymYnpdC5ms4WnYi4MLA5cOJXBHBGrBUQyny/FYvEplkvbUzEXBhYHLpzKYFbIUbFqBMhse+WrYGBx4MKpDObj4J5YMatH5DhfvgoGFgcunMpgvkyOiPta7zZIMCwOXDij4Cg4Cv6bYJ5F+V91wg42TUvxLMrHOp9/1MMOxrm1EaA9SacvspbVtcP6ZeLCqWz6aMxO0+fZp+cXdu4EfSRgceBSNnu/2lt5L4HbW1g/7W00ohHW+AYpkWmxvX/prAAAAABJRU5ErkJggg==
# platform.  Your usage will incur direct financial cost to Public Health
# Scotland.  As such, please ensure
#
#   1. that this session is appropriately sized with the minimum number of CPUs
#      and memory required for the size and scale of your analysis;
#   2. the code you write in this script is optimal and only writes out the
#      data required, nothing more.
#   3. you close this session when not in use; idle sessions still cost PHS
#      money!
#data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==
# For further guidance, please see https://github.com/Public-Health-Scotland/R-Resources/blob/master/posit_workbench_best_practice_with_r.md.
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#This is a sandbox file used to create the leaflet map in a suitable format#

library(sf)
library(sp)
library(leaflet)
# library(terra)
# library(raster)

# Specify the path to your shapefile (.shp) without the file extension

shapefile_path="/conf/C19_Test_and_Protect/Analyst Space/Iain (Analyst Space)/covid-19_respiratory_surveillance_dashboard/shiny_app/spatial_files/"

# import  polygons
#hb_polygons<-st_read(dsn=shapefile_path, layer="SG_NHS_HealthBoards_2019")


# Read the shapefile
HB_Polygons <- st_read(dsn = shapefile_path,layer="SG_NHS_HealthBoards_2019")
# Plot the original and simplified polygons
#plot(HB_Polygons, main = "Original Polygon", col = "blue")
# Specify a tolerance value for simplification
tolerance <- 500 # You can adjust this value based on your needs


# Simplify the polygon & edit HB code name for join
Simplified_HB_Polygons <- st_simplify(HB_Polygons, dTolerance = tolerance) %>% 
   rename(HB=HBCode) %>% 
   select(-HBName)
 

Intro_Pathogens_MEM_HB_Polygons<-left_join(Simplified_HB_Polygons, `Intro_Pathogens_MEM_HB `,
                                     by="HB") # %>% 
  # mutate(ActivityLevel = factor(ActivityLevel,
  #                          levels = c("Baseline","Low","Moderate" ,"High","Extraordinary")))  %>% 
 #  filter(Pathogen=="Mycoplasma Pneumoniae")


# Transforming to WGS84 (EPSG:4326)
Intro_Pathogens_MEM_HB_Polygons <- st_transform(Intro_Pathogens_MEM_HB_Polygons, crs = 4326)

#activity_levels <- c("Baseline", "Low", "Moderate", "High", "Extraordinary")

# Colours for thresholds
#activity_level_colours <- c("#01A148", "#FFDE17", "#F36523", "#ED1D24", "#7D4192")


leaflet(Intro_Pathogens_MEM_HB_Polygons) %>%
  setView(lng = -4.3, lat = 57.7, zoom = 5.25) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(weight = 1,smoothFactor = 0.5,fillColor = ~ActivityLevelColour,
              opacity = 0.6,
              fillOpacity = 0.6,
              color = "grey",
              dashArray = "0",
    popup = ~paste0("Season: ", Season, "<br>","Week number: ", ISOWeek, "<br>",
                    "(Week ending: </b>", format(WeekEnding, "%d %b %y"), ")<br>",
                    "NHS Health Board: ", HBName, "<br>",
                   "Rate: ", RatePer100000, "<br>","Activity level: ", ActivityLevel),
    label = ~paste0(ActivityLevel),
    labelOptions = labelOptions(noHide = FALSE, direction = "auto"),
    highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE) ) %>% 
    addLegend(position = "bottomright",colors = activity_level_colours,
              labels = activity_levels,
              title = ~paste0($pathogen_filter, " MEM Activity Level"),
              labFormat = labelFormat())

    
