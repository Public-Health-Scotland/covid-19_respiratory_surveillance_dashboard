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
shiny_data_folder <- "shiny_app/data/"


# Remove all files in shiny data folder
purrr::walk(list.files(path=shiny_data_folder, full.names=TRUE), file.remove)

# Load all processed data files and save out as rds
copy_to_shiny_data <- function(csv){
  # Given a .csv file name in processed_data_folder
  # copies it across to an .rds file in shiny_data_folder
  readfile <- readr::read_csv(paste0(output_folder, csv))
  saveRDS(readfile, paste0(shiny_data_folder, gsub(".csv", ".rds", csv)))
}

# Copy all csv files in processed_data to shiny_data as rds files
# Not copying march files across as only June needed
files =  list.files(path=output_folder)
purrr::walk(files, copy_to_shiny_data)
