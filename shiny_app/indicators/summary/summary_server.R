
#### Cases ----

output$ons_infobox <- renderInfoBox({
  infoBox(title=h5("Estimated prevalence", tags$a("(ONS - external link)",
                                                  target = "_blank",
                                                  href = "https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/previousReleases"),
                   summaryButtonUI("ons",
                                   "COVID-19 infection survey (ONS) estimated prevalence",
                                   paste("An estimate of how many people test positive for COVID-19 at a given point.",
                                         "A confidence interval gives an indication of the degree of uncertainty of an estimate, showing the precision",
                                         "of a sample estimate. The 95% confidence intervals are calculated so that if we repeated the study many times,",
                                         "95% of the time the true unknown value would lie between the lower and upper confidence limits<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value={ONS %>% tail(1) %>% .$EstimatedRatio},
          subtitle = glue("{ONS %>% tail(1) %>% .$LowerCIRatio}",
                          " to {ONS %>% tail(1) %>% .$UpperCIRatio}",
                          " (95% CI)"),
          icon = icon_no_warning_fn("viruses"),
          color = "purple")
})

# output$r_number_infobox <- renderInfoBox({
#   infoBox(title=h5("R number",
#                    summaryButtonUI("r_number",
#                                    "The reproduction (R) number",
#                                    paste("This is the average number of secondary infections produced by a single infected person,",
#                                          "estimated to be within this range. If R is greater than one the epidemic is growing, if R is less",
#                                          "than one the epidemic is shrinking.<br><br>",
#                                          strong("For more information, see Metadata. Click again to close.")))),
#           value= glue("{R_Number %>% tail(1) %>% .$LowerBound}",
#                       " - {R_Number %>% tail(1) %>% .$UpperBound}"),
#           subtitle = "Range",
#           icon = icon_no_warning_fn("r"),
#           color = "purple")
# })


output$wastewater_infobox <- renderInfoBox({
  infoBox(title=h5("Wastewater level",
                   summaryButtonUI("wastewater",
                                   "COVID-19 levels in wastewater",
                                   paste("This is the seven day average level of COVID-19 in wastewater samples by Million gene copies per person per day.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= {Wastewater %>% tail(1) %>% .$WastewaterSevenDayAverageMgc %>%
              signif(3) %>% paste("Mgc/p/d")},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("faucet-drip"),
          color = "purple")
})


output$reported_cases_infobox <- renderInfoBox({
  infoBox(title=h5("Reported COVID-19 cases",
                   summaryButtonUI("reported_cases_infobox",
                                   "COVID-19 cases reported",
                                   paste("This is the seven day average number of polymerase chain reaction (PCR) and lateral flow device (LFD)",
                                         "positive test results recorded<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= {Cases %>% tail(1) %>% .$SevenDayAverage %>%
              round_half_up(0) %>% format(big.mark=",")},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("pen-to-square"),
          color = "purple")
})


#### Hospital admissions ----

output$admissions_infobox <- renderInfoBox({
  infoBox(title=h5("Admissions", summaryButtonUI("admissions",
                                              "COVID-19 hospital admissions",
                                              paste("An admission to hospital where the patient had a first positive PCR from 14 days prior to",
                                                    "admission up to two days following admission. This includes reinfections which are 90 days or",
                                                    "more since their last positive test. This only includes emergency admissions to medical or",
                                                    "paediatric specialties, excluding emergency admissions for injuries.<br><br>",
                                                    strong("For more information, see Metadata. Click again to close.")))),
          value= admissions_headlines[[1]],
          subtitle = "Weekly total",
          icon = icon_no_warning_fn("truck-medical"),
          color = "blue")})



output$icu_infobox <- renderInfoBox({
  infoBox(title=h5("ICU admissions",
                   summaryButtonUI("icu",
                                   "COVID-19 related ICU admissions",
                                   paste("A patient who has tested positive for COVID at any time in the 21 days prior to admission to ICU,",
                                         "or who has tested positive from the date of admission up to and including the date of ICU discharge.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= icu_headlines[[1]],
          subtitle = "Weekly total",
          icon = icon_no_warning_fn("heart-pulse"),
          color = "blue")
})



output$los_infobox <- renderInfoBox({
  infoBox(title=h5("Length of stay",
                   summaryButtonUI("los",
                                   "Length of stay (LOS) of COVID-19 admissions",
                                   paste("The length of time an individual spends in hospital. The median is a measure of the",
                                         "typical LOS experienced by patients in hospital with COVID-19. One simple way of explaining this statistic",
                                         "is that approximately half of patients had a LOS less than the figure shown and half had a LOS greater",
                                         "than this.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= glue("{Length_of_Stay_Median %>% filter(AgeGroup == 'All Ages') %>%
                        .$MedianLengthOfStay %>%round_half_up(1)} days"),
          subtitle = "Median",
          icon = icon_no_warning_fn("clock"),
          color = "blue")
})


#### Hospital occupancy ----

output$occupancy_infobox <- renderInfoBox({
  infoBox(title=h5("Hospital beds occupied",
                   summaryButtonUI("occupancy",
                                   "Number of inpatients in hospital with COVID-19",
                                   paste("Average number of patients in hospital with recently confirmed COVID-19, identified by their first positive",
                                         "LFD test (from 5 January 2022) or PCR test. This measure includes patients who first tested positive in hospital",
                                         "or in the 14 days before admission. Patients stop being included after 28 days in hospital",
                                         "(or 28 days after first testing positive if this is after admission).<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= {occupancy_headlines[[1]]$HospitalOccupancy},
          subtitle = glue("Snapshot at 8am on {names(occupancy_headlines)[1]}"),
          icon = icon_no_warning_fn("hospital"),
          color = "fuchsia")
})


output$icu_less_occupancy_infobox <- renderInfoBox({
  infoBox(title=h5("ICU beds occupied (28 days or less)",
                   summaryButtonUI("icu_less_occupancy",
                                   "Number of patients in ICU with COVID-19 (28 days or less)",
                                   paste("Average number of ICU patients by SARS-CoV-2 PCR status and the clinical diagnosis on ICU admission",
                                         "that have been in ICU for 28 days or less. Most ICU SARS-CoV-2 inpatients have a non-COVID-19 or",
                                         "unknown clinical diagnosis, and those with a clinical diagnosis of COVID-19 remain low.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
              .$SevenDayAverage},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("bed"),
          color = "fuchsia")
})


output$icu_more_occupancy_infobox <- renderInfoBox({
  infoBox(title=h5("ICU beds occupied (greater than 28 days)",
                   summaryButtonUI("icu_more_occupancy_infobox",
                                   "Number of patients in ICU with COVID-19 (greater than 28 days)",
                                   paste("Average number of ICU patients by SARS-CoV-2 PCR status and the clinical diagnosis on ICU admission",
                                         "that have been in ICU for greater than 28 days. Most ICU SARS-CoV-2 inpatients have a non-COVID-19 or",
                                         "unknown clinical diagnosis, and those with a clinical diagnosis of COVID-19 remain low.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value= {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
              .$SevenDayAverage},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("bed-pulse"),
          color = "fuchsia")
})


#### Vaccine wastage ----

output$doses_wasted_infobox <- renderInfoBox({
  infoBox(title=h5("Doses wasted",
                   summaryButtonUI("doses_wasted_infobox",
                                   "COVID-19 vaccine doses wasted",
                                   paste("This is the total number of vaccine doses which could not be administered and were therefore wasted",
                                         "in the latest month.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value={Vaccine_Wastage %>% tail(1) %>%
              .$NumberOfDosesWasted %>%
              format(big.mark = ",")},
          subtitle = "Monthly total",
          icon = icon_no_warning_fn("dumpster"),
          color = "teal")
})


output$doses_administered_infobox <- renderInfoBox({
  infoBox(title=h5("Doses administered",
                   summaryButtonUI("doses_administered_infobox",
                                   "COVID-19 vaccine doses administered",
                                   paste("This is total number of doses administered (including all doses) in the latest month.<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value={Vaccine_Wastage %>% tail(1) %>%
              .$NumberOfDosesAdministered %>%
              format(big.mark = ",")},
          subtitle = "Monthly total",
          icon = icon_no_warning_fn("syringe"),
          color = "teal")
})


output$percent_wasted_infobox <- renderInfoBox({
  infoBox(title=h5("Percent wasted",
                   summaryButtonUI("percent_wasted_infobox",
                                   "Percentage of COVID-19 vaccine doses wasted",
                                   paste("This is the proportion of doses which were wasted out of the total number of doses which were either",
                                         "administered or wasted: (Number of Doses Wasted x 100) / (Number of Doses Wasted + Administered).<br><br>",
                                         strong("For more information, see Metadata. Click again to close.")))),
          value={Vaccine_Wastage %>% tail(1) %>%
              .$PercentageWasted %>%
              paste0("%")},
          subtitle = "Monthly %",
          icon = icon_no_warning_fn("percent"),
          color = "teal")
})

#### Buttons linking to different tabs ----
observeEvent(input$jump_to_cases_from_summary, {
  updateTabsetPanel(session, "intabset", selected = "cases")})

observeEvent(input$jump_to_hospital_admissions_from_summary, {
  updateTabsetPanel(session, "intabset", selected = "hospital_admissions")})

observeEvent(input$jump_to_hospital_occupancy_from_summary, {
  updateTabsetPanel(session, "intabset", selected = "hospital_occupancy")})

observeEvent(input$jump_to_vaccines_from_summary, {
  updateTabsetPanel(session, "intabset", selected = "vaccines")})





