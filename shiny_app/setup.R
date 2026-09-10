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
library(readxl)


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


######

## Recode flu subtypes

Flu_Subtype_Cases %<>% 
  mutate(Pathogen = recode(Pathogen,
                           "Influenza (A or B)" = "Type A or B",
                           "Influenza A (Any Subtype)" = "Type A (any subtype)",
                           "Influenza A (Subtype Not Known)" = "Type A (not subtyped)",
                           "Influenza A(H1N1)pdm09" = "Type A(H1N1)pdm09",
                           "Influenza A(H3)" = "Type A(H3)",
                           "Influenza B" = "Type B")) 


## MEM file format updates

Respiratory_Pathogens_Test_Positivity_by_Age %<>% 
  arrange(year, ISOweek, pathogen, agegrp)

Respiratory_Pathogens_MEM_Age %<>%
  mutate(AgeGroup = factor(AgeGroup, 
                levels = c("< 1 year", "1-4 years",
                           "5-14 years", "15-44 years",
                           "45-64 years", "65-74 years",
                           "75+ years", "All ages"))) %>% 
  arrange(desc(WeekEnding), AgeGroup)



# respiratory isoweeks
this_week_iso <- lubridate::isoweek(Resp_cases_recent_weeks$DateThisWeek[1])


#### Respiratory MEM ####

# season values
all_seasons <- unique(Respiratory_Pathogens_MEM_Scot$Season)
recent_six_seasons <- tail(all_seasons,6)
admission_seasons <- unique(Average_Length_of_Stay$Season)

## colours to be used for season charts throughout - matching to respiratory report
season_colours <- c(phs_colours("phs-teal"), phs_colours("phs-green"),
                    phs_colours("phs-blue"), phs_colours("phs-magenta"),
                    phs_colours("phs-purple"), phs_colours("phs-graphite"))


# Static legend for MEM plots
mem_legend <- readPNG("www/MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Static legend for Euromomo age MEM plots
euromomo_age_mem_legend <- readPNG("www/Euromomo_age_MEM_legend_liberty10.PNG", native = FALSE, info = FALSE)

# Activity levels
activity_levels <- c("Baseline", "Low", "Medium", "High", "Very high", "NA")

# Colours for thresholds
activity_level_colours <- c("#FDE725FF", "#5DC863FF", "#21908CFF", "#3B528BFF", "#440154FF", phs_colours("phs-liberty-10"))

# Activity levels   for euromomo - not used, uses the generic levels above
#euromomo_activity_levels <- c("Baseline", "Low", "Medium", "High", "Very High", "Reporting delay")

# Colours for thresholds for euromomo
euromomo_activity_level_colours <- c("#FDE725FF", "#5DC863FF", "#21908CFF", "#3B528BFF", "#440154FF", phs_colours("phs-liberty-10"), "#a6a6a6")

# Colours for lines on line chart
mem_line_colours <- rev(c("#12436D", "#801650", "#F46A25","#3F085C",
                      "#3E8ECC", "#3D3D3D"))

# Age group colours

cases_agegpp_colours <- c("#A8CCE8", "#12436D", "#28A197", "#801650", 
                       "#F46A25", "#A285D1", "#3F085C", "#3D3D3D")


# Include week 53?
include_week_53 <- TRUE

# If week 53 is present, should lines with no week 53 be continuous or have a gap?
# TRUE for gap, FALSE for continuous
non_week_53_gap <- FALSE

if(include_week_53){
  
  # Isoweeks from week 40 to 39
  mem_isoweeks <- c(40:53, 1:39)
  # Weeks in order from 1 to 52
  mem_week_order <- c(1:53)
  
} else{
  
  # Isoweeks from week 40 to 39
  mem_isoweeks <- c(40:52, 1:39)
  # Weeks in order from 1 to 52
  mem_week_order <- c(1:52)
  
}

# Age groups
mem_age_groups <- c("< 1", "1-4", "5-14", "15-44", "45-64", "65-74",
                    "75+", "All ages")
mem_age_groups_full <- c("< 1 year", "1-4 years", "5-14 years", "15-44 years",
                         "45-64 years", "65-74 years", "75+ years", "All ages")

# Age groups
euromomo_mem_age_groups <- c("0-4", "5-14", "15-64", "65+", "All Ages")
euromomo_mem_age_groups_full <- c("0-4 years", "5-14 years", "15-64 years",
                                  "65+ years", "All Ages")

# Set date data goes up to - previous Sunday
data_recent_date <- floor_date(as.Date(Deployment_Date, format = "%d %B %Y"), "week") %>% format("%d %B %Y")


# Relabel age groups for admissions

admissions_age %<>% mutate(#ISOweek = as.numeric(ISOweek),
                           AgeGroup = factor(AgeGroup, levels = c("<1",  "1-4", "5-14", "15-44", "45-64",
                                                                  "65-74", "75+", "Total"),
                                             labels=mem_age_groups_full)) 



# Function for admissions value boxes (used in UI so needs to be called earlier than respiratory_mem_functions.R)

make_admissions_value_boxes <- function(data) {
  as_tibble(list(DateTwoWeek = data$WeekEnding[1],
                 DateLastWeek = data$WeekEnding[2],
                 DateThisWeek = data$WeekEnding[3],
                 AdmissionsTwoWeek = data$NumberAdmissionsPerWeek[1],
                 AdmissionsLastWeek = data$NumberAdmissionsPerWeek[2],
                 AdmissionsThisWeek = data$NumberAdmissionsPerWeek[3],
                 RateTwoWeek = data$RateAdmissionsPerWeek[1],
                 RateLastWeek = data$RateAdmissionsPerWeek[2], 
                 RateThisWeek = data$RateAdmissionsPerWeek[3])) #%>%
}

