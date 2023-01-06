####################### Modals #######################

altTextServer <- function(id, title, content) {

  moduleServer(
    id,
    function(input, output, session) {

      modal <- modalDialog(
        h3(title),
        content,
        size = "l",
        easyClose = TRUE,
        fade = TRUE,
        footer = actionButton(session$ns("close"), label = "Close")
      )

      observeEvent(input$alttext, { showModal(modal) })
      observeEvent(input$close, { removeModal() })


    }
  )

}


# To make a new alt text button create an alt text server object here and then
# add corresponding ui component where you want the button to appear

# e.g. corresponding ui for ons_cases_modal is altTextUI("ons_cases_modal")
#      in indicators/cases/cases_ui.R
ons_cases_modal <- altTextServer("ons_cases_modal",
                                 title = "Estimated COVID-19 infection rate",
                                 content = tags$ul(tags$li("This is a plot of the estimated COVID-19 infection rate in the population",
                                                           "from the Office for National Statistics."),
                                                   tags$li("The x axis shows week ending, starting from 06 November 2020."),
                                                   tags$li("The y axis shows the official positivity estimate, as a percentage",
                                                           "of the population in Scotland. "),
                                                   tags$li("There is one trace which includes error bars denoting confidence intervals."),
                                                   tags$li("The positivity estimate peaked at 1 in 11 for week ending 20 Mar 2022."),
                                                   tags$li("The latest positivity estimate in week ending",
                                                           glue("{ONS %>% tail(1) %>% .$EndDate %>% convert_opendata_date() %>% format('%d %b %y')}"),
                                                           glue("is {ONS %>% tail(1) %>% .$EstimatedRatio}")
                                                           )
                                                   )
                                 )

r_number_modal <- altTextServer("r_number_modal",
                                      title = "Estimated COVID-19 R number",
                                content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

wastewater_modal <- altTextServer("wastewater_modal",
                                title = "Seven day average trend in wastewater COVID-19",
                                content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

reported_cases_modal <- altTextServer("reported_cases_modal",
                                      title = "Reported COVID-19 cases",
                                      content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

hospital_admissions_modal <- altTextServer("hospital_admissions_modal",
                                           title = "Daily number of COVID-19 hospital admissions",
                                           content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

hospital_admissions_simd_modal <- altTextServer("hospital_admissions_simd_modal",
                                           title = "Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)",
                                           content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

hospital_admissions_los_modal <- altTextServer("hospital_admissions_los_modal",
                                           title = "Length of stay of acute COVID-19 hospital admissions",
                                           content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

hospital_admissions_ethnicity_modal <- altTextServer("hospital_admissions_ethnicity_modal",
                                               title = "Admissions to hospital 'with' COVID-19 by ethnicity",
                                               content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

icu_admissions_modal <- altTextServer("icu_admissions_modal",
                                       title = "Daily number of COVID-19 ICU admissions",
                                      content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

hospital_occupancy_modal <- altTextServer("hospital_occupancy_modal",
                                      title = "Number of patients with COVID-19 in hospital",
                                      content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

icu_occupancy_modal <- altTextServer("icu_occupancy_modal",
                                      title = "Number of patients with COVID-19 in ICU",
                                     content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

vaccine_wastage_modal <- altTextServer("vaccine_wastage_modal",
                                     title = "COVID-19 vaccine wastage",
                                     content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

vaccine_wastage_reason_modal <- altTextServer("vaccine_wastage_reason_modal",
                                       title = "Reasons for COVID-19 vaccine wastage",
                                       content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))


