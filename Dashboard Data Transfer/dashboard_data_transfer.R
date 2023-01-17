#####################################################
# Script to transfer data from Input data folder    #
# to dashboard data folder                          #
#####################################################

# Getting packages
if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
if (!pacman::p_isinstalled("friendlyloader")){pacman::p_install_gh("RosalynLP/friendlyloader")}

pacman::p_load(dplyr, magrittr, glue, openxlsx, lubridate,
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

# Refresh input data folder ----
# Clear input data
purrr::walk(list.files(path=input_data, full.names=TRUE), unlink, recursive=TRUE)

# Copy new files across from data folder
data_folder <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Data Folders/{report_date}/Data")

# This can be commented out once we have a proper process
# in place for adding the flu data to test and protect warehouse
respiratory_input_data_path <- glue("/conf/C19_Test_and_Protect/Test & Protect - Warehouse/",
                    "Weekly Covid Dashboard/Flu-NonFlu")

data_files = list.files(path=data_folder, recursive=TRUE, full.names=TRUE)
purrr::walk(data_files, file.copy, to = input_data, recursive=TRUE, overwrite=TRUE)

# Getting respiratory data files
# This can be commented out once we have a proper process
# in place for adding the flu data to test and protect warehouse
flu_data_files = list.files(path=respiratory_input_data_path, recursive=TRUE, full.names=TRUE)
purrr::walk(flu_data_files, file.copy, to = input_data, recursive=TRUE, overwrite=TRUE)


##### Cases
source("Transfer Scripts/transfer_cases.R")

##### NRS Deaths
source("Transfer Scripts/transfer_deaths.R")

##### Ethnicity
# Updated quarterly
source("Transfer Scripts/transfer_ethnicity.R")

##### ICU
source("Transfer Scripts/transfer_icu.R")

##### Hosp Adms
source("Transfer Scripts/transfer_admissions.R")

##### Length of Stay
source("Transfer Scripts/transfer_los.R")

##### Vaccine Wastage
source("Transfer Scripts/transfer_vacc_wastage.R")

##### ONS
source("Transfer Scripts/transfer_ons.R")

#### Care Homes
source("Transfer Scripts/transfer_carehomes.R")

#### Wastewater
source("Transfer Scripts/transfer_wastewater.R")

#### Occupancy
source("Transfer Scripts/transfer_occupancy.R")

