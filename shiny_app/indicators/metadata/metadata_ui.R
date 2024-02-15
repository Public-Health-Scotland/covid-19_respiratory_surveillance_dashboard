
tagList(h1("Metadata"),

        #### METADATA PANELS ----
        bsCollapse(id="notes_collapse", open = "Panel 1",

                   #### COVID PANEL ----
                   bsCollapsePanel("COVID-19",


                                   # Infection Levels ----
                                   h4("Infection Levels"),

                                   # Estimated infections ----
                                   h4("Estimated infections (winter covid infection survey)"),
                                   p("The Office for National Statistics (ONS) publish results from the Winter COVID-19 Infection Survey which aims to estimate how many
                                     people test positive for COVID-19 infection at a given point. The ONS survey results are Scotland’s current best understanding of
                                     community population prevalence."),
                                   p("The Winter COVID-19 Infection Study (WCIS) runs from November 2023 to March
                                      2024, involving up to 200,000 participants across Scotland and England submitting
                                      results from 32,000 lateral flow tests carried out each week. More information on this
                                      study can be found at",
                                     tags$a("Winter Coronavirus (COVID-19) Infection Study",
                                            href="https://www.ons.gov.uk/surveys/informationforhouseholdsandindividuals/householdandindividualsurveys/wintercoronaviruscovid19infectionstudy"),
                                     "."),
                                   p("Further SARS-CoV-2 prevalence results are available in the UKHSA report on Winter
                                      CIS, which can be found on their website",
                                     tags$a("UKHSA Winter Coronavirus Infection Study",
                                            href="https://www.gov.uk/government/statistics/winter-coronavirus-covid-19-infection-study-estimates-of-epidemiological-characteristics-england-and-scotland-2023-to-2024"),
                                     "."),
                                   p("The full publication for the Winter CIS results, including unweighted positivity figure as
                                      well as further measures on age groups, sex, symptoms and self-reported health
                                      outcomes, can be found on the ONS website",
                                     tags$a("Winter Coronavirus Infection Study",
                                            href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/datasets/wintercoronaviruscovid19infectionstudyenglandandscotland"),
                                     "."),
                                   p(strong("Source: The Office for National Statistics (ONS)")),
                                   p("Please note, a",strong("confidence interval"), "gives an indication of the degree of uncertainty of an estimate, showing the precision of a sample estimate.
                                     The 95% confidence intervals are calculated so that if we repeated the study many times, 95% of the time the true unknown value would lie between
                                     the lower and upper confidence limits. A wider interval indicates more uncertainty in the estimate. Overlapping confidence intervals indicate that
                                     there may not be a true difference between two estimates."),
                                   br(),

                                   # Wastewater ----
                                   h4("Wastewater"),
                                   p("In June 2020, Scottish Government, in partnership with Scottish Environment Protection Agency (SEPA), established a national Wastewater
                                     Monitoring Programme for COVID-19 in Scotland. This surveillance system detects fragments, known as ribonucleic acid (RNA), of the
                                     SARS-CoV-2 virus genome, from wastewater samples. "),
                                   p("In contrast to COVID-19 case records, virus shedding into wastewater is a biological process, meaning wastewater data is unaffected
                                     by factors that impact whether testing is done. Sewage samples are taken by Scottish Water from 116 sample sites across Scotland
                                     from the sewage network (wastewater treatment works). Composite samples are built up over a period of time. The amount of unique
                                     fragments of viral DNA within known volumes of the sample is calculated, outputting a number which can be used to calculate the
                                     number of COVID markers in each sample which is reported as million gene copies per litre (Mgc/p/d). Samples are representative of
                                     wastewater from between 70-80% of the Scottish population.  Site level wastewater level can show substantial degree of variability,
                                     especially when prevalence of COVID-19 is high. An average and standard deviation is taken for three samples. Household drainage water
                                     is mixed with water from other urban sources, meaning composite samples will contain rainwater which dilutes the sample. Therefore,
                                     this variability is accounted for by controlling for rainfall."),
                                   p(strong("Source: These analyses of the levels of SARS-CoV-2 detected in wastewater in Scotland are produced by Biomathematics & Statistics Scotland
                                            (formally part of the James Hutton Institute) for the Wastewater Monitoring Programme in Scotland which is operated by Scottish Government
                                            in partnership with Scottish Water and the Scottish Environment Protection Agency.")),
                                   br(),

                                   # Reported cases ----
                                   h4("Reported cases"),
                                   p("Reported cases include both polymerase chain reaction (PCR) and lateral flow device (LFD) positive test results."),
                                   p("There have been changes in testing practices in ",
                                     tags$a("May", href="https://www.gov.scot/publications/test-protect-transition-plan/?msclkid=69623e15ba4711ecb8a394934cbaa327"),
                                     " (end of universal testing) and ",
                                     tags$a("September",
                                            href="https://www.sehd.scot.nhs.uk/dl/DL(2022)32.pdf"),
                                     "(end of asymptomatic testing) which make it difficult to draw any conclusions from these data on community prevalence,
                                            therefore, caution is advised when comparing trends in cases over time. LFD/PCR data precedes the ONS data by approximately two weeks,
                                            and therefore, can give an early estimate of the trends in infection rates in Scotland. The ONS COVID-19 household survey gives robust
                                            estimates of community incidence over time."),
                                   p(strong("Source: PCR - Electronic Communication of Surveillance in Scotland (ECOSS); LFD - UK Government self-reported / NSS Portal")),
                                   br(),
                                   p("Please note:"),
                                   tags$li("The total number of people within Scotland who have, or have had, COVID-19 since the coronavirus outbreak began is unknown.
                                           The number of confirmed cases is likely to be an underestimate."),
                                   tags$li("The purpose of COVID-19 testing has now shifted from population-wide testing to reduce transmission, to targeted, symptomatic
                                            testing in clinical care settings. Data are continuously updated, therefore figures for previous weeks may differ
                                            from published data in previous weeks’ reports."),
                                   tags$li("The drop in the number of confirmed cases at weekends likely reflects that laboratories are doing fewer tests at the weekend."),
                                   tags$li("Due to changes in testing strategy outlined above, caution is advised when comparing trends over time."),
                                   br(),



                                   # Hospital admissions ----

                                   h4("Hospital admissions"),
                                   p("COVID-19 hospital admissions are defined as: A patient’s first PCR or LFD confirmed test of the episode of infection
                                     (including reinfections at 90 days or more after their last positive test) for COVID-19 up to 14 days prior to admission to hospital or within
                                     two days of admission. COVID-19 hospital admissions only include emergency admissions to medical or paediatric specialties,
                                     excluding emergency admissions for injuries."),
                                   p(strong("Source: PCR - Electronic Communication of Surveillance in Scotland (ECOSS); LFD - UK Government self-reported / NSS Portal;
                                            Rapid and Preliminary Inpatient Data (RAPID)")),
                                   br(),
                                   p("Please note:"),
                                   tags$li("RAPID is a weekly submission of people who have been admitted to and discharged from hospital. Further, figures are subject
                                           to change as hospital records are updated. It can take on average 6-8 weeks before a record is finalised, particularly discharge details. "),
                                   tags$li("Hospital admissions for the most recent week may be incomplete for some Boards and should be treated as provisional and
                                           interpreted with caution.Where no data are available at the time of publication, the number of admissions for the previous week
                                           will be rolled forward for affected Boards. Missing data will either be due to a board not submitting on time or there being
                                           zero COVID-19 admissions in the latest week. These provisional data will be refreshed the following week. "),
                                   tags$li("These data include admissions to acute hospitals only and do not include psychiatric or maternity/obstetrics specialties.
                                           In the data presented here, an admission is defined as a period of stay in a single hospital. There may be multiple admissions
                                           for a single patient if they have moved between locations during a continuous inpatient stay (CIS), or if they have been admitted
                                           to hospital on separate occasions. "),
                                   tags$li("Episodes of reinfection were included from 01 March 2022, so care should be taken when interpreting trends over time. For more information, see ",
                                           tags$a("here",
                                                  href = "https://publichealthscotland.scot/news/2022/february/covid-19-reporting-to-include-further-data-on-reinfections/"), "."),
                                   tags$li("Patients are not included in the analysis if their first positive PCR or LFD test of the episode of infection is after their
                                           date of discharge from hospital."),
                                   tags$li("People who were admitted for a non-COVID-19 reason, who tested positive upon admission, may be included, as analysis does not take into account
                                           reason for hospitalisation."),
                                   tags$li("An admission is defined as a period of stay in a single hospital. There may be multiple admissions for a single patient
                                           if they have moved between locations during a continuous inpatient stay, or if they have been admitted to hospital on separate occasions."),
                                   br(),

                                   # LOS ----
                                   h4("Length of stay (LOS)"),
                                   p("Length of stay, i.e. the length of time an individual spends in hospital, is an important indicator for measuring the severity of COVID-19."),
                                   p(strong("Source: Rapid and Preliminary Inpatient Data (RAPID)")),
                                   br(),
                                   p("In this section, LOS has been grouped into categories to aid comparison. The interpretation of the categories is as follows:"),
                                   br(),

                                   tags$table(
                                     tags$tr(
                                       tags$th("LOS category"),
                                       tags$th("Interpretation")
                                     ),

                                     tags$tr(
                                       tags$td("1 day or less"),
                                       tags$td("Less than or equal to 24 hours")
                                     ),
                                     tags$tr(
                                       tags$td("2-3 days"),
                                       tags$td("2-3 days	Greater than 24 hours and less than or equal to 72 hours")
                                     ),
                                     tags$tr(
                                       tags$td("4-5 days"),
                                       tags$td("Greater than 72 hours and less than or equal to 120 hours")
                                     ),
                                     tags$tr(
                                       tags$td("6-7 days"),
                                       tags$td("6-7 days	Greater than 120 hours and less than or equal to 168 hours")
                                     ),
                                     tags$tr(
                                       tags$td("8+ days"),
                                       tags$td("Greater than 168 hours")
                                     )
                                   ),

                                   br(),
                                   p("Please note:"),
                                   tags$li("Length of stay in hospital can be influenced by a variety of factors including age, reason for admission, co-morbidities,
                                           and hospital pressures. The analysis presented in this publication has not been adjusted to account for these factors. "),
                                   tags$li("This information is subject to future revisions due to the completeness of discharge information (approximately 8% of
                                           records excluded due to missing discharge information)."),
                                   br(),



                                   #Hospital occupancy ----
                                   h4("Hospital occupancy (inpatients)"),
                                   p("Number of inpatients in hospital with recently confirmed COVID-19, identified by their first positive LFD test (from 5 January 2022)
                                     or PCR test. This measure (available from 11 September 2020 and first published 15 September 2020) includes inpatients who first tested positive
                                     in hospital or in the 14 days before admission. Patients stop being included after 10 days in hospital (or 10 days after first testing positive
                                     if this is after admission)."),
                                   p("This is based on the number of inpatients in beds at 8am the day prior to reporting, with the data extract taken at 8am on the day of
                                     reporting to allow 24 hours for test results to become available. If boards have not submitted by 8am on Monday, the most recent available
                                     data will be rolled over and used as a proxy for the missing dates. Where a patient has not yet received a positive test result they will
                                     not be included in this figure. Patients who have been in hospital for more than 10 days and still being treated for COVID-19 will stop being
                                     included in this figure after 10 days."),
                                   p("All inpatients in hospital, including in intensive care, and community, mental health and long stay hospitals are included in this figure."),
                                   p(strong("Source: NHS Health Boards")),
                                   br(),

                                   # Archive ----
                                   h4("Archive"),
                                   # Estimated infections ----
                                   h4("Estimated infections"),
                                   p("The Office for National Statistics (ONS) publish results from the COVID-19 Infection Survey which aims to estimate how many
                                     people test positive for COVID-19 infection at a given point. The ONS survey results are Scotland’s current best understanding of
                                     community population prevalence."),
                                   p("The Infection Survey invites private residential households to test whether they have the infection, regardless of whether they have symptoms,
                                     using a PCR test. Data are based on confirmed positive COVID-19 test results of those living in private households, excluding those living in
                                     care homes or other communal establishments. All data are provisional and subject to revision."),
                                   p("For more details and further breakdowns on the Infection Survey please refer to",
                                     tags$a("Coronavirus (COVID-19) Infection Survey, UK - Office for National Statistics",
                                            href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/previousReleases"),
                                     "."),
                                   p(strong("Source: The Office for National Statistics (ONS)")),
                                   p("Please note, a",strong("confidence interval"), "gives an indication of the degree of uncertainty of an estimate, showing the precision of a sample estimate.
                                     The 95% confidence intervals are calculated so that if we repeated the study many times, 95% of the time the true unknown value would lie between
                                     the lower and upper confidence limits. A wider interval indicates more uncertainty in the estimate. Overlapping confidence intervals indicate that
                                     there may not be a true difference between two estimates."),
                                   br(),

                                   # ICU admissions ----
                                   h4("ICU admissions"),
                                   p("COVID-19 varies in severity from very mild symptoms through to those requiring hospital admission and the most ill who require
                                     intensive care treatment and supported ventilation in an Intensive Care Unit (ICU). Monitoring the admission frequency to
                                     critical care units in Scotland (ICU) is therefore an important measure of the severity of COVID-19."),
                                   p("COVID-19 related ICU admissions have been identified as the following: A patient who has tested positive for COVID at any
                                     time in the 21 days prior to admission to ICU, or who has tested positive from the date of admission up to and
                                     including the date of ICU discharge. "),
                                   p("Includes any patient admitted to ICU with:"),

                                   tags$li("a valid linkage to laboratory data ", strong("AND")),
                                   tags$li("with laboratory confirmation for COVID-19 during the 21 days before the date of ICU admission ", strong("OR")),
                                   tags$li("with laboratory confirmation for COVID-19 during their ICU stay, from the date of ICU admission up to and
                                           including the date of ICU discharge."),
                                   p(strong("Source: Scottish Intensive Care Society Audit Group (SICSAG)")),
                                   br(),
                                   p("Please note:"),
                                   tags$li("SICSAG data are stored in a dynamic database and subject to ongoing validations, so data may change weekly."),
                                   tags$li("Counts do not include any COVID-19 suspected cases who have not yet been lab confirmed. Therefore, there may
                                           be a lag for recent days where patients may still be awaiting the results of COVID-19 tests."),
                                   tags$li("Data excludes any patient under the age 15."),
                                   tags$li("Individual patients are identified using their CHI number as recorded within the ICU admissions system.
                                           There may be a very small number of patients where CHI was not recorded, for whom linkage to ECOSS for
                                           COVID-19 status may not have been possible."),
                                   tags$li("On 30 October 2020, Public Health Scotland became aware of an ongoing issue when linking ICU data to
                                           laboratory data for COVID-19 test results. Any COVID-19 positive patients with a missing a
                                           CHI number that had a first positive test in the community are unable to be linked to ICU data.
                                           As a result, the COVID-19 positive ICU patients could be underreported by up to 10%."),
                                   br(),


                                   # ICU occupancy ----
                                   h4("ICU occupancy (28 days or less)"),
                                   p("COVID-19 confirmed ICU occupancy (28 days or less) have been identified as the following: This measure (available from 11 September 2020)
                                     includes patients who first tested positive, within their current COVID-19 episode, in hospital or in the 14 days before admission.
                                     Patients stop being included after 28 days in hospital (or 28 days after first testing positive if this is after admission).
                                     COVID-19 episodes include both first infections and possible reinfections."),
                                   br(),
                                   h4("ICU occupancy (greater than 28 days)"),
                                   p("COVID-19 confirmed ICU occupancy (greater than 28 days) are now identified as the following: This measure (available from 20 January)
                                     includes long-stay COVID-19 patients who have been in ICU continuously for more than 28 days. This measure includes patients who first
                                     tested positive, within their current COVID-19 episode, in hospital or in the 14 days before admission. Patients start being included
                                     once they have exceeded 28 days in in ICU (or 28 days after first testing positive if this is after admission). Patients who have been
                                     in hospital or ICU for 28 days or less are not included in this figure. COVID-19 episodes include both first infections and possible reinfections."),
                                   br(),
                                   p(strong("Source: NHS Health Boards"))

                   ),


                   #### INFLUENZA PANEL ----
                   bsCollapsePanel("Influenza",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Influenza, or 'flu', is a common infectious viral illness caused by influenza viruses.",
                                     "Influenza can cause mild to severe illness with symptoms including fever (38°C or above),",
                                     "cough, body aches, and fatigue. Influenza has a different presentation than the common",
                                     "cold, with symptoms starting more suddenly, presenting more severely, and lasting longer.",
                                     "Influenza can be caught all year round but is more common in the winter months."),
                                    # "Additional information can be found on the PHS page for influenza."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS); Rapid and Preliminary Inpatient Data (RAPID)")),
                                   br(),

                                   # Hospital admissions ----
                                   h4("Hospital admissions"),
                                   p("Patients admitted as an emergency to a hospital in Scotland with recently confirmed influenza are identified from Rapid Preliminary Inpatient Data (RAPID).
                                 RAPID is a daily submission of people who have been admitted to hospital in Scotland.
                                 The case definition includes patients admitted as an emergency to a medical specialty (excluding surgical and mental health specialties,
                                 and emergency admissions with patient injury codes) who have a positive influenza test result, taken within a period of between 14 days before the admission date and 48 hours after the admission date.
                                 RAPID data is updated on a weekly basis and NHS boards are required to submit information on admissions no later than midday Wednesday. A complete provisional dataset prepared on Tuesday 2pm is used for the analysis in this report."),
                                 p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS); Rapid and Preliminary Inpatient Data (RAPID)"))),


                   #### RSV PANEL ----
                   bsCollapsePanel("RSV",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Respiratory syncytial virus (RSV) is a virus that generally causes mild cold like",
                                   "symptoms but may occasionally result in severe lower respiratory infection such as",
                                    "bronchiolitis or pneumonia, particularly in infants and young children or in adults",
                                    "with compromised cardiac, pulmonary, or immune systems. RSV has an annual seasonality",
                                    "with peaks of activity in the winter months."),# Additional information can be found on the PHS page for RSV."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS); Rapid and Preliminary Inpatient Data (RAPID)")),
                                   br(),

                                   # Hospital admissions ----
                                   h4("Hospital admissions"),
                                   p("Patients admitted as an emergency to a hospital in Scotland with recently confirmed RSV are identified from Rapid Preliminary Inpatient Data (RAPID).
                                 RAPID is a daily submission of people who have been admitted to hospital in Scotland.
                                 The case definition includes patients admitted as an emergency to a medical specialty (excluding surgical and mental health specialties,
                                 and emergency admissions with patient injury codes) who have a positive RSV test result, taken within a period of between 14 days before the admission date and 48 hours after the admission date.
                                 RAPID data is updated on a weekly basis and NHS boards are required to submit information on admissions no later than midday Wednesday. A complete provisional dataset prepared on Tuesday 2pm is used for the analysis in this report."),
                                 p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS); Rapid and Preliminary Inpatient Data (RAPID)"))),

                   #### ADENOVIRUS PANEL ----
                   bsCollapsePanel("Adenovirus",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Adenoviruses most commonly present as respiratory infections but can also",
                                     "cause gastrointestinal infections and infect the lining of the eyes (conjunctivitis),",
                                     "the urinary tract, and the nervous system. They are very contagious and are",
                                     "relatively resistant to common disinfectants. Adenoviruses do not follow a seasonal",
                                     "pattern and circulate all year round."),# Additional information can be found on the PHS page for adenovirus."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                                   ),


                   #### HMPV PANEL ----
                   bsCollapsePanel("HMPV",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Human Metapneumovirus (HMPV) is a virus associated with respiratory infections,",
                                     "ranging from mild symptoms to more severe illness such as bronchiolitis and",
                                     "pneumonia. Infection can occur in people of all ages, but commonly occurs in",
                                     "infants and young children. HMPV has distinct annual seasonality, with the highest",
                                     "transmission in the winter months."),# Additional information can be found on the PHS page for human metapneumovirus."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                   ),


                   #### MYCOPLASMA PNEUMONIAE PANEL ----
                   bsCollapsePanel("Mycoplasma pneumoniae",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Mycoplasma pneumoniae is a bacterium that only infects humans. It typically ",
                                     "causes mild infections of the upper respiratory tract, resulting in cold-like ",
                                     "symptoms. Mycoplasma pneumoniae is most frequently seen in school-age children ",
                                     "and young adults, but individuals of any age may be infected. Infections peak in ",
                                     "winter, usually between late December and February, but Mycoplasma pneumoniae ",
                                     "circulates throughout the year."),# Additional information can be found on the ",
                                    # "PHS page for Mycoplasma pneumoniae."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                   ),


                   #### PARAINFLUENZA PANEL ----
                   bsCollapsePanel("Parainfluenza",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Human parainfluenza virus (HPIV) is a virus that causes respiratory illness in humans.",
                                     "Despite its name, parainfluenza is not related to influenza and exhibits different",
                                     "characteristics. It is an important cause of upper and lower respiratory disease in",
                                     "infants and young children, elderly people and people who are immunocompromised."),
                                     #"Additional information can be found on the PHS page for parainfluenza."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                   ),


                   #### RHINOVIRUS PANEL ----
                   bsCollapsePanel("Rhinovirus",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Rhinoviruses are the most frequent cause of the common cold worldwide.",
                                     "Most infections are mild, with symptoms including coughs, sneezing, and",
                                     "nasal congestion but can lead to severe illness such as bronchitis, sinusitis,",
                                     "or pneumonia. Rhinoviruses circulate year-round, with peaks in autumn and spring."),
                                     #"Additional information can be found on the PHS page for rhinovirus."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                   ),


                   #### SEASONAL CORONAVIRUS PANEL ----
                   bsCollapsePanel("Seasonal Coronaviruses (non COVID-19)",

                                   # Infection Levels ----
                                   h4("Infection levels"),
                                   p("Seasonal Coronaviruses are a group of viruses that typically cause mild to moderate upper respiratory tract infections, such as the common cold,
                                     but can cause lower-respiratory tract illnesses such as pneumonia and bronchitis. Infection can occur in people of all ages.
                                     Seasonal coronaviruses have an annual seasonality and typically circulate in the winter months."),
                                   p(strong("Source: Electronic Communication of Surveillance in Scotland (ECOSS)")),
                                   br()

                   ),

                   #### SYNDROMIC SURVEILLANCE PANEL ----
                   bsCollapsePanel("Syndromic Surveillance",

                                   # NHS 24 Calls ----
                                   h4("NHS 24 Calls"),
                                   p("NHS24 is the '111' service for Scotland, providing a 24-hour hotline available to members of the public who require advice about urgent
                             but not-life-threatening medical problems. Data from these calls is recorded by call handlers and stored electronically,
                             including information regarding time of call, geographical location, caller demographics, and call reason."),
                             p("The proportion of NHS24 calls for respiratory symptoms is calculated through identifying calls with the following call reasons:
                             ‘cough’, ‘colds and flu’, ‘difficulty breathing’, and ‘fever’.
                             Call reason is a free-text field, that is screened for key words used to identify syndromes"),
                             p(strong("Source: NHS24")),
                             br(),

                             # GP Consultations ----
                             h4("GP Consultations"),
                             p("Public Health Scotland regularly reports consultation rates for influenza-like-illness (ILI) in primary care. This is the key measure of influenza activity in the community
                            and is used to gauge the severity of influenza seasons in Scotland each winter. It is also used for comparison of influenza activity across the UK and Europe. "),
                            p("Since 1972, rates of ILI seen by general practitioners have been monitored every week across Scotland.
                            The way in which this influenza data is captured has changed over the years, but the common method of presentation has remained constant
                            and has been to express GP consultations as a rate per hundred thousand population.
                            Consultation rates are monitored on a Scotland-wide level, with additional breakdowns by age group and by Health Board."),
                            p("Typically, around 923 practices (98% of all practices in Scotland) routinely report to PHS."),
                            p(strong("Source: GP consultations for influenza-like illness (ILI)")),
                            br()
                            ),
                   
                   
                   #### CARI PANEL ----
                   bsCollapsePanel("Community Acute Respiratory Infection (CARI) surveillance",
                                   
                                   # CARI ----
                                   #h4("Swab positivity (community surveillance)"),
                                   p("CARI surveillance is a sentinel community surveillance programme for a range of respiratory pathogens: SARS-CoV-2, ",
                                     "influenza A and B, RSV, adenovirus, coronavirus (non-SARS CoV-2), human metapneumovirus, rhinovirus, parainfluenza and ",
                                     "Mycoplasma pneumoniae. The programme is open to GP practices across all NHS Boards in Scotland. To become a sentinel site, ",
                                     "GP practices voluntarily opt into the CARI programme. Patients in the community who consult a sentinel GP practice with respiratory ",
                                     "symptoms and who meet the case definition for acute respiratory infection (ARI) are recruited, consented, and swabbed for the CARI ",
                                     "programme."),  
                                   p("Data are reported by week of swab for recruited individuals for whom test result data are available. Data are derived from samples ",
                                     "tested up to the current reporting week, and any retrospective numbers are updated in the next weekly report. The CARI surveillance ",
                                     "programme detects community transmission of specific pathogens."),
                             p(strong("Source: Community Acute Respiratory Infection (CARI) sentinel practices")),
                             br()
                             ),
                   

                #### MORTALITY PANEL ----
                bsCollapsePanel("Mortality",

                  h4("Euromomo (all cause mortality)"),
                  p("National Records of Scotland provide daily information to PHS on the number of registered deaths relating to all causes.
                    PHS use the European monitoring of excess mortality (Euromomo) system to estimate weekly all-cause excess mortality, which is presented as z-scores.
                    All-cause mortality is reported two weeks after the week of the occurrence of the deaths to allow for reporting delay."),
                  p(strong("Source:",
                           tags$a("National Records of Scotland (NRS)",
                           href="https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-deaths-registered-in-scotland")
                  ))),


                #### GLOSSARY PANEL ----
                bsCollapsePanel("Glossary",

                  # Activity Level ----
                  h4("Activity Level"),
                  p("In the context of the MEM and WHO methodology, epidemiological activity is characterised by five activity levels.
                    The activity levels based on the MEM use 4 thresholds (Epidemic, Medium, High and Very high) and are categorised as:"),
                  p(tags$li("baseline activity (when activity is below epidemic threshold);")),
                  p(tags$li("low activity (when activity is between epidemic and medium thresholds);")),
                  p(tags$li("moderate activity (when activity is between medium and high thresholds);")),
                  p(tags$li("high activity (when activity is between high and very high thresholds); and")),
                  p(tags$li("extraordinary activity (when activity is above very high threshold).")),
                  p("Respiratory pathogen and system-based activity levels allow comparisons to be made over time and with other countries that use the same methodology.
                    In the context of influenza, it can also influence the timing of prescribing antiviral medication."),
                  br(),

                  # Confidence interval ----
                  h4("Confidence interval"),
                  p("A confidence interval gives an indication of the degree of uncertainty of an estimate, showing the precision of a sample estimate.
                   The 95% confidence intervals are calculated so that if we repeated the study many times, 95% of the time the true unknown value would lie
                   between the lower and upper confidence limits. A wider interval indicates more uncertainty in the estimate. Overlapping confidence intervals
                   indicate that there may not be a true difference between two estimates."),
                   br(),

                   # Isoweek ----
                   h4("ISO week"),
                   p("The ISO week date system is effectively a leap week calendar system that is part of the ISO 8601 date and time standard issued by the
                    International Organization for Standardization (ISO). Week number according to the ISO-8601 standard, weeks starting on Monday.
                    The first week of the year is the week that contains that year's first Thursday (='First 4-day week')"),
                   br(),

                   #Median Length of Stay ----
                   h4("Median length of stay"),
                   p("This a measure of the typical length of stay experienced by patients being admitted to hospital with COVID-19.
                    One simple way of explaining this statistic is that approximately half of patients treated had a stay less than the figure shown and half had a stay greater than this."),
                   br(),

                   # Moving Epidemic Method (MEM) ----
                   h4("Moving Epidemic Method (MEM)"),
                   p("MEM is a methodology used for setting thresholds and classifying epidemiological activity levels.
                    Using this model, thresholds are calculated using data from at least five previous seasons.
                    A key assumption of this model is that the pathogen being observed must follow a distinct seasonal pattern of incidence."),
                   p("NHS24, GP ILI consultations, influenza, RSV, seasonal coronavirus (non-SARS-CoV-2) and Euromomo (mortality) thresholds are calculated using the MEM methodology.
                    This methodology was adopted by the UK, the European Centre for Disease Prevention and Control (ECDC) and World Health Organisation (WHO) to define influenza activity levels."),
                   br(),

                   #Provisional figures ----
                   h4("Provisional figures"),
                   p("Hospital admissions for the most recent week may be incomplete for some Boards and should be treated as provisional and interpreted with caution.
                    Where no data are available at the time of publication, the number of admissions for the previous week will be rolled forward for affected Boards.
                    Missing data will either be due to a board not submitting on time or there being zero COVID-19 admissions in the latest week. These provisional data
                    will be refreshed the following week"),
                   br(),

                   #Rate per 100,000 ----
                   h4("Rate per 100,000"),
                   p("Number of new laboratory positive test results expressed as a rate per 100,000 Scottish population (using the 2021 NRS mid-year population estimate)."),
                   p("Virological data are dynamic, therefore, the incidence rate will change week to week as more data become available."),
                   br(),

                   #SIMD ----
                   h4("Scottish Index of Multiple Deprivation (SIMD)"),
                   p("People have been allocated to different levels of deprivation based on the small area (data zone) in which they live and the",
                     tags$a("Scottish Index of Multiple Deprivation (SIMD) (external website)",
                            href = "https://simd.scot/#/simd2020/BTTTFTT/9/-4.0000/55.9000/"),
                     "score for that area. SIMD scores are based on data for 38 indicators",
                     "covering seven topic areas: income, employment, health, education, skills and training, housing, geographic access, and crime."),
                  p("The SIMD identifies deprived areas, not deprived individuals."),
                  p("In this tool we have presented results for people living in different SIMD ‘quintiles’. To produce quintiles,
                    data zones are ranked by their SIMD score then the areas each containing a fifth (20%) of the overall population of Scotland are identified.
                    People living in the most and least deprived areas that each contain a fifth of the population are assigned to SIMD quintile 1 and 5 respectively."),
                  br(),

                  #Seven day average ----
                  h4("Seven day average"),
                  p("This is the numbers for the previous 7 days added together and then divided by 7. This helps to smooth out any short term fluctuations."),
                  br(),
                  
                  #Swab positivity ----
                  h4("Swab positivity"),
                  p("Swab positivity is the proportion of positive laboratory results among a defined number of ",
                    "laboratory tested samples, i.e. number of positives divided by total number of laboratory tests done."),
                  br()

                   ))

)#tagList