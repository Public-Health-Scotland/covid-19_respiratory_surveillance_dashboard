tagList(
  fluidRow(width=12, h1("COVID-19 in Scotland"),
           linebreaks(1)),
  fluidRow(
    tagList(
      box(height=500,
          tagList(
            h2("Hospital admissions"),
            infoBoxOutput("admissions_infobox", width=NULL),
            bsPopover("admissions_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("icu_infobox", width=NULL),
            bsPopover("icu_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("los_infobox", width=NULL),
            bsPopover("los_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL)
          )),
      box(height=500,
          tagList(
            h2("Hospital occupancy"),
            infoBoxOutput("occupancy_infobox", width=NULL),
            bsPopover("occupancy_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("icu_occupancy_infobox", width=NULL),
            bsPopover("icu_occupancy_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL)
          )),
      linebreaks(10),
      box(height=500,
          tagList(
            h2("Cases"),
            infoBoxOutput("ons_infobox", width=NULL),
            bsPopover("ons_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("r_number_infobox", width=NULL),
            bsPopover("r_number_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("wastewater_infobox", width=NULL),
            bsPopover("wastewater_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("reported_cases_infobox", width=NULL),
            bsPopover("reported_cases_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL)

          )),
      box(height=500,
          tagList(
            h2("Vaccine wastage"),
            infoBoxOutput("doses_wasted_infobox", width=NULL),
            bsPopover("doses_wasted_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("doses_administered_infobox", width=NULL),
            bsPopover("doses_administered_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("percent_wasted_infobox", width=NULL),
            bsPopover("percent_wasted_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL)
          )),

      fluidRow(height="100px", width=12, linebreaks(10))
    ) # taglist
)# fluidRow
)