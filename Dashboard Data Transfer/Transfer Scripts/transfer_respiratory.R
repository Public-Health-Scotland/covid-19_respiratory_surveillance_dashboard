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
  df1 <- get(glue("i_respiratory_{filename}_agg")) %>%
    mutate(year = get_resp_year(weekord, season),
           date = MMWRweek2Date(year, week)) %>%
    mutate(flu_nonflu = case_when(pathogen %in% flu ~ "flu",
                                  pathogen %in% nonflu ~ "nonflu",
                                  TRUE ~ NA_character_))

  if(filename == "scotland"){

    df1 %<>% mutate(scotland_by_organism_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    HealthBoard = "Scotland",
                    breakdown = "Scotland")

  } else if (filename == "agegp_sex") {

    df1 %<>% mutate(scotland_by_organism_age_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    breakdown = paste0(agegp,"_",sex))

  } else if (filename == "agegp"){

    df1 %<>% mutate(scotland_by_organism_age_flag = 1,
                    breakdown = agegp)

  } else if (filename == "sex") {

    df1 %<>% mutate(scotland_by_organism_sex_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    breakdown = sex)

  } else if (filename == "hb") {

    df1 %<>% mutate(organism_by_hb_flag = 1,
                    organism = recode(pathogen, !!!organism, .default = NA_character_),
                    HealthboardCode = recode(HealthBoard, !!!healthboards, .default = NA_character_),
                    breakdown = HealthboardCode) %>%
      filter(!is.na(HealthBoard))

  }

  assign(glue("{filename}_agg"), df1)

  # 2. scotland flu and non-flu totals
  df2 <- df1 %>%
    filter(pathogen != "typea") %>%
    group_by(season, week, weekord, date, pop, measure, breakdown, flu_nonflu) %>%
    summarise(count = sum(count)) %>%
    mutate(rate = round_half_up((count/pop)*100000, 1),
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
  hb_flu_total) %>%
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
         organism_by_hb_flag)

#### Create Summary Table
sequence = c("PreviousWeek", "PreviousWeek", "ThisWeek", "ThisWeek")

# get total flu and non-flu cases
g_resp_summary_totals <- g_resp_data %>%
  filter(total_number_flag == 1) %>%
  arrange(Date) %>%
  tail(4) %>%
  mutate(Breakdown = "Scotland Total") %>%
  bind_cols(., sequence) %>%
  rename(ReportingWeek = "...31") %>%
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

g_resp_data %<>% mutate(HealthboardCode = ifelse(HealthBoard == "Scotland", "S92000003", HealthboardCode))

# Checks on aggregated data
source("Transfer Scripts/respiratory_checks.R")

# Output
write_csv(g_resp_data, glue(output_folder, "Respiratory_AllData.csv"))
write_csv(g_resp_summary_totals, glue(output_folder, "Respiratory_Summary_Totals.csv"))
write_csv(g_resp_summary, glue(output_folder, "Respiratory_Summary.csv"))

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
