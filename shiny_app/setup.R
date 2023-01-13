####################### Setup #######################

# Getting packages
if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
if (!pacman::p_isinstalled("phsstyles")){pacman::p_install_gh("Public-Health-Scotland/phsstyles")}

pacman::p_load(shiny, shinycssloaders, dplyr, magrittr, plotly, phsstyles, DT,
               shinydashboard, shinyBS, shinyWidgets, glue, stringr, janitor)

# Load core functions ----
source("functions/core_functions.R")

## Plotting ----
# Style of x and y axis
xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14),
                    showline = TRUE)

yaxis_plots <- list(title = FALSE, rangemode="tozero", size = 4,
                    fixedrange = FALSE, tickfont = list(size=14),
                    titlefont = list(size=14))

# Buttons to remove from plotly plots
bttn_remove <-  list(
                     'select2d',
                     'lasso2d',
                     'zoomIn2d',
                     'zoomOut2d',
                     'autoScale2d',
                     'toggleSpikelines',
                     'hoverCompareCartesian',
                     'hoverClosestCartesian'
                  )

home_list<- c("About"= "about",
              "Using the dashboard"= "use",
              "Further information"= "info",
              "Accessibility"= "accessibility")

# LOAD IN DATA ----

# Load in data to app_data
# Find all rds files in shiny_app/data
rds_files <- list.files(path="data/", pattern="*.rds")
for (rds in rds_files){
  load_rds_file(rds)
}


vaccine_wastage_month <- {Vaccine_Wastage %>% tail(1) %>%
    .$Month %>% convert_opendata_date() %>% convert_date_to_month()}

#Creating variable for latest week for headlines

admissions_headlines <- get_threeweek_admissions_figures(df = Admissions, sumcol = "TotalInfections", datecol="AdmissionDate")
icu_headlines <- get_threeweek_admissions_figures(df = ICU, sumcol = "NewCovidAdmissionsPerDay", datecol="DateFirstICUAdmission")
los_date_end <- Admissions %>% tail(1) %>% .$AdmissionDate %>% convert_opendata_date() %>% {.-7}
los_date_start <- los_date_end-28
