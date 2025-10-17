
cari_at_a_glance <- Respiratory_Pathogens_CARI_Scot %>%
  mutate(WeekBeginning = as.Date(WeekBeginning),
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
           #p(strong("The next release of this dashboard will be 08 August 2024.")),
           linebreaks(1)), #fluidRow
  
  fluidRow(width = 12,
           tagList(h2("Number and rate of laboratory-confirmed respiratory pathogen cases (week ending)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("cases_intro_table"))),
               fluidRow(
                 width=12, linebreaks(1)),
           p("Please refer to metadata tab for further information on testing policies."),
           ), #fluidRow
  
  fluidRow(width = 12,
           tagList(h2("Test positivity in the Community Acute Respiratory Infection (CARI) sentinel surveillance programme")),
           linebreaks(1)), #fluidRow
  
  fluidRow(width=12,
           selectInput("cari_selected_pathogen", "Select pathogen(s):", 
                       choices = sort(unique(cari_at_a_glance$Pathogen)),
                       selected = sort(unique(cari_at_a_glance$Pathogen))[1],
                       multiple = TRUE),
           box(width = NULL,
               altTextUI("cari_summary_modal"),
               swabposDefinitionUI("cari_summary_swabpos"),
               #ciDefinitionUI("cari_summary_ci"),
               withNavySpinner(
                 plotlyOutput("cari_intro_plot")),
               fluidRow(
                 width=12)),
           linebreaks(1)
  ), #fluidRow

  fluidRow(width = 12,
           tagList(h2("Number and rate of acute hospital admissions due to COVID-19, influenza and RSV (week ending)")),
           linebreaks(1)), #fluidRow

  fluidRow(width=12,
           box(width = NULL,
               withNavySpinner(dataTableOutput("hosp_adms_intro_table"))),
           linebreaks(1),
           tagList(h2("Number of acute hospital admissions due to COVID-19, influenza and RSV")),
           linebreaks(1)),

  fluidRow(width=12,
           box(width = NULL,
               altTextUI("adms_summary_modal"),
               withNavySpinner(
                 plotlyOutput("hosp_adms_intro_plot")),
           fluidRow(
             width=12, linebreaks(5)))),
  
  # All Pathogens Trend Chart starts here. Move if desired.         
  fluidRow(width = 12,
           tagList(h2("All Pathogens Trend Chart")),
           linebreaks(1)),
  fluidRow(width=12,
           box(width = NULL,
               altTextUIStatic("all_pathogens_chart_text"),
               withNavySpinner(
                 plotOutput("pathogen_barchart")),
               fluidRow(
                 width=12, linebreaks(5))))
)#, #fluidRow

  # fluidRow(width = 12,
  #          tagList(h2("Number of inpatients with COVID-19 in hospital (seven day average)")),
  #          linebreaks(1)), #fluidRow
  # 
  # fluidRow(width=12,
  #          box(width = NULL,
  #              withNavySpinner(dataTableOutput("inpatients_intro_table"))),
  #          fluidRow(
  #            width=12, linebreaks(5))
 # )




 #tagList



