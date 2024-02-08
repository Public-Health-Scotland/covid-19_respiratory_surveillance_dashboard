# Dashboard data transfer for CARI
# Sourced from ../dashboard_data_transfer.R

##### Respiratory CARI

filenames <- c("scotland", "agegp")

for (filename in filenames){
  
  assign(glue("Respiratory_CARI_{filename}"),
         read_csv_with_options(
           match_base_filename(
             glue("{input_data}/cari_{filename}.csv")
           )
         )
  )
}

# Output
write_csv(Respiratory_CARI_scotland, glue(output_folder, "Respiratory_Pathogens_CARI_Scot.csv"))
write_csv(Respiratory_CARI_agegp, glue(output_folder, "Respiratory_Pathogens_CARI_Age.csv"))
