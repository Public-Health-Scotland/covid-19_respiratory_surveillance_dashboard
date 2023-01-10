
# ? Buttons for summary tab
summaryButtonUI <- function(id, title, content, placement = "left",
                            label = "",
                            icon = "question", class = "summary-btn"){

  ns <- NS(id)

  popify(bsButton(ns("click"),
                  class = class,
                  label = label,
                  icon = icon(icon),
                  size = "extra-small"),
         title,
         content,
         placement = placement,
         trigger = "click",
         options = list(container = "body"))


}

# Buttons that go next to plots for how to interact with the plot
plotInfoButtonUI <- function(id, placement = "right") {
  ns <- NS(id)

  summaryButtonUI(ns("plotinfo"),
                  title = "How to interact with the plot",
                  content = paste("Some text here.<br><br>",
                                  strong("For more information, see Metadata. Click again to close.")),
                  placement = placement,
                  label = "Using the plot",
                  icon = "circle-info",
                  class = "plotinfo-btn"
                  )
}

