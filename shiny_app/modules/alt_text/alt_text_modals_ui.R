####################### Modals UI #######################


altTextUI <- function(id) {

  ns <- NS(id)

  tagList(
  actionButton(ns("alttext"),
               "Plot description",
               icon = icon_no_warning_fn('chart-simple')),
  plotInfoButtonUI(ns("pi"))
  )

}

