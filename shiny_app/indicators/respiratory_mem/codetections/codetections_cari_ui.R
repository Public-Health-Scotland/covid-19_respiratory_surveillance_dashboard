
# CARI HB data
codetection_cari_age <- Respiratory_Pathogens_CARI_codetections %>% 
  mutate(AgeGroup = factor(AgeGroup, levels = c("All ages", "0-4 years", "5-14 years", 
                                                "15-44 years", "45-64 years", "65+ years")))



cari_seasons <- sort(unique(Respiratory_Pathogens_CARI_duodetections$Season))


tagList(
  
  fluidRow(width = 12,
           p("CARI surveillance is a sentinel community surveillance programme monitoring COVID-19, ",
             "influenza A and B, Respiratory Syncytial Virus (RSV), adenovirus, coronavirus (non-COVID19),", 
             "human metapneumovirus (HMPV), rhinovirus, parainfluenza and Mycoplasma pneumoniae. The ",
             "programme is open to GP practices across all NHS Boards in Scotland. To become a sentinel site,", 
             "GP practices voluntarily opt into the CARI programme. Patients in the community who consult a ",
             "sentinel GP practice with respiratory symptoms and who meet the case definition for acute ",
             "respiratory infection (ARI) are recruited, consented, and tested for the CARI programme.")#,
  ),
  
  fluidRow(width = 12,
           tagList(h2("CARI - Proportion of positive samples that are co-detections by age group")),
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    br(),
                    pickerInput("codetection_cari_selected_age", "Select age group(s) of interest:", 
                                choices = sort(unique(codetection_cari_age$AgeGroup)),
                                selected = sort(unique(codetection_cari_age$AgeGroup))[1],
                                multiple = TRUE),
                    tagList(linebreaks(1),
                            altTextUI("codetections_cari_modal"),
                            withNavySpinner(plotlyOutput("codetections_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("codetections_cari_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ),
  
  
  fluidRow(width = 12,
           tagList(h2("CARI - Relative frequency (%) of each pathogen in all samples with two-pathogen co-detections"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    br(),
                    pickerInput(inputId = "cari_season",
                                label = "Select season",
                                choices = {cari_seasons %>% tail(6) },
                                selected = {cari_seasons %>% tail(1)}),
                    tagList(linebreaks(1),
                            altTextUI("duodetections_cari_modal"),
                            withNavySpinner(plotlyOutput("duodetections_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("duodetections_cari_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  )
  
)
