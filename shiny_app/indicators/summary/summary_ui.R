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
                      "An admission to hospital where the patient had a first positive PCR from 14 days prior to admission up to two days following admission. This includes reinfections which are 90 days or more since their last positive test. This only includes emergency admissions to medical or paediatric specialties, excluding emergency admissions for injuries.",strong("For more information, see metadata.")),
                      placement = "bottom", trigger = "hover",
                      options = list(container = "body")),
            infoBoxOutput("icu_infobox", width=NULL),
            bsPopover("icu_infobox", "COVID-19 related ICU admissions", paste("A patient who has tested positive for COVID at any time in the 21 days prior to admission to ICU, or who has tested positive from the date of admission up to and including the date of ICU discharge", strong("For more information, see metadata.")) ,
                      placement = "top", trigger = "hover",
                      options = NULL),
            infoBoxOutput("los_infobox", width=NULL),
            bsPopover("los_infobox", "Length of stay (LOS) of COVID-19 admissions", paste("The length of time an individual spends in hospital.", strong("For more information, see metadata.")),
                      placement = "top", trigger = "hover",
                      options = NULL)
          )),
      box(height=500, status = "info",
          tagList(
            h2("Hospital occupancy"),
            infoBoxOutput("occupancy_infobox", width=NULL),
            bsPopover("occupancy_infobox", "title", "This is some content blah blah blah",
                      placement = "bottom", trigger = "hover",
                      options = NULL),
            infoBoxOutput("icu_occupancy_infobox", width=NULL),
            bsPopover("icu_occupancy_infobox", "title", "This is some content blah blah blah",
                      placement = "top", trigger = "hover",
                      options = NULL)
          )),
      linebreaks(10),
      box(height=500, status = "info",
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
      box(height=500, status = "info",
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
      # Padding out the bottom of the page
      fluidRow(height="500px", width=12, linebreaks(5))
    ) # taglist
)# fluidRow
)