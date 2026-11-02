
tagList(h1("Metadata"),
        
        p("For details of data sources used for weekly surveillance, please refer to the", 
          tags$a("technical information webpage",
                 href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/technical-information/overview/", target = "_blank")),
        br(),
        
        #### METADATA PANELS ----
        #bsCollapse(id="notes_collapse", open = "Panel 1",
        
        h1("Glossary"),
        br(),
                   
                  
                                   #### GLOSSARY PANEL ----
                                   #bsCollapsePanel("Glossary",
                                                   
                                                   # ACTIVITY LEVEL
                                                   h4("Activity Level"),
                                                   p("The activity level refers to the number or rate of positive test results for an organism and shows how common a respiratory
                                                     infection or related measure is compared with what is usually seen."),
                                                   p("Levels such as baseline, low, medium, high or very high are set by calculating thresholds and they then 
                                                     help readers compare patterns over time and across settings and countries."),
                                                   p(tags$a("Find out more information",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/technical-information/metrics-activity-levels/", target = "_blank")),
                                                   br(),
                                                   
                                                   #ARI
                                                   h4("Acute respiratory infection (ARI)"),
                                                   p("Acute respiratory infection (ARI) is a general term for a respiratory illness that starts suddenly."),
                                                   p("Symptoms may include cough, sneezing, a runny or blocked nose, sore throat, fever, breathlessness
                                                     or muscle aches."),
                                                   p("Individual surveillance systems may use a more specific definition."),
                                                   br(),
                                                   
                                                   # ADENOVIRUS
                                                   h4("Adenovirus"),
                                                   p("Adenoviruses are a group of viruses that often cause respiratory illness."),
                                                   p("They can also affect the stomach and bowel, eyes, urinary tract or nervous system."),
                                                   p("They circulate throughout the year."),
                                                   br(),
                                                   
                                                   # CARI
                                                   h4("Community Acute Respiratory Infection (CARI)"),
                                                   p("Community Acute Respiratory Infection (CARI) is a year-round surveillance programme that monitors respiratory infections
                                                     in the community."),
                                                   p("Around 125 GP practices across Scotland, selected to provide representative geographical coverage:"),
                                                   tags$ul(
                                                     tags$li("recruit patients with respiratory symptoms"),
                                                     tags$li("collect symptom information"),
                                                     tags$li("arrange testing for 10 respiratory pathogens")),
                                                   p("CARI provides a representative sample rather than a count of every infection in Scotland."),
                                                   p(tags$a("Find out more about CARI",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/respiratory-surveillance-systems/community-acute-respiratory-infection-cari-surveillance/purpose-of-the-surveillance-system/", target = "_blank")),
                                                   br(),
                                                   
                                                   # CONFIDENCE INTERVAL
                                                   h4("Confidence interval"),
                                                   p("A confidence interval shows the uncertainty around an estimate."),
                                                   tags$ul(
                                                     tags$li("A narrow interval means the estimate is more precise."),
                                                     tags$li("A wide interval means there is more uncertainty."),
                                                     tags$li("Overlapping intervals suggest that there may not be a true
                                                             difference between two estimates.")),
                                                   br(),

                                                   # COVID-19 
                                                   h4("COVID-19"),
                                                   p("COVID-19 is an infectious disease caused by the SARS-CoV-2 virus."),
                                                   p("Symptoms can include cough, sneezing, blocked nose, sore throat, headache, shortness of breath, fever,
                                                   and tiredness."),
                                                   p("Most people recover without treatment, but some people become seriously ill."),
                                                   p(tags$a("Find out more about COVID-19",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/infectious-diseases/covid-19/", target = "_blank")),
                                                   br(),
                                                   
                                                   # ECOSS 
                                                   h4("Electronic Communication of Surveillance in Scotland (ECOSS)"),
                                                   p("ECOSS is the national system for collecting laboratory test results from diagnostic and reference
                                                     laboratories in Scotland."),
                                                   br(),
                                                   
                                                   # Excess mortality 
                                                   h4("Excess mortality"),
                                                   p("Excess mortality means that more deaths occurred than expected for that time of year."),
                                                   p("It can be affected by many factors, including cold weather, long-term health conditions and respiratory infections such as influenza,
                                                     so this measure is not specific to respiratory conditions."),
                                                   br(),
                                                   
                                                   # HMPV
                                                   h4("HMPV"),
                                                   p("Human Metapneumovirus (HMPV) is a virus that causes respiratory infections."),
                                                   p("Illness can range from mild symptoms to bronchiolitis or pneumonia."),
                                                   p("It can affect all ages but is most common in infants and young children, and usually peaks in winter."),
                                                   br(),
                                                   
                                                   # Hospital occupancy
                                                   h4("Hospital occupancy (inpatients)"),
                                                   p("Hospital occupancy is the average number of hospital beds occupied by inpatients during the previous
                                                     seven days."),
                                                   p("On the COVID-19 and Respiratory Surveillance dashboard we show occupancy for patients with community-acquired,
                                                     laboratory-confirmed influenza, COVID-19 or respiratory syncytial virus (RSV)."),
                                                   br(),

                                                   # INFLUENZA 
                                                   h4("Influenza"),
                                                   p("Influenza, or flu, is an infectious illness caused by influenza viruses."),
                                                   p("Symptoms can include fever, cough, body aches, and tiredness."),
                                                   p("Flu often starts more suddenly, lasts longer and is more severe than a common cold."),
                                                   p("It is most common in winter. The main seasonal influenza viruses in people are influenza A and influenza B."),
                                                   br(),
                                                   
                                                   # INFLUENZA LIKE ILLNESS
                                                   h4("Influenza-like illness (ILI)"),
                                                   p("Influenza-like illness (ILI) describes an acute respiratory illness with symptoms that may be caused by flu."),
                                                   p("It is based on symptoms and a clinician's assessment, so it is not the same as laboratory-confirmed influenza."),
                                                   br(),
                                                   
                                                   # ISO WEEK
                                                   h4("ISO week"),
                                                   p("An ISO week starts on a Monday."),
                                                   p("Week 1 is the week that contains the first Thursday of the year."),
                                                   p("Most years have 52 ISO weeks, but some have 53."),
                                                   br(),
                                                   
                                                   # Length of stay
                                                   h4("Length of stay (LOS)"),
                                                   p("Length of stay (LOS) is the time a person stays in hospital, from admission to discharge."),
                                                   p("In our surveillance outputs, it relates to admissions with laboratory-confirmed influenza, COVID-19 or RSV."),
                                                   br(),
                                                   
                                                   # Mean standard deviation method
                                                   h4("Mean standard deviation (MSD) method"),
                                                   p("The mean standard deviation (MSD) method sets activity thresholds using patterns in previous data."),
                                                   p("It is useful when an infection does not have a clear seasonal wave or when fewer than five years of
                                                     comparable data are available."),
                                                   p("Thresholds may change slightly when recent data is updated."),
                                                   p(tags$a("Find out more about the MSD method",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/technical-information/metrics-activity-levels/mean-standard-deviation-msd/", target = "_blank")),
                                                   br(),
                                                   
                                                   # MOVING EPIDEMIC METHOD (MEM)
                                                   h4("Moving Epidemic Method (MEM)"),
                                                   p("The moving epidemic method (MEM) uses data from previous seasons to set thresholds and classify activity levels."),
                                                   p("It is mainly used for infections or measures with a clear seasonal pattern and is widely used to
                                                     define influenza activity levels."),
                                                   p(tags$a("Find out more about the MEM method",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/technical-information/metrics-activity-levels/moving-epidemic-method-mem/", target = "_blank")),
                                                   br(),
                                                   
                                                   # MYCOPLASMA PNEUMONIAE
                                                   h4("Mycoplasma pneumoniae"),
                                                   p("Mycoplasma pneumoniae is a bacterium that causes respiratory infections, often with mild cold-like symptoms."),
                                                   p("It is most common in school-age children and young adults, although anyone can be infected."),
                                                   p("Larger increases tend to occur every three to five years."),
                                                   br(),
                                                   
                                                   # NHS 24
                                                   h4("NHS 24"),
                                                   p("NHS 24 provides Scotland's 111 service for urgent care health advice when a condition is not life-threatening."),
                                                   p("Information about reasons for calls, such as cough, colds and flu, fever, breathing difficulty, sore throat and 
                                                     and loss of sense of taste or smell, helps monitor changes in respiratory symptoms across Scotland."),
                                                   br(),
                                                   
                                                   # PARAINFLUENZA
                                                   h4("Parainfluenza"),
                                                   p("Human parainfluenza viruses cause respiratory illness and are not the same as influenza viruses."),
                                                   p("They can cause upper and lower respiratory infections, particularly in young children, older 
                                                     people and people with weakened immune systems and typically peak in October and November."),
                                                   p("They are also a common cause of croup."),
                                                   br(),
                                                   
                                                   # Pathogen-confirmed hospital admissions
                                                   h4("Pathogen-confirmed hospital admissions"),
                                                   p("A pathogen-confirmed hospital admission is an emergency admission where testing has found a respiratory 
                                                     pathogen and this infection is considered to be linked to the admission."),
                                                   br(),
                                                   
                                                   # RAPID
                                                   h4("RAPID"),
                                                   p("Rapid and Preliminary Inpatient Data (RAPID) is a PHS dataset containing recent information about 
                                                     inpatient and day-case hospital activity submitted by NHS Boards."),
                                                   p("It is updated weekly and covers acute hospital admissions, excluding psychiatric and maternity or 
                                                     obstetric specialties."),
                                                   p("Records relate to a stay in a single hospital, so a transfer will result in a new record. The figures may 
                                                     change as hospital records are completed."),
                                                   br(),
                                                   
                                                   # RHINOVIRUS
                                                   h4("Rhinovirus"),
                                                   p("Rhinoviruses are the most common cause of the common cold."),
                                                   p("Most infections are mild, with symptoms including cough, sneezing and nasal congestion, but some can lead 
                                                     to more serious respiratory illness."),
                                                   p("Rhinoviruses circulate throughout the year and often peak in autumn and spring."),
                                                   br(),
                                                   
                                                   # RSV
                                                   h4("RSV"),
                                                   p("Respiratory syncytial virus (RSV) usually causes mild cold-like symptoms, but can sometimes cause severe lower
                                                     respiratory infection such as bronchiolitis or pneumonia."),
                                                   p("Severe illness is more likely in infants, young children and adults with heart, lung or immune system conditions."),
                                                   p("RSV usually peaks in winter."),
                                                   br(),
                                                   
                                                   # Seasonal coronavirus
                                                   h4("Seasonal coronavirus"),
                                                   p("Seasonal coronaviruses are viruses that usually cause mild to moderate respiratory illness, such
                                                     as the common cold."),
                                                   p("They can sometimes cause more serious illnesses such as pneumonia and bronchitis."),
                                                   p("They often circulate in winter and affect people of all ages."),
                                                   p("SARS-CoV-2, which causes COVID-19, is reported separately."),
                                                   br(),
                                                   
                                                   # SARI
                                                   h4("Severe acute respiratory infection (SARI)"),
                                                   p("Sever acute respiratory infection (SARI) is a serious respiratory illness that requires hospital care."),
                                                   p("The World Health Organization definition includes fever and cough, with symptoms starting in the previous 
                                                     10 days."),
                                                   p("PHS may use a closely related working definition for surveillance."),
                                                   br(),
                                                   
                                                   # Syndromic surveillance
                                                   h4("Syndromic surveillance"),
                                                   p("Syndromic surveillance uses observable signs and reported symptoms to identify cases of an illness in the 
                                                      absence of definitive diagnoses or laboratory test results."),
                                                   br(),
                                                   
                                                   #TEST POSITIVITY
                                                   h4("Test positivity"),
                                                   p("Test positivity is the percentage of tests that have a positive result."),
                                                   p("It is worked out from positive and negative test results."),
                                                   p(tags$a("Find out more about test positivity",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/respiratory-surveillance/technical-information/metrics-test-positivity/", target = "_blank")),
                                                   br()



                                                   #)

                              #)
        )#tagList
                   
