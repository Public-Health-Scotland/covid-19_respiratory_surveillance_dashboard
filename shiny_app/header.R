#### Header contents ----

tags$head(# css scripts
          includeCSS("www/css/main.css"),  # Main
          includeCSS("www/css/tables.css"),  # tables
          includeCSS("www/css/navbar_and_panels.css"), # navbar and notes panel
          includeCSS("www/css/buttons.css"), # buttons
          includeCSS("www/css/select.css"), # selectors and radio buttons
          includeCSS("www/css/popovers.css"), # popovers
          includeCSS("www/css/boxes.css"), # boxes
          includeCSS("www/css/valueBox.css"), # valueBox for headline figures
          includeCSS("www/css/infoBox.css"), # infoBox for summary page boxes
          # External file with javascript code for bespoke functionality
          includeScript("www/javascript.js"),
          includeHTML("www/google-analytics.html"), #Including Google analytics
          tags$link(rel = "shortcut icon", href = "favicon_phs.ico") # Icon for browser tab
)
