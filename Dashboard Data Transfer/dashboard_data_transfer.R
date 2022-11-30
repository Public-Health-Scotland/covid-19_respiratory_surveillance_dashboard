#####################################################
# Script to transfer data from Input data folder    #
# to dashboard data folder                          #
#####################################################

library(dplyr)
library(magrittr)
library(glue)
library(openxlsx)
library(lubridate)
library(janitor)
library(stringr)
library(data.table)
library(stats)
library(zoo)
library(tidyr)
library(readxl)
library(readr)
# remotes::install_github("RosalynLP/friendlyloader")
# Provides the following functions:
# ----------------------------------
# read_csv_with_options
# read_excel_with_options
# read_all_sheets
library(friendlyloader)

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

data_files = list.files(path=data_folder, recursive=TRUE, full.names=TRUE)
purrr::walk(data_files, file.copy, to = input_data, recursive=TRUE, overwrite=TRUE)


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

