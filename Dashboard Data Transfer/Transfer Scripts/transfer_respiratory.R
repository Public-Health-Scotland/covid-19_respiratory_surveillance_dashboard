# Dashboard data transfer for Admissions
# Sourced from ../dashboard_data_transfer.R

##### Respiratory

get_resp_year <- function(w, s){
  year <- case_when(w < 14 ~ paste0("20", substr(s, 3, 4)),
                    w >= 14 ~ paste0("20", substr(s, 6, 7)) ) %>%
                      as.numeric()

  return(year)
}

filenames <- c("scotland", "agegp_sex", "agegp", "sex", "hb")

## Getting respiratory data
for (filename in filenames){
  assign(glue("i_respiratory_{filename}_agg"), read_csv_with_options(glue("{input_data}/{filename}_agg.csv")))
}


##  create dictionaries so we can make new column names with meaningful data for user
flu <- c("fluaorb", "h1n1", "typea", "typeah3", "typeb", "unknowna")
nonflu <- c("adeno", "coron", "hmpv", "mpn", "para", "rhino", "rsv")

healthboards <- c("AA" = "NHS Ayrshire and Arran",
                  "BR" = "NHS Borders",
                  "DG" = "NHS Dumfries and Galloway",
                  "FF" = "NHS Fife",
                  "FV" = "NHS Forth Valley",
                  "GC" = "NHS Greater Glasgow and Clyde",
                  "GR" = "NHS Grampian",
                  "HG" = "NHS Highland",
                  "LN" = "NHS Lanarkshire",
                  "LO" = "NHS Lothian",
                  "OR" = "NHS Orkney",
                  "SH" = "NHS Shetland",
                  "TY" = "NHS Tayside",
                  "WI" = "NHS Western Isles")

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

  #  e.g. scotland_agg, agegp_sex_agg, ...
  df1 <- get(glue("i_respiratory_{filename}_agg")) %>%
    mutate(year = get_resp_year(weekord, season),
           date = MMWRweek2Date(year, week)) %>%
    mutate(flu_nonflu = case_when(pathogen %in% flu ~ "flu",
                                  pathogen %in% nonflu ~ "nonflu",
                                  TRUE ~ NA_character_))

  if(filename == "scotland"){
    df1 %<>% mutate(scotland_by_organism_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    HBName = "Scotland")
  } else if (filename == "agegp_sex") {
    df1 %<>% mutate(scotland_by_organism_age_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_))
  } else if (filename == "agegp"){
    df1 %<>% mutate(scotland_by_organism_age_flag = 1)

  } else if (filename == "sex") {
    df1 %<>% mutate(scotland_by_organism_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_))
  } else if (filename == "hb") {
    df1 %<>% mutate(organism_by_hb_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_)) %>%
      filter(!is.na(HealthBoard))
  }

  assign(glue("{filename}_agg"), df1)

  # e.g. scotland_flu_total, agegp_sex_flu_total, ...
  #df2 <-
}


scot_flu_total = scotland_agg %>%
  filter(flu_nonflu == "flu",
         pathogen != "typea") %>%
  group_by(season, week, weekord, date, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "Total",
         organism = "Total",
         total_number_flag = 1,
         HBName = "Scotland",
         countQF = "d",
         rateQF = "d")

scot_non_flu_total = scotland_agg %>%
  filter(flu_nonflu == "nonflu") %>%
  group_by(season, week, weekord, date, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         total_number_flag = 1,
         HBName = "Scotland",
         countQF = "d",
         rateQF = "d")


agegp_sex_flu_total <- agegp_sex_agg %>%
  filter(flu_nonflu == "flu") %>%
  group_by(season, week, weekord, date, agegp, sex, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         scotland_by_age_sex_flag = 1,
         countQF = "d",
         rateQF = "d")

agegp_sex_non_flu_total <- agegp_sex_agg %>%
  filter(flu_nonflu == "nonflu",
         pathogen != "typea") %>%
  group_by(season, week, weekord, date, agegp, sex, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         scotland_by_age_sex_flag = 1,
         countQF = "d",
         rateQF = "d")

agegp_flu_total <- agegp_agg %>%
  filter(flu_nonflu == "flu") %>%
  filter(pathogen != "typea") %>%
  group_by(season, week, weekord, date, agegp, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total_flu",
         organism = "Total",
         scotland_by_age_flag = 1,
         countQF = "d",
         rateQF = "d")

agegp_non_flu_total <- agegp_agg %>%
  filter(flu_nonflu == "nonflu") %>%
  group_by(season, week, weekord, date, agegp, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total_nonflu",
         organism = "Total",
         scotland_by_age_flag = 1,
         countQF = "d",
         rateQF = "d")



sex_flu_total <- sex_agg %>%
  filter(flu_nonflu == "flu") %>%
  filter(pathogen != "typea") %>%
  group_by(season, week, weekord, date, sex, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         scotland_by_sex_flag = 1,
         countQF = "d",
         rateQF = "d")

sex_non_flu_total <- sex_agg %>%
  filter(flu_nonflu == "nonflu") %>%
  group_by(season, week, weekord, date, sex, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         scotland_by_sex_flag = 1,
         countQF = "d",
         rateQF = "d")



hb_flu_total = hb_agg %>%
  filter(flu_nonflu == "flu") %>%
  filter(pathogen != "typea") %>%
  group_by(season, week, weekord, date, HealthBoard, HBName, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         hb_flag = 1,
         countQF = "d",
         rateQF = "d")

hb_non_flu_total = hb_agg %>%
  filter(flu_nonflu == "nonflu") %>%
  group_by(season, week, weekord, date, HealthBoard, HBName, pop, measure, flu_nonflu) %>%
  summarise(count = sum(count)) %>%
  mutate(rate = round_half_up((count/pop)*100000, 1),
         pathogen = "total",
         organism = "Total",
         hb_flag = 1,
         countQF = "d",
         rateQF = "d")

all_data <- bind_rows(
  scotland_agg,
  agegp_sex_agg,
  agegp_agg,
  sex_agg,
  hb_agg,
  scot_non_flu_total,
  agegp_non_flu_total,
  sex_non_flu_total,
  agegp_sex_non_flu_total,
  hb_non_flu_total,
  scot_flu_total,
  agegp_flu_total,
  sex_flu_total,
  agegp_sex_flu_total,
  hb_flu_total) %>%
  mutate(count = as.numeric(count),
         agegp = factor(agegp, levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")))

g_resp_data <- all_data %>%
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
                Healthboard = HBName,
                AgeGroup = agegp,
                Sex = sex,
                HealthboardCode = HealthBoard,
                CountQF = countQF,
                RateQF = rateQF) %>%
  select(Season, Date, Week, Year, Weekord, Measure, FluOrNonFlu, Organism, Healthboard, AgeGroup, Sex, Count, CountQF, Rate, RateQF, Population,
         Pathogen, HealthboardCode, total_number_flag, scotland_by_age_flag, scotland_by_sex_flag, scotland_by_age_sex_flag, hb_flag,
         scotland_by_organism_flag, scotland_by_organism_age_sex_flag, scotland_by_organism_age_flag, scotland_by_organism_sex_flag,
         organism_by_hb_flag)

#### Create Summary Table

sequence = c("PreviousWeek", "PreviousWeek", "ThisWeek", "ThisWeek")

g_resp_summary <- bind_rows(

  # get total flu and non-flu cases
  g_resp_data %>%
    filter(total_number_flag == 1) %>%
    arrange(Date) %>%
    tail(4) %>%
    mutate(Breakdown = "Scotland Total") %>%
    bind_cols(., sequence) %>%
    rename(ReportingWeek = "...30") %>%
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
    mutate(SummaryMeasure = "Scotland_Total"),

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
    group_by(Healthboard) %>%
    filter(Date == max(Date)) %>%
    ungroup() %>%
    filter(Date == max(Date)) %>%
    mutate(Breakdown = Healthboard) %>%
    select(Date, Count, CountQF, Rate, RateQF, Breakdown, FluOrNonFlu) %>%
    mutate(SummaryMeasure = "Healthboard_Total")
)

### running checks on the aggregated data

# do the column names equal the column names we are expecting?

scot_colnames <- c("season", "pathogen", "week", "weekord", "count", "measure", "pop", "rate")
hb_colnames <- c(scot_colnames, "HealthBoard")
sex_colnames <- c(scot_colnames, "sex")
agegp_colnames <- c(scot_colnames, "agegp")
agegp_sex_colnames <- c(scot_colnames, "agegp", "sex")

scot_colnames_match <- scot_colnames %in% colnames(i_respiratory_scotland_agg)
hb_colnames_match <- hb_colnames %in% names(i_respiratory_hb_agg)
sex_colnames_match <- sex_colnames %in% names(i_respiratory_sex_agg)
agegp_colnames_match <- agegp_colnames %in% names(i_respiratory_agegp_agg)
agegp_sex_colnames_match <- agegp_sex_colnames %in% names(i_respiratory_agegp_sex_agg)

colnames_match <- c(scot_colnames_match, hb_colnames_match, sex_colnames_match, agegp_colnames_match, agegp_sex_colnames_match)

if(FALSE %in% colnames_match) {

  message("column names do not match")

} else {

  message("column names match")

}


# this function checks that the data sent to us is adds up and is the same as last week.
# inputs:
# data = this week's data
# measure = the aggregated data (Scotland, Healthboard, Sex, Age, Age Sex)
# checks = this week or previous week
# prev week = a file path for the previous week (created below)

# the function will print a message if there are any issues with the data sent to us

check_data <- function(data, measure = "Scotland", checks = "this week", prev_week_file = NULL) {

  if(checks == "this week") {

    print("checking aggregated data matches scotland totals")

    data_match <- data %>%
      group_by(season, pathogen, weekord, week) %>%
      summarise(scotland_count = sum(count, na.rm=TRUE)) %>%
      left_join(., i_respiratory_scotland_agg) %>%
      mutate(total_match = ifelse(scotland_count == count, TRUE, FALSE),
             count_difference = count-scotland_count)

    if(data_match$count_difference >= 20) {

      data_message <- sprintf("%s aggregated totals do not match. Check returned data.", measure)

    } else {

      data_message <- sprintf("%s aggregated totals match", measure)

    }

    print(data_message)
    return(data_match)

  } else if(checks == "previous week") {

    file <- deparse(substitute(data))

    prev_week <- read.csv(prev_week_file) %>%
      rename(prev_week_count = "count",
             prev_week_rate = "rate")

    data <- data %>%
      left_join(., prev_week) %>%
      mutate(this_week_vs_last_week_count = ifelse(count == prev_week_count, TRUE, FALSE),
             this_week_vs_last_week_rate = ifelse(rate == prev_week_rate, TRUE, FALSE),
             count_difference = count-prev_week_count)

    if(FALSE %in% data$this_week_vs_last_week_count) {

      count_check <- sprintf("%s counts are different this week compared to last week. Check returned file", measure)

    } else if(TRUE %in% data$this_week_vs_last_week_count) {

      count_check <- sprintf("%s counts are the same as last week compared to last week", measure)

    } else {

      count_check <- print("error with checking counts")

    }

    if(FALSE %in% data$this_week_vs_last_week_rate) {

      rate_check <- sprintf("%s rates are different this week compared to last week. Check returned file", measure)

    } else if(TRUE %in% data$this_week_vs_last_week_rate) {

      rate_check <- sprintf("%s rates are the same as last week compared to last week", measure)

    } else {

      rate_check <- print("error with checking rates")
    }

    print(count_check)
    print(rate_check)

    return(data)

  }

}

# get previous week's file paths
path_data_archive <- paste0(respiratory_input_data_path, "/Archive")

scot_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= ".*scotland_agg.*\\.csv$", full.names= T))
scot_agg_prev_week_file <- rownames(scot_agg_prev_week_file)[which.max(scot_agg_prev_week_file$mtime)]


hb_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= ".*hb_agg.*\\.csv$", full.names= T))
hb_agg_prev_week_file <- rownames(hb_agg_prev_week_file)[which.max(hb_agg_prev_week_file$mtime)]

sex_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= "^sex_agg.*\\.csv$", full.names= T))
sex_agg_prev_week_file <- rownames(sex_agg_prev_week_file)[which.max(sex_agg_prev_week_file$mtime)]

agegp_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= "^agegp_agg.*\\.csv$", full.names= T))
agegp_agg_prev_week_file <- rownames(agegp_agg_prev_week_file)[which.max(agegp_agg_prev_week_file$mtime)]

agegp_sex_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= ".*agegp_sex_agg.*\\.csv$", full.names= T))
agegp_sex_agg_prev_week_file <- rownames(agegp_sex_agg_prev_week_file)[which.max(agegp_sex_agg_prev_week_file$mtime)]


# run checks for this week's data
hb_checks_this_week <- check_data(data=i_respiratory_hb_agg, measure="Healthboard", checks="this week")
agegp_checks_this_week <- check_data(data=i_respiratory_agegp_agg, measure="Age group", checks="this week")
sex_checks_this_week <- check_data(data=i_respiratory_sex_agg, measure="Sex", checks="this week")
agegp_sex_checks_this_week <- check_data(data=i_respiratory_agegp_sex_agg, measure="Agegp & Sex", checks="this week")

# run checks that previous week's data matches this week's data
scotland_checks_prev_week <- check_data(data=i_respiratory_scotland_agg, measure="Healthboard", checks="previous week", prev_week_file = scot_agg_prev_week_file)
hb_checks_prev_week <- check_data(data=i_respiratory_hb_agg, measure="Healthboard", checks="previous week", prev_week_file = hb_agg_prev_week_file)
agegp_checks_prev_week <- check_data(data=i_respiratory_agegp_agg, measure="Age group", checks="previous week", prev_week_file = agegp_agg_prev_week_file)
sex_checks_prev_week <- check_data(data=i_respiratory_sex_agg, measure="Sex", checks="previous week", prev_week_file = sex_agg_prev_week_file)
agegp_sex_checks_prev_week <- check_data(data=i_respiratory_agegp_sex_agg, measure="Agegp & Sex", checks="previous week", prev_week_file = agegp_sex_agg_prev_week_file)


write_csv(g_resp_data, glue(output_folder, "Respiratory_AllData.csv"))
write_csv(g_resp_summary, glue(output_folder, "Respiratory_Summary.csv"))

# remove all data
rm(i_respiratory_scotland_agg, i_respiratory_agegp_agg, i_respiratory_agegp_sex_agg, i_respiratory_sex_agg, i_respiratory_hb_agg)
rm(scotland_agg, hb_agg, sex_agg, agegp_agg, agegp_sex_agg, scot_non_flu_total,
   agegp_non_flu_total,
   sex_non_flu_total,
   agegp_sex_non_flu_total,
   hb_non_flu_total,
   scot_flu_total,
   agegp_flu_total,
   sex_flu_total,
   agegp_sex_flu_total,
   hb_flu_total)
rm(hb_checks_this_week, agegp_checks_this_week, sex_checks_this_week, agegp_sex_checks_this_week,
   scotland_checks_prev_week, hb_checks_prev_week, agegp_checks_prev_week, sex_checks_prev_week, agegp_sex_checks_prev_week,
   scot_colnames, hb_colnames, sex_colnames, agegp_colnames, agegp_sex_colnames,
   scot_colnames_match,
   hb_colnames_match,
   sex_colnames_match,
   agegp_colnames_match,
   agegp_sex_colnames_match)

rm(g_resp_data, g_resp_summary)








