
# Get corresponding data dictionary ----
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
