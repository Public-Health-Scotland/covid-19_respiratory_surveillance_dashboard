output$admissions_infobox <- renderInfoBox({
  infoBox(title="Admissions",
          value= admissions_headlines[[1]],
          subtitle = "Weekly total",
          icon = icon_no_warning_fn("hospital"),
          color = "green")})

output$icu_infobox <- renderInfoBox({
  infoBox(title="ICU admissions",
          value= icu_headlines[[1]],
          subtitle = "Weekly total",
          icon = icon_no_warning_fn("heart-pulse"),
          color = "green")
})

output$los_infobox <- renderInfoBox({
  infoBox(title="Length of stay",
          value= glue("{Length_of_Stay_Median %>% filter(AgeGroup == 'All Ages') %>%
                        .$MedianLengthOfStay %>%round_half_up(1)} days"),
          subtitle = "Median",
          icon = icon_no_warning_fn("clock"),
          color = "green")
})

output$occupancy_infobox <- renderInfoBox({
  infoBox(title="Hospital beds occupied",
          value= {Occupancy_Hospital %>% tail(1) %>%
                                .$SevenDayAverage},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("hospital"),
          color = "fuchsia")
})

output$icu_less_occupancy_infobox <- renderInfoBox({
  infoBox(title="ICU beds occupied (28 days or less)",
          value= {Occupancy_ICU %>% filter(ICULengthOfStay == "28 days or less") %>%  tail(1) %>%
              .$SevenDayAverage},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("bed"),
          color = "fuchsia")
})

output$icu_more_occupancy_infobox <- renderInfoBox({
  infoBox(title="ICU beds occupied (greater than 28 days)",
          value= {Occupancy_ICU %>% filter(ICULengthOfStay == "greater than 28 days") %>%  tail(1) %>%
              .$SevenDayAverage},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("bed-pulse"),
          color = "fuchsia")
})

output$ons_infobox <- renderInfoBox({
  infoBox(title="Estimated prevalence",
          value={ONS %>% tail(1) %>% .$EstimatedRatio},
          subtitle = glue("{ONS %>% tail(1) %>% .$LowerCIRatio}",
                          " to {ONS %>% tail(1) %>% .$UpperCIRatio}",
                          " (95% CI)"),
          icon = icon_no_warning_fn("viruses"),
          color = "red")
})

output$r_number_infobox <- renderInfoBox({
  infoBox(title="R number",
          value= glue("{R_Number %>% tail(1) %>% .$LowerBound}",
                      " - {R_Number %>% tail(1) %>% .$UpperBound}"),
          icon = icon_no_warning_fn("r"),
          color = "red")
})

output$wastewater_infobox <- renderInfoBox({
  infoBox(title="Wastewater level",
          value= {Wastewater %>% tail(1) %>% .$WastewaterSevenDayAverageMgc %>%
              signif(3) %>% paste("Mgc/p/d")},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("faucet-drip"),
          color = "red")
})

output$reported_cases_infobox <- renderInfoBox({
  infoBox(title="Reported cases",
          value= {Cases %>% tail(1) %>% .$SevenDayAverage %>%
              round_half_up(0) %>% format(big.mark=",")},
          subtitle = "7 day average",
          icon = icon_no_warning_fn("lungs-virus"),
          color = "red")
})

output$doses_wasted_infobox <- renderInfoBox({
  infoBox(title="Doses wasted",
          value={Vaccine_Wastage %>% tail(1) %>%
              .$NumberOfDosesWasted %>%
              format(big.mark = ",")},
          subtitle = "Monthly total",
          icon = icon_no_warning_fn("dumpster"),
          color = "teal")
})

output$doses_administered_infobox <- renderInfoBox({
  infoBox(title="Doses administered",
          value={Vaccine_Wastage %>% tail(1) %>%
              .$NumberOfDosesAdministered %>%
              format(big.mark = ",")},
          subtitle = "Monthly total",
          icon = icon_no_warning_fn("syringe"),
          color = "teal")
})

output$percent_wasted_infobox <- renderInfoBox({
  infoBox(title="Percent wasted",
          value={Vaccine_Wastage %>% tail(1) %>%
              .$PercentageWasted %>%
              paste0("%")},
          subtitle = "Monthly %",
          icon = icon_no_warning_fn("percent"),
          color = "teal")
})





