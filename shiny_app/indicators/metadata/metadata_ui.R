
tagList(h1("Metadata"),
        
        #### METADATA PANELS ----
        bsCollapse(id="notes_collapse", open = "Panel 1",
                   
                   #### INFECTION LEVELS PANEL ----
                   bsCollapsePanel("Laboratory Surveillance",
                                   
                                   p("All pathogen testing is recorded in Electronic Communication of Surveillance in Scotland (ECOSS), a national laboratory surveillance
                                     system that captures laboratory results from diagnostic and reference laboratories in Scotland."),
                                   p("All case counts include cases diagnosed by PCR (polymerase chain reaction), LFD (lateral flow device), or both (LFD included from 05 January 2022).
                                     A positive case includes both new infections and possible reinfections. Possible reinfections are defined as individuals who tests positive by PCR 
                                     or LFD, 90 or more clear days after their last positive test. More information is available on the PHS website",
                                     tags$a("here.",
                                            href="https://publichealthscotland.scot/news/2022/february/covid-19-reporting-to-include-further-data-on-reinfections/"),
                                   ),
                                   
                                   
                                   p("Changes in testing practices since  ",
                                     tags$a("May", href="https://www.gov.scot/publications/test-protect-transition-plan/?msclkid=69623e15ba4711ecb8a394934cbaa327"),
                                     " (end of universal testing) and ",
                                     tags$a("September",
                                            href="https://www.sehd.scot.nhs.uk/dl/DL(2022)32.pdf"),
                                     "(end of asymptomatic testing) make it difficult to draw any conclusions from these data on community prevalence, therefore, caution
                                     is advised when comparing trends in cases over time."),
                                   p(strong("Source: PCR - Electronic Communication of Surveillance in Scotland (ECOSS); LFD - UK Government self-reported / NSS Portal")),
                                   br(),
                                   p("Notes:"),
                                   tags$ul(
                                     tags$li("The total number of people within Scotland who have, or have had, COVID-19 since the coronavirus outbreak began is unknown.
                                           The number of confirmed cases is likely to be an underestimate."),
                                     tags$li("The purpose of COVID-19 testing has now shifted from population-wide testing to reduce transmission, to targeted, symptomatic
                                            testing in clinical care settings. Data are continuously updated, therefore figures for previous weeks may differ
                                            from published data in previous weeks’ reports."),
                                     tags$li("The drop in the number of confirmed cases at weekends likely reflects that laboratories are doing fewer tests at the weekend.")),
                                   p("Due to changes in testing strategy outlined above, caution is advised when comparing trends over time."),
                                   br()),
                                   
                                   
                                   
                                   #### CARI PANEL ----
                                   bsCollapsePanel("CARI",
                                                   
                                                   # Infection Levels ----
                                                   #h4("Infection levels"),
                                                   p("CARI surveillance is a sentinel community surveillance programme monitoring COVID-19, influenza A and B, Respiratory Syncytial Virus (RSV), 
                                     adenovirus, coronavirus (non-COVID19), human metapneumovirus (HMPV), rhinovirus, parainfluenza and Mycoplasma pneumoniae. The programme is 
                                     open to GP practices across all NHS Boards in Scotland. To become a sentinel site, GP practices voluntarily opt into the CARI programme. 
                                     Patients in the community who consult a sentinel GP practice with respiratory symptoms and who meet the case definition for acute respiratory 
                                     infection (ARI) are recruited, consented, and tested for the CARI programme. Clinicians also complete a symptoms checklist."),
                                                   p("The case definition is: sudden onset of symptoms; at least one of the following four respiratory symptoms: cough, sore throat, 
                                                     shortness of breath, coryza; and a clinician's judgement that the illness is due to an infection."),
                                                   p("Data are reported by week of test for recruited individuals for whom test result data are available. Data are derived from samples 
                                                     tested up to the current reporting week, and any retrospective numbers are updated in the next weekly report."),
                                                   # "Additional information can be found on the PHS page for influenza."),
                                                   p(strong("Source: Community Acute Respiratory Infection (CARI) sentinel practices")),
                                                   br()),
                                                   
     
                                   
                                   #### HOSPITAL ADMISSIONS PANEL ----
                                   bsCollapsePanel("Hospital Admissions",
                                                   

                                                   p("Patients admitted as an emergency to a hospital in Scotland with laboratory-confirmed respiratory infections are 
                                                     identified from Rapid Preliminary Inpatient Data (RAPID)."),
                                                   p("RAPID is a weekly submission of people who have been admitted and discharged to hospital in Scotland. RAPID 
                                                     data is updated on a weekly basis and NHS boards are required to submit information on admissions no later than 
                                                     midday Wednesday. A complete provisional dataset prepared on Tuesday 2pm is used for the analysis in this report."),
                                                   p("The case definition includes patients admitted as an emergency to a medical specialty in acute hospitals 
                                                     (excluding surgical, maternity/obstetrics and mental health specialties, and emergency admissions with patient
                                                     injury codes) who have a PCR test result, taken within a period of between 14 days before the admission date and
                                                     48 hours after the admission date. COVID-19 test results can include LFD results (from 05 Jan 2022)."),
                                                   p("Notes:"),
                                                   tags$ul(
                                                     tags$li("RAPID figures are subject to change as hospital records are updated. It can take on average 
                                                             6-8 weeks before a record is finalised, particularly discharge details."),
                                                     tags$li("Hospital admissions for the most recent week may be incomplete for some Boards and should be 
                                                             treated as provisional and interpreted with caution. Where no data are available at the time of 
                                                             publication, the number of admissions for the previous week will be rolled forward for affected 
                                                             Boards. Missing data will either be due to a board not submitting on time or there being zero 
                                                             dmissions in the latest week. These provisional data will be updated the following week."),
                                                     tags$li("COVID-19 episodes of reinfection are included from 01 March 2022, so care should be taken when 
                                                             interpreting trends over time. For more information, see ",
                                                             tags$a("here.",
                                                                    href="https://publichealthscotland.scot/news/2022/february/covid-19-reporting-to-include-further-data-on-reinfections/")),
                                                     tags$li("People who were admitted for a non-respiratory infection reason, who subsequently tested positive 
                                                             for a respiratory pathogen upon admission, may be included, as analysis does not take into account
                                                             reason for hospitalisation."),
                                                     tags$li("An admission is defined as a period of stay in a single hospital. There may be multiple admissions 
                                                             for a single patient if they have moved between locations during a continuous inpatient stay, or if 
                                                             they have been admitted to hospital on separate occasions.")),
                                                   
                                                   p(strong("Source: PCR - Electronic Communication of Surveillance in Scotland (ECOSS); 
                                                            LFD - UK Government self-reported / NSS Portal; Rapid and Preliminary Inpatient Data (RAPID)")),
                                                   br()),
                                                   
                                                                            
                                   #### HOSPITAL OCCUPANCY (INPATIENTS) PANEL ----
                                   bsCollapsePanel("Hospital Occupancy (inpatients)",
                                                   
                                                   p("This measure shows the number of hospital beds across Scotland occupied by patients with 
                                                     community-acquired Influenza, COVID-19, or RSV. They are hospital admissions with laboratory-confirmed
                                                     positive test results."),
                                                   p("Hospital occupancy is calculated from admission and discharge dates provided in RAPID, with inpatient
                                                     days counted from date of admission to date of discharge. It can take 6-8 weeks before a RAPID record 
                                                     is finalised, discharge details in particular can be slow to complete. For this reason, discharge 
                                                     values are imputed when they are missing. Data are subject to revision as hospital records are updated."),
                                                   p("Patients admitted to hospital and discharged on the same date are included in this count."),
                                                   p("Values shown are mean daily numbers, across the previous 7 days."),
                                                   p("Cases where more than one virus has been co-detected will be counted more than once, in each pathogen specific count."),
                                                   tags$ul(
                                                     tags$li("This measure of hospital occupancy for influenza and RSV is available from May 2023 and first published in October 2025."),
                                                     tags$li("The same measure is reported for COVID-19 from October 2025.")),
                                                   p("COVID-19: Other measures for hospital occupancy for COVID-19 are available from 11 September 2020 
                                                     (first published 15 September 2020) until October 2025."),
                                                   p("Differences in measures should be considered when looking at trends in COVID-19 hospital occupancy over time. Prior to October 2025:"),
                                                   tags$ul(
                                                     tags$li("COVID-19 test results include LFD test results from 5 January 2022."),
                                                     tags$li("COVID-19 hospital occupancy data include inpatients in community, mental health and long stay hospitals."),
                                                     tags$li("COVID-19 occupancy data was submitted directly by Boards, weekly. This was based on the number of inpatients 
                                                     in beds at 8am the day prior to reporting, with the data extract taken at 8am on the day of reporting to allow 24 hours 
                                                             for test results to become available."),
                                                     tags$li("This included all inpatients who tested positive during their stay in hospital or in the 14 days before admission;
                                                             hospital acquired infections were not excluded."),
                                                     tags$li("Patients stopped being included after 10 days in hospital, or 10 days after first testing positive if this 
                                                             was after admission (this definition first applied to COVID-19 from May 2023).")
                                                   ),
                                                   p("Health Board analyses are based on NHS Health Board of treatment."),
                                                   p(strong("Source: Rapid and Preliminary Inpatient Data (RAPID), Electronic Communication of Surveillance in Scotland (ECOSS), 
                                                            NHS Health Boards (for COVID-19 data prior to October 2025)")),
                                                   br()),
                                                   
                                                   
                                                
                                   
                                   #### LENGTH OF STAY (LOS) PANEL ----
                                   bsCollapsePanel("Length of stay (LOS)",

                                                   p("This measure is shown for admissions with laboratory-confirmed positive test results for Influenza, COVID-19 and RSV.
                                                     LOS can be influenced by a variety of factors including age, reason for admission, co-morbidities, and hospital pressures.
                                                     This analysis does not account for these factors."),
                                                   p("LOS is calculated from admission and discharge dates provided in RAPID. It can take 6-8 weeks before a record is finalised,
                                                     discharge details in particular can be slow to complete. For this reason, discharge values are imputed when they are missing.
                                                     Data are subject to revision as hospital records are updated."),
                                                   p("Data are reported a week in lag, to allow for discharge dates to be supplied."),
                                                   p("Values shown are mean LOS values throughout the given respiratory season."),
                                                   p("Cases where more than one virus has been co-detected will be counted more than once, in each pathogen specific count."),
                                                   p(strong("Source: Rapid and Preliminary Inpatient Data (RAPID) and Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                                   br()),

                   
                                   
                                   #### WASTEWATER PANEL ----
                                   bsCollapsePanel("Wastewater",
                                                   
                                      
                                                   h4("COVID-19"),
                                                   p("In June 2020, Scottish Government, in partnership with Scottish Water and the Scottish Environment Protection Agency (SEPA), 
                                                     established a national Wastewater Monitoring Programme for SARS-CoV-2 in Scotland. This surveillance system detects fragments,
                                                     known as ribonucleic acid (RNA), of the SARS-CoV-2 virus genome from wastewater samples."),
                                                   p("In contrast to COVID-19 case records, virus shedding into wastewater is a biological process, meaning wastewater data is 
                                                     unaffected by factors that impact whether individuals seek and access healthcare. Around 113 sewage samples each week are 
                                                     collected by Scottish Water from wastewater treatment works across Scotland and sent to NHS Lothian for testing (carried out 
                                                     by SEPA until end July 2024)."),
                                                   p("A quantitative Polymerase Chain Reaction (qPCR) method is used to quantify the strength of the RNA signal in a cleaned and 
                                                     concentrated sample, allowing PHS to calculate the number of SARS-CoV-2 virus markers in each sample. This raw viral concentration
                                                     is reported as gene copies per litre (gc/L). It should be noted that levels of SARS-CoV-2 quantity can show a substantial 
                                                     degree of variability, particularly at the scale of individual sampling sites. Household drainage water is typically mixed
                                                     with water from other urban sources, meaning samples will contain rainwater which dilutes the sample. This variability is 
                                                     accounted for by controlling for the volumes of influent received by wastewater treatment works, known as ‘flow’ (sourced 
                                                     from Scottish Water). Flow is controlled for directly where feasible, or otherwise using an approximation based on ammonia
                                                     levels. The data are also adjusted by the population size covered by each treatment works’ catchment area and finally reported
                                                     as million gene copies per person per day (Mgc/p/d)."),
                                                   p(strong("Source: Wastewater data analyses for COVID-19 are produced by PHS Wastewater Analysis Group for the Wastewater Monitoring 
                                                            Programme in Scotland, which is operated by Scottish Government in partnership with Scottish Water and NHS Lothian")),
                                                   p(strong("This text was last updated on Tuesday 2 September 2025.")),
                                                   br()),
                                                   
                                                   
                                            
                                   
                                   
                                   
                                   #### SYNDROMIC SURVEILLANCE PANEL ----
                                   bsCollapsePanel("Syndromic Surveillance",
                                                   
                                                   # NHS 24 Calls ----
                                                   h4("NHS 24 Calls"),
                                                   p("NHS24 is the '111' service for Scotland, providing a 24-hour hotline available to members of the public who require advice about
                                                     urgent but not-life-threatening medical problems. Data from these calls is recorded by call handlers and stored electronically, 
                                                     including information regarding time of call, geographical location, caller demographics, and call reason."),
                                                   p("The proportion of NHS24 calls for respiratory symptoms is calculated through identifying calls with the following call reasons: 
                                                     ‘cough’, ‘colds and flu’, ‘difficulty breathing’, and ‘fever’. Call reason is a free-text field, that is screened for key words 
                                                     used to identify syndromes. Postcode data provided in the calls allows for surveillance of geographical distribution, and caller
                                                     age provides information on the age breakdown of different symptoms."),
                                                   p(strong("Source: NHS24")),
                                                   br(),
                                                   
                                                   # GP Consultations
                                                   h4("GP Consultations"),
                                                   p("Public Health Scotland regularly reports consultation rates for influenza-like-illness (ILI) and acute respiratory infection (ARI)
                                                     in primary care. This is the key measure of influenza activity in the community and is used to gauge the severity of influenza seasons
                                                     in Scotland each winter. It is also used for comparison of influenza activity across the UK and Europe."),
                                                   p("Since 1972, rates of ILI seen by general practitioners have been monitored every week across Scotland. The way in which this influenza
                                                     data is captured has changed over the years, but the common method of presentation has remained constant and has been to express GP 
                                                     consultations as a rate per hundred thousand population. Consultation rates are monitored on a Scotland-wide level, with additional 
                                                     breakdowns by age group."),
                                                   p("Typically, around 96% of all practices in Scotland routinely report to PHS."),
                                                   p("From week 35 2017, practices changed to submission of consultation data on a weekly basis. The extract is automatically generated 
                                                     in each practice based on the previous week’s consultations for ILI and ARI. Consultations for ILI and ARI are identified by searching
                                                     for ILI and ARI specific Read codes, generated by, and stored in the practice software system."),
                                                   p("Practices in Scotland use one of two GP software systems, EMIS or Cegedim (formerly known as INPS). It is recognised that the quality
                                                     of coding between practices and software systems varies and that this contributes to differences in consultation rates between practices."),
                                                   p("Caution should be taken when interpreting data from ISO weeks 52 and 1, as many NHS services, including GP practices, operate reduced
                                                     hours or are closed over Public Holidays."),
                                                   p(strong("Source: GP consultations for influenza-like illness (ILI)")),
                                                   br()
                                                   ),
                                          
                   
                                   
                                   
                                   
                                   #### MORTALITY PANEL ----
                                   bsCollapsePanel("Mortality",
                                                   
                                                   # Euromomo ----
                                                   h4("Euromomo (all-cause mortality)"),
                                                   p("National Records of Scotland provide daily information to PHS on the number of registered deaths relating to all causes. 
                                                     PHS use the European monitoring of excess mortality (Euromomo) system to estimate weekly all-cause excess mortality, which is presented
                                                     as z-scores. All-cause mortality is reported two weeks after the week of the occurrence of the deaths to allow for reporting delay."),
                                                   p("All-cause mortality is reported, instead of just respiratory specific deaths because:"),
                                                   tags$ol(
                                                     tags$li("There is preliminary but incomplete information on cause of death, so all causes provides the most reliable near real-time 
                                                             understanding of deaths, some of which in the winter could be due to seasonal respiratory viruses."),
                                                     tags$li("Respiratory illnesses may be the reason for cardiac and cardiovascular deaths, thus looking at all-cause mortality will 
                                                             capture trends even where the infectious respiratory pathogen is not known.")
                                                   ),
                                                   p(strong("Source: ", tags$a("National Records of Scotland (NRS)",
                                                                               href="https://www.nrscotland.gov.uk/publications/deaths-registered-weekly-in-scotland/"))
                                                     ),
                                                   br()),
                                                   
                                                  
                                   
                                   
                                   
                                   
                                   #### GLOSSARY PANEL ----
                                   bsCollapsePanel("Glossary",

                                                   # COVID-19 ----
                                                   h4("COVID-19"),
                                                   p("Coronavirus disease (COVID-19) is an infectious disease caused by the SARS-CoV-2 virus. The most common symptoms are fever, chills,
                                                     and sore throat. Anyone can get sick with COVID-19 but most people will recover without treatment. As yet, COVID-19 has not been shown
                                                     to follow the same seasonal patterns as other respiratory pathogens. Additional information can be found on the PHS page for ",
                                                     tags$a("COVID-19.",
                                                            href="https://publichealthscotland.scot/population-health/health-protection/infectious-diseases/covid-19/")),
                                                   br(),


                                                   # INFLUENZA ----
                                                   h4("Influenza"),
                                                   p("Influenza, or flu, is a common infectious viral illness caused by influenza viruses. Influenza can cause mild to severe illness
                                                     with symptoms including fever (38°C or above), cough, body aches, and fatigue. Influenza has a different presentation than the
                                                     common cold, with symptoms starting more suddenly, presenting more severely, and lasting longer. Influenza can be caught all year
                                                     round but is more common in the winter months. There are two main types of influenza virus: Types A and B. The influenza A and B
                                                     viruses that routinely spread in people (human influenza viruses) are responsible for seasonal flu epidemics each year. Current
                                                     subtypes of influenza A viruses found in people are influenza A(H1N1) and influenza A(H3N2) viruses. Currently circulating
                                                     influenza B viruses mostly belong to B/Victoria."),
                                                   br(),


                                                   # RSV
                                                   h4("RSV"),
                                                   p("Respiratory syncytial virus (RSV) is a virus that generally causes mild cold like symptoms but may occasionally result in severe lower
                                                     respiratory infection such as bronchiolitis or pneumonia, particularly in infants and young children or in adults with compromised cardiac,
                                                     pulmonary, or immune systems. RSV has an annual seasonality with peaks of activity in the winter months."),
                                                   br(),


                                                   # ADENOVIRUS
                                                   h4("Adenovirus"),
                                                   p("Adenoviruses most commonly present as respiratory infections but can also cause gastrointestinal infections and infect the lining of the
                                                     eyes (conjunctivitis), the urinary tract, and the nervous system. They are very contagious and are relatively resistant to common
                                                     disinfectants. Adenoviruses do not follow a seasonal pattern and circulate all year round."),
                                                   br(),


                                                   # HMPV
                                                   h4("HMPV"),
                                                   p("Human Metapneumovirus (HMPV) is a virus associated with respiratory infections, ranging from mild symptoms to more severe illness such as
                                                     bronchiolitis and pneumonia. Infection can occur in people of all ages, but commonly occurs in infants and young children. HMPV has distinct
                                                     annual seasonality, with the highest transmission in the winter months."),
                                                   br(),


                                                   # MYCOPLASMA PNEUMONIAE
                                                   h4("Mycoplasma pneumoniae"),
                                                   p("Mycoplasma pneumoniae is a bacterium that only infects humans. It typically causes mild infections of the upper respiratory tract,
                                                     resulting in cold-like symptoms. Mycoplasma pneumoniae is most frequently seen in school-age children and young adults, but individuals
                                                     of any age may be infected. Infections peak in winter, usually between late December and February, but Mycoplasma pneumoniae circulates
                                                     throughout the year."),
                                                   br(),


                                                   # PARAINFLUENZA
                                                   h4("Parainfluenza"),
                                                   p("Human parainfluenza virus (HPIV) is a virus that causes respiratory illness in humans. Despite its name, parainfluenza is not related to
                                                     influenza and exhibits different characteristics. It is an important cause of upper and lower respiratory disease in infants and young children,
                                                     elderly people and people who are immunocompromised. HPIV-1 is the most common cause of croup in young children, with outbreaks often occurring
                                                     in autumn. HPIV-2 is less common than HPIV-1 and tends to follow a biennial outbreak pattern, usually in autumn. HPIV-3 circulates all year-round,
                                                     while HPIV-4 is less frequently detected and typically associated with milder respiratory illness."),
                                                   br(),


                                                   # RHINOVIRUS
                                                   h4("Rhinovirus"),
                                                   p("Rhinoviruses are the most frequent cause of the common cold worldwide. Most infections are mild, with symptoms including coughs, sneezing,
                                                     and nasal congestion but can lead to severe illness such as bronchitis, sinusitis, or pneumonia. Rhinoviruses circulate year-round, with peaks
                                                     in autumn and spring."),
                                                   br(),


                                                   # OTHER SEASONAL CORONAVIRUS
                                                   h4("Other seasonal coronavirus"),
                                                   p("Seasonal Coronaviruses (non COVID-19) are a group of viruses that typically cause mild to moderate upper respiratory tract infections, such
                                                     as the common cold, but can cause lower-respiratory tract illnesses such as pneumonia and bronchitis. Seasonal coronaviruses typically circulate
                                                     in the winter months and infection can occur in people of all ages. We generally monitor and report three types together, although some systems
                                                     may report them separately: HCoV-229E (alpha) commonly causes mild upper respiratory tract infections such as colds, HCoV-NL63 (alpha) causes a
                                                     spectrum of illness from cold-like symptoms to croup and bronchiolitis, particularly in children, and HCoV-OC43 (beta) is one of the most prevalent
                                                     types, often linked with winter outbreaks of mild respiratory illness. SARS-CoV-2, which causes COVID-19, is also a type of seasonal coronavirus
                                                     which is reported separately."),
                                                   br(),


                                                   # ACTIVITY LEVEL
                                                   h4("Activity Level"),
                                                   p("In the context of the MEM and WHO methodology, epidemiological activity is characterised by five activity levels. The activity levels based on the
                                                     MEM use 4 thresholds (Epidemic, Medium, High and Very high) and are categorised as:"),
                                                   tags$ul(
                                                     tags$li("baseline activity (when activity is below epidemic threshold);"),
                                                     tags$li("low activity (when activity is between epidemic and medium thresholds);"),
                                                     tags$li("medium activity (when activity is between medium and high thresholds);"),
                                                     tags$li("high activity (when activity is between high and very high thresholds); and"),
                                                     tags$li("very high activity (when activity is above very high threshold).")
                                                   ),
                                                   p("Respiratory pathogen and system-based activity levels allow comparisons to be made over time and with other countries that use the same methodology.
                                                     In the context of influenza, it can also influence the timing of prescribing antiviral medication."),
                                                   br(),


                                                   # CONFIDENCE INTERVAL
                                                   h4("Confidence interval"),
                                                   p("A confidence interval gives an indication of the degree of uncertainty of an estimate, showing the precision of a sample estimate. The 95% confidence
                                                     intervals are calculated so that if we repeated the study many times, 95% of the time the confidence interval would contain the true unknown value.
                                                     A wider interval indicates more uncertainty in the estimate. Overlapping confidence intervals indicate that there may not be a true difference
                                                     between two estimates."),
                                                   br(),


                                                   # ISO WEEK
                                                   h4("ISO week"),
                                                   p("The ISO week date system is effectively a leap week calendar system that is part of the ISO 8601 date and time standard issued by the International
                                                     Organization for Standardization (ISO). Week number according to the ISO-8601 standard, weeks starting on Monday. The first week of the year is the
                                                     week that contains that year's first Thursday (='First 4-day week')."),
                                                   br(),


                                                   # MOVING EPIDEMIC METHOD (MEM)
                                                   h4("Moving Epidemic Method (MEM)"),
                                                   p("MEM is a methodology used for setting thresholds and classifying epidemiological activity levels. Using this model, thresholds are calculated using
                                                     data from at least five previous seasons. A key assumption of this model is that the pathogen being observed must follow a distinct seasonal pattern
                                                     of incidence."),
                                                   p("NHS24, GP ILI consultations, influenza, RSV, seasonal coronavirus (non-SARS-CoV-2) and Euromomo (mortality) thresholds are calculated using the MEM
                                                     methodology. This methodology was adopted by the UK, the European Centre for Disease Prevention and Control (ECDC) and World Health Organisation (WHO)
                                                     to define influenza activity levels."),
                                                   p("For further information on MEM, including the methodology, please visit: ",
                                                     tags$a("Influenza surveilance: determining the epidemic threshold for influenza by using the Moving Epidemic Method (MEM), Montenegro, 2010/11 to 2017/18 influenza seasons - PMC (nih.gov)",
                                                            href="https://pmc.ncbi.nlm.nih.gov/articles/PMC6440585/")),
                                                   br(),


                                                   # PROVISIONAL FIGURES
                                                   h4("Provisional figures"),
                                                   p("Hospital admissions for the most recent week may be incomplete for some Boards and should be treated as provisional and interpreted with caution.
                                                   Where no data are available at the time of publication, the number of admissions for the previous week will be rolled forward for affected Boards.
                                                     Missing data will either be due to a board not submitting on time or there being zero COVID-19 admissions in the latest week. These provisional data
                                                     will be refreshed the following week."),
                                                   br(),



                                                   # RATE PER 100,000
                                                   h4("Rate per 100,000"),
                                                   p("Number of new laboratory positive test results expressed as a rate per 100,000 Scottish population (using the 2024 NRS mid-year population estimate)."),
                                                   p("Virological data are dynamic, therefore, the incidence of laboratory-confirmed infection rate will change week to week as more data become available."),
                                                   br(),


                                                   # SEVEN-DAY AVERAGE
                                                   h4("Seven-day average"),
                                                   p("This is the sum of numbers for the previous 7 days added together and then divided by 7. Looking at a 7-day average can help to smooth out short-term
                                                     fluctuations, for example normal day-to-day fluctuations, or submissions of data that might be affected by weekends."),
                                                   br(),


                                                   # TEST POSITIVITY
                                                   h4("Test positivity"),
                                                   p("Proportion of positive laboratory results among a defined number of laboratory-tested samples, i.e. number of positives divided by total number of
                                                     laboratory tests done. Test positivity values may change retrospectively as data from test results becomes available."),
                                                   br()



                                                   )

                              )
        )#tagList
                   
