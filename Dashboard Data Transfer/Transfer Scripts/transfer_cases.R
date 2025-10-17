# Dashboard data transfer for Cases
# Sourced from ../dashboard_data_transfer.R

##### Cases

i_cases <- read_all_excel_sheets(glue(input_data, "Lab_Data_New_{format(report_date-2, format='%Y-%m-%d')}.xlsx"))

g_cases <- i_cases$`Cumulative confirmed cases`

g_cases %<>%
  dplyr::rename(NumberCasesPerDay = `Number of cases per day`) %>%
  mutate(NumberCasesPerDay = as.numeric(NumberCasesPerDay),
         Cumulative = as.numeric(Cumulative))

pop_grandtotal <- i_population_v2 %>%
  filter(AgeGroup == "Total", Sex == "Total") %>%
  .$PopNumber

g_cases %<>%
  mutate(SevenDayAverage = round_half_up(zoo::rollmean(NumberCasesPerDay, k = 7, fill = NA, align="right"),0),
         SevenDayAverageQF = ifelse(is.na(SevenDayAverage), "z", ""),
         CumulativeRatePer100000 = round_half_up(100000 * Cumulative / pop_grandtotal,1),
         Date = format(Date, "%Y%m%d"))


write_csv(g_cases, glue(output_folder, "Cases.csv"))

g_cases_weekly <- i_cases$`Cumulative confirmed cases`

g_cases_weekly %<>%
  mutate(WeekEnding = ceiling_date(
    as.Date(Date),unit="week",week_start=7, change_on_boundary=FALSE)) %>%
  dplyr::rename(NumberCasesPerWeek = `Number of cases per day`) %>%
  mutate(NumberCasesPerWeek = as.numeric(NumberCasesPerWeek),
         Cumulative = as.numeric(Cumulative)) %>%
  group_by(WeekEnding) %>%
  summarise(NumberCasesPerWeek = sum(NumberCasesPerWeek)) %>%
  mutate(Cumulative = cumsum(NumberCasesPerWeek)) %>%
  mutate(WeekEnding = format(WeekEnding, "%Y%m%d"))

write_csv(g_cases_weekly, glue(output_folder, "Cases_Weekly.csv"))


rm(i_cases, g_cases, pop_grandtotal)

get_scotland_population <- function(population_year) {
  gpd_base_path <- "/conf/linkage/output/lookups/Unicode/"
  
  base_hb_population <- readRDS(
    glue("{gpd_base_path}Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_{pop_year}.rds")
  )
  
  pop_total <- base_hb_population %>%
    filter(year == population_year) %>%
    summarise(pop = sum(pop)) %>%
    pull(pop)
  
  return(pop_total)
}

population_this_season <- get_scotland_population(pop_year)
population_last_season <- get_scotland_population(pop_year - 1)
population_two_seasons_ago <- get_scotland_population(pop_year - 2)


SeasonStartWeek <- "40"  
covid_cases_weekly <- g_cases_weekly %>%
  mutate(
    WeekEnding = as.Date(as.character(WeekEnding), format = "%Y%m%d"),
    ISOWeekFull = ISOweek::ISOweek(WeekEnding),
    Year = str_sub(ISOWeekFull, 1, 4),
    ISOWeek = str_sub(ISOWeekFull, -2, -1),
    Flu_Season = case_when(
      str_sub(ISOWeekFull, -2, -1) < SeasonStartWeek ~ paste(as.numeric(Year) - 1, "/", Year, sep = ""),
      TRUE ~ paste(Year, "/", as.numeric(Year) + 1, sep = "")
    ),
    RatePer100000 = case_when(
      as.numeric(Year) >= pop_year ~ (NumberCasesPerWeek / population_this_season) * 100000,
      as.numeric(Year) >= (pop_year - 1) ~ (NumberCasesPerWeek / population_last_season) * 100000,
      as.numeric(Year) >= (pop_year - 2) ~ (NumberCasesPerWeek / population_two_seasons_ago) * 100000,
      TRUE ~ NA_real_  
    ),
    Weekord = case_when(
      as.numeric(str_sub(ISOWeekFull, -2, -1)) >= 40 ~ as.numeric(str_sub(ISOWeekFull, -2, -1)) - 39,
      TRUE ~ as.numeric(str_sub(ISOWeekFull, -2, -1)) + (52 - 39)
    )
  ) %>%
  #This filters to the previous 3 seasons from this year (it may potentially catch another season, but it is what it is)
  filter(as.numeric(Year) >= (as.numeric(format(Sys.Date(), "%Y")) - 3)) %>% 
  rename(Season = Flu_Season)

write_csv(covid_cases_weekly, glue(output_folder, "covid_cases_weekly.csv"))

#select the latest sex_agg_data file. Check that the latest file in the one you want to use
# Define the directory path
dir_path <- "/PHI_conf/Respiratory_Surveillance_Viral/Dashboard/Data/Lab Surveillance/Non-COVID Viral Pathogens"

# List all CSV files containing 'sex_agg' in the name
csv_files <- list.files(path = dir_path, pattern = "sex_agg.*\\.csv$", full.names = TRUE)

# Get file info and sort by modification time
file_info <- file.info(csv_files)
latest_file <- rownames(file_info[order(file_info$mtime, decreasing = TRUE),])[1]

# Assign to variable
file_path_sex_agg_data <- latest_file

# Print the selected file path
print(paste("Latest sex_agg CSV file selected:", file_path_sex_agg_data))

sex_agg_data <- read_csv(file_path_sex_agg_data)

# list of pathogen names
all_pathogens_list <- c("COVID-19", "Adenovirus", "HMPV", "Influenza (A or B)",
                        "Mycoplasma pneumoniae", "Parainfluenza (Any Type)",
                        "RSV", "Rhinovirus", "Seasonal coronavirus")

sex_agg_data_final <- sex_agg_data %>%
  filter(pathogen %in% all_pathogens_list) %>%
  group_by(season, pathogen, year, week, weekord, measure) %>%
  summarise(
    count = sum(count, na.rm = TRUE),
    Pop = sum(Pop, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    rate = round((count / Pop) * 100000, 4),
    ISOweek_string = paste0(year, "-W", stringr::str_pad(week, 2, pad = "0"), "-1"),
    ISOweek_beginning = ISOweek::ISOweek2date(ISOweek_string),
    season = ifelse(
      stringr::str_detect(season, "^\\d{4}/\\d{2}$"),
      paste0(
        stringr::str_extract(season, "^\\d{4}"), "/",
        as.character(as.numeric(stringr::str_extract(season, "\\d{2}$")) + 2000)
      ),
      season
    )
  ) %>%
  select(-ISOweek_string, -measure) %>%
  rename(
    FluSeason = season,
    Organism = pathogen,
    Year = year,
    ISOweek = week
  ) %>%
  arrange(Year, ISOweek)


covid_cases_weekly_to_join <- covid_cases_weekly %>%
  mutate(
    ISOweek_beginning = ISOweek::ISOweek2date(paste0(ISOWeekFull, "-1")),
    Organism = "COVID-19",
    Year = as.numeric(substr(Season, 1, 4))
  ) %>%
  rename(
    ISOweek = ISOWeek,
    weekord = Weekord,
    FluSeason = Season,
    rate = RatePer100000,
    count = NumberCasesPerWeek
  ) %>%
  mutate(ISOweek = as.numeric(ISOweek))



# Step 1: Combine and filter the data
combined_data <- bind_rows(sex_agg_data_final, covid_cases_weekly_to_join) %>%
  select(FluSeason, Organism, Year, ISOweek, weekord, count, Pop, rate, ISOweek_beginning) %>%
  filter(Year >= (year(Sys.Date()) - 2)) %>%
  arrange(Year, ISOweek)

# Step 2: Get unique years
unique_years <- sort(unique(combined_data$Year))

# Step 3: Create a named vector of population estimates
pop_lookup <- map_dbl(unique_years, function(y) {
  pop <- get_scotland_population(y)
  # If pop is 0, look back until a non-zero value is found
  while (pop == 0 && y > min(unique_years)) {
    y <- y - 1
    pop <- get_scotland_population(y)
  }
  return(pop)
})
names(pop_lookup) <- unique_years

# Step 4: Populate the Pop column using the lookup
all_pathogen_data <- combined_data %>%
  mutate(Pop = pop_lookup[as.character(Year)]) %>%
  mutate(rate = round((count / Pop) * 100000, 4)) %>%
  mutate(Organism = recode(Organism,
                           "HMPV" = "Human metapneumovirus (HMPV)",
                           "Seasonal coronavirus" = "Seasonal coronavirus (non-COVID-19)"
                           
  )) 

write_csv(all_pathogen_data, glue(output_folder, "all_pathogen_data.csv"))






