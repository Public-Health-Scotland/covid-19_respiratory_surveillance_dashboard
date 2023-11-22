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
library(lubridate)
library(png)
library(tidyr)

# Load core functions ----
source("functions/core_functions.R")

## Plotting ----
# Style of x and y axis
xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14),
                    showline = TRUE)

yaxis_plots <- list(title = FALSE, rangemode="tozero", size = 4,
                    fixedrange = FALSE, tickfont = list(size=14),
                    titlefont = list(size=14), tickformat = ",d")

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

# If on shinyapps.io config::get()$online is TRUE, else FALSE
if (config::get()$online){
  # Whether to password protect the app - set in deployment script
  # TRUE if deployed to PRA, FALSE if not
  password_protect <- Password_Protect
} else {
  password_protect <- FALSE
}

# Creating variable for latest week for headlines

# Admissions and ICU
admissions_headlines <- get_threeweek_admissions_figures(df = Admissions,
                                                         sumcol = "TotalInfections",
                                                         datecol="AdmissionDate")

icu_headlines <- get_threeweek_admissions_figures(df = ICU,
                                                  sumcol = "NewCovidAdmissionsPerDay",
                                                  datecol="DateFirstICUAdmission")

occupancy_headlines <- get_threeweek_occupancy_figures(df = Occupancy_Hospital,
                                                       datecol = "Date")

adm_hb_dates <- c(Admissions_HB %>% tail(1) %>% .$WeekEnding, Admissions_HB %>% tail(1) %>% .$WeekEnding%>% {.-7}, Admissions_HB %>% tail(1) %>% .$WeekEnding%>% {.-14})

# LOS
los_date_end <- Admissions %>% tail(1) %>% .$AdmissionDate %>% convert_opendata_date() %>% {.-7}

los_date_start <- los_date_end-28

los_median_max <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == max(MedianLengthOfStay))

los_median_min <- Length_of_Stay_Median %>%
  filter(MedianLengthOfStay == min(MedianLengthOfStay))

# Respiratory factor
resp_order <- c("Influenza - Type A (any subtype)",
                "Influenza - Type A(H1N1)pdm09",
                "Influenza - Type A(H3)",
                "Influenza - Type A (not subtyped)",
                "Influenza - Type B",
                "Influenza - Type A or B",
                "Adenovirus",
                "Human metapneumovirus",
                "Mycoplasma pneumoniae",
                "Parainfluenza virus",
                "Respiratory syncytial virus",
                "Rhinovirus",
                "Seasonal coronavirus (Non-SARS-CoV-2)",
                "Total")

Respiratory_AllData %<>%
  mutate(
         AgeGroup = factor(AgeGroup,
                           levels = c("<1", "1-4", "5-14", "15-44", "45-64", "65-74", "75+")
                           ),
         Organism = factor(Organism,
                           levels = resp_order
          )
         )

resp_sum_order <- c(resp_order,
                   unique(Respiratory_Summary$Breakdown)[!(
                    unique(Respiratory_Summary$Breakdown) %in% resp_order)])

# Duplicate of Respiratory_Summary where Breakdown col is a factor - needed for the
# headline dropdown. Can't reassign to Respiratory_Summary for some reason
# TODO: fix this!
Respiratory_Summary_Factor <- Respiratory_Summary %>%
  mutate(Breakdown = factor(Breakdown,levels = resp_sum_order)) %>% arrange(Breakdown)

# respiratory headline figures
flu_icon_headline <- Respiratory_Summary_Totals %>%
  mutate(icon = case_when(PercentageDifference > 0 ~ "arrow-up",
                          PercentageDifference < 0 ~ "arrow-down",
                          PercentageDifference == 0 ~ "equals"))

# respiratory isoweeks
this_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DateThisWeek[1])
prev_week_iso <- lubridate::isoweek(Respiratory_Summary_Totals$DatePreviousWeek[1])



#### Respiratory MEM ####

# Static legend for MEM plots
mem_legend <- readPNG("www/MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Static legend for Euromomo age MEM plots
euromomo_age_mem_legend <- readPNG("www/Euromomo_age_MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Activity levels
activity_levels <- c("Baseline", "Low", "Moderate", "High", "Extraordinary")

# Colours for thresholds
activity_level_colours <- c("#01A148", "#FFDE17", "#F36523", "#ED1D24", "#7D4192")

# Colours for lines on line chart
# mem_line_colours <- c("#010101", "#A35000", "#00FF1A", "#004785","#00a2e5",
#                       "#376C31", "#FF0000")
mem_line_colours <- c("#A35000", "#00FF1A", "#004785","#00a2e5",
                      "#376C31", "#FF0000")

# Colours for lines on summary admissions line chart
flu_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                            phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                            phs_colours("phs-blue"))

rsv_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                           phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                           phs_colours("phs-blue"))

# Colours for lines on line chart
euromomo_mem_line_colours <- c("#004785","#00a2e5", "#376C31", "#FF0000", "#FF0000")

# Isoweeks from week 40 to 39
mem_isoweeks <- c(40:52, 1:39)
# Weeks in order from 1 to 52
mem_week_order <- c(1:52)

# Age groups
mem_age_groups <- c("< 1", "1-4", "5-14", "15-44", "45-64", "65-74",
                    "75+", "All Ages")
mem_age_groups_full <- c("< 1 years", "1-4 years", "5-14 years", "15-44 years",
                         "45-64 years", "65-74 years", "75+ years", "All Ages")

# Age groups
euromomo_mem_age_groups <- c("0-4", "5-14", "15-64", "65+", "All Ages")
euromomo_mem_age_groups_full <- c("0-4 years", "5-14 years", "15-64 years",
                                  "65+ years", "All Ages")


