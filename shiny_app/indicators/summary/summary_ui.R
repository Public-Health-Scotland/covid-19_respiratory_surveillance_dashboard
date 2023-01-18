tagList(
  fluidRow(width=12, h1("COVID-19 in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(
          status = "info",
          tagList(
            h2("Hospital admissions"),

            withNavySpinner(
              infoBoxOutput("admissions_infobox", width = NULL)
              ),

            withNavySpinner(
              infoBoxOutput("icu_infobox", width=NULL)
              ),

            withNavySpinner(
              infoBoxOutput("los_infobox", width=NULL)
              ),

            linebreaks(1)

          )),


      box(
          status = "info",
          tagList(
            h2("Hospital occupancy"),

            withNavySpinner(
              infoBoxOutput("occupancy_infobox", width=NULL)
              ),

            withNavySpinner(
              infoBoxOutput("icu_less_occupancy_infobox", width=NULL)
              ),

            withNavySpinner(
              infoBoxOutput("icu_more_occupancy_infobox", width=NULL)
              ),

            linebreaks(1)

          )),

      box(
          status = "info",
          tagList(
            h2("Cases"),


            withNavySpinner(
              infoBoxOutput("ons_infobox", width=NULL)
              ),

            # withNavySpinner(
            #  infoBoxOutput("r_number_infobox", width=NULL)
            #  ),

            withNavySpinner(
              infoBoxOutput("wastewater_infobox", width=NULL)
              ),

            withNavySpinner(
              infoBoxOutput("reported_cases_infobox", width=NULL)
              ),

            linebreaks(1)

          )),


      box(
          status = "info",
          tagList(
            h2("Vaccine wastage"),


            withNavySpinner(
              infoBoxOutput("doses_wasted_infobox", width=NULL)
              ),

            withNavySpinner(
              infoBoxOutput("doses_administered_infobox", width=NULL)
              ),

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
