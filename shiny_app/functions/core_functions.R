####################### Core functions #######################

# Add n linebreaks
linebreaks <- function(n){HTML(strrep(br(), n))}

# Remove warnings from icons
icon_no_warning_fn = function(icon_name) {
  icon(icon_name, verify_fa=FALSE)
}

# Generic data table
make_table <- function(input_data_table,
                       rows_to_display = 20
){

  # Take out underscores in column names for display purposes
  table_colnames  <-  gsub("_", " ", colnames(input_data_table))

  dt <- DT::datatable(input_data_table, style = 'bootstrap',
                      class = 'table-bordered table-condensed',
                      rownames = FALSE,
                      filter="top",
                      colnames = table_colnames,
                      options = list(pageLength = rows_to_display,
                                     scrollX = FALSE,
                                     scrollY = FALSE,
                                     dom = 'tip',
                                     autoWidth = TRUE,
                                     # style header
                                     initComplete = htmlwidgets::JS(
                                       "function(settings, json) {",
                                       "$(this.api().table().header()).css({'background-color': '#C5C3DA', 'color': '#3F3685'});",
                                       "$(this.api().table().row().index()).css({'background-color': '#C5C3DA', 'color': '#3F3685'});",
                                       "}")))


  return(dt)
}

# Load data from shiny_app/data
load_rds_file <- function(rds){
  # Given a .rds file name in shiny_app/data
  # this function loads it as a variable with the same name as the
  # file apart from the extension
  assign(gsub(".rds", "", rds), readRDS(paste0("data/", rds)), envir = .GlobalEnv)
}
