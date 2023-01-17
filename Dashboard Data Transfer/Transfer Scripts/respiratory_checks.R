### running checks on the aggregated data

# do the column names equal the column names we are expecting?

scotland_colnames <- c("season", "pathogen", "week", "weekord", "count", "measure", "pop", "rate")
hb_colnames <- c(scotland_colnames, "HealthBoard")
sex_colnames <- c(scotland_colnames, "sex")
agegp_colnames <- c(scotland_colnames, "agegp")
agegp_sex_colnames <- c(scotland_colnames, "agegp", "sex")

scotland_colnames_match <- scotland_colnames %in% colnames(i_respiratory_scotland_agg)
hb_colnames_match <- hb_colnames %in% names(i_respiratory_hb_agg)
sex_colnames_match <- sex_colnames %in% names(i_respiratory_sex_agg)
agegp_colnames_match <- agegp_colnames %in% names(i_respiratory_agegp_agg)
agegp_sex_colnames_match <- agegp_sex_colnames %in% names(i_respiratory_agegp_sex_agg)

colnames_match <- c(scotland_colnames_match, hb_colnames_match, sex_colnames_match, agegp_colnames_match, agegp_sex_colnames_match)


if(FALSE %in% colnames_match) {

  message("column names do not match")

} else {

  message("column names match")

}

# Halting code if the column names don't match
stopifnot(!(FALSE %in% colnames_match))


# this function checks that the data sent to us adds up and is the same as last week.
# inputs:
# data = this week's data
# measure = the aggregated data (Scotland, Healthboard, Sex, Age, Age Sex)
# checks = this week or previous week
# prev week = a file path for the previous week (created below)

# the function will print a message if there are any issues with the data sent to us

check_data <- function(data, measure = "Scotland", checks = "this week", prev_week_file = NULL) {

  if(checks == "this week") {

    message("Checking aggregated data matches scotland totals")

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

    message(data_message)
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

      count_check <- sprintf("%s counts are the same as last week", measure)

    } else {

      count_check <- print("error with checking counts")

    }

    if(FALSE %in% data$this_week_vs_last_week_rate) {

      rate_check <- sprintf("%s rates are different this week compared to last week. Check returned file", measure)

    } else if(TRUE %in% data$this_week_vs_last_week_rate) {

      rate_check <- sprintf("%s rates are the same as last week", measure)

    } else {

      rate_check <- message("error with checking rates")
    }

    message(count_check)
    message(rate_check)

    return(data)

  }

}



# get previous week's file paths
path_data_archive <- paste0(respiratory_input_data_path, "/Archive")

scotland_agg_prev_week_file <- file.info(list.files(path_data_archive, pattern= ".*scotland_agg.*\\.csv$", full.names= T))
scotland_agg_prev_week_file <- rownames(scotland_agg_prev_week_file)[which.max(scotland_agg_prev_week_file$mtime)]


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
scotland_checks_prev_week <- check_data(data=i_respiratory_scotland_agg, measure="Healthboard", checks="previous week", prev_week_file = scotland_agg_prev_week_file)
hb_checks_prev_week <- check_data(data=i_respiratory_hb_agg, measure="Healthboard", checks="previous week", prev_week_file = hb_agg_prev_week_file)
agegp_checks_prev_week <- check_data(data=i_respiratory_agegp_agg, measure="Age group", checks="previous week", prev_week_file = agegp_agg_prev_week_file)
sex_checks_prev_week <- check_data(data=i_respiratory_sex_agg, measure="Sex", checks="previous week", prev_week_file = sex_agg_prev_week_file)
agegp_sex_checks_prev_week <- check_data(data=i_respiratory_agegp_sex_agg, measure="Agegp & Sex", checks="previous week", prev_week_file = agegp_sex_agg_prev_week_file)

