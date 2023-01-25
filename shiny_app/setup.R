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
library(gotop)
library(R.utils)

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

# Go to top button
gotop::use_gotop(
  src = "fas fa-chevron-circle-up", # css class from Font Awesome
  color = navy, # color
  opacity = 0.8, # transparency
  width = 50, # size
  appear = 80 # number of pixels before appearance
)

# LOAD IN DATA ----

# Load in data to app_data
# Find all rds files in shiny_app/data
rds_files <- list.files(path="data/", pattern="*.rds")
for (rds in rds_files){
  load_rds_file(rds)
}

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

# Respiratory factor

Respiratory_AllData %<>%
  mutate(
         AgeGroup = factor(AgeGroup,
                           levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")
                           )#,
         # Organism = factor(Organism,
         #                   levels = c("Influenza - Type A (any subtype)",
         #                              "Influenza - Type A(H1N1)pdm09",
         #                              "Influenza - Type A(H3)",
         #                              "Influenza - Type A (not subtyped)",
         #                              "Influenza - Type B",
         #                              "Influenza - Type A or B",
         #                              "Adenovirus",
         #                              "Human metapneumovirus",
         #                              "Mycoplasma pneumoniae",
         #                              "Parainfluenza virus",
         #                              "Respiratory syncytial virus",
         #                              "Rhinovirus",
         #                              "Seasonal coronavirus (Non-SARS-CoV-2)",
         #                              "Total",
         #                              NA_character_))
         )

# Respiratory_Summary %<>%
#   mutate(Breakdown = factor(Breakdown,
#                             levels = c("Influenza - Type A (any subtype)",
#                                        "Influenza - Type A(H1N1)pdm09",
#                                        "Influenza - Type A(H3)",
#                                        "Influenza - Type A (not subtyped)",
#                                        "Influenza - Type B",
#                                        "Influenza - Type A or B",
#                                        "Adenovirus",
#                                        "Human metapneumovirus",
#                                        "Mycoplasma pneumoniae",
#                                        "Parainfluenza virus",
#                                        "Respiratory syncytial virus",
#                                        "Rhinovirus",
#                                        "Seasonal coronavirus (Non-SARS-CoV-2)",
#                                        NA_character_)
#                             )
#   )

# respiratory headline figures
flu_icon_headline <- Respiratory_Summary_Totals %>%
  mutate(icon = case_when(PercentageDifference > 0 ~ "arrow-up",
                          PercentageDifference < 0 ~ "arrow-down",
                          PercentageDifference == 0 ~ "equals"))

# respiratory isoweeks
this_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DateThisWeek[1])
prev_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DatePreviousWeek[1])




