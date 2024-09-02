# Dashboard data transfer for Respiratory Pathogens - MEM
# Sourced from ../dashboard_data_transfer.R

##### Respiratory MEM

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


get_resp_year <- function(w, s){
  year <- case_when(w >= 1 & w <= 39 ~ paste0("20", substr(s, 6, 7)),
                    w >= 40 ~ paste0("20", substr(s, 3, 4)) ) %>%
    as.numeric()
  return(year)
}

filenames1 <- c("flu", "nonflu")
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
             Pathogen = str_to_title(Pathogen),
             ActivityLevel = factor(ActivityLevel, levels = c("Baseline", "Low",
                                                              "Moderate", "High", "Extraordinary"))) %>%
      rename(ISOWeek = Week,
             RatePer100000 = Rate) %>%
      select(-Date, -Measure) 
    
    if(filename2 == "hb"){
      df <- df %>%
        mutate(HB = recode(Healthboard, !!!healthboards, .default = NA_character_),
               HBName = paste0("NHS ", phsmethods::match_area(HB))) %>%
        rename(HBCode = Healthboard) %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, HBCode, 
               HB, HBName, Pathogen, RatePer100000, ActivityLevel, everything())
      
    } else if(filename2 == "agegp"){
      df <- df %>%
        mutate(AgeGroup = case_when(
          Agegp == "gunder1" ~ "< 1 years",
          Agegp == "g1to4" ~ "1-4 years",
          Agegp == "g5to14" ~ "5-14 years",
          Agegp == "g15to44" ~ "15-44 years",
          Agegp == "g45to64" ~ "45-64 years",
          Agegp == "g65to74" ~ "65-74 years",
          Agegp == "g75plus" ~ "75+ years",
          TRUE ~ NA
        )) %>%
        select(-Agegp) %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, 
               AgeGroup, Pathogen, RatePer100000, ActivityLevel, everything())
    } else{
      df <- df %>%
        select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, 
               Pathogen, RatePer100000, ActivityLevel, everything())
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

# Combine flu and non flu datasets
for (filename2 in filenames2){
  
  combined_df <- bind_rows(base::get(glue("respiratory_flu_MEM_{filename2}")),
                           base::get(glue("respiratory_nonflu_MEM_{filename2}")))
  # Assign to new object
  assign(glue("respiratory_pathogens_MEM_{filename2}"), combined_df)
  rm(combined_df)
}

# Order datasets
respiratory_pathogens_MEM_scotland <- respiratory_pathogens_MEM_scotland %>%
  arrange(WeekBeginning, Pathogen)
respiratory_pathogens_MEM_hb <- respiratory_pathogens_MEM_hb %>%
  arrange(WeekBeginning, HBName, Pathogen)
respiratory_pathogens_MEM_agegp <- respiratory_pathogens_MEM_agegp %>%
  arrange(WeekBeginning, AgeGroup, Pathogen)

# create small dataframe for use in maps
respiratory_pathogens_MEM_hb_two_seasons<-respiratory_pathogens_MEM_hb %>%
  filter(Season=="2022/2023" | Season=="2023/2024") %>% 
  select(WeekEnding, Season, Year, ISOWeek,HB, HBName, Pathogen, 
         RatePer100000,ActivityLevel, Weekord ) %>% 
  mutate(ActivityLevelColour = case_when(
    ActivityLevel == "Baseline" ~ "#01A148",
    ActivityLevel == "Low" ~ "#FFDE17",
    ActivityLevel == "Moderate" ~ "#F36523",
    ActivityLevel == "High" ~ "#ED1D24",
    ActivityLevel == "Extraordinary" ~ "#7D4192"  )) %>%
  mutate(Pathogen=if_else(Pathogen=="Coronavirus","Seasonal Coronavirus (non-COVID-19)" ,Pathogen),
         Pathogen= factor(Pathogen,levels = c("Influenza",
                                              "Respiratory Syncytial Virus",
                                              "Adenovirus","Human Metapneumovirus",
                                              "Mycoplasma Pneumoniae",
                                              "Parainfluenza Virus","Rhinovirus","Seasonal Coronavirus (non-COVID-19)"
         )))  %>%
  arrange(HBName, Pathogen)


# Output
write_csv(respiratory_pathogens_MEM_scotland, glue(output_folder, "Respiratory_Pathogens_MEM_Scot.csv"))
write_csv(respiratory_pathogens_MEM_hb, glue(output_folder, "Respiratory_Pathogens_MEM_HB.csv"))
write_csv(respiratory_pathogens_MEM_agegp, glue(output_folder, "Respiratory_Pathogens_MEM_Age.csv"))


#for use in mem maps
write_csv(respiratory_pathogens_MEM_hb_two_seasons, glue(output_folder, "Respiratory_Pathogens_MEM_HB_Two_Seasons.csv"))

