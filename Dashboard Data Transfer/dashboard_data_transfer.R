#####################################################
# Script to transfer data from Input data folder    #
# to dashboard data folder                          #
#####################################################

# Getting packages
if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
if (!pacman::p_isinstalled("friendlyloader")){pacman::p_install_gh("RosalynLP/friendlyloader")}

pacman::p_load(dplyr, magrittr, glue, openxlsx, lubridate, ISOweek,
               janitor, stringr, data.table, stats, zoo, tidyr, readxl, readr, friendlyloader)

# Setting permisisons for files outputted
Sys.umask("006")

# Getting main script location for working directory
path_main_script_location = dirname(rstudioapi::getActiveDocumentContext()$path)

setwd(path_main_script_location)

report_date <- floor_date(today(), "week", 1) + 2


# Dashboard main folder is located one up from data transfer
dashboard_folder <- "../"
# Output to weekly dashboard data folder (shared)
input_data <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Input/"
output_folder <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/"


# Getting useful functions
#source("data_transfer_functions.R")

# Getting population information
# ------------------------------

copy_bool <- file.copy(
  from="/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/population.csv",
  to=glue("{input_data}/population.csv"),
  overwrite=TRUE)

if (copy_bool == FALSE){
  stop("Failed to copy population.csv to input data. Check that population.csv is in
       /conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/")
}

i_population <- read_csv_with_options(glue(input_data, "population.csv"))  %>%
  dplyr::rename(age_group = contains("MYE"))

i_population %<>%
  pivot_longer(cols=c("Male", "Female", "Total"), values_to="value", names_to="sex") %>%
  dplyr::rename(PopNumber=value,
                AgeGroup = age_group,
                Sex = sex)

i_population[i_population == "May-14"] <- "5-14"
i_population$AgeGroup[i_population$AgeGroup == "total"] <- "Total"
i_population$AgeGroup <- sapply(i_population$AgeGroup, function(x) str_remove(x, "years"))
i_population$AgeGroup <- sapply(i_population$AgeGroup, function(x) str_remove_all(x, " "))

source("Transfer Scripts/population_lookups.R")

# Refresh input data folder ----
# Clear input data
purrr::walk(list.files(path=input_data, full.names=TRUE), unlink, recursive=TRUE)

# Copy new files across from data folder
data_folder <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Data Folders/{report_date}/Data")

data_files = list.files(path=data_folder, recursive=TRUE, full.names=TRUE)
purrr::walk(data_files, file.copy, to = input_data, recursive=TRUE, overwrite=TRUE)


##### Cases
source("Transfer Scripts/transfer_cases.R")

##### NRS Deaths
# source("Transfer Scripts/transfer_deaths.R")

##### Ethnicity
# Updated quarterly
source("Transfer Scripts/transfer_ethnicity.R")

##### ICU
# source("Transfer Scripts/transfer_icu.R")

##### Hosp Adms
source("Transfer Scripts/transfer_admissions.R")

##### Length of Stay
source("Transfer Scripts/transfer_los.R")

##### Vaccine Wastage
# source("Transfer Scripts/transfer_vacc_wastage.R")

##### ONS
# source("Transfer Scripts/transfer_ons.R")

#### Care Homes
# source("Transfer Scripts/transfer_carehomes.R")

#### Wastewater
source("Transfer Scripts/transfer_wastewater.R")

#### Occupancy
source("Transfer Scripts/transfer_occupancy.R")

#### Respiratory
source("Transfer Scripts/transfer_respiratory.R")

#### Open Data 
# output locations
# all open data data saved to this location

#output_folder <-glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/")

#(glue(output_folder, "Ethnicity.csv"))
od_date <- floor_date(today(), "week", 1) + 1
od_report_date <- format(report_date, "%Y%m%d")
od_archive_date <-format(report_date-7, "%Y%m%d")
od_sunday<- floor_date(today(), "week", 1) -1
od_folder<- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/"
od_archive_folder<- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/archived/{report_date }")


# Set the source directory where your files are located


#od_archive_folder <- glue("{od_folder}/archived/{od_report_date}")


# Create the new destination directory if it doesn't exist
if (!dir.exists(od_archive_folder)) {
  dir.create(od_archive_folder)
}
# Set the source directory where your files are located
#source_dir <- "/path/to/source/directory"

# Create a vector of file names you want to move
# file_names_to_move <- c(glue("cumulative_testcases_HB2019_{od_report_date}.csv", 
#                          glue("cumulative_testcases_CA2019_{od_report_date}.csv")))

# Set the name of the new destination directory
#destination_dir <- "/path/to/new/destination/directory"

# 
# 
# # Loop through the file names and move them to the new destination directory
# for (file_name in file_names_to_move) {
#   source_path <- file.path(od_folder, file_name)
#   destination_path <- file.path(od_archive_folder, file_name)
# 
#   # Move the file to the new destination directory
#   if (file.rename(od_folder, od_archive_folder)) {
#     cat("Moved", file_name, "to", destination_dir, "\n")
#   } else {
#     cat("Failed to move", file_name, "\n")
#   }
# }


# Geography
source("Transfer Scripts/transfer_geography_open_data.R")
# age sex cases
source("Transfer Scripts/transfer_weekly_agesex_cases_od.R")
# simd cases data
source("Transfer Scripts/transfer_weekly_simd_cases_od.R")

# remove(population files (i_population_v2 used in dashboard, not just Open Data) 
rm(base_hb_population,  pop_60plus_sex, pop_60plus_total,
   pop_agegroup_sex, pop_agegroup_total, pop_dash_ageband, 
   pop_dash_fifteen_fourty_four, pop_dash_sex, pop_dash_sex_ageband,
   pop_dash_total, pop_total_sex, pop_total_total, pop_dash_sex_fifteen_fourty_four)
rm(i_population_v2)
