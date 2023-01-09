
summaryButtonUI <- function(id, title, content, placement = "left"){

  ns <- NS(id)

  popify(bsButton(ns("click"),
                  class = "summary-btn",
                  label = "",
                  icon = icon("question"),
                  size = "extra-small"),
         title,
         content,
         placement = placement,
         trigger = "click",
         options = list(container = "body"))


}