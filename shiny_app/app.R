##########################################################
# COVID-19 Dashboard
# Original author(s): C19 Data & Analytics Team
# Contact: PHS.Covid19Data&Analytics@phs.scot
# Original date: 2022-11-30
# Written/run on RStudio server 1.1.463 and R 3.6.1
# Description of content
##########################################################

# Get packages
source("setup.R")

# Getting UI for modules
source(file.path("modules/metadata_button/metadata_button_ui.R"), local = TRUE)$value
source(file.path("modules/summary_button/summary_button_ui.R"), local = TRUE)$value
source(file.path("modules/jump_to_tab_button/jump_to_tab_button_ui.R"), local = TRUE)$value
source(file.path("modules/alt_text/alt_text_modals_ui.R"), local = TRUE)$value
source(file.path("modules/respiratory/respiratory_module_ui.R"), local = TRUE)$value

# UI
ui <- fluidPage(
  tagList(
    # For go to top chevrons on scroll down
    use_gotop(),
    # Specify most recent fontawesome library - change version as needed
    navbarPage(
      id = "intabset", # id used for jumping between tabs
      position = "fixed-top",
      collapsible = "true",
      # Specify language for accessibility
      #lang = "en",
      #tags$html(lang="en"),
      title = div(
        tags$a(img(src = "white-logo.png", height = 40,
                   alt ="Go to Public Health Scotland (external site)"),
               href = "https://www.publichealthscotland.scot/",
               target = "_blank"), # PHS logo links to PHS website
        style = "position: relative; top: -10px;"),
      windowTitle = "COVID-19 & Respiratory Surveillance",# Title for browser tab
      header = source(file.path("header.R"), local=TRUE)$value,
      ##############################################.
      # INTRO PAGE ----
      ##############################################.
      tabPanel(title = "Introduction",
               icon = icon_no_warning_fn("circle-info"),
               value = "intro",

               source(file.path("indicators/introduction/introduction_ui.R"), local = TRUE)$value

      ), # tabpanel
      ##############################################.
      # AT A GLANCE ----
      ##############################################.
      tabPanel(title = "At a glance",
               icon = icon_no_warning_fn("square-poll-vertical"),
               value = "summary",

               source(file.path("indicators/summary/summary_ui.R"), local = TRUE)$value

      ), # tabpanel
      ##############################################.
      # CASES ----
      ##############################################.
      #     tabPanel(title = "COVID-19 cases",
      #              # Look at https://fontawesome.com/search?m=free for icons
      #              icon = icon_no_warning_fn("virus-covid"),
      #              value = "cases",

      #              source(file.path("indicators/cases/cases_ui.R"), local = TRUE)$value

      #     ), # tabpanel
      ##############################################.
      # ADMISSIONS ----
      ##############################################.
      tabPanel(title = "COVID-19 hospital admissions",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("hospital-user"),
               value = "hospital_admissions",

               #       source(file.path("indicators/hospital_admissions/hospital_admissions_ui.R"), local = TRUE)$value

      ), # tabpanel
      ##############################################.
      # OCCUPANCY ----
      ##############################################.
      tabPanel(title = "COVID-19 hospital occupancy",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("bed-pulse"),
               value = "hospital_occupancy",

               #   source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value

      ), # tabpanel
      ##############################################.
      # RESPIRATORY ----
      ##############################################.
      tabPanel(title = "Respiratory infection activity",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("virus"),
               value = "respiratory",

               source(file.path("indicators/respiratory/respiratory_ui.R"), local = TRUE)$value
      ), # tabpanel
      ##############################################.
      # RESPIRATORY PATHOGENS ----
      ##############################################.
      tabPanel(title ="Respiratory pathogens",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("virus"),
               value = "repiratory_pathogens",
               navlistPanel(widths = c(2,10), id = "respiratory_pathogens_panel", #icon = icon_no_warning_fn("spa")

                            tabPanel(title = "COVID-19",
                                     value = "covid_19",
                                     br(),
                                     radioGroupButtons("covid19_select", status = "home",
                                                       choices = c("Infection levels", "Hospital admissions", "Hospital occupancy", "Archive"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.covid19_select=='Infection levels'",
                                                      source(file.path("indicators/cases/cases_ui.R"), local = TRUE)$value),
                                     conditionalPanel(condition="input.covid19_select=='Hospital admissions'",
                                                      source(file.path("indicators/hospital_admissions/hospital_admissions_ui.R"), local = TRUE)$value),
                                     conditionalPanel(condition="input.covid19_select=='Hospital occupancy'",
                                                      source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value),
                                     conditionalPanel(condition="input.covid19_select=='Archive'",
                                                      source(file.path("indicators/Archive/archive_ui.R"), local = TRUE)$value)
                            ),
                            tabPanel(title = "Influenza",
                                     value = "influenza",
                                     br(),
                                     radioGroupButtons("influenza_select", status = "home",
                                                       choices = c("Infection levels (all Influenza)", "Infection levels (by subtype)"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.influenza_select=='Infection levels (all Influenza)'",
                                                      source(file.path("indicators/respiratory_mem/influenza/influenza_mem_ui.R"), local = TRUE)$value),
                                     conditionalPanel(condition="input.influenza_select=='Infection levels (by subtype)'",
                                                      source(file.path("indicators/respiratory_mem/influenza/influenza_subtype_ui.R"), local = TRUE)$value)),
                            tabPanel(title = "RSV",
                                     value = "rsv",
                                     br(),
                                     radioGroupButtons("rsv_select", status = "home",
                                                       choices = c("Infection levels"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.influenza_select=='Infection levels'",
                                                      source(file.path("indicators/respiratory_mem/rsv/rsv_mem_ui.R"), local = TRUE)$value)),
                            tabPanel(title = "Adenovirus",
                                     value = "adenovirus",
                                     br(),
                                     radioGroupButtons("adenovirus_select", status = "home",
                                                       choices = c("Infection levels"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.adenovirus_select=='Infection levels'",
                                                      source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_mem_ui.R"), local = TRUE)$value)
                            ),
                            tabPanel(title = "HMPV",
                                     value = "hmpv",
                                     br(),
                                     radioGroupButtons("hmpv_select", status = "home",
                                                       choices = c("Infection levels"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.hmpv_select=='Infection levels'",
                                                      source(file.path("indicators/respiratory_mem/hmpv/hmpv_mem_ui.R"), local = TRUE)$value)),
                            tabPanel(title = "Parainfluenza",
                                     value = "parainfluenza",
                                     br(),
                                     radioGroupButtons("parainfluenza_select", status = "home",
                                                       choices = c("Infection levels"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.parainfluenza_select=='Infection levels'",
                                                      source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_mem_ui.R"), local = TRUE)$value)),
                            tabPanel(title = "Rhinovirus",
                                     value = "rhinovirus",
                                     br(),
                                     radioGroupButtons("rhinovirus_select", status = "home",
                                                       choices = c("Infection levels"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.rhinovirus_select=='Infection levels'",
                                                      source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_mem_ui.R"), local = TRUE)$value))
               ) # navbarlistPanel
               #
      ),#tabPanel


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

      ), # tabpanel
    ) # navbar
  ) # taglist
) # ui fluidpage

# ----------------------------------------------
# Server

server <- function(input, output, session) {

  if(password_protect){
    source(file.path("password_protect/password_protect_server.R"), local = TRUE)$value
  }

  # Get modules
  source(file.path("modules/metadata_button/metadata_button_server.R"), local = TRUE)$value
  source(file.path("modules/alt_text/alt_text_modals_server.R"), local = TRUE)$value
  source(file.path("modules/summary_button/summary_button_server.R"), local = TRUE)$value
  source(file.path("modules/jump_to_tab_button/jump_to_tab_button_server.R"), local = TRUE)$value
  source(file.path("modules/respiratory/respiratory_module_server.R"), local = TRUE)$value

  # Get functions
  source(file.path("functions/core_functions.R"), local = TRUE)$value
  source(file.path("functions/plot_functions.R"), local = TRUE)$value
  source(file.path("indicators/introduction/introduction_functions.R"), local = TRUE)$value
  source(file.path("indicators/summary/summary_functions.R"), local = TRUE)$value
  source(file.path("indicators/cases/cases_functions.R"), local = TRUE)$value
  source(file.path("indicators/hospital_admissions/hospital_admissions_functions.R"), local = TRUE)$value
  source(file.path("indicators/hospital_occupancy/hospital_occupancy_functions.R"), local = TRUE)$value
  source(file.path("indicators/respiratory/respiratory_functions.R"), local = TRUE)$value
  source(file.path("indicators/metadata/metadata_functions.R"), local = TRUE)$value
  source(file.path("indicators/download/download_functions.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/respiratory_mem_functions.R"), local = TRUE)$value

  # Get content for individual pages
  source(file.path("indicators/introduction/introduction_server.R"), local = TRUE)$value
  source(file.path("indicators/summary/summary_server.R"), local = TRUE)$value
  source(file.path("indicators/cases/cases_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_admissions/hospital_admissions_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_occupancy/hospital_occupancy_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory/respiratory_server.R"), local = TRUE)$value
  source(file.path("indicators/metadata/metadata_server.R"), local = TRUE)$value
  source(file.path("indicators/download/download_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_subtype_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_mem_server.R"), local = TRUE)$value

  source(file.path("indicators/respiratory_mem/hmpv/hmpv_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rsv/rsv_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_mem_server.R"), local = TRUE)$value


}
#sets language right at the top of source (required this way for screen readers)
attr(ui, "lang") = "en"

#conditionally password protect app
if (password_protect){ ui <- secure_app(ui) }


# Run the application
shinyApp(ui=ui, server=server)

### END OF SCRIPT ###
