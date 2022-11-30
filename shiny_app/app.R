##########################################################
# COVID-19 Dashboard
# Original author(s): C19
# Original date: 2022-11-30
# Written/run on RStudio server 1.1.463 and R 3.6.1
# Description of content
##########################################################


# Get packages
source("setup.R")

# UI
ui <- fluidPage(
tagList(
# Specify most recent fontawesome library - change version as needed
tags$style("@import url(https://use.fontawesome.com/releases/v6.1.2/css/all.css);"),
navbarPage(
    id = "intabset", # id used for jumping between tabs
    title = div(
        tags$a(img(src = "phs-logo.png", height = 40),
               href = "https://www.publichealthscotland.scot/",
               target = "_blank"), # PHS logo links to PHS website
    style = "position: relative; top: -5px;"),
    windowTitle = "COVID-19 Dashboard",# Title for browser tab
    header = tags$head(includeCSS("www/styles.css"),  # CSS stylesheet
    tags$link(rel = "shortcut icon", href = "favicon_phs.ico") # Icon for browser tab
),
##############################################.
# INTRO PAGE ----
##############################################.
tabPanel(title = "Introduction",
    icon = icon_no_warning_fn("circle-info"),
    value = "intro",

    h1("Welcome to the dashboard")

), # tabpanel
##############################################.
# HEADLINE FIGURES ----
##############################################.
tabPanel(title = "Summary",
         icon = icon_no_warning_fn("square-poll-vertical"),
         value = "summary",

         h1("Summary stuff here")

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

         br()
         #source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# VACCINE WASTAGE ----
##############################################.
tabPanel(title = "Vaccine wastage",
         # Look at https://fontawesome.com/search?m=free for icons
         icon = icon_no_warning_fn("biohazard"),
         value = "vaccines",

         source(file.path("indicators/vaccines/vaccines_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# NOTES ----
##############################################.
tabPanel(title = "Notes",
         # Look at https://fontawesome.com/search?m=free for icons
         icon = icon_no_warning_fn("file-pen"),
         value = "notes",

         br()

         #source(file.path("indicators/notes/notes_ui.R"), local = TRUE)$value

), # tabpanel
##############################################.
# DATA DOWNLOAD ----
##############################################.
tabPanel(title = "Download data",
         # Look at https://fontawesome.com/search?m=free for icons
         icon = icon_no_warning_fn("floppy-disk"),
         value = "download",

         br()
       #  source(file.path("indicators/download/download_ui.R"), local = TRUE)$value

) # tabpanel
#
) # navbar
) # taglist
) # ui fluidpage

# ----------------------------------------------
# Server

server <- function(input, output, session) {

    # Get functions
    source(file.path("functions/core_functions.R"), local = TRUE)$value

    # Get content for individual pages
    source(file.path("indicators/cases/cases_server.R"), local = TRUE)$value
    source(file.path("indicators/hospital_admissions/hospital_admissions_server.R"), local = TRUE)$value
    source(file.path("indicators/vaccines/vaccines_server.R"), local = TRUE)$value

}

# Run the application
shinyApp(ui=ui, server=server)

### END OF SCRIPT ###
