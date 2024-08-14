####################### Setup #######################

# You need to make sure you have all these packages installed. Note that we can't include
# a conditional install in the code due to a known rsconnect issue
# (https://github.com/rstudio/rsconnect/issues/88)
library(shiny)
library(shinycssloaders)
library(dplyr)
library(magrittr)
library(plotly)
library(phsstyles)
library(DT)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(glue)
library(stringr)
library(janitor)
library(fontawesome)
library(shinymanager)
library(gotop)
library(R.utils)
library(lubridate)
library(png)
library(tidyr)

# Load core functions ----
source("functions/core_functions.R")

## Plotting ----
# Style of x and y axis
xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14),
                    showline = TRUE)

yaxis_plots <- list(title = FALSE, rangemode="tozero", size = 4,
                    fixedrange = FALSE, tickfont = list(size=14),
                    titlefont = list(size=14), tickformat = ",d")

navy <- "#010068"

# Buttons to remove from plotly plots
bttn_remove <-  list(
                     'select2d',
                     'lasso2d',
                     'zoomIn2d',
                     'zoomOut2d',
                     'autoScale2d',
                     'toggleSpikelines',
                     'hoverCompareCartesian',
                     'hoverClosestCartesian'
                  )

home_list<- c("About"= "about",
              "Using the dashboard"= "use",
              "Contact us"= "contact",
              "Accessibility"= "accessibility",
              "Open data" = "open_data")

# Go to top button
gotop::use_gotop(
  src = "fas fa-chevron-circle-up", # css class from Font Awesome
  color = navy, # color
  opacity = 0.8, # transparency
  width = 50, # size
  appear = 80 # number of pixels before appearance
)

# LOAD IN DATA ----

# Load in data to app_data
# Find all rds files in shiny_app/data
rds_files <- list.files(path="data/", pattern="*.rds")
for (rds in rds_files){
  load_rds_file(rds)
}

# If on shinyapps.io config::get()$online is TRUE, else FALSE
if (config::get()$online){
  # Whether to password protect the app - set in deployment script
  # TRUE if deployed to PRA, FALSE if not
  password_protect <- Password_Protect
} else {
  password_protect <- FALSE
}

# Creating variable for latest week for headlines

# Admissions and ICU
admissions_headlines <- get_threeweek_admissions_figures(df = Admissions,
                                                         sumcol = "TotalInfections",
                                                         datecol="AdmissionDate")

icu_headlines <- get_threeweek_admissions_figures(df = ICU,
                                                  sumcol = "NewCovidAdmissionsPerDay",
                                                  datecol="DateFirstICUAdmission")

# occupancy_headlines <- get_threeweek_occupancy_figures(df = Occupancy_Hospital,
#                                                        datecol = "Date")
#imk addition (orig retained), Use weekly hospital hb files
#filter to scotland, then create list
occupancy_headlines <- Occupancy_Weekly_Hospital_HB %>% 
  filter(HealthBoardQF== "d") 

occupancy_headlines <- get_threeweek_occupancy_figures(df = occupancy_headlines,
                                                       datecol = "WeekEnding_od")
##

adm_hb_dates <- c(Admissions_HB %>% tail(1) %>% .$WeekEnding, Admissions_HB %>% tail(1) %>% .$WeekEnding%>% {.-7}, Admissions_HB %>% tail(1) %>% .$WeekEnding%>% {.-14})

# LOS
los_date_end <- Admissions %>% tail(1) %>% .$AdmissionDate %>% convert_opendata_date() %>% {.-7}

los_date_start <- los_date_end-28

los_median_max <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == max(MedianLengthOfStay))

los_median_min <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == min(MedianLengthOfStay))

# Respiratory factor
resp_order <- c("Influenza - Type A (any subtype)",
                "Influenza - Type A(H1N1)pdm09",
                "Influenza - Type A(H3)",
                "Influenza - Type A (not subtyped)",
                "Influenza - Type B",
                "Influenza - Type A or B",
                "Adenovirus",
                "Human metapneumovirus",
                "Mycoplasma pneumoniae",
                "Parainfluenza virus",
                "Respiratory syncytial virus",
                "Rhinovirus",
                "Seasonal coronavirus (Non-SARS-CoV-2)",
                "Total")

Respiratory_AllData %<>%
  mutate(
         AgeGroup = factor(AgeGroup,
                           levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")
                           ),
         Organism = factor(Organism,
                           levels = resp_order
          )
         )

resp_sum_order <- c(resp_order,
                   unique(Respiratory_Summary$Breakdown)[!(
                    unique(Respiratory_Summary$Breakdown) %in% resp_order)])

# Duplicate of Respiratory_Summary where Breakdown col is a factor - needed for the
# headline dropdown. Can't reassign to Respiratory_Summary for some reason
# TODO: fix this!
Respiratory_Summary_Factor <- Respiratory_Summary %>%
  mutate(Breakdown = factor(Breakdown,levels = resp_sum_order)) %>% arrange(Breakdown)

# respiratory headline figures
flu_icon_headline <- Respiratory_Summary_Totals %>%
  mutate(icon = case_when(PercentageDifference > 0 ~ "arrow-up",
                          PercentageDifference < 0 ~ "arrow-down",
                          PercentageDifference == 0 ~ "equals"))

# respiratory isoweeks
this_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DateThisWeek[1])
prev_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DatePreviousWeek[1])



#### Respiratory MEM ####

# Static legend for MEM plots
mem_legend <- readPNG("www/MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Static legend for Euromomo age MEM plots
euromomo_age_mem_legend <- readPNG("www/Euromomo_age_MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Activity levels
activity_levels <- c("Baseline", "Low", "Moderate", "High", "Extraordinary")

# Colours for thresholds
activity_level_colours <- c("#01A148", "#FFDE17", "#F36523", "#ED1D24", "#7D4192")

# Activity levels   for euromomo
euromomo_activity_levels <- c("Baseline", "Low", "Moderate", "High", "Extraordinary", "Reporting delay")

# Colours for thresholds for euromomo
euromomo_activity_level_colours <- c("#01A148", "#FFDE17", "#F36523", "#ED1D24", "#7D4192", "#a6a6a6")

# Colours for lines on line chart
# mem_line_colours <- c("#010101", "#A35000", "#00FF1A", "#004785","#00a2e5",
#                       "#376C31", "#FF0000")
mem_line_colours <- c("#A35000", "#00FF1A", "#004785","#00a2e5",
                      "#376C31", "#FF0000")

# Colours for lines on summary admissions line chart
flu_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                            phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                            phs_colours("phs-blue"))

rsv_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                           phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                           phs_colours("phs-blue"))

# Colours for lines on line chart
euromomo_mem_line_colours <- c("#004785","#00a2e5", "#376C31", "#FF0000", "#FF0000")

# Isoweeks from week 40 to 39
mem_isoweeks <- c(40:52, 1:39)
# Weeks in order from 1 to 52
mem_week_order <- c(1:52)

# Age groups
mem_age_groups <- c("< 1", "1-4", "5-14", "15-44", "45-64", "65-74",
                    "75+", "All Ages")
mem_age_groups_full <- c("< 1 years", "1-4 years", "5-14 years", "15-44 years",
                         "45-64 years", "65-74 years", "75+ years", "All Ages")

# Age groups
euromomo_mem_age_groups <- c("0-4", "5-14", "15-64", "65+", "All Ages")
euromomo_mem_age_groups_full <- c("0-4 years", "5-14 years", "15-64 years",
                                  "65+ years", "All Ages")

# Set date data goes up to - previous Sunday
data_recent_date <- floor_date(today(), "week") %>% format("%d %B %Y")

# Read in shapefile

Sys.setenv("GDAL_DATA" = "/usr/gdal34/share/gdal")
#load the geospatial libraries
dyn.load("/usr/gdal34/lib/libgdal.so")
dyn.load("/usr/geos310/lib64/libgeos_c.so", local = FALSE)
library(sf)
library(sp)
library(leaflet)

# Specify the path to your shapefile (.shp) without the file extension
shapefile_path = "/conf/linkage/output/lookups/Unicode/Geography/Shapefiles/Health Board 2019/"

# Read the shapefile
HB_Polygons <- st_read(dsn = shapefile_path,layer="SG_NHS_HealthBoards_2019")
# Specify a tolerance value for simplification # You can adjust this value based on your needs
tolerance <- 500

Simplified_HB_Polygons <- st_simplify(HB_Polygons, dTolerance = tolerance) 

#current week joined polygon

WW_HB_table_edited = COVID_Wastewater_HB_table %>%
  filter(!health_board %in% c("AllSites", "28Sites")) %>% #removing rows containing Allsites and 28sites
  mutate(HBCode= case_when(health_board == 'NHS Ayrshire and Arran' ~ 'S08000015',
                           health_board == 'NHS Borders' ~ 'S08000016',
                           health_board  == 'NHS Dumfries and Galloway' ~ 'S08000017',
                           health_board  == 'NHS Fife' ~ 'S08000029',
                           health_board  == 'NHS Forth Valley' ~ 'S08000019',
                           health_board  == 'NHS Grampian' ~ 'S08000020',
                           health_board  == 'NHS Highland' ~ 'S08000022',
                           health_board  == 'NHS Lanarkshire' ~ 'S08000032',
                           health_board  == 'NHS Lothian' ~ 'S08000024',
                           health_board  == 'NHS Orkney' ~ 'S08000025',
                           health_board  == 'NHS Shetland' ~ 'S08000026',
                           health_board  == 'NHS Tayside' ~ 'S08000030',
                           health_board  == 'NHS Western Isles' ~ 'S08000028',
                           health_board  == 'NHS Greater Glasgow and Clyde' ~ 'S08000031',
                           TRUE ~ "NA"))

HB_Polygons<-left_join(Simplified_HB_Polygons, WW_HB_table_edited, by="HBCode") 

# Transforming to WGS84 (EPSG:4326) need this to adjust placement of map
HB_Polygons <- st_transform(HB_Polygons, crs = 4326)

site_lat_long= site_lat_long %>% 
  rename('latitude'='Lat') %>% 
  rename('longitude' = 'Lon') %>% 
  rename('site_name'='Site Name') %>% 
  rename('HB'='Health Area')


site_lat_long <- site_lat_long %>%
  mutate(across(c(latitude, longitude), ~ as.numeric(trimws(.)))) %>%
  drop_na(latitude, longitude)


site_lat_long_sf <- st_as_sf(site_lat_long, coords = c("longitude", "latitude"), crs = 27700)

# Transform the site points to WGS84
site_lat_long_sf <- st_transform(site_lat_long_sf, crs = 4326)

site_lat_long_sf= site_lat_long_sf %>% 
  mutate(health_board= case_when(HB == 'Ayrshire and Arran' ~ 'NHS Ayrshire and Arran',
                                 HB == 'Borders' ~ 'NHS Borders',
                                 HB  == 'Dumfries and Galloway' ~ 'NHS Dumfries and Galloway',
                                 HB  == 'Fife' ~ 'NHS Fife',
                                 HB  == 'Forth Valley' ~ 'NHS Forth Valley',
                                 HB  == 'Grampian' ~ 'NHS Grampian',
                                 HB  == 'Highland' ~ 'NHS Highland',
                                 HB  == 'Lanarkshire' ~ 'NHS Lanarkshire',
                                 HB  == 'Lothian' ~ 'NHS Lothian',
                                 HB  == 'Orkney' ~ 'NHS Orkney',
                                 HB  == 'Shetland' ~ 'NHS Shetland',
                                 HB  == 'Tayside' ~ 'NHS Tayside',
                                 HB  == 'Western Isles' ~ 'NHS Western Isles',
                                 HB  == 'Greater Glasgow and Clyde' ~ 'NHS Greater Glasgow and Clyde',
                                 TRUE ~ "NA"))

#add the health board names for site_lat_long as well
site_lat_long= site_lat_long %>% 
  mutate(health_board= case_when(HB == 'Ayrshire and Arran' ~ 'NHS Ayrshire and Arran',
                                 HB == 'Borders' ~ 'NHS Borders',
                                 HB  == 'Dumfries and Galloway' ~ 'NHS Dumfries and Galloway',
                                 HB  == 'Fife' ~ 'NHS Fife',
                                 HB  == 'Forth Valley' ~ 'NHS Forth Valley',
                                 HB  == 'Grampian' ~ 'NHS Grampian',
                                 HB  == 'Highland' ~ 'NHS Highland',
                                 HB  == 'Lanarkshire' ~ 'NHS Lanarkshire',
                                 HB  == 'Lothian' ~ 'NHS Lothian',
                                 HB  == 'Orkney' ~ 'NHS Orkney',
                                 HB  == 'Shetland' ~ 'NHS Shetland',
                                 HB  == 'Tayside' ~ 'NHS Tayside',
                                 HB  == 'Western Isles' ~ 'NHS Western Isles',
                                 HB  == 'Greater Glasgow and Clyde' ~ 'NHS Greater Glasgow and Clyde',
                                 TRUE ~ "NA"))

