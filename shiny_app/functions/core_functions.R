####################### Core functions #######################

# Add n linebreaks ----
linebreaks <- function(n){HTML(strrep(br(), n))}

# Remove warnings from icons ----
icon_no_warning_fn = function(icon_name) {
  icon(icon_name, verify_fa=FALSE)
}

withNavySpinner <- function(out){
  withSpinner(out, color = navy)
}

# Get health board name ----
get_hb_name <- function(code){
# e.g. converts HB code to "NHS Ayrshire and Arran"
  ifelse(is.na(code),
         NA_character_,
         phsmethods::match_area(code) %>% paste("NHS", .)
         )
}

## Function to format a given entry in a table ----
format_entry <- function(x, dp=0, perc=F){
  # x (numeric, char): entry
  # dp (int): number of decimal places
  # perc (bool): whether to add % afterwards

  # First strip any existing commas and whitespace out
  x <- gsub(",", "", x)
  x <- gsub(" ", "", x)

  # Try to convert entry to numeric, if failed return NULL
  numx <- tryCatch(as.numeric(x),
                   warning = function(w) NULL)

  # Format entry if numeric
  if (!is.null(numx)){
    numx <- formatC(numx, format="f", big.mark = ",", digits=dp)
    if (perc){
      numx <- paste0(numx, "%")
    }
    return (numx)
  } else {
    # If entry cannot be converted to numeric, return original entry i.e. "*"
    return(x)
  }
}

# Data table for Data tab ----
make_table <- function(input_data_table,
                       add_separator_cols = NULL, # with , separator and 0dp
                       add_separator_cols_1dp = NULL, # with , separator and 1dp
                       add_separator_cols_2dp = NULL, # with , separator and 2dp,
                       add_percentage_cols = NULL, # with % symbol and 1dp
                       maxrows = 14, # max rows displayed on page
                       order_by_firstcol = NULL, # asc, desc or NULL
                       filter_cols = NULL, # columns to have filters for
                       highlight_column = NULL # Column to highlight specific entries based off
){


  # Remove the underscore from column names in the table

  table_colnames  <-  gsub("_", " ", colnames(input_data_table))

  # Add column formatting

  for (i in add_separator_cols){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry)
  }

  for (i in add_separator_cols_1dp){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=1)
  }

  for (i in add_separator_cols_2dp){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=2)
  }

  for (i in add_percentage_cols){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=1, perc=T)
  }

  # Always filter date cols
  date_cols <- which({purrr::map(input_data_table, class) %>% paste()} == "Date")
  filter_cols <- union(filter_cols, date_cols)

  # Getting columns not to filter based off columns to filter
  # Shifting down by 1 as data table starts counting from 0 whereas we want
  # to choose columns to filter by counting from 1 like in R
  no_filter_cols <- seq(0, (ncol(input_data_table)-1)) %>% .[!(. %in% (filter_cols-1))]

  if(!is.null(order_by_firstcol)){
    tab_order <- list(list(0, order_by_firstcol))
  } else {
    tab_order <- NULL
  }

  dt <- DT::datatable(input_data_table, style = 'bootstrap',

                      class = 'table-bordered table-condensed',
                      rownames = FALSE,
                      options = list(pageLength = maxrows,
                                     dom = 'tip',
                                     columnDefs = list(list(searchable = FALSE,
                                                            #targets = no_filter_cols,
                                                            targets = "_all", 
                                                            className = "dt-left")),
                                     ordering = FALSE,
                                     scrollX = TRUE,
                                     initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': 'rgba(1, 0, 104, 1)', 'color': 'white'});",
                                       "}"), # Make header navy
                                     order = tab_order),
                      filter = list(position="top", clear=TRUE, plain=FALSE),
                      colnames = table_colnames) %>%
    formatStyle(
      highlight_column, target="row",
      backgroundColor = styleEqual(c("Cumulative", "Total"),
                                   c(phs_colours("phs-blue"), phs_colours("phs-blue"))),
      fontWeight = styleEqual(c("Cumulative", "Total"), c("bold", "bold")),
      color = styleEqual(c("Cumulative", "Total"), c("white", "white"))
    )

  return(dt)


}

# Load data from shiny_app/data ----
load_rds_file <- function(rds){
  # Given a .rds file name in shiny_app/data
  # this function loads it as a variable with the same name as the
  # file apart from the extension
  assign(gsub(".rds", "", rds), readRDS(paste0("data/", rds)), envir = .GlobalEnv)
}

# Date conversion functions ----
convert_opendata_date <- function(date){
  date <- as.Date(as.character(date), format = "%Y%m%d")
  return(date)
}


# Data table for At a glance tab ----
make_summary_table <- function(input_data_table,
                       add_separator_cols = NULL, # with , separator and 0dp
                       add_separator_cols_1dp = NULL, # with , separator and 1dp
                       add_separator_cols_2dp = NULL, # with , separator and 2dp,
                       add_percentage_cols = NULL, # with % symbol and 2dp
                       maxrows = 14, # max rows displayed on page
                       order_by_firstcol = NULL, # asc, desc or NULL
                       filter_cols = NULL, # columns to have filters for
                       highlight_column = NULL # Column to highlight specific entries based off
){


  # Remove the underscore from column names in the table

  table_colnames  <-  gsub("_", " ", colnames(input_data_table))

  # Add column formatting

  for (i in add_separator_cols){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry)
  }

  for (i in add_separator_cols_1dp){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=1)
  }

  for (i in add_separator_cols_2dp){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=2)
  }

  for (i in add_percentage_cols){
    input_data_table[i] <- apply(input_data_table[i], MARGIN=1, FUN=format_entry, dp=1, perc=T)
  }

  # Always filter date cols
  date_cols <- which({purrr::map(input_data_table, class) %>% paste()} == "Date")
  filter_cols <- union(filter_cols, date_cols)

  # Getting columns not to filter based off columns to filter
  # Shifting down by 1 as data table starts counting from 0 whereas we want
  # to choose columns to filter by counting from 1 like in R
  no_filter_cols <- seq(0, (ncol(input_data_table)-1)) %>% .[!(. %in% (filter_cols-1))]

  if(!is.null(order_by_firstcol)){
    tab_order <- list(list(0, order_by_firstcol))
  } else {
    tab_order <- NULL
  }

  dt <- DT::datatable(input_data_table, style = 'bootstrap',

                      class = 'table-bordered table-condensed',
                      rownames = FALSE,
                      options = list(pageLength = maxrows,
                                     dom = 'tip',
                                     columnDefs = list(list(searchable = FALSE,
                                                            #targets = no_filter_cols
                                                            targets = "_all", 
                                                            className = "dt-left")),
                                     lengthChange=FALSE,
                                     searching=FALSE,
                                     paging=FALSE,
                                     info=FALSE,
                                     ordering = FALSE,
                                     scrollX = TRUE,
                                     initComplete = JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': 'rgba(1, 0, 104, 1)', 'color': 'white'});",
                                       "}"), # Make header navy
                                     order = tab_order),
                      #filter = list(position="top", clear=TRUE, plain=FALSE),
                      colnames = table_colnames) %>%
    formatStyle(
      highlight_column, target="row",
      backgroundColor = styleEqual(c("Cumulative", "Total"),
                                   c(phs_colours("phs-blue"), phs_colours("phs-blue"))),
      fontWeight = styleEqual(c("Cumulative", "Total"), c("bold", "bold")),
      color = styleEqual(c("Cumulative", "Total"), c("white", "white"))
    )

  return(dt)


}

