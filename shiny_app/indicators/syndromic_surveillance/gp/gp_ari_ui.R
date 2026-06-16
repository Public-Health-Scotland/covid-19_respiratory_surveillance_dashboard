tagList(
  fluidRow(width = 12,
           h2("GP Consultations for Acute Respiratory Infections (ARI)"),
           p("Acute respiratory infection (ARI) diagnoses by General Practitioners (GP) are recommended ",
             "for use in recruiting participants to sentinel surveillance programs such as the Community ",
             "Acute Respiratory Infection (CARI) system. Consultations for ARI typically occur at much ",
             "higher rates than those of influenza-like illness (ILI) because the ARI surveillance system ", 
             "reports GP visits from patients with a wide range of respiratory diagnoses. ARI ",
             "consultation rates are used internationally as a key measure of respiratory viral activity in ", 
             "the community and is recommended for use alongside ILI surveillance to indicate overall trends ", 
             "in respiratory infection rates."),
           
           linebreaks(1)),
  
  fluidRow(width = 12,
           tagList(h2("GP consultation rates for ARI per 100,000 population in Scotland"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("gp_ari_mem_modal"),
                            withNavySpinner(plotlyOutput("gp_ari_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("gp_ari_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  

  
  
  fluidRow(width = 12,
           tagList(h2("GP consultation rates for ARI per 100,000 population by age group"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("gp_ari_mem_age_modal"),
                            withNavySpinner(plotlyOutput("gp_ari_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("gp_ari_mem_age_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  )#, # fluidRow
  
)


