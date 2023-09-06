# Dashboard data transfer for Respiratory NHS24 - MEM
# Sourced from ../dashboard_data_transfer.R

##### NHS24 MEM

# HB recoding
healthboards <- c("AA" = "S08000015",
                  "BR" = "S08000016",
                  "DG" = "S08000017",
                  "FF" = "S08000029",
                  "FV" = "S08000019",
                  "GC" = "S08000031",
                  "GR" = "S08000020",
                  "HG" = "S08000022",
                  "LN" = "S08000032",
                  "LO" = "S08000024",
                  "OR" = "S08000025",
                  "SH" = "S08000026",
                  "TY" = "S08000030",
                  "WI" = "S08000028")

resp_od_output_folder <- paste0("/conf/linkage/output/Covid Daily Dashboard/",
                                "Tableau process/Open Data/Respiratory/")

get_resp_year <- function(w, s){
  year <- case_when(w >= 1 & w <= 39 ~ paste0("20", substr(s, 6, 7)),
                    w >= 40 ~ paste0("20", substr(s, 3, 4)) ) %>%
    as.numeric()
  return(year)
}

filenames1 <- c("NHS24")
filenames2 <- c("scotland", "hb", "agegp")

## Getting respiratory data
for (filename1 in filenames1){
  for(filename2 in filenames2){

    assign(glue("i_respiratory_{filename1}_MEM_{filename2}_agg"),
           read_csv_with_options(
             match_base_filename(
               glue("{input_data}/{filename1}_MEM_{filename2}_agg.csv")
             )
           )
    )
  }
}

# Recoding variables/variable names
for (filename1 in filenames1){
  for(filename2 in filenames2){

    df <- base::get(glue("i_respiratory_{filename1}_MEM_{filename2}_agg"))

    # Remove any instances where rate is NA
    df <- df %>%
      filter(!is.na(rate))

    # Update column names
    old_names <- names(df)
    new_names <- old_names
    new_names <- gsub("_", " ", new_names)
    new_names <- str_to_title(new_names)
    new_names <- gsub(" ", "", new_names)
    setnames(df, old_names, new_names)

    # Derive variables
    df <- df %>%
      mutate(Date = ISOweek2date(paste0(Year, "-W",
                                        str_pad(as.character(Week), width = 2,
                                                side = "left", pad = "0"), "-7")),
             WeekEnding = as.Date(Date),
             WeekBeginning = as.Date(Date) - 6,
             #Pathogen = str_to_title(Pathogen),
             ActivityLevel = factor(ActivityLevel, levels = c("Baseline", "Low",
                                                              "Moderate", "High", "Extraordinary"))) %>%
      rename(ISOWeek = Week,
             Percentage = Rate) %>%
      select(-Date, -Measure)

    if(filename2 == "hb"){
      df <- df %>%
        mutate(HB = recode(Healthboard, !!!healthboards, .default = NA_character_),
               HBName = paste0("NHS ", phsmethods::match_area(HB))) %>%
        rename(HBCode = Healthboard) %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, HBCode,
               HB, HBName, Percentage, ActivityLevel, everything())

    } else if(filename2 == "agegp"){
      df <- df %>%
        mutate(AgeGroup = case_when(
          Agegp == "<1" ~ "< 1 years",
          #Agegp == "g1to4" ~ "1-4 years",
          Agegp == "1-4" ~ "1-4 years",
          Agegp == "5-14" ~ "5-14 years",
          Agegp == "15-44" ~ "15-44 years",
          Agegp == "45-64" ~ "45-64 years",
          Agegp == "65-74" ~ "65-74 years",
          Agegp == "75+" ~ "75+ years",
          TRUE ~ NA
        )) %>%
        select(-Agegp) %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord,
               AgeGroup, Percentage, ActivityLevel, everything())
    } else{
      df <- df %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord,
               Percentage, ActivityLevel, everything())
    }

    # Assign to new object
    assign(glue("respiratory_{filename1}_MEM_{filename2}"), df)
    rm(df)
  }
}

# Need to add 'All ages' into age datasets
for (filename1 in filenames1){

  df_scot <- base::get(glue("respiratory_{filename1}_MEM_scotland")) %>%
    tibble::add_column(AgeGroup = "All Ages", .after = "Weekord")

  df_age <- bind_rows(base::get(glue("respiratory_{filename1}_MEM_agegp")),
                      df_scot) %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("< 1 years", "1-4 years",
                                                  "5-14 years", "15-44 years",
                                                  "45-64 years", "65-74 years",
                                                  "75+ years", "All Ages")))

  # Assign to new object
  assign(glue("respiratory_{filename1}_MEM_agegp"), df_age)
  rm(df_scot, df_age)

}

# Order datasets
respiratory_NHS24_MEM_scotland <- respiratory_NHS24_MEM_scotland %>%
  arrange(WeekBeginning)
respiratory_NHS24_MEM_hb <- respiratory_NHS24_MEM_hb %>%
  arrange(WeekBeginning, HBName)
respiratory_NHS24_MEM_agegp <- respiratory_NHS24_MEM_agegp %>%
  arrange(WeekBeginning, AgeGroup)

# Output
write_csv(respiratory_NHS24_MEM_scotland, glue(output_folder, "Respiratory_NHS24_MEM_Scot.csv"))
write_csv(respiratory_NHS24_MEM_hb, glue(output_folder, "Respiratory_NHS24_MEM_HB.csv"))
write_csv(respiratory_NHS24_MEM_agegp, glue(output_folder, "Respiratory_NHS24_MEM_Age.csv"))





