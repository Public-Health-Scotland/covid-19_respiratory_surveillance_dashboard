tagList(
  fluidRow(width=12, h1("COVID-19 in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(height=500, status = "info",
          tagList(
            h2("Hospital admissions"),
            infoBoxOutput("admissions_infobox", width=NULL),
            bsPopover("admissions_infobox", "COVID-19 hospital admissions",
                      paste("An admission to hospital where the patient had a first positive PCR from 14 days prior to admission up to two days following admission. This includes reinfections which are 90 days or more since their last positive test. This only includes emergency admissions to medical or paediatric specialties, excluding emergency admissions for injuries.",strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("icu_infobox", width=NULL),
            bsPopover("icu_infobox", "COVID-19 related ICU admissions", paste("A patient who has tested positive for COVID at any time in the 21 days prior to admission to ICU, or who has tested positive from the date of admission up to and including the date of ICU discharge", strong("For more information, see Metadata.")) ,
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("los_infobox", width=NULL),
            bsPopover("los_infobox", "Length of stay (LOS) of COVID-19 admissions", paste("The length of time an individual spends in hospital. The median is a measure of the typical LOS experienced by patients in hospital with COVID-19. One simple way of explaining this statistic is that approximately half of patients had a LOS less than the figure shown and half had a LOS greater than this.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body"))
          )),
      box(height=500, status = "info",
          tagList(
            h2("Hospital occupancy"),
            infoBoxOutput("occupancy_infobox", width=NULL),
            bsPopover("occupancy_infobox", "Number of patients in hospital with COVID-19", paste("Average number of patients in hospital with recently confirmed COVID-19, identified by their first positive LFD test (from 5 January 2022) or PCR test. This measure includes patients who first tested positive in hospital or in the 14 days before admission. Patients stop being included after 28 days in hospital (or 28 days after first testing positive if this is after admission).", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("icu_less_occupancy_infobox", width=NULL),
            bsPopover("icu_less_occupancy_infobox", "Number of patients in ICU with COVID-19 (28 days or less)", paste("Average number of ICU patients by SARS-CoV-2 PCR status and the clinical diagnosis on ICU admission that have been in ICU for 28 days or less. Most ICU SARS-CoV-2 inpatients have a non-COVID-19 or unknown clinical diagnosis, and those with a clinical diagnosis of COVID-19 remain low.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("icu_more_occupancy_infobox", width=NULL),
            bsPopover("icu_more_occupancy_infobox", "Number of patients in ICU with COVID-19 (greater than 28 days)", paste("Average number of ICU patients by SARS-CoV-2 PCR status and the clinical diagnosis on ICU admission that have been in ICU for greater than 28 days. Most ICU SARS-CoV-2 inpatients have a non-COVID-19 or unknown clinical diagnosis, and those with a clinical diagnosis of COVID-19 remain low.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body"))
          )),
      linebreaks(10),
      box(height=500, status = "info",
          tagList(
            h2("Cases"),
            infoBoxOutput("ons_infobox", width=NULL),
            bsPopover("ons_infobox", "COVID-19 infection survey (ONS) estimated prevalence", paste("An estimate of how many people test positive for COVID-19 at a given point. A confidence interval gives an indication of the degree of uncertainty of an estimate, showing the precision of a sample estimate. The 95% confidence intervals are calculated so that if we repeated the study many times, 95% of the time the true unknown value would lie between the lower and upper confidence limits", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("r_number_infobox", width=NULL),
            bsPopover("r_number_infobox", "The reproduction (R) number", paste("This is the average number of secondary infections produced by a single infected person, estimated to be within this range. If R is greater than one the epidemic is growing, if R is less than one the epidemic is shrinking.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("wastewater_infobox", width=NULL),
            bsPopover("wastewater_infobox", "COVID-19 levels in wastewater", paste("This is the seven day average level of COVID-19 in wastewater samples by Million gene copies per person per day.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("reported_cases_infobox", width=NULL),
            bsPopover("reported_cases_infobox", "COVID-19 cases reported", paste("This is the seven day average number of polymerase chain reaction (PCR) and lateral flow device (LFD) positive test results recorded", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body"))

          )),
      box(height=500, status = "info",
          tagList(
            h2("Vaccine wastage"),
            infoBoxOutput("doses_wasted_infobox", width=NULL),
            bsPopover("doses_wasted_infobox", "COVID-19 vaccine doses wasted", paste("This is the total number of vaccine doses which could not be administered and were therefore wasted in the latest month.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("doses_administered_infobox", width=NULL),
            bsPopover("doses_administered_infobox", "COVID-19 vaccine doses administered", paste("This is total number of doses administered (including all doses) in the latest month.", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("percent_wasted_infobox", width=NULL),
            bsPopover("percent_wasted_infobox", "Percentage of COVID-19 vaccine doses wasted", paste("This is the proportion of doses which were wasted out of the total number of doses which were either administered or wasted: (Number of Doses Wasted x 100) / (Number of Doses Wasted + Administered).", strong("For more information, see Metadata.")),
                      placement = "top", trigger = "hover",
                      options = list(container = "body"))
          )),
      # Padding out the bottom of the page
      fluidRow(height="500px", width=12, linebreaks(5))
    ) # taglist
)# fluidRow
)
