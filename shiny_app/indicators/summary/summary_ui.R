tagList(
  fluidRow(width=12, h1("COVID-19 in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(height=500, status = "info",
          tagList(
            h2("Hospital admissions"),

            infoBoxOutput("admissions_infobox", width = NULL),

            infoBoxOutput("icu_infobox", width=NULL),

            infoBoxOutput("los_infobox", width=NULL)

          )),


      box(height=500, status = "info",
          tagList(
            h2("Hospital occupancy"),
            infoBoxOutput("occupancy_infobox", width=NULL),

            infoBoxOutput("icu_less_occupancy_infobox", width=NULL),

            infoBoxOutput("icu_more_occupancy_infobox", width=NULL)

          )),


      linebreaks(10),
      box(height=500, status = "info",
          tagList(
            h2("Cases"),
            infoBoxOutput("ons_infobox", width=NULL),

            infoBoxOutput("r_number_infobox", width=NULL),

            infoBoxOutput("wastewater_infobox", width=NULL),

            infoBoxOutput("reported_cases_infobox", width=NULL)

          )),


      box(height=500, status = "info",
          tagList(
            h2("Vaccine wastage"),
            infoBoxOutput("doses_wasted_infobox", width=NULL),

            infoBoxOutput("doses_administered_infobox", width=NULL),

            infoBoxOutput("percent_wasted_infobox", width=NULL)

          )),
      # Padding out the bottom of the page

      fluidRow(height="500px", width=12, linebreaks(5))
    ) # taglist
)# fluidRow
)
