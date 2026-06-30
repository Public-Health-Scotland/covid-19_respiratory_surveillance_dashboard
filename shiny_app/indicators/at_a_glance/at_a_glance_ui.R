
cari_at_a_glance <- Respiratory_Pathogens_CARI_Scot %>%
  mutate(#WeekBeginning = as.Date(WeekBeginning),
    WeekEnding = as.Date(WeekEnding)) %>%
  filter(Pathogen %in% c("Adenovirus", "COVID-19", "Human Metapneumovirus", "Influenza",
                         "Mycoplasma Pneumoniae", "Overall Test Positivity", "Parainfluenza Virus",
                         "Respiratory Syncytial Virus", "Rhinovirus", "Seasonal Coronavirus (non-COVID-19)")) %>%
  mutate(Pathogen = ifelse(Pathogen == "Overall Test Positivity", "Any pathogen", as.character(Pathogen)),
         Pathogen = ifelse(Pathogen == "Parainfluenza Virus", "Parainfluenza", as.character(Pathogen))) %>%
  mutate(Pathogen = factor(Pathogen, levels = c("Any pathogen", "COVID-19", "Influenza",
                                                "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
                                                "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
                                                "Seasonal Coronavirus (non-COVID-19)")))

tagList(
  
  
  fluidRow(width=12, h1("Viral respiratory diseases (including influenza and COVID-19) surveillance in Scotland"),
           linebreaks(1)), #fluidRow
  
  fluidRow(width = 12,
           tagList("The chart below shows selected indicators of activity for each respiratory pathogen across the past 52 weeks.",
                   "These include laboratory-confirmed cases from ECOSS, CARI test-positivity from sentinel GP practices, and laboratory-confirmed hospital 
           admissions for each respiratory pathogen." ,
                   "The most recent week’s figure is displayed for each chart, as well as an indication of change relative to the previous week.",
                   "Values for specific weeks can be found by hovering over the chart."),
           linebreaks(1), #fluidRow
           linebreaks(1), #fluidRow
           p(strong("Lab-Confirmed Case Counts/ Activity Level"), " – reports testing data from the", tags$a("Electronic 
               Communication of Surveillance Scotland (ECOSS)",
                                                                                                             href="https://publichealthscotland.scot/resources-and-tools/health-intelligence-and-data-management/national-data-catalogue/national-datasets/search-the-datasets/electronic-communication-of-surveillance-scotland-ecoss/"),
             "system, undertaken primarily for clinical 
               or diagnostic purposes and largely in hospitals rather than in general practice or community settings."),
           linebreaks(1),
           p(strong("CARI Test Positivity")," - ",
             tags$a("Community Acute Respiratory Infection (CARI) surveillance",
                    href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/community-acute-respiratory-infection-cari-surveillance/overview-of-the-programme/#section-1"),
             "is conducted across a number of GP practices across Scotland. Patients attending with respiratory symptoms 
             are tested and the percentage of samples testing positive for each respiratory pathogen are shown here."),
           linebreaks(1),
           p(strong("Hospital Admissions ")," - Patients admitted to a hospital in Scotland with laboratory-confirmed respiratory infections, 
               as identified from the ",
             tags$a("Rapid Preliminary Inpatient Data (RAPID) datamart",
                    href="https://publichealthscotland.scot/healthcare-system/system-monitoring-accountability-and-quality-of-care/system-watch/rapid-preliminary-inpatient-data-rapid-datamart/"),
             "."),
           linebreaks(1),
           linebreaks(1)),
  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(plotlyOutput("all_paths_at_a_glance_plot", height="900px")),
               fluidRow(column(
                 width=12,
                 div(style = "background-color: white; padding: 15px;",
                     p("Further information on the above systems can be found within the Metadata tab, and further detail on activity for each pathogen
                can be found within the Respiratory Pathogens tab.")
                 )))
           ),
           fluidRow(
             width=12, linebreaks(1))
  )#, #fluidRow
  
  #  fluidRow(width = 12,
  #           tagList(h2("Number and rate per 100,000 population of laboratory-confirmed respiratory pathogen cases (week ending)")),
  #           linebreaks(1)), #fluidRow
  # 
  #  fluidRow(width=12,
  #           box(width = NULL,
  #               withNavySpinner(dataTableOutput("cases_intro_table"))),
  #               fluidRow(
  #                 width=12, linebreaks(1)),
  #           p("Please refer to metadata tab for further information on testing policies."),
  #           ), #fluidRow
  #  
  #  fluidRow(width = 12,
  #           tagList(h2("Test positivity in the Community Acute Respiratory Infection (CARI) sentinel surveillance programme")),
  #           linebreaks(1)), #fluidRow
  #  
  #  fluidRow(width=12,
  #           pickerInput("cari_selected_pathogen", "Select pathogen(s):", 
  #                       choices = sort(unique(cari_at_a_glance$Pathogen)),
  #                       selected = sort(unique(cari_at_a_glance$Pathogen))[1],
  #                       multiple = TRUE),
  #           box(width = NULL,
  #               altTextUI("cari_summary_modal"),
  #               cariDefinitionUI("cari_summary_definition"),
  #               swabposDefinitionUI("cari_summary_swabpos"),
  #               #ciDefinitionUI("cari_summary_ci"),
  #               withNavySpinner(
  #                 plotlyOutput("cari_intro_plot")),
  #               fluidRow(
  #                 width=12)),
  #           linebreaks(1)
  #  ), #fluidRow
  # 
  #  fluidRow(width = 12,
  #           tagList(h2("Number and rate per 100,000 population of acute hospital admissions due to each pathogen (week ending)")),
  #           linebreaks(1)), #fluidRow
  # 
  #  fluidRow(width=12,
  #           box(width = NULL,
  #               withNavySpinner(dataTableOutput("hosp_adms_intro_table"))),
  #           linebreaks(1),
  #           tagList(h2("Number of acute hospital admissions due to each pathogen")),
  #           linebreaks(1)),
  # 
  #  fluidRow(width=12,
  #           box(width = NULL,
  #               altTextUI("adms_summary_modal"),
  #               withNavySpinner(
  #                 plotlyOutput("hosp_adms_intro_plot")),
  #           # fluidRow(
  #           #   width=12, 
  #           #   linebreaks(1))
  #           )
  #  ), #fluidRow
  # 
  # fluidRow(width = 12,
  #          tagList(h2("Number of inpatients in hospital with COVID-19, Influenza, or RSV (seven day average)")),
  #          linebreaks(1)), #fluidRow
  # 
  # fluidRow(width=12,
  #          box(width = NULL,
  #              withNavySpinner(dataTableOutput("inpatients_intro_table"))),
  #          fluidRow(
  #            width=12, linebreaks(5))
  #)
  
  
  
  
) #tagList



