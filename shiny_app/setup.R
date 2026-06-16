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

# season values
all_seasons <- unique(Respiratory_AllData$Season)
recent_six_seasons <- tail(all_seasons,6)
admission_seasons <- unique(Average_Length_of_Stay$Season)

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

# Colours for lines on summary admissions line chart
flu_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                            phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                            phs_colours("phs-blue"))

rsv_hosp_adms_colours <- c(phs_colours("phs-purple"), phs_colours("phs-green"),
                           phs_colours("phs-magenta"), phs_colours("phs-teal"), phs_colours("phs-graphite"),
                           phs_colours("phs-blue"))

# Colours for lines on line chart
#euromomo_mem_line_colours <- c("#004785","#00a2e5", "#376C31", "#FF0000", "#FF0000")
euromomo_mem_line_colours <- c("#3F085C","#F46A25", "#801650", "#12436D", "#12436D")

# Include week 53?
include_week_53 <- FALSE

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
                    "75+", "All Ages")
mem_age_groups_full <- c("< 1 years", "1-4 years", "5-14 years", "15-44 years",
                         "45-64 years", "65-74 years", "75+ years", "All Ages")

# Age groups
euromomo_mem_age_groups <- c("0-4", "5-14", "15-64", "65+", "All Ages")
euromomo_mem_age_groups_full <- c("0-4 years", "5-14 years", "15-64 years",
                                  "65+ years", "All Ages")

# Set date data goes up to - previous Sunday
data_recent_date <- floor_date(as.Date(Deployment_Date, format = "%d %B %Y"), "week") %>% format("%d %B %Y")

## Function to add seasons into tables (used in admissions script)

add_season <- function(input_data) {
  input_data %>%
    mutate(week_start = week_ending - 6,
           week = ISOweek::ISOweek(week_ending),
           Season = case_when(str_sub(week, start = -2) < 40 ~
                                (paste(as.numeric(str_sub(week, end = 4)) -1 , "-",
                                       as.numeric(str_sub(week, end = 4)), sep="")),
                              TRUE ~ (paste(as.numeric(str_sub(week, end = 4)),
                                            "-", as.numeric(str_sub(week, end = 4)) + 1, sep=""))))
}



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

