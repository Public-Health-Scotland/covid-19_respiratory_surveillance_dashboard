tagList(
  fluidRow(width=12, h1("COVID-19 & respiratory surveillance in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(
        status = "info",
        tagList(
          h2("COVID-19 cases"),
          jumpToTabButtonUI("cases_from_summary", location_pretty = "cases"),
          linebreaks(1),

          fluidRow(column(12,
                          h4(glue("Week ending {ONS %>% tail(1) %>% .$EndDate %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("ons_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Wastewater %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("wastewater_infobox", width=NULL)
                          ))),

          h4(glue("Week ending {Cases %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),

          fluidRow(column(6,
                          #h4(glue("Week ending {Cases %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("reported_cases_infobox", width=NULL)
                          )),

                   column(6, #h4(glue("Week ending {Cases %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("cases_cumulative_infobox", width=NULL)
                          ))),

          linebreaks(1)

        )),

      box(
        status = "info",
        tagList(
          h2("COVID-19 hospital admissions"),
          jumpToTabButtonUI("hospital_admissions_from_summary", location_pretty = "hospital admissions"),
          linebreaks(1),

          h4(glue("Week ending {names(admissions_headlines[1])}")),

          fluidRow(column(6,
                          withNavySpinner(
                            infoBoxOutput("admissions_infobox", width = NULL)
                          )),
                   column(6,

                          #h4(glue("Week ending {Admissions %>%  tail(1) %>% .$AdmissionDate %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("admissions_cumulative_infobox", width = NULL)
                          ))),

          h4(glue("Week ending {names(icu_headlines[1])}")),

          fluidRow(column(6,
                          withNavySpinner(
                            infoBoxOutput("icu_infobox", width=NULL)
                          )),
                   column(6,

                          #h4(glue("Week ending {ICU %>%  tail(1) %>% .$DateFirstICUAdmission %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("icu_cumulative_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {los_date_end %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("los_infobox", width=NULL)
                          ))),

          linebreaks(1)

        )),


      box(
        status = "info",
        tagList(
          h2("COVID-19 hospital occupancy"),
          jumpToTabButtonUI("hospital_occupancy_from_summary", location_pretty = "hospital occupancy"),
          linebreaks(1),

          fluidRow(column(12,
                          h4(glue("As at {names(occupancy_headlines)[1]}")),
                          withNavySpinner(
                            infoBoxOutput("occupancy_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Occupancy_ICU %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("icu_less_occupancy_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Occupancy_ICU %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("icu_more_occupancy_infobox", width=NULL)
                          ))),

          linebreaks(1)

        )),

      box(
        status = "info",
        tagList(
          h2("Respiratory infection activity"),
          jumpToTabButtonUI("respiratory_from_summary", location_pretty = "respiratory"),
          linebreaks(1),

          fluidRow(column(12,
                          h4(glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                  .$DateThisWeek %>%
                  as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("respiratory_flu_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'flu') %>%
                  .$DateThisWeek %>%
                  as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("respiratory_flu_change_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                  .$DateThisWeek %>%
                  as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("respiratory_nonflu_infobox", width=NULL)
                          ))),

          fluidRow(column(12,
                          h4(glue("Week ending {Respiratory_Summary_Totals %>% filter(FluOrNonFlu == 'nonflu') %>%
                  .$DateThisWeek %>%
                  as_dashboard_date()}")),
                          withNavySpinner(
                            infoBoxOutput("respiratory_nonflu_change_infobox", width=NULL)
                          ))),

          linebreaks(1)

        )),


      # Padding out the bottom of the page
      fluidRow(column(12, linebreaks(5)))
    ) # taglist
  )# fluidRow
)
