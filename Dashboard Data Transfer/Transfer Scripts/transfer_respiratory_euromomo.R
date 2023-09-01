# Dashboard data transfer for Euromomo
# Sourced from ../dashboard_data_transfer.R

##### Respiratory Euromomo

resp_od_output_folder <- paste0("/conf/linkage/output/Covid Daily Dashboard/", 
                                "Tableau process/Open Data/Respiratory/")

get_resp_year <- function(w, s){
  year <- case_when(w >= 1 & w <= 39 ~ paste0("20", substr(s, 6, 7)),
                    w >= 40 ~ paste0("20", substr(s, 3, 4)) ) %>%
    as.numeric()
  return(year)
}

assign(glue("i_respiratory_euromomo_agg"),
       read_csv_with_options(
         match_base_filename(
           glue("{input_data}/euromomo.csv"))))

df <- base::get(glue("i_respiratory_euromomo_agg"))

# Remove any instances where rate is NA
df <- df %>%
  filter(!is.na(zscore))

# Update column names
old_names <- names(df)
new_names <- old_names
new_names <- gsub("_", " ", new_names)
new_names <- str_to_title(new_names)
new_names <- gsub(" ", "", new_names)
setnames(df, old_names, new_names)

# Derive variables
df <- df %>%
  mutate(Date = ISOweek2date(paste0(Isoyear, "-W",
                                    str_pad(as.character(Isoweek), width = 2,
                                            side = "left", pad = "0"), "-7")),
         WeekEnding = as.Date(Date),
         WeekBeginning = as.Date(Date) - 6,
         ActivityLevel = factor(ActivityLevel, levels = c("Baseline", "Low",
                                                          "Moderate", "High", "Extraordinary"))) %>%
  rename(Year = Isoyear,
         ISOWeek = Isoweek,
         ZScore = Zscore) %>%
  select(-Date) 

# Derive week ord
df <- df %>%
  group_by(Season, Agegrp) %>%
  mutate(Weekord = row_number()) %>%
  ungroup()

df <- df %>%
  mutate(AgeGroup = case_when(
    Agegrp == "All Ages" ~ "All Ages",
    Agegrp == "g0-4" ~ "0-4 years",
    Agegrp == "g5-14" ~ "5-14 years",
    Agegrp == "g15-64" ~ "15-64 years",
    Agegrp == "g65+" ~ "65+ years",
    TRUE ~ NA
  )) %>%
  select(-Agegrp) %>%
  select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, 
         AgeGroup, ZScore, ActivityLevel, everything())

# Assign to new object
assign(glue("respiratory_euromomo"), df)
rm(df)

# Output
write_csv(respiratory_euromomo, glue(output_folder, "Respiratory_Euromomo.csv"))
