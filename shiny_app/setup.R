####################### Setup #######################

# You need to make sure you have all these packages installed. Note that we can't include
# a conditional install in the code due to a known rsconnect issue
# (https://github.com/rstudio/rsconnect/issues/88)
library(shiny)
library(shinycssloaders)
library(dplyr)
library(magrittr)
library(plotly)
library(phsstyles)
library(DT)
library(shinydashboard)
library(shinyBS)
library(shinyWidgets)
library(glue)
library(stringr)
library(janitor)
library(fontawesome)
library(shinymanager)


# Load core functions ----
source("functions/core_functions.R")

## Plotting ----
# Style of x and y axis
xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14),
                    showline = TRUE)

yaxis_plots <- list(title = FALSE, rangemode="tozero", size = 4,
                    fixedrange = FALSE, tickfont = list(size=14),
                    titlefont = list(size=14))

navy <- "#010068"

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
              "Contact us"= "contact",
              "Accessibility"= "accessibility",
              "Open data" = "open_data")

# LOAD IN DATA ----

# Load in data to app_data
# Find all rds files in shiny_app/data
rds_files <- list.files(path="data/", pattern="*.rds")
for (rds in rds_files){
  load_rds_file(rds)
}


vaccine_wastage_month <- {Vaccine_Wastage %>% tail(1) %>%
    .$Month %>% convert_opendata_date() %>% convert_date_to_month()}

# Creating variable for latest week for headlines

# Admissions and ICU
admissions_headlines <- get_threeweek_admissions_figures(df = Admissions,
                                                         sumcol = "TotalInfections",
                                                         datecol="AdmissionDate")

icu_headlines <- get_threeweek_admissions_figures(df = ICU,
                                                  sumcol = "NewCovidAdmissionsPerDay",
                                                  datecol="DateFirstICUAdmission")

# LOS
los_date_end <- Admissions %>% tail(1) %>% .$AdmissionDate %>% convert_opendata_date() %>% {.-7}

los_date_start <- los_date_end-28

los_median_max <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == max(MedianLengthOfStay))

los_median_min <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == min(MedianLengthOfStay))
