
tagList(h1("Metadata"),

  #### METADATA PANELS ----
  bsCollapse(id="notes_collapse", open = "Panel 1",
                   #### CASES PANEL ----
                   bsCollapsePanel("Cases",
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
                                   br(),

                                   # R number ----
                                   h4("R number"),
                                   p("The reproduction (R) number is the average number of secondary infections produced by a single infected person.
                                     The R number is a useful measure in assessing if the epidemic is growing or shrinking. If R is greater than one the epidemic is growing,
                                     if R is less than one the epidemic is shrinking. The higher the R is above one, the more people an infectious person is likely to further infect."),
                                   p("Please note that R lags by two or three weeks."),
                                   p(strong("Source:",
                                     tags$a("COVID-19 Modelling the Epidemic",
                                            href="https://www.gov.scot/collections/coronavirus-covid-19-modelling-the-epidemic/"))),
                                   br(),

                                   # Wastewater ----
                                   h4("Wastewater"),
                                   p("In May 2020, the Scottish Environment Protection Agency (SEPA) began exploratory work to pinpoint fragments of coronavirus’
                                     ribonucleic acid (RNA) in local wastewater samples. "),
                                   p("In contrast to COVID-19 case records, virus shedding into wastewater is a biological process, meaning wastewater data is unaffected
                                     by factors that impact whether testing is done. Sewage samples are taken by Scottish Water from 116 sample sites across Scotland
                                     from the sewage network (wastewater treatment works). Composite samples are built up over a period of time. The amount of unique
                                     fragments of viral DNA within known volumes of the sample is calculated, outputting a number which can be used to calculate the
                                     number of COVID markers in each sample which is reported as million gene copies per litre (Mgc/p/d). Samples are representative of
                                     wastewater from between 70-80% of the Scottish population.  Site level wastewater level can show substantial degree of variability,
                                     especially when prevalence of COVID-19 is high. An average and standard deviation is taken for three samples. Household drainage water
                                     is mixed with water from other urban sources, meaning composite samples will contain rainwater which dilutes the sample. Therefore,
                                     this variability is accounted for by controlling for rainfall."),
                                   p(strong("Source:",
                                            tags$a("COVID-19 Modelling the Epidemic",
                                                   href="https://www.gov.scot/collections/coronavirus-covid-19-modelling-the-epidemic/"))),
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
                                   tags$li("Due to changes in testing strategy outlined above, caution is advised when comparing trends over time.")),



                   ####  HOSPITAL ADMISSIONS PANEL ----
                   bsCollapsePanel("Hospital admissions",

                                   # Hospital admissions ----
                                   h4("Hospital admissions"),
                                   p("COVID-19 hospital admissions are defined as: A patient’s first PCR or PCR confirmed test of the episode of infection
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
                                           As a result, the COVID-19 positive ICU patients could be underreported by up to 10%.")),



                   #### HOSPITAL OCCUPANCY PANEL ----
                   bsCollapsePanel("Hospital occupancy",

                                   #Hospital occupancy ----
                                   h4("Hospital occupancy"),
                                   p("Number of patients in hospital with recently confirmed COVID-19, identified by their first positive LFD test (from 5 January 2022)
                                     or PCR test. This measure (available from 11 September 2020 and first published 15 September 2020) includes patients who first tested positive
                                     in hospital or in the 14 days before admission. Patients stop being included after 28 days in hospital (or 28 days after first testing positive
                                     if this is after admission)."),
                                   p("This is based on the number of patients in beds at 8am the day prior to reporting, with the data extract taken at 8am on the day of
                                     reporting to allow 24 hours for test results to become available. If boards have not submitted by 8am on Monday, the most recent available
                                     data will be rolled over and used as a proxy for the missing dates. Where a patient has not yet received a positive test result they will
                                     not be included in this figure. Patients who have been in hospital for more than 28 days and still being treated for COVID-19 will stop being
                                     included in this figure after 28 days."),
                                   p("All patients in hospital, including in intensive care, and community, mental health and long stay hospitals are included in this figure."),
                                   p(strong("Source:")),
                                   br(),

                                   # ICU occupancy ----
                                   h4("ICU occupancy"),
                                   p("Clinical diagnosis of COVID-19 comprises patients admitted with a clinical diagnosis of confirmed or suspected COVID-19 disease recorded in WardWatcher
                                     regardless of SARS-CoV-2 PCR test status. The clinical diagnosis is the main reason that the patient is admitted to ICU and is coded by ICU clinicians."),
                                   p("SARS-CoV-2 PCR +ve with non-COVID-19/unknown diagnosis comprises patients with a positive SARS-CoV-2 PCR test who have been admitted with a non-COVID-19
                                     clinical diagnosis or missing diagnosis recorded in WardWatcher at the time of data extraction. Less than 5% of all patients in this group have an unknown
                                     diagnosis at the time of data extraction, although this proportion is likely to be higher in the most recent week."),
                                   p("Non-COVID-19 clinical diagnosis comprises patients with a negative SARS-CoV-2 PCR test and who have been admitted with a non-COVID-19 clinical diagnosis
                                     recorded in WardWatcher."),
                                   p("Unknown clinical diagnosis comprises patients with a negative SARS-CoV-2 PCR test who are missing a clinical diagnosis recorded in WardWatcher at the
                                     time of data extraction. Please see the most recent",
                                     tags$a("Scottish Intensive Care Society Audit Group COVID-19 report",
                                            href = "https://publichealthscotland.scot/publications/show-all-releases?id=20581"),
                                            "for more information."),
                                   p(strong("Source:"))),


                   #### VACCINE WASTAGE PANEL ----
                   bsCollapsePanel("Vaccine wastage",

                                   # Vaccine wastage ----
                                   h4("COVID-19 vaccine wastage"),
                                   p("Given the scale of the Covid-19 vaccination programme, some vaccine wastage has been unavoidable for a variety of reasons including logistical issues,
                                     storage failure and specific clinical situations."),
                                   p("The initial planning assumption for the vaccination programme was that there would be around 5% vaccine wastage."),
                                   p(strong("Source: NSS Service Now wastage form")),
                                   br(),
                                   p("Please note:"),
                                   tags$li("Percent wasted is calculated as (Number of Doses Wasted x 100) / (Number of Doses Wasted + Administered)"),
                                   tags$li("The vaccine wastage form is populated by health board clinicians which can impact the timeliness and accuracy of the data."),
                                   tags$li("Data excludes GP practice information and wastage from clinical trials."),
                                   tags$li("Excess stock is defined: Where a vaccination team reach the end of an allotted shift or job, and have surplus vaccines that cannot be returned to stock,
                                           or used before it expires. This includes any unused doses in opened vials at the end of a clinic."))
                   )

)#tagList
