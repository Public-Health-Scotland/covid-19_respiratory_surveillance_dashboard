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
source(file.path("modules/definitions/definitions_ui.R"), local = TRUE)$value

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
      # tabPanel(title = "At a glance",
      #          icon = icon_no_warning_fn("square-poll-vertical"),
      #          value = "summary",
      #
      #          source(file.path("indicators/summary/summary_ui.R"), local = TRUE)$value
      #
      # ), # tabpanel
      ##############################################.
      # AT A GLANCE ----
      ##############################################.
      tabPanel(title = "At a glance",
               icon = icon_no_warning_fn("square-poll-vertical"),
               value = "at_a_glance",

               source(file.path("indicators/at_a_glance/at_a_glance_ui.R"), local = TRUE)$value

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
      # tabPanel(title = "COVID-19 hospital admissions",
      #          # Look at https://fontawesome.com/search?m=free for icons
      #          icon = icon_no_warning_fn("hospital-user"),
      #          value = "hospital_admissions",
      #
      #          #       source(file.path("indicators/hospital_admissions/hospital_admissions_ui.R"), local = TRUE)$value
      #
      # ), # tabpanel
      ##############################################.
      # OCCUPANCY ----
      ##############################################.
      # tabPanel(title = "COVID-19 hospital occupancy",
      #          # Look at https://fontawesome.com/search?m=free for icons
      #          icon = icon_no_warning_fn("bed-pulse"),
      #          value = "hospital_occupancy",
      #
      #          #   source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value
      #
      # ), # tabpanel
      ##############################################.
      # RESPIRATORY ----
      ##############################################.
      # tabPanel(title = "Respiratory infection activity",
      #          # Look at https://fontawesome.com/search?m=free for icons
      #          icon = icon_no_warning_fn("virus"),
      #          value = "respiratory",
      #
      #          source(file.path("indicators/respiratory/respiratory_ui.R"), local = TRUE)$value
      # ), # tabpanel
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
                                     h1("COVID-19"),
                                     p("Coronavirus disease (COVID-19) is an infectious disease caused by the SARS-CoV-2 virus.",
                                       "The most common symptoms are fever, chills, and sore throat. Anyone can get sick with",
                                       "COVID-19 but most people will recover without treatment. As yet, COVID-19 has not been",
                                       "shown to follow the same seasonal patterns as other respiratory pathogens.",
                                       "Additional information can be found on the PHS page for" , tags$a(href = "https://publichealthscotland.scot/our-areas-of-work/conditions-and-diseases/covid-19/",
                                                                                                          "COVID-19.")),
                                     linebreaks(1),
                                     radioGroupButtons("covid19_select", status = "home",
                                                       choices = c("Infection levels", "Hospital admissions", "Hospital occupancy",
                                                                   "CARI community surveillance", "Archive"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.covid19_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/cases/cases_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.covid19_select=='Hospital admissions'",
                                                      column(12, source(file.path("indicators/hospital_admissions/hospital_admissions_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.covid19_select=='Hospital occupancy'",
                                                      column(12, source(file.path("indicators/hospital_occupancy/hospital_occupancy_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.covid19_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/covid_19/covid_cari_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.covid19_select=='Archive'",
                                                      column(12, source(file.path("indicators/Archive/archive_ui.R"), local = TRUE)$value))
                            ),
                            tabPanel(title = "Influenza",
                                     value = "influenza",
                                     h1("Influenza"),
                                     p("Influenza, or flu, is a common infectious viral illness caused by influenza viruses.",
                                       "Influenza can cause mild to severe illness with symptoms including fever (38°C or above),",
                                       "cough, body aches, and fatigue. Influenza has a different presentation than the common",
                                       "cold, with symptoms starting more suddenly, presenting more severely, and lasting longer.",
                                       "Influenza can be caught all year round but is more common in the winter months."),
                                     linebreaks(1),
                                     radioGroupButtons("influenza_select", status = "home",
                                                       choices = c("Infection levels (all Influenza)", "Infection levels (by subtype)", "Hospital admissions", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.influenza_select=='Infection levels (all Influenza)'",
                                                      column(12, source(file.path("indicators/respiratory_mem/influenza/influenza_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.influenza_select=='Infection levels (by subtype)'",
                                                      column(12, source(file.path("indicators/respiratory_mem/influenza/influenza_subtype_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.influenza_select=='Hospital admissions'",
                                                      column(12, source(file.path("indicators/respiratory_mem/influenza/influenza_admissions_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.influenza_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/influenza/influenza_cari_ui.R"), local = TRUE)$value))
                                     ),
                            tabPanel(title = "RSV",
                                     value = "rsv",
                                     h1("Respiratory syncytial virus (RSV)"),
                                     p("Respiratory syncytial virus (RSV) is a virus that generally causes mild cold like",
                                       "symptoms but may occasionally result in severe lower respiratory infection such as",
                                       "bronchiolitis or pneumonia, particularly in infants and young children or in adults",
                                       "with compromised cardiac, pulmonary, or immune systems. RSV has an annual seasonality",
                                       "with peaks of activity in the winter months."),
                                     linebreaks(1),
                                     radioGroupButtons("rsv_select", status = "home",
                                                       choices = c("Infection levels", "Hospital admissions", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.rsv_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/rsv/rsv_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.rsv_select=='Hospital admissions'",
                                                      column(12, source(file.path("indicators/respiratory_mem/rsv/rsv_admissions_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.rsv_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/rsv/rsv_cari_ui.R"), local = TRUE)$value))),
                            tabPanel(title = "Adenovirus",
                                     value = "adenovirus",
                                     h1("Adenovirus"),
                                     p("Adenoviruses most commonly present as respiratory infections but can also",
                                       "cause gastrointestinal infections and infect the lining of the eyes (conjunctivitis),",
                                       "the urinary tract, and the nervous system. They are very contagious and are",
                                       "relatively resistant to common disinfectants. Adenoviruses do not follow a seasonal",
                                       "pattern and circulate all year round."),
                                     linebreaks(1),
                                     radioGroupButtons("adenovirus_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.adenovirus_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.adenovirus_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_cari_ui.R"), local = TRUE)$value))),
                            tabPanel(title = "HMPV",
                                     value = "hmpv",
                                     h1("HMPV"),
                                     p("Human Metapneumovirus (HMPV) is a virus associated with respiratory infections,",
                                       "ranging from mild symptoms to more severe illness such as bronchiolitis and",
                                       "pneumonia. Infection can occur in people of all ages, but commonly occurs in",
                                       "infants and young children. HMPV has distinct annual seasonality, with the highest",
                                       "transmission in the winter months."),
                                     linebreaks(1),
                                     radioGroupButtons("hmpv_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.hmpv_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/hmpv/hmpv_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.hmpv_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/hmpv/hmpv_cari_ui.R"), local = TRUE)$value))
                                     ),
                            tabPanel(title = "Mycoplasma pneumoniae",
                                     value = "mycoplasma_pneumoniae",
                                     h1("Mycoplasma pneumoniae"),
                                     p("Mycoplasma pneumoniae is a bacterium that only infects humans. It typically ",
                                       "causes mild infections of the upper respiratory tract, resulting in cold-like ",
                                       "symptoms. Mycoplasma pneumoniae is most frequently seen in school-age children ",
                                       "and young adults, but individuals of any age may be infected. Infections peak in ",
                                       "winter, usually between late December and February, but Mycoplasma pneumoniae ",
                                       "circulates throughout the year."), 
                                     linebreaks(1),
                                     radioGroupButtons("mycoplasma_pneumoniae_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.mycoplasma_pneumoniae_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/mycoplasma_pneumoniae/mycoplasma_pneumoniae_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.mycoplasma_pneumoniae_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/mycoplasma_pneumoniae/mycoplasma_pneumoniae_cari_ui.R"), local = TRUE)$value))
                                     ),
                            tabPanel(title = "Parainfluenza",
                                     value = "parainfluenza",
                                     h1("Parainfluenza"),
                                     p("Human parainfluenza virus (HPIV) is a virus that causes respiratory illness in humans.",
                                       "Despite its name, parainfluenza is not related to influenza and exhibits different",
                                       "characteristics. It is an important cause of upper and lower respiratory disease in",
                                       "infants and young children, elderly people and people who are immunocompromised."),
                                     #             "Additional information can be found on the PHS page for parainfluenza."),
                                     linebreaks(1),
                                     radioGroupButtons("parainfluenza_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.parainfluenza_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.parainfluenza_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_cari_ui.R"), local = TRUE)$value))
                                     ),
                            tabPanel(title = "Rhinovirus",
                                     value = "rhinovirus",
                                     h1("Rhinovirus"),
                                     p("Rhinoviruses are the most frequent cause of the common cold worldwide.",
                                       "Most infections are mild, with symptoms including coughs, sneezing, and",
                                       "nasal congestion but can lead to severe illness such as bronchitis, sinusitis,",
                                       "or pneumonia. Rhinoviruses circulate year-round, with peaks in autumn and spring."),
                                     #             "Additional information can be found on the PHS page for rhinovirus."),
                                     linebreaks(1),
                                     radioGroupButtons("rhinovirus_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.rhinovirus_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.rhinovirus_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_cari_ui.R"), local = TRUE)$value))
                                     ),
                            tabPanel(title = "Other seasonal coronaviruses",
                                     value = "seasonal_coronavirus",
                                     h1("Other seasonal coronaviruses"),
                                     p("Seasonal Coronaviruses (non COVID-19) are a group of viruses that typically cause mild to moderate",
                                       "upper respiratory tract infections, such as the common cold, but can cause lower-respiratory",
                                       "tract illnesses such as pneumonia and bronchitis. Infection can occur in people of all ages.",
                                       "Seasonal coronaviruses have an annual seasonality and typically circulate in the winter months."),
                                     linebreaks(1),
                                     radioGroupButtons("seasonal_coronavirus_select", status = "home",
                                                       choices = c("Infection levels", "CARI community surveillance"),
                                                       direction = "horizontal", justified = F),
                                     conditionalPanel(condition="input.seasonal_coronavirus_select=='Infection levels'",
                                                      column(12, source(file.path("indicators/respiratory_mem/seasonal_coronavirus/seasonal_coronavirus_mem_ui.R"), local = TRUE)$value)),
                                     conditionalPanel(condition="input.seasonal_coronavirus_select=='CARI community surveillance'",
                                                      column(12, source(file.path("indicators/respiratory_mem/seasonal_coronavirus/seasonal_coronavirus_cari_ui.R"), local = TRUE)$value))
                                     )
                            # tabPanel(title = "Other respiratory pathogens",
                            #          value = "other_pathogens",
                            #          source(file.path("indicators/respiratory_mem/other_pathogens/other_pathogens_mem_ui.R"), local = TRUE)$value)
               ) # navbarlistPanel
               #

      ),#tabPanel


     ##############################################.
      # SYNDROMIC SURVEILLANCE ----
      ##############################################.
      tabPanel(title ="Syndromic surveillance",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("virus"),
               value = "syndromic_surveillance",
               navlistPanel(widths = c(2,10), id = "syndromic_surveillance_panel", #icon = icon_no_warning_fn("spa")

                            tabPanel(title = "NHS24 calls",
                                     value = "nhs24_calls",
                                     column(12, source(file.path("indicators/syndromic_surveillance/nhs24/nhs24_ui.R"), local = TRUE)$value)),
                            tabPanel(title = "GP consultations",
                                     value = "gp_consultations",
                                     column(12, source(file.path("indicators/syndromic_surveillance/gp/gp_ui.R"), local = TRUE)$value))
               ) # navbarlistPanel
               #
      ),#tabPanel

      ##############################################.
      # MORTALITY ----
      ##############################################.
      tabPanel(title ="Mortality",
               # Look at https://fontawesome.com/search?m=free for icons
               icon = icon_no_warning_fn("virus"),
               value = "mortality",
               column(12, source(file.path("indicators/mortality/euromomo/euromomo_ui.R"), local = TRUE)$value)
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
  source(file.path("indicators/mortality/euromomo/euromomo_functions.R"), local = TRUE)$value

  # Get content for individual pages
  source(file.path("indicators/introduction/introduction_server.R"), local = TRUE)$value
  source(file.path("indicators/summary/summary_server.R"), local = TRUE)$value
  source(file.path("indicators/at_a_glance/at_a_glance_server.R"), local = TRUE)$value
  source(file.path("indicators/cases/cases_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_admissions/hospital_admissions_server.R"), local = TRUE)$value
  source(file.path("indicators/hospital_occupancy/hospital_occupancy_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory/respiratory_server.R"), local = TRUE)$value
  source(file.path("indicators/metadata/metadata_server.R"), local = TRUE)$value
  source(file.path("indicators/download/download_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/covid_19/covid_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_subtype_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_admissions_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/influenza/influenza_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/adenovirus/adenovirus_cari_server.R"), local = TRUE)$value

  source(file.path("indicators/respiratory_mem/hmpv/hmpv_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/hmpv/hmpv_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rsv/rsv_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rsv/rsv_admissions_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rsv/rsv_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/parainfluenza/parainfluenza_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/rhinovirus/rhinovirus_cari_server.R"), local = TRUE)$value
  #source(file.path("indicators/respiratory_mem/other_pathogens/other_pathogens_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/mycoplasma_pneumoniae/mycoplasma_pneumoniae_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/mycoplasma_pneumoniae/mycoplasma_pneumoniae_cari_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/seasonal_coronavirus/seasonal_coronavirus_mem_server.R"), local = TRUE)$value
  source(file.path("indicators/respiratory_mem/seasonal_coronavirus/seasonal_coronavirus_cari_server.R"), local = TRUE)$value
  

  source(file.path("indicators/mortality/euromomo/euromomo_server.R"), local = TRUE)$value

  source(file.path("indicators/syndromic_surveillance/nhs24/nhs24_server.R"), local = TRUE)$value
  source(file.path("indicators/syndromic_surveillance/gp/gp_server.R"), local = TRUE)$value
  
  auto_invalidate <- reactiveTimer(10000)
  observe({
    auto_invalidate()
    cat(".")
  })


}
#sets language right at the top of source (required this way for screen readers)
attr(ui, "lang") = "en"

#conditionally password protect app
if (password_protect){ ui <- secure_app(ui) }


# Run the application
shinyApp(ui=ui, server=server)

### END OF SCRIPT ###
