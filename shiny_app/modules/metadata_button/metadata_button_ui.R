#### Metadata buttons

metadataButtonUI <- function(id){

  ns <- NS(id)

  actionButton(ns("jump_to_metadata"),
               label = "Metadata",
               class = "metadata-btn",
               icon = icon_no_warning_fn("file-pen")
  )

}