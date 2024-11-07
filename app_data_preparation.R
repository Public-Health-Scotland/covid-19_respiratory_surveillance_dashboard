####################### App data preparation #######################

# Data preparation for app

# This script loads data from Clinical_Prioritisation/data/processed_data
# and saves out .rds files needed for running the dashboard to the shiny_app/data folder

rm(list = ls())
gc()

# Getting project directory to choose files from
project_directory <- rstudioapi::getActiveProject()
if (!is.null(project_directory)){ setwd(project_directory) }

# Create output directory
dir.create(here::here("shiny_app", "data"))

output_folder <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/"
data_dictionary_folder <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Data Dictionaries/"
shiny_data_folder <- "shiny_app/data/"

# Specify the path to your shapefile (.shp) without the file extension
shapefile_path = "/conf/linkage/output/lookups/Unicode/Geography/Shapefiles/Health Board 2019/"

# Check if shapefile is saved locally
if(!paste0(shiny_data_folder, "/Simplified_HB_Polygons.rds") %in% list.files(path=shiny_data_folder, full.names=TRUE, pattern="")){
  
  # Read the shapefile
  HB_Polygons <- sf::st_read(dsn = shapefile_path,layer="SG_NHS_HealthBoards_2019")
  # Specify a tolerance value for simplification # You can adjust this value based on your needs
  tolerance <- 500
  
  Simplified_HB_Polygons <- sf::st_simplify(HB_Polygons, dTolerance = tolerance)
  
  # Save to local data folder
  readr::write_rds(Simplified_HB_Polygons, paste0(shiny_data_folder, "Simplified_HB_Polygons.rds"))
  
}

# Remove all files in shiny data folder
purrr::walk(
  {list.files(path=shiny_data_folder, full.names=TRUE, pattern="") %>%
    stringr::str_subset(., "Deployment_Date.rds", negate = TRUE) %>%
    stringr::str_subset(., "Password_Protect.rds", negate = TRUE) %>%
    stringr::str_subset(., "Simplified_HB_Polygons.rds", negate = TRUE)
    },
  file.remove)

# Load all processed data files and save out as rds
copy_to_shiny_data <- function(csv, startloc){
  # Given a .csv file name in startloc
  # copies it across to an .rds file in shiny_data_folder
  readfile <- readr::read_csv(paste0(startloc, csv))
  saveRDS(readfile, paste0(shiny_data_folder, gsub(".csv", ".rds", csv)))
}

# Copy all csv files in processed_data to shiny_data as rds files
files =  list.files(path=output_folder, pattern = ".csv")
purrr::walk(files, copy_to_shiny_data, startloc = output_folder)

# Now get all data dictionaries
dictionary_files = list.files(path=data_dictionary_folder)
purrr::walk(dictionary_files, copy_to_shiny_data, startloc = data_dictionary_folder)




