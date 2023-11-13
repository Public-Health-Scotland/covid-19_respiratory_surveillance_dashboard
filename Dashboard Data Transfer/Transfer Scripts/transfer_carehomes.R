# Dashboard data transfer for Care Homes (Turas) for SG
# Sourced from ../dashboard_data_transfer.R

##### Care Homes data for Scottish Government
care_homes_visit_path <- "/conf/C19_Test_and_Protect/Care Home Visiting - Turas/Outputs/"
care_homes_visit_files <- list.files(path=care_homes_visit_path, pattern="*care_homes_visits.xlsx")

# Get the most recent file
filedates <- purrr::map_dbl(care_homes_visit_files, ~ as.numeric(str_extract_all(.x, "[0-9]+")[[1]]))
most_recent_date <- max(filedates)
most_recent_file <- care_homes_visit_files[which.max(filedates)]

# Health Board lookup
hblookup <- list("Ayrshire and Arran" = "S08000015",
                 "Borders" = "S08000016",
                 "Dumfries and Galloway" = "S08000017",
                 "Fife" = "S08000029",
                 "Forth Valley" = "S08000019",
                 "Grampian" = "S08000020",
                 "Greater Glasgow and Clyde" = "S08000031",
                 "Highland" = "S08000022",
                 "Lanarkshire" = "S08000032",
                 "Lothian" = "S08000024",
                 "Orkney" = "S08000025",
                 "Shetland" = "S08000026",
                 "Tayside" = "S08000030",
                 "Western Isles" = "S08000028",
                 "Orkney, Shetland, and Western Isles"= "GR0800001",
                 "Scotland" = "S92000003",
                 "Unknown"=  "")

# Function for processing Tabs 1, 3a, 3b
process_visiting_status_table <- function(df) {

  df  %<>%
    select(-c("% supporting indoor visits (as a proportion of all homes)",
              "% supporting indoor visits (as a proportion of those returning a huddle)")) %>%
    mutate(`Outdoor and essential visits only` = as.numeric(`Outdoor and essential visits only`),
           TotalCareHomesWithIndoorVisitsPc = round_half_up(100*`Total indoor visits`/`All adult care homes`, 1),
           SubmittedCareHomesWithIndoorVisitsPc = round_half_up(
             100*`Total indoor visits`/(`All adult care homes` - `No data submitted`), 1)) %>%
    pivot_longer(cols=names(.)[!(names(.) %in% c("NHS Board", "No data submitted", "All adult care homes",
                                                 "TotalCareHomesWithIndoorVisitsPc", "SubmittedCareHomesWithIndoorVisitsPc"))],
                 names_to = "VisitingStatus", values_to="NumberOfCareHomesWithVisitingStatus") %>%
    dplyr::rename(HealthBoard = `NHS Board`,
                  TotalAdultCareHomes = `All adult care homes`,
                  TotalCareHomesNotSubmitted = `No data submitted`) %>%
    mutate(VisitingStatusQF = ifelse(VisitingStatus == "Total indoor visits", "d", ""),
           NumberOfCareHomesWithVisitingStatusQF = ifelse(is.na(NumberOfCareHomesWithVisitingStatus), "z", ""),
           HealthBoardQF = ifelse(HealthBoard == "Scotland", "d", ""),
           HealthBoard = unlist(hblookup[HealthBoard])) %>%
    select(HealthBoard, HealthBoardQF, VisitingStatus, VisitingStatusQF,
           NumberOfCareHomesWithVisitingStatus, NumberOfCareHomesWithVisitingStatusQF,
           TotalAdultCareHomes, TotalCareHomesNotSubmitted,
           TotalCareHomesWithIndoorVisitsPc, SubmittedCareHomesWithIndoorVisitsPc)

  # Removing this column if it's empty strings only
  if(length(unique(df$NumberOfCareHomesWithVisitingStatusQF)) == 1){
    df %<>% select(-NumberOfCareHomesWithVisitingStatusQF)
  }

  return(df)

}


# Processing most recent file
i_ch <- read_all_excel_sheets(paste0(care_homes_visit_path, most_recent_file))
g_notes <- i_ch$Notes

write.csv(g_notes, glue(output_folder, glue("CareHomeVisitsNotes_{most_recent_date}.csv")), row.names = FALSE)

g_board <- i_ch$`Table 1` %>%
  process_visiting_status_table()

write_csv(g_board, glue(output_folder, glue("CareHomeVisitsBoard_{most_recent_date}.csv")))

g_outbreak <- i_ch$`Table 2` %>%
  mutate(`Outdoor and essential visits only` = as.numeric(`Outdoor and essential visits only`)) %>%
  pivot_longer(cols = c("Up to two indoor visits per week", "Daily indoor visits", "Multiple indoor visitors",
                        "Total indoor visits", "Outdoor and essential visits only", "Essential visits only",
                        "Other visiting status"),
               names_to = "VisitingStatus", values_to="NumberOfCareHomes") %>%
  dplyr::rename(TotalAdultCareHomes = `All adult care homes`,
                TotalCareHomesNotSubmitted = `No data submitted`,
                OutbreakStatus = `Outbreak status`) %>%
  mutate(VisitingStatusQF = ifelse(VisitingStatus == "Total indoor visits", "d", ""),
         OutbreakStatusQF = ifelse(OutbreakStatus == "Total", "d", ""),
         NumberOfCareHomesQF = ifelse(is.na(NumberOfCareHomes), "z", "")) %>%
  select(OutbreakStatus, OutbreakStatusQF, VisitingStatus, VisitingStatusQF, NumberOfCareHomes, NumberOfCareHomesQF,
         TotalAdultCareHomes, TotalCareHomesNotSubmitted)

if(length(unique(g_outbreak$NumberOfCareHomesQF)) == 1){
  g_outbreak %<>% select(-NumberOfCareHomesQF)
}



write_csv(g_outbreak, glue(output_folder, glue("CareHomeVisitsOutbreak_{most_recent_date}.csv")))

g_board_older <- i_ch$`Table 3a` %>%
  process_visiting_status_table()

write_csv(g_board_older, glue(output_folder, glue("CareHomeVisitsBoardOlder_{most_recent_date}.csv")))

g_outbreak_older <- i_ch$`Table 3b` %>%
  process_visiting_status_table()

write_csv(g_outbreak_older, glue(output_folder, glue("CareHomeVisitsOutbreakOlder_{most_recent_date}.csv")))


rm(g_notes, g_board, g_outbreak, g_board_older, g_outbreak_older, i_ch, process_visiting_status_table)
