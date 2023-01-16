##########################################################
# COVID-19 Dashboard
# Original author(s): C19
# Original date: 2022-11-30
# Written/run on RStudio server 1.1.463 and R 3.6.1
# Description of content
##########################################################


# Get credentials for securing app ----
credentials <- readRDS("credentials.rds")

# Get packages
source("setup.R")

# Getting summary buttons and plot info buttons
source(file.path("modules/summary_button/summary_button_ui.R"), local = TRUE)$value
# Getting UI for modals for alt text
source(file.path("modules/alt_text/alt_text_modals_ui.R"), local = TRUE)$value

# UI
ui <- secure_app( fluidPage(
tagList(
# Specify language for accessibility
tags$html(lang="en"),
# External file with javascript code for bespoke functionality
tags$head(tags$script(src="javascript.js")),
# Specify most recent fontawesome library - change version as needed
tags$style("@import url(https://use.fontawesome.com/releases/v6.1.2/css/all.css);"),
navbarPage(
    id = "intabset", # id used for jumping between tabs
    title = div(
        tags$a(img(src = "white-logo.png", height = 40,
                   alt ="Go to Public Health Scotland (external site)"),
               href = "https://www.publichealthscotland.scot/",
               target = "_blank"), # PHS logo links to PHS website
    style = "position: relative; top: -10px;"),
    windowTitle = "COVID-19 Dashboard",# Title for browser tab
    header = tags$head(includeCSS("www/styles.css"),  # CSS stylesheet
                     #  includeHTML("www/google-analytics.html"), #Including Google analytics
    tags$link(rel = "shortcut icon", href = "favicon_phs.ico") # Icon for browser tab
),
##############################################.
# INTRO PAGE ----
##############################################.
tabPanel(title = "Introduction",
    icon = icon_no_warning_fn("circle-info"),
    value = "intro",

    source(file.path("indicators/introduction/introduction_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# HEADLINE FIGURES ----
##############################################.
tabPanel(title = "Summary",
         icon = icon_no_warning_fn("square-poll-vertical"),
         value = "summary",

         source(file.path("indicators/summary/summary_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# CASES ----
##############################################.
tabPanel(title = "Cases",
    # Look at https://fontawesome.com/search?m=free for icons
    icon = icon_no_warning_fn("virus-covid"),
    value = "cases",

    source(file.path("indicators/cases/cases_ui.R"), local = TRUE)$value

    ), # tabpanel
##############################################.
# ADMISSIONS ----
##############################################.
tabPanel(title = "Hospital admissions",
      # Look at https://fontawesome.com/search?m=free for icons
      icon = icon_no_warning_fn("hospital-user"),
      value = "hospital_admissions",

      source(file.path("indicators/hospital_admissions/hospital_admissions_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# OCCUPANCY ----
##############################################.
tabPanel(title = "Hospital occupancy",
      # Look at https://fontawesome.com/search?m=free for icons
      icon = icon_no_warning_fn("bed-pulse"),
      value = "hospital_occupancy",

      source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# VACCINE WASTAGE ----
##############################################.
tabPanel(title = "Vaccine wastage",
      # Look at https://fontawesome.com/search?m=free for icons
      icon = icon_no_warning_fn("syringe"),
      value = "vaccines",

      source(file.path("indicators/vaccines/vaccines_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# METADATA ----
##############################################.
tabPanel(title = "Metadata",
      # Look at https://fontawesome.com/search?m=free for icons
      icon = icon_no_warning_fn("file-pen"),
      value = "metadata",

      source(file.path("indicators/metadata/metadata_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# DATA DOWNLOAD ----
##############################################.
tabPanel(title = "Download data",
      # Look at https://fontawesome.com/search?m=free for icons
      icon = icon_no_warning_fn("floppy-disk"),
      value = "download",

      source(file.path("indicators/download/download_ui.R"), local = TRUE)$value

) # tabpanel
#
) # navbar
) # taglist
) # ui fluidpage
) # secureapp

# ----------------------------------------------
# Server

server <- function(input, output, session) {

  # Shinymanager Auth
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )

  output$auth_output <- renderPrint({
    reactiveValuesToList(res_auth)
  })

  # Get functions
  source(file.path("functions/core_functions.R"), local = TRUE)$value
  source(file.path("functions/plot_functions.R"), local = TRUE)$value
  source(file.path("modules/alt_text/alt_text_modals_server.R"), local = TRUE)$value
  source(file.path("modules/summary_button/summary_button_server.R"), local = TRUE)$value
  source(file.path("indicators/introduction/introduction_functions.R"), local = TRUE)$value
  source(file.path("indicators/summary/summary_functions.R"), local = TRUE)$value
  source(file.path("indicators/cases/cases_functions.R"), local = TRUE)$value
  source(file.path("indicators/hospital_admissions/hospital_admissions_functions.R"), local = TRUE)$value
  source(file.path("indicators/hospital_occupancy/hospital_occupancy_functions.R"), local = TRUE)$value
  source(file.path("indicators/vaccines/vaccines_functions.R"), local = TRUE)$value
  source(file.path("indicators/metadata/metadata_functions.R"), local = TRUE)$value
  source(file.path("indicators/download/download_functions.R"), local = TRUE)$value

  # Get content for individual pages
  source(file.path("indicators/introduction/introduction_server.R"), local = TRUE)$value
  source(file.path("indicators/summary/summary_server.R"), local = TRUE)$value
  source(file.path("indicators/cases/cases_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_admissions/hospital_admissions_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_occupancy/hospital_occupancy_server.R"), local = TRUE)$value
  source(file.path("indicators/vaccines/vaccines_server.R"), local = TRUE)$value
  source(file.path("indicators/metadata/metadata_server.R"), local = TRUE)$value
  source(file.path("indicators/download/download_server.R"), local = TRUE)$value

}

# Run the application
shinyApp(ui=ui, server=server)

### END OF SCRIPT ###
