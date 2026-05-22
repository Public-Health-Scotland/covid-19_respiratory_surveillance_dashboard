### File only to be run temporarily while processes are being updated
### After updates are finished, files will be moved directly from the
### Weekly Data Folder to the Analyst Space (with Input folder, Output 
### folder and dashboard_data_transfer.R no longer required)

updated_files <- c("COVID_Wastewater_National_table.csv",
                   "Respiratory_Euromomo.csv",
                   "Respiratory_Pathogens_CARI_Age.csv",
                   "Respiratory_Pathogens_CARI_codetections.csv",
                   "Respiratory_Pathogens_CARI_duodetections.csv",
                   "Respiratory_Pathogens_CARI_HB.csv",
                   "Respiratory_Pathogens_CARI_Scot.csv",
                   "COVID_Wastewater_CA_table.csv",
                   "COVID_Wastewater_HB_table.csv",
                   "Respiratory_GPARI_MEM_Age.csv",
                   "Respiratory_GPARI_MEM_Scot.csv",
                   "Respiratory_GPILI_MEM_Age.csv",
                   "Respiratory_GPILI_MEM_Scot.csv",
                   "Respiratory_NHS24_MEM_Age.csv",
                   "Respiratory_NHS24_MEM_Scot.csv",
                   "admissions_age.csv",
                   "admissions_hb_new.csv",
                   "admissions_scotland.csv",
                   "admissions_simd_new.csv",
                   "Average_Length_of_Stay.csv",
                   "occupancy_rapid_hb_new.csv",
                   "occupancy_rapid_new.csv")

updates_to_move <- paste(input_data, updated_files, sep="")

purrr::walk(updates_to_move, file.copy, to = output_folder, recursive=TRUE, overwrite=TRUE)

