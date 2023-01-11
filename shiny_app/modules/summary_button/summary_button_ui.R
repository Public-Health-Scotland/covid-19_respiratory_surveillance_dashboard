
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
                  content = paste("<ul>",
                                  "<li>Move the cursor over the data points the see the data values</li>",
                                  "<li>Hold down cursor, drag to size and release to zoom in on part of the plot</li>",
                                  "<li>Alter the x axis by dragging the vertical white bars on the left and right of the bottom panel</li>",
                                  "<li>Click the home button in the top right to reset the axes</li>",
                                  "<li>Single click on legend items to remove that trace</li>",
                                  "<li>Double click on legend items to isolate that trace</li>",
                                  "<li>Double click on the legend to restore all traces</li>",
                                  "<li>Click the camera icon in the top right to download the plot as a png</li>",
                                  "</ul>",
                                  strong("Click again to close.")),
                  placement = placement,
                  label = "Using the plot",
                  icon = "circle-info",
                  class = "plotinfo-btn"
                  )
}



