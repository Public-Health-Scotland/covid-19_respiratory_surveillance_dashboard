tagList(
  fluidRow(width=12, h1("COVID-19 in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(height=500, status = "info",
          tagList(
            h2("Hospital admissions"),
            infoBox(title="Admissions",
                    value= admissions_headline,
                    subtitle = "Weekly total",
                    icon = icon_no_warning_fn("hospital"),
                    width = NULL,
                    color = "green"),
            infoBox(title="ICU admissions",
                    value= ICU_headline,
                    subtitle = "Weekly total",
                    icon = icon_no_warning_fn("heart-pulse"),
                    width = NULL,
                    color = "green"),
            infoBox(title="Length of stay",
                    value= glue("{Length_of_Stay_Median %>% filter(AgeGroup == 'All Ages') %>%
                        .$MedianLengthOfStay %>%round_half_up(1)} days"),
                    subtitle = "Median",
                    icon = icon_no_warning_fn("clock"),
                    width = NULL,
                    color = "green")
          )),
      box(height=500, status = "info",
          tagList(
            h2("Hospital occupancy"),
            infoBox(title="Hospital beds occupied",
                    value= "tbc",
                    subtitle = "7 day average",
                    icon = icon_no_warning_fn("bed"),
                    width = NULL,
                    color = "fuchsia"),
            infoBox(title="ICU beds occupied",
                    value= "tbc",
                    subtitle = "7 day average",
                    icon = icon_no_warning_fn("bed-pulse"),
                    width = NULL,
                    color = "fuchsia")
          )),
      linebreaks(10),
      box(height=500, status = "info",
          tagList(
            h2("Cases"),
            infoBox(title="Estimated prevalence",
                    value={ONS %>% tail(1) %>% .$EstimatedRatio},
                    subtitle = glue("{ONS %>% tail(1) %>% .$LowerCIRatio}",
                                    " to {ONS %>% tail(1) %>% .$UpperCIRatio}",
                                    " (95% CI)"),
                    icon = icon_no_warning_fn("viruses"),
                    width = NULL,
                    color = "red"),
            infoBox(title="R number",
                    value= glue("{R_Number %>% tail(1) %>% .$LowerBound}",
                                " - {R_Number %>% tail(1) %>% .$UpperBound}"),
                    icon = icon_no_warning_fn("r"),
                    width = NULL,
                    color = "red"),
            infoBox(title="Wastewater level",
                    value= {Wastewater %>% tail(1) %>% .$WastewaterSevenDayAverageMgc %>%
                           signif(3) %>% paste("Mgc/p/d")},
                    subtitle = "7 day average",
                    icon = icon_no_warning_fn("faucet-drip"),
                    width = NULL,
                    color = "red"),
            infoBox(title="Reported cases",
                    value= {Cases %>% tail(1) %>% .$SevenDayAverage %>%
                        round_half_up(0) %>% format(big.mark=",")},
                    subtitle = "7 day average",
                    icon = icon_no_warning_fn("lungs-virus"),
                    width = NULL,
                    color = "red")
          )),
      box(height=500, status = "info",
          tagList(
            h2("Vaccine wastage"),
            infoBox(title="Doses wasted",
                    value={Vaccine_Wastage %>% tail(1) %>%
                        .$NumberOfDosesWasted %>%
                        format(big.mark = ",")},
                    icon = icon_no_warning_fn("dumpster"),
                    width = NULL,
                    color = "teal"),
            infoBox(title="Doses administered",
                    value={Vaccine_Wastage %>% tail(1) %>%
                        .$NumberOfDosesAdministered %>%
                        format(big.mark = ",")},
                    icon = icon_no_warning_fn("syringe"),
                    width = NULL,
                    color = "teal"),
            infoBox(title="Percent wasted",
                    value={Vaccine_Wastage %>% tail(1) %>%
                        .$PercentageWasted %>%
                        paste0("%")},
                    icon = icon_no_warning_fn("percent"),
                    width = NULL,
                    color = "teal")
          )),
      # Padding out the bottom of the page
      fluidRow(height="500px", width=12, linebreaks(5))
    ) # taglist
)# fluidRow
)