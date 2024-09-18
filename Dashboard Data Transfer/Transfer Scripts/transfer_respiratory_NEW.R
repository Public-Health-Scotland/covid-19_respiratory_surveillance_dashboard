
# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

# Seasons to include
resp_seasons_to_include <- c("2016/17", "2017/18", "2018/19", "2019/20", "2020/21",
                             "2021/22", "2022/23", "2023/24")

##### Respiratory
get_resp_year <- function(w, s){
  year <- case_when(w >= 1 & w <= 39 ~ paste0("20", substr(s, 6, 7)),
                    w >= 40 ~ paste0("20", substr(s, 3, 4)) ) %>%
    as.numeric()
  return(year)
}

filenames <- c("scotland", "agegp_sex", "agegp", "sex", "hb")

## Getting respiratory data
for (filename in filenames){
  assign(glue("i_respiratory_{filename}_agg"),
         read_csv_with_options(
           match_base_filename(
             glue("{input_data}/NEW_{filename}_agg.csv")
           )
         )
  )
}

## Getting respiratory data
for (filename in filenames){

  temp_data <- base::get(glue("i_respiratory_{filename}_agg"))

  # Remove parainfluenza subtypes
  temp_data <- temp_data %>%
    filter(!pathogen %in% c("Parainfluenza (Type Not Known)", "Parainfluenza Type 1", "Parainfluenza Type 2",
                            "Parainfluenza Type 3", "Parainfluenza Type 4"))

  # Recode pathogen names
  temp_data <- temp_data %>%
    mutate(pathogen = recode(pathogen,
                             "Adenovirus" = "adeno",
                             "Seasonal coronavirus" = "coron",
                             "Parainfluenza (Any Type)" = "para",
                             "Rhinovirus" = "rhino",
                             "RSV" = "rsv",
                             "Mycoplasma pneumoniae" = "mpn",
                             "HMPV" = "hmpv",
                             "Influenza (A or B)" = "fluaorb",
                             "Influenza A (Any Subtype)" = "typea",
                             "Influenza A (Subtype Not Known)" = "unknowna",
                             "Influenza B" = "typeb",
                             "Influenza A(H3)" = "typeah3",
                             "Influenza A(H1N1)pdm09" = "h1n1"))

  if(filename %in% c("agegp", "agegp_sex")){

    # Recode age
    temp_data <- temp_data %>%
      mutate(agegp = recode(agegp,
                            "gunder1" = "<1",
                            "g1to4" = "1-4",
                            "g5to14" = "5-14",
                            "g15to44" = "15-44",
                            "g45to64" = "45-64",
                            "g65to74" = "65-74",
                            "g75plus" = "75+"))

  }

  if(filename == "agegp_sex"){

    # Recode season
    temp_data <- temp_data %>%
      mutate(season = paste0(substr(season,1,5), substr(season,8,9)))

  }

  # Only keep data in seasons we want to include in dashboard
  temp_data <- temp_data %>%
    filter(season %in% resp_seasons_to_include)

  assign(glue("i_respiratory_{filename}_agg"), temp_data)

}

##  create dictionaries so we can make new column names with meaningful data for user
flu <- c("fluaorb", "h1n1", "typea", "typeah3", "typeb", "unknowna")
nonflu <- c("adeno", "coron", "hmpv", "mpn", "para", "rhino", "rsv")

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

organism <- c("fluaorb" = "Influenza - Type A or B",
              "h1n1" = "Influenza - Type A(H1N1)pdm09",
              "typea" = "Influenza - Type A (any subtype)",
              "typeah3" = "Influenza - Type A(H3)",
              "typeb" = "Influenza - Type B",
              "unknowna" = "Influenza - Type A (not subtyped)",
              "adeno" = "Adenovirus",
              "coron" = "Seasonal coronavirus (Non-SARS-CoV-2)",
              "hmpv" = "Human metapneumovirus",
              "mpn" = "Mycoplasma pneumoniae",
              "para" = "Parainfluenza virus",
              "rhino" = "Rhinovirus",
              "rsv" = "Respiratory syncytial virus")

for(filename in filenames) {

  # 1.  e.g. scotland_agg, agegp_sex_agg, ...
  df1 <- base::get(glue("i_respiratory_{filename}_agg")) %>%
    mutate(year = get_resp_year(week, season),
           date = ISOweek2date(paste0(year, "-W",
                                      str_pad(as.character(week), width = 2,
                                              side = "left", pad = "0"), "-7"))) %>%
    mutate(flu_nonflu = case_when(pathogen %in% flu ~ "flu",
                                  pathogen %in% nonflu ~ "nonflu",
                                  TRUE ~ NA_character_)) %>%
    clean_names()

  if(filename == "scotland"){

    df1 %<>% mutate(scotland_by_organism_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    HealthBoard = "Scotland",
                    breakdown = "Scotland")

  } else if (filename == "agegp_sex") {

    df1 %<>% mutate(agegp = ifelse(agegp == "01-Apr", "1-4",
                                   ifelse(agegp == "May-14", "5-14", agegp)),
                    scotland_by_organism_age_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    breakdown = paste0(agegp,"_",sex))

  } else if (filename == "agegp"){

    df1 %<>% mutate(agegp = ifelse(agegp == "01-Apr", "1-4",
                                   ifelse(agegp == "May-14", "5-14", agegp)),
                    scotland_by_organism_age_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    breakdown = agegp)

  } else if (filename == "sex") {

    df1 %<>% mutate(scotland_by_organism_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    breakdown = sex)

  } else if (filename == "hb") {

    df1 %<>% mutate(organism_by_hb_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    HealthboardCode = recode(health_board, !!!healthboards, .default = NA_character_),
                    breakdown = HealthboardCode) %>%
      filter(!is.na(health_board))

  }

  assign(glue("{filename}_agg"), df1)

  # 2. scotland flu and non-flu totals
  df2 <- df1 %>%
    filter(!pathogen %in% c("h1n1", "typea", "typeah3", "typeb", "unknowna")) %>%
    group_by(season, week, weekord, date, pop, measure, breakdown, flu_nonflu) %>%
    summarise(count = sum(count)) %>%
    mutate(rate = round_half_up((count/pop)*100000, 2),
           pathogen = "Total",
           organism = "Total",
           countQF = "d",
           rateQF = "d")

  if(filename == "scotland"){

    df2 %<>% mutate(total_number_flag = 1,
                    HealthBoard = "Scotland")

  } else if (filename == "agegp_sex") {

    df2 %<>% mutate(scotland_by_age_sex_flag = 1,
                    agegp = sub("_.*", "", breakdown),
                    sex = sub(".*_", "", breakdown))

  } else if (filename == "agegp"){

    df2 %<>% mutate(scotland_by_age_flag = 1,
                    agegp = breakdown)

  } else if (filename == "sex") {

    df2 %<>% mutate(scotland_by_sex_flag = 1,
                    sex = breakdown)

  } else if (filename == "hb") {

    df2 %<>% mutate( hb_flag = 1,
                     HealthboardCode = breakdown)

  }
  # 3. scotland_flu_total, ...
  df3 <- df2 %>% filter(flu_nonflu == "flu")
  df4 <- df2 %>% filter(flu_nonflu == "nonflu")

  assign(glue("{filename}_flu_total"), df3)
  assign(glue("{filename}_non_flu_total"), df4)

  if (filename == "agegp_sex") {

    df5 <- df2 %>%
      filter(flu_nonflu == "flu") %>%
      group_by(season, pop, measure, breakdown, flu_nonflu, pathogen, organism, agegp, sex) %>%
      summarise(date = max(date),
                count = sum(count)) %>%
      ungroup() %>%
      mutate(rate = round_half_up((count/pop)*100000, 2),
             countQF = "d",
             rateQF = "d",
             pathogen = "Season Total",
             organism = "Season Total",
             scotland_by_age_sex_season_flag = 1)

    assign(glue("{filename}_flu_season_total"), df5)

  }

}

g_resp_data <- bind_rows(
  scotland_agg,
  agegp_sex_agg,
  agegp_agg,
  sex_agg,
  hb_agg,
  scotland_non_flu_total,
  agegp_non_flu_total,
  sex_non_flu_total,
  agegp_sex_non_flu_total,
  hb_non_flu_total,
  scotland_flu_total,
  agegp_flu_total,
  sex_flu_total,
  agegp_sex_flu_total,
  hb_flu_total,
  agegp_sex_flu_season_total) %>%
  mutate(count = as.numeric(count),
         agegp = factor(agegp,
                        levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+"))
  ) %>%
  dplyr::rename(Season = season,
                Pathogen = pathogen,
                Week = week,
                Weekord = weekord,
                Count = count,
                Measure = measure,
                Population = pop,
                Rate = rate,
                Year = year,
                Date = date,
                FluOrNonFlu = flu_nonflu,
                Organism = organism,
                BreakDown = breakdown,
                Healthboard = HealthBoard,
                AgeGroup = agegp,
                Sex = sex,
                HealthboardCode = HealthboardCode,
                CountQF = countQF,
                RateQF = rateQF) %>%
  select(Season, Date, Week, Year, Weekord, Measure, FluOrNonFlu, Organism, BreakDown, Healthboard, AgeGroup, Sex, Count, CountQF, Rate, RateQF,
         Population,Pathogen, HealthboardCode, total_number_flag, scotland_by_age_flag, scotland_by_sex_flag, scotland_by_age_sex_flag, hb_flag,
         scotland_by_organism_flag, scotland_by_organism_age_sex_flag, scotland_by_organism_age_flag, scotland_by_organism_sex_flag,
         organism_by_hb_flag, scotland_by_age_sex_season_flag)

#### Create Summary Table
sequence = c("PreviousWeek", "PreviousWeek", "ThisWeek", "ThisWeek")

# get total flu and non-flu cases
g_resp_summary_totals <- g_resp_data %>%
  filter(total_number_flag == 1) %>%
  arrange(Date) %>%
  tail(4) %>%
  mutate(Breakdown = "Scotland Total") %>%
  bind_cols(., sequence) %>%
  rename(ReportingWeek = "...32") %>%
  select(ReportingWeek, Date, Count, CountQF, Rate, RateQF, Breakdown, FluOrNonFlu) %>%
  pivot_wider(., names_from = c("ReportingWeek"), values_from = c("Count", "Date", "Rate")) %>%
  dplyr::rename(CountPreviousWeek = Count_PreviousWeek,
                CountThisWeek = Count_ThisWeek,
                RatePreviousWeek = Rate_PreviousWeek,
                RateThisWeek = Rate_ThisWeek,
                DatePreviousWeek = Date_PreviousWeek,
                DateThisWeek = Date_ThisWeek) %>%
  mutate(Difference = CountThisWeek-CountPreviousWeek,
         PercentageDifference = round((Difference/CountPreviousWeek)*100, 0),
         ChangeFactor = case_when(PercentageDifference < 0 ~ "decrease",
                                  PercentageDifference > 0 ~ "increase",
                                  PercentageDifference == 0 ~ "no change")) %>%
  mutate(SummaryMeasure = "Scotland_Total") %>% select(
    DateThisWeek, DatePreviousWeek,
    Breakdown, FluOrNonFlu,
    CountThisWeek, CountPreviousWeek,  CountQF,
    RateThisWeek, RatePreviousWeek, RateQF,
    Difference, PercentageDifference, ChangeFactor,
    SummaryMeasure)

g_resp_summary <- bind_rows(

  g_resp_data %>%
    filter(scotland_by_organism_flag == 1) %>%
    arrange(desc(Date)) %>%
    group_by(Organism) %>%
    filter(Date == max(Date)) %>%
    ungroup() %>%
    filter(Date == max(Date)) %>%
    mutate(Breakdown = Organism) %>%
    select(Date, Count, CountQF, Rate, RateQF, Breakdown, FluOrNonFlu) %>%
    mutate(SummaryMeasure = "Scotland_by_Organism_Total"),

  g_resp_data %>%
    filter(hb_flag == 1) %>%
    arrange(desc(Date)) %>%
    group_by(HealthboardCode) %>%
    filter(Date == max(Date)) %>%
    ungroup() %>%
    filter(Date == max(Date)) %>%
    mutate(Breakdown = HealthboardCode) %>%
    select(Date, Count, CountQF, Rate, RateQF, Breakdown, FluOrNonFlu) %>%
    mutate(SummaryMeasure = "Healthboard_Total")

) %>% select(
  Date,
  Breakdown, FluOrNonFlu,
  Count,  CountQF,
  Rate, RateQF,
  SummaryMeasure)

# Adding Scotland HB code for Scotland entries
g_resp_data %<>% mutate(HealthboardCode = ifelse((!is.na(Healthboard) & Healthboard == "Scotland"),
                                                 "S92000003", HealthboardCode))

# Checks on aggregated data
#source("Transfer Scripts/respiratory_checks.R")

# Output
write_csv(g_resp_data, glue(output_folder, "Respiratory_AllData.csv"))
write_csv(g_resp_summary_totals, glue(output_folder, "Respiratory_Summary_Totals.csv"))
write_csv(g_resp_summary, glue(output_folder, "Respiratory_Summary.csv"))

### Create additional outputs for data download section ###

# Function that creates template with all possible
# combinations of supplied variables
create_template <- function(data, template_variables){

  for(i in 1:length(template_variables)){

    # Create empty list
    empty_list <- list()

    # Get unique values of variable
    df <- data %>%
      select(template_variables[i]) %>%
      unique()

    # Turn to vector and sort
    vec <- sort(df[[template_variables[i]]])

    # Add to list
    if(i == 1){
      vecs <- c(empty_list, list(vec))
    } else{
      vecs <- c(vecs, list(vec))
    }

  }

  # Create template
  template <- expand.grid(vecs)

  # Update variable names
  colnames(template) <- template_variables

  # Tidy up template
  template <- template %>%
    arrange(across(everything()))
}

# Create templates
cases_scotland_template <- create_template(scotland_agg, c("date", "organism"))
case_rates_hb_template <- create_template(hb_agg, c("date", "HealthboardCode", "organism"))
case_rates_age_template <- create_template(agegp_agg, c("date", "agegp", "pathogen"))
case_rates_sex_template <- create_template(sex_agg, c("date", "sex", "organism"))
case_rates_age_sex_template <- create_template(agegp_sex_agg, c("date", "agegp", "sex", "organism"))

# Weekly cases by pathogen in Scotland
cases_scotland <- cases_scotland_template %>%
  full_join(scotland_agg) %>%
  mutate(count = ifelse(is.na(count), 0, count)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         NumberCasesPerWeek = count,
         Pathogen = organism) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(as.character(WeekEnding)),
         WeekBeginning = as.numeric(as.character(WeekBeginning))) %>%
  select(WeekBeginning, WeekEnding, Pathogen, NumberCasesPerWeek) %>%
  arrange(WeekBeginning, WeekEnding, Pathogen)

# Weekly case rates by pathogen in Scotland
case_rates_scotland <- cases_scotland_template %>%
  full_join(scotland_agg) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         RatePer100000 = rate,
         HB = "S92000003",
         HBQF = "d",
         HBName = "Scotland",
         Pathogen = organism) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(as.character(WeekEnding)),
         WeekBeginning = as.numeric(as.character(WeekBeginning))) %>%
  select(WeekBeginning, WeekEnding, HB, HBQF, HBName, Pathogen, RatePer100000)

# Weekly case rates by pathogen and HB
case_rates_hb <- case_rates_hb_template %>%
  full_join(hb_agg) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  filter(!is.na(HealthboardCode)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         HB = HealthboardCode,
         HBQF = "",
         HBName = paste0("NHS ", phsmethods::match_area(HealthboardCode)),
         Pathogen = organism,
         RatePer100000 = rate) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(WeekEnding),
         WeekBeginning = as.numeric(WeekBeginning)) %>%
  select(WeekBeginning, WeekEnding, HB, HBQF, HBName, Pathogen, RatePer100000) %>%
  bind_rows(case_rates_scotland) %>%
  arrange(WeekBeginning, WeekEnding, HB, Pathogen)

# Weekly case rates by pathogen and age in Scotland
case_rates_age <- case_rates_age_template %>%
  full_join(agegp_agg) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         AgeGroup = factor(agegp, levels = c("<1", "1-4", "5-14", "15-44",
                                             "45-64", "65-74", "75+")),
         RatePer100000 = rate,
         Pathogen = recode(pathogen,
                           "fluaorb" = "Influenza - Type A or B",
                           "h1n1" = "Influenza - Type A(H1N1)pdm09",
                           "typea" = "Influenza - Type A (any subtype)",
                           "typeah3" = "Influenza - Type A(H3)",
                           "typeb" = "Influenza - Type B",
                           "unknowna" = "Influenza - Type A (not subtyped)",
                           "adeno" = "Adenovirus",
                           "coron" = "Seasonal coronavirus (Non-SARS-CoV-2)",
                           "hmpv" = "Human metapneumovirus",
                           "mpn" = "Mycoplasma pneumoniae",
                           "para" = "Parainfluenza virus",
                           "rhino" = "Rhinovirus",
                           "rsv" = "Respiratory syncytial virus")) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(as.character(WeekEnding)),
         WeekBeginning = as.numeric(as.character(WeekBeginning))) %>%
  select(WeekBeginning, WeekEnding, AgeGroup, Pathogen, RatePer100000) %>%
  arrange(WeekBeginning, WeekEnding, AgeGroup, Pathogen) %>%
  mutate(AgeGroup = paste0(AgeGroup, " years"))

# Weekly case rates by pathogen and sex in Scotland
case_rates_sex <- case_rates_sex_template %>%
  full_join(sex_agg) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         Sex = recode(sex, "F" = "Female", "M" = "Male"),
         RatePer100000 = rate,
         Pathogen = organism) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(as.character(WeekEnding)),
         WeekBeginning = as.numeric(as.character(WeekBeginning))) %>%
  select(WeekBeginning, WeekEnding, Sex, Pathogen, RatePer100000) %>%
  arrange(WeekBeginning, WeekEnding, Sex, Pathogen)

# Weekly case rates by pathogen, age, and sex in Scotland
case_rates_age_sex <- case_rates_age_sex_template %>%
  full_join(agegp_sex_agg) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         AgeGroup = factor(agegp, levels = c("<1", "1-4", "5-14", "15-44",
                                             "45-64", "65-74", "75+")),
         Sex = recode(sex, "F" = "Female", "M" = "Male"),
         RatePer100000 = rate,
         Pathogen = organism) %>%
  mutate(WeekEnding = gsub("-", "", as.character(WeekEnding)),
         WeekBeginning = gsub("-", "", as.character(WeekBeginning))) %>%
  mutate(WeekEnding = as.numeric(as.character(WeekEnding)),
         WeekBeginning = as.numeric(as.character(WeekBeginning))) %>%
  select(WeekBeginning, WeekEnding, AgeGroup, Sex, Pathogen, RatePer100000) %>%
  arrange(WeekBeginning, WeekEnding, AgeGroup, Sex, Pathogen) %>%
  mutate(AgeGroup = paste0(AgeGroup, " years"))

# Output
write_csv(cases_scotland, glue(output_folder, "Respiratory_Scot.csv"))
write_csv(case_rates_hb, glue(output_folder, "Respiratory_HB.csv"))
write_csv(case_rates_age, glue(output_folder, "Respiratory_Age.csv"))
write_csv(case_rates_sex, glue(output_folder, "Respiratory_Sex.csv"))
write_csv(case_rates_age_sex , glue(output_folder, "Respiratory_Age_Sex.csv"))

# Output to new output_folder Open Data subfolder with datestamp
write_csv(cases_scotland, glue(od_folder, "Respiratory_Scot_{od_report_date}.csv"))
write_csv(case_rates_hb, glue(od_folder, "Respiratory_HB_{od_report_date}.csv"))
write_csv(case_rates_age, glue(od_folder, "Respiratory_Age_{od_report_date}.csv"))
write_csv(case_rates_sex, glue(od_folder, "Respiratory_Sex_{od_report_date}.csv"))
write_csv(case_rates_age_sex , glue(od_folder, "Respiratory_Age_Sex_{od_report_date}.csv"))


### Create MEM files ###

# Weekly case rates and MEM by pathogen in Scotland
case_rates_scotland_mem <- cases_scotland_template %>%
  full_join(scotland_agg) %>%
  filter(!is.na(activity_level)) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         Season = season,
         Year = year,
         ISOWeek = week,
         Weekord = weekord,
         ActivityLevel = activity_level,
         LowThreshold = low_threshold,
         MediumThreshold = moderate_threshold,
         HighThreshold = high_threshold,
         ExtraordinaryThreshold = extraordinary_threshold,
         RatePer100000 = rate,
         Pathogen = organism) %>%
  mutate(Season = paste0(substr(Season, 1, 5), "20", substr(Season, 6, 7))) %>%
  mutate(Pathogen = recode(Pathogen,
                           "Human metapneumovirus" = "Human Metapneumovirus",
                           "Influenza - Type A or B" = "Influenza",
                           "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
                           "Respiratory syncytial virus" = "Respiratory Syncytial Virus",
                           "Parainfluenza virus" = "Parainfluenza Virus",
                           "Seasonal coronavirus (Non-SARS-CoV-2)" = "Coronavirus")) %>%
  select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, Pathogen, RatePer100000,
         ActivityLevel, LowThreshold, MediumThreshold, HighThreshold, ExtraordinaryThreshold) %>%
  arrange(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, Pathogen)

# Weekly case rates and MEM by pathogen and HB
case_rates_hb_mem <- case_rates_hb_template %>%
  full_join(hb_agg) %>%
  filter(!is.na(activity_level)) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         HBCode = health_board,
         HB = HealthboardCode,
         HBName = paste0("NHS ", phsmethods::match_area(HealthboardCode)),
         Season = season,
         Year = year,
         ISOWeek = week,
         Weekord = weekord,
         ActivityLevel = activity_level,
         LowThreshold = low_threshold,
         MediumThreshold = moderate_threshold,
         HighThreshold = high_threshold,
         ExtraordinaryThreshold = extraordinary_threshold,
         RatePer100000 = rate,
         Pathogen = organism) %>%
  mutate(Season = paste0(substr(Season, 1, 5), "20", substr(Season, 6, 7))) %>%
  mutate(Pathogen = recode(Pathogen,
                           "Human metapneumovirus" = "Human Metapneumovirus",
                           "Influenza - Type A or B" = "Influenza",
                           "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
                           "Respiratory syncytial virus" = "Respiratory Syncytial Virus",
                           "Parainfluenza virus" = "Parainfluenza Virus",
                           "Seasonal coronavirus (Non-SARS-CoV-2)" = "Coronavirus")) %>%
  select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, HBCode, HB, HBName, Pathogen, RatePer100000,
         ActivityLevel, LowThreshold, MediumThreshold, HighThreshold, ExtraordinaryThreshold) %>%
  arrange(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, HBCode, HB, HBName, Pathogen)


# Weekly case rates and MEM by pathogen and age
case_rates_age_mem <- case_rates_age_template %>%
  full_join(agegp_agg) %>%
  filter(!is.na(activity_level)) %>%
  mutate(rate = ifelse(is.na(rate), 0, rate)) %>%
  mutate(agegp = recode(agegp,
                        "<1" = "< 1 years",
                        "1-4" = "1-4 years",
                        "5-14" = "5-14 years",
                        "15-44" = "15-44 years",
                        "45-64" = "45-64 years",
                        "65-74" = "65-74 years",
                        "75+" = "75+ years")) %>%
  mutate(WeekEnding = as.Date(date),
         WeekBeginning = as.Date(date) - 6,
         AgeGroup = agegp,
         Season = season,
         Year = year,
         ISOWeek = week,
         Weekord = weekord,
         ActivityLevel = activity_level,
         LowThreshold = low_threshold,
         MediumThreshold = moderate_threshold,
         HighThreshold = high_threshold,
         ExtraordinaryThreshold = extraordinary_threshold,
         RatePer100000 = rate,
         Pathogen = organism) %>%
  mutate(Season = paste0(substr(Season, 1, 5), "20", substr(Season, 6, 7))) %>%
  mutate(Pathogen = recode(Pathogen,
                           "Human metapneumovirus" = "Human Metapneumovirus",
                           "Influenza - Type A or B" = "Influenza",
                           "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
                           "Respiratory syncytial virus" = "Respiratory Syncytial Virus",
                           "Parainfluenza virus" = "Parainfluenza Virus",
                           "Seasonal coronavirus (Non-SARS-CoV-2)" = "Coronavirus")) %>%
  select(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, AgeGroup, Pathogen, RatePer100000,
         ActivityLevel, LowThreshold, MediumThreshold, HighThreshold, ExtraordinaryThreshold) %>%
  bind_rows(case_rates_scotland_mem) %>%
  mutate(AgeGroup = ifelse(is.na(AgeGroup), "All Ages", AgeGroup)) %>%
  mutate(AgeGroup = factor(AgeGroup, levels = c("< 1 years", "1-4 years", "5-14 years", "15-44 years",
                                                "45-64 years", "65-74 years", "75+ years", "All Ages"))) %>%
  arrange(WeekBeginning, WeekEnding, Season, Year, ISOWeek, Weekord, AgeGroup, Pathogen)

# Output
write_csv(case_rates_scotland_mem, glue(output_folder, "Respiratory_Pathogens_MEM_Scot.csv"))
write_csv(case_rates_hb_mem, glue(output_folder, "Respiratory_Pathogens_MEM_HB.csv"))
write_csv(case_rates_age_mem, glue(output_folder, "Respiratory_Pathogens_MEM_Age.csv"))

# remove all data
rm(i_respiratory_scotland_agg, i_respiratory_agegp_agg,
   i_respiratory_agegp_sex_agg, i_respiratory_sex_agg, i_respiratory_hb_agg)
rm(scotland_agg, hb_agg, sex_agg, agegp_agg, agegp_sex_agg, scotland_non_flu_total,
   agegp_non_flu_total,
   sex_non_flu_total,
   agegp_sex_non_flu_total,
   hb_non_flu_total,
   scotland_flu_total,
   agegp_flu_total,
   sex_flu_total,
   agegp_sex_flu_total,
   hb_flu_total)
rm(hb_checks_this_week, agegp_checks_this_week, sex_checks_this_week, agegp_sex_checks_this_week,
   scotland_checks_prev_week, hb_checks_prev_week, agegp_checks_prev_week, sex_checks_prev_week, agegp_sex_checks_prev_week,
   scotland_colnames, hb_colnames, sex_colnames, agegp_colnames, agegp_sex_colnames,
   scotland_colnames_match,
   hb_colnames_match,
   sex_colnames_match,
   agegp_colnames_match,
   agegp_sex_colnames_match)
rm(g_resp_data, g_resp_summary, g_resp_summary_totals)
rm(cases_scotland, case_rates_scotland, case_rates_hb, case_rates_age,
   case_rates_sex, case_rates_age_sex)
rm(cases_scotland_template, case_rates_hb_template, case_rates_sex_template,
   case_rates_age_template, case_rates_age_sex_template)
rm(case_rates_scotland_mem, case_rates_hb_mem, case_rates_age_mem)


