
# Get corresponding data dictionary ----
# i.e. provide "Admissions" and it will give you
# the Admissions_Dictionary object.
# If no such object is loaded, returns "No summary available"
# to the shiny app
get_data_dictionary <- function(dataname){

  dictionary_name <- dataname %>%
    paste0("_Dictionary")

  tryCatch(
    expr = {dictionary <<- get(dictionary_name)},
    error = function(e) { dictionary <<- "could not find"}
  )

  validate(
    need(is.data.frame(dictionary),
         "No summary available")
  )

  return(dictionary)
}
