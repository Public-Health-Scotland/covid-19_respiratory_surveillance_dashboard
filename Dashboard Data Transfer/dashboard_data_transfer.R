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

# Open Data output locations and dates (still to fine tune this)
od_date <- floor_date(today(), "week", 1) + 1
od_report_date <- format(report_date, "%Y%m%d")
od_archive_date <-format(report_date-7)
od_sunday<- floor_date(today(), "week", 1) -1
od_sunday_minus_7 <- floor_date(today(), "week", 1) -8
od_sunday_minus_14 <- today() - 17



# all open data data saved to this location
od_folder<- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/"
# location for archive folders to go
od_archive_folder<- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/archived/{report_date}"

# Getting useful functions
#source("data_transfer_functions.R")


# Refresh input data folder ----
# Clear input data
purrr::walk(list.files(path=input_data, full.names=TRUE), unlink, recursive=TRUE)

# Copy new files across from data folder
data_folder <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Data Folders/{report_date}/Data")

data_files = list.files(path=data_folder, recursive=TRUE, full.names=TRUE)
purrr::walk(data_files, file.copy, to = input_data, recursive=TRUE, overwrite=TRUE)

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

######  Open data archiving steps #######
# run this section before the data transfer steps 
# the process moves all existing content from od_outputs folder
# into a newly created folder within the archive sub-folder. 
# this new folder is labelled with the previous week's publication date)

# Set the source directory where your files are located
source_dir <- "/conf/C19_Test_and_Protect/Test & Protect - Warehouse/Weekly Covid Dashboard/Output/od_outputs/"

# Set the name of the new destination directory
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

#####################
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

#### Care Homes ( first part not working, moved time series to separate script)
# archived until further notice
#source("Transfer Scripts/transfer_carehomes.R")

#### Wastewater
source("Transfer Scripts/transfer_wastewater.R")

#### Occupancy
source("Transfer Scripts/transfer_occupancy.R")

#### Respiratory
source("Transfer Scripts/transfer_respiratory.R")

#### Respiratory Pathogens - MEM
source("Transfer Scripts/transfer_respiratory_pathogens_mem.R")


#### Respiratory - Euromomo
source("Transfer Scripts/transfer_respiratory_euromomo.R")

#### Respiratory NHS24 - MEM
source("Transfer Scripts/transfer_respiratory_nhs24_mem.R")

#### Respiratory GP - MEM
source("Transfer Scripts/transfer_respiratory_gp_mem.R")

#### Influenza Hospital Admissions
source("Transfer Scripts/transfer_flu_admissions.R")

#### RSV Hospital Admissions
source("Transfer Scripts/transfer_rsv_admissions.R")

## Open Data transfers ##

#### Open data test and cases by HB or CA
source("Transfer Scripts/transfer_geography_open_data.R")

#### Open Data age sex cases
source("Transfer Scripts/transfer_weekly_agesex_cases_od.R")

#### Open data simd cases data
source("Transfer Scripts/transfer_weekly_simd_cases_od.R")

#### Open data ethnicity open 
source("Transfer Scripts/transfer_ethnicity_open_data.R")

#### Open data care home times series 
source("Transfer Scripts/transfer_carehome_timeseries_od.R")

####  Open data weekly covid hospital admissions & occupancy for open data
####  PLUS Open data weekly Respiratory flu and RSV hospital admissions
source("Transfer Scripts/transfer_admissions_occupancy_HB_od.R")

#remove open data values
rm(od_date, od_report_date,od_archive_date ,od_sunday,od_sunday_minus_7,
   od_sunday_minus_14, od_folder, od_archive_folder, gpd_base_path)
   
# remove(population files (i_population_v2 used in dashboard, not just Open Data) 
# rm(pop_60plus_sex, pop_60plus_total,
#    pop_agegroup_sex, pop_agegroup_total, pop_dash_ageband, 
#    pop_dash_fifteen_fourty_four, pop_dash_sex, pop_dash_sex_ageband,
#    pop_dash_total, pop_total_sex, pop_total_total, 
#    pop_dash_sex_fifteen_fourty_four,pop_year, i_population_v2)
