tagList(
  fluidRow(width=12, h1("COVID-19 & respiratory surveillance in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(
        status = "info",
        tagList(
          h2("COVID-19 cases"),
          linebreaks(1),

          h4(glue("Week ending {ONS %>% tail(1) %>% .$EndDate %>% convert_opendata_date() %>% as_dashboard_date()}")),
          withNavySpinner(
            infoBoxOutput("ons_infobox", width=NULL)
          ),

          # withNavySpinner(
          #  infoBoxOutput("r_number_infobox", width=NULL)
          #  ),

          h4(glue("Week ending {Wastewater %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
          withNavySpinner(
            infoBoxOutput("wastewater_infobox", width=NULL)
          ),

          h4(glue("Week ending {Cases %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
          withNavySpinner(
            infoBoxOutput("reported_cases_infobox", width=NULL)
          ),

          linebreaks(1)

        )),

      box(
          status = "info",
          tagList(
            h2("Hospital admissions"),
            linebreaks(1),

            h4(glue("Week ending {names(admissions_headlines[1])}")),
            withNavySpinner(
              infoBoxOutput("admissions_infobox", width = NULL)
              ),

            h4(glue("Week ending {names(icu_headlines[1])}")),
            withNavySpinner(
              infoBoxOutput("icu_infobox", width=NULL)
              ),

            h4(glue("Week ending {los_date_end %>% as_dashboard_date()}")),
            withNavySpinner(
              infoBoxOutput("los_infobox", width=NULL)
              ),

            linebreaks(1)

          )),


      box(
          status = "info",
          tagList(
            h2("Hospital occupancy"),
            linebreaks(1),

            h4(glue("Week ending {Occupancy_Hospital %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
            withNavySpinner(
              infoBoxOutput("occupancy_infobox", width=NULL)
              ),

            h4(glue("Week ending {Occupancy_ICU %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
            withNavySpinner(
              infoBoxOutput("icu_less_occupancy_infobox", width=NULL)
              ),

            h4(glue("Week ending {Occupancy_ICU %>% tail(1) %>% .$Date %>% convert_opendata_date() %>% as_dashboard_date()}")),
            withNavySpinner(
              infoBoxOutput("icu_more_occupancy_infobox", width=NULL)
              ),

            linebreaks(1)

          )),

      box(
          status = "info",
          tagList(
            h2("Vaccine wastage"),
            linebreaks(1),

            h4(glue("Month beginning {Vaccine_Wastage %>% tail(1) %>% .$Month %>% convert_opendata_date() %>% convert_date_to_month()}")),
            withNavySpinner(
              infoBoxOutput("doses_wasted_infobox", width=NULL)
              ),

            h4(glue("Month beginning {Vaccine_Wastage %>% tail(1) %>% .$Month %>% convert_opendata_date() %>% convert_date_to_month()}")),
            withNavySpinner(
              infoBoxOutput("doses_administered_infobox", width=NULL)
              ),

            h4(glue("Month beginning {Vaccine_Wastage %>% tail(1) %>% .$Month %>% convert_opendata_date() %>% convert_date_to_month()}")),
            withNavySpinner(
              infoBoxOutput("percent_wasted_infobox", width=NULL)
              ),

            linebreaks(1)

          )),
      # Padding out the bottom of the page

      fluidRow(column(12, linebreaks(5)))
    ) # taglist
)# fluidRow
)
