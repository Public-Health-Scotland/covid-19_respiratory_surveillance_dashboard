####################### App data preparation #######################

# Data preparation for app

# This script converts the dashboardinput files to .rds files, and mvoes them to the shiny_app/data folder in
# the analyst's analyst space to enable them to run the dashboard

rm(list = ls())
gc()

# Getting project directory to choose files from
project_directory <- rstudioapi::getActiveProject()
if (!is.null(project_directory)){ setwd(project_directory) }

# Create output directory
dir.create(here::here("shiny_app", "data"))

dash_input_folder <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Dashboard_Inputs/"
shiny_data_folder <- "shiny_app/data/"

# Set deployment date
set_deployment_date()

# Remove all files in shiny data folder
purrr::walk(
  {list.files(path=shiny_data_folder, full.names=TRUE, pattern="") %>%
    stringr::str_subset(., "Deployment_Date.rds", negate = TRUE) %>%
    stringr::str_subset(., "Password_Protect.rds", negate = TRUE)
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
files =  list.files(path=dash_input_folder, pattern = ".csv")
purrr::walk(files, copy_to_shiny_data, startloc = dash_input_folder)





