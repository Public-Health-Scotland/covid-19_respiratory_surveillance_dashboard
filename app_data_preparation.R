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


# Remove all files in shiny data folder
purrr::walk(list.files(path=shiny_data_folder, full.names=TRUE), file.remove)

# Load all processed data files and save out as rds
copy_to_shiny_data <- function(csv, startloc){
  # Given a .csv file name in startloc
  # copies it across to an .rds file in shiny_data_folder
  readfile <- readr::read_csv(paste0(startloc, csv))
  saveRDS(readfile, paste0(shiny_data_folder, gsub(".csv", ".rds", csv)))
}

# Copy all csv files in processed_data to shiny_data as rds files
files =  list.files(path=output_folder)
purrr::walk(files, copy_to_shiny_data, startloc = output_folder)

# Now get all data dictionaries
dictionary_files = list.files(path=data_dictionary_folder)
purrr::walk(dictionary_files, copy_to_shiny_data, startloc = data_dictionary_folder)



