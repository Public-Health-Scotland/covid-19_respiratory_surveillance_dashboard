#####################################################
# Script to transfer data from Input data folder    #
# to dashboard data folder                          #
#####################################################
#Test comment
# Getting packages
if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
if (!pacman::p_isinstalled("friendlyloader")){pacman::p_install_gh("RosalynLP/friendlyloader")}

pacman::p_load(dplyr, magrittr, glue, openxlsx, lubridate, ISOweek,
               janitor, stringr, data.table, stats, zoo, tidyr, readxl,
               readr, friendlyloader, phsopendata, rjson, purrr)

# Setting permisisons for files outputted
Sys.umask("006")

# Getting main script location for working directory
path_main_script_location = dirname(rstudioapi::getActiveDocumentContext()$path)

setwd(path_main_script_location)

report_date <- floor_date(today(), "week", 1) + 2

# Output to weekly dashboard data folder (shared)
dash_input_data <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Dashboard_Inputs/"


# Refresh dash input data folder ----
# Clear input data
purrr::walk(list.files(path=dash_input_data, full.names=TRUE), unlink, recursive=TRUE)

# Copy new files across from weekly data folder
data_folder <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Data Folders/{report_date}/Data/new")

data_files = list.files(path=data_folder, recursive=TRUE, full.names=TRUE)
purrr::walk(data_files, file.copy, to = dash_input_data, recursive=TRUE, overwrite=TRUE)


## Create next week's Weekly Data Folder

new_data_folder <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Data Folders/{report_date + days(7)}/Data")

# Define the main directory and subdirectories

sub_dirs <- c("Respiratory", "Hospital Admissions", "new")

# Create the main directory if it doesn't exist
if (!dir.exists(new_data_folder)) {
  dir.create(new_data_folder, recursive=TRUE)
}

# Create each subdirectory inside the main directory
for (sub in sub_dirs) {
  dir_path <- file.path(new_data_folder, sub)

  # Create subdirectory if it doesn't exist
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
    message("Created: ", dir_path)
  } else {
    message("Already exists: ", dir_path)
  }
}



######  Open data archiving steps #######
# run this section to move this week's content from od_outputs folder
# into a newly created folder within the archive sub-folder.
# this new folder is labelled with the current week's publication date

# Set the source directory where your files are located
source_dir <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/"

# Set the name of the new destination directory
od_archive_date <-format(report_date)
destination_dir <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/archived/{od_archive_date}")

# Create the new destination directory for archive steps
if (!dir.exists(destination_dir)) {
  dir.create(destination_dir)}

# List ***all*** files in the source directory
files_to_move <- list.files(source_dir)

# Loop through the files and move them to the new destination directory
for (file_name in files_to_move) {
  source_path <- file.path(source_dir, file_name)
  destination_path <- file.path(destination_dir, file_name)
  # Move the file to the new destination directory
  if (file.rename(source_path, destination_path)) {
    cat("Moved", file_name, "to", destination_dir, "\n")
  } else {
    cat("Failed to move", file_name, "\n")
    cat("Error message: ", geterrmessage(), "\n")
  }
}


# Create a 'new' folder for next week's open data files
new_od_dir <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/new/")

# Create the new destination directory
if (!dir.exists(new_od_dir)) {
  dir.create(new_od_dir)
}
