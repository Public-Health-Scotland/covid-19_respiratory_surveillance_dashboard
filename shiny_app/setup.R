####################### Setup #######################

# Getting packages
if(is.na(utils::packageDate("pacman"))) install.packages("pacman")
if (!pacman::p_isinstalled("phsstyles")){pacman::p_install_gh("Public-Health-Scotland/phsstyles")}

pacman::p_load(shiny, shinycssloaders, dplyr, magrittr, plotly, phsstyles, DT,
               shinydashboard, glue, stringr)

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
                     #'select2d',
                     'lasso2d',
                     'zoomIn2d',
                     'zoomOut2d',
                     'autoScale2d',
                     #'toggleSpikelines',
                     'hoverCompareCartesian',
                     'hoverClosestCartesian'
                  )


# LOAD IN DATA ----

# Load in data to app_data
# Find all rds files in shiny_app/data
rds_files <- list.files(path="data/", pattern="*.rds")
for (rds in rds_files){
  load_rds_file(rds)
}





