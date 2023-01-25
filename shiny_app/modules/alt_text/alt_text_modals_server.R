####################### Modals #######################

# Alt text module server ----
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
        footer = modalButton("Close")
      )

      observeEvent(input$alttext, { showModal(modal) })


    }
  )

}

# Individual modals ----

# To make a new alt text button create an alt text server object here and then
# add corresponding ui component where you want the button to appear

# e.g. corresponding ui for ons_cases_modal is altTextUI("ons_cases_modal")
#      in indicators/cases/cases_ui.R

# Cases ----
altTextServer("ons_cases_modal",
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

altTextServer("r_number_modal",
              title = "Estimated COVID-19 R number",
              content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

altTextServer("wastewater_modal",
              title = "Seven day average trend in wastewater COVID-19",
              content = tags$ul(tags$li("point a"), tags$li("point b"), tags$li("point c")))

altTextServer("reported_cases_modal",
              title = "Reported COVID-19 cases",
              content = tags$ul(tags$li("This is a plot of the number of reported COVID-19 cases each day."),
                                tags$li("The x axis is the date"),
                                tags$li("The y axis is the number of reported cases"),
                                tags$li("There are two traces: a light blue trace which shows the number of reported cases each day;",
                                        "and a dark blue trace overlayed which has the 7 day average of this."),
                                tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                        "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                        "the second marks the change in testing policy on 1 May 2022."),
                                tags$li("The 7 day average peaked at about 18,000 at the start of Jan 2022.")
                                )
              )

# Hospital admissions ----

altTextServer("hospital_admissions_modal",
             title = "Daily number of COVID-19 hospital admissions",
             content = tags$ul(tags$li("This is a plot of daily COVID-19 hospital admissions."),
                               tags$li("The x axis is the date, starting 01 Mar 2020."),
                               tags$li("The y axis is the number of admissions."),
                               tags$li("There are two traces: a light blue trace which shows the number of",
                                       "hospital admissions; and a dark blue trace overlayed which shows the 7 day average of this."),
                               tags$li("The data for the most recent week are provisional and displayed in grey."),
                               tags$li("There are two vertical lines: the first denotes that prior to 5 Jan 2022 ",
                                       "reported cases are PCR only, and since then they include PCR and LFD cases; ",
                                       "the second marks the change in testing policy on 1 May 2022."),
                               tags$li("There have been several peaks throughout the pandemic, notably in",
                                       "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021, Jan 2022, Mar 2022 and Jun 2022.")
                               )
             )

altTextServer("hospital_admissions_simd_modal",
             title = "Weekly number of COVID-19 hospital admissions by deprivation category (SIMD)",
             content = tags$ul(tags$li("This is a plot of weekly COVID-19 hospital admissions broken down by SIMD deprivation category."),
                               tags$li("SIMD is a relative measure of deprivation across small areas in Scotland.",
                                       "There are equal numbers of data zones in each of the five categories.",
                                       "SIMD 1 contains the 20% most deprived zones and SIMD 5 contains the 20%",
                                       "least deprived zones. See the",
                                       tags$a("Scottish government website (external link)",
                                              href="https://www.gov.scot/collections/scottish-index-of-multiple-deprivation-2020/"),
                                       "for more information."),
                               tags$li("The x axis is the week ending, starting 03 Jan 2021."),
                               tags$li("The y axis is the number of COVID-19 hospital admissions in that week."),
                               tags$li("The plot contains a trace for each of the SIMD categories. SIMD 1 is",
                                       "highlighted in red and SIMD 5 in blue. The other categories are in grey."),
                               tags$li("There have been several peaks throughout the pandemic, notably in",
                                       "Apr 2020, Oct 2020, Jan 2021, Jul 2021, Sep 2021, Jan 2022, Mar 2022 and Jun 2022.")
                               )
             )

altTextServer("hospital_admissions_los_modal",
             title = "Length of stay of acute COVID-19 hospital admissions",
             content = tags$ul(
               tags$li("This is a plot of the distribution of lengths of stay in hospital",
                       "for acute COVID-19 hospital admissions."),
               tags$li("There is a drop down above the chart which allows you to select",
                       "an age group for plotting. The default is all ages."),
               tags$li("The legend shows five categories for length of stay: 1 day or less;",
                       "2-3 days, 4-5 days, 6-7 days, 8+ days. See the metadata tab for further detail."),
               tags$li("The x axis is the hospital admission date by week ending."),
               tags$li("The y axis is the percentage of admissions in a given length of stay category."),
               tags$li("The plot is a stacked bar chart for each week ending, where the",
                       "sections of vertical bars correspond to different length of stay categories.",
                       "The bar sections are ordered from smallest length of stay to largest",
                       "length of stay from bottom to top."),
               tags$li("Please note that in cases where there are no hospital admissions there",
                       "will be a gap in the chart.")
               )
             )

altTextServer("hospital_admissions_ethnicity_modal",
             title = "Admissions to hospital 'with' COVID-19 by ethnicity",
             content = tags$ul(
               tags$li("This is a plot of admissions to hospital 'with' COVID-19",
                       "broken down by ethnic group."),
               tags$li("The x axis is the month of admission to hospital."),
               tags$li("The y axis is the number of admissions."),
               tags$li("The plot is a stacked bar chart for each month beginning,",
                       "where the bars are broken down by ethnic group."),
               tags$li("The ethnic groups are displayed from bottom to top in the",
                       "following order: African; Asian, Asian Scottish or Asian British;",
                       "Caribbean or Black; White; Mixed or Multiple Ethnic Groups;",
                       "Other; Unknown.")
               )
             )

altTextServer("icu_admissions_modal",
             title = "Daily number of COVID-19 ICU admissions",
             content = tags$ul(
              tags$li("This is a plot of the daily number of COVID-19 admissions to",
                      "hospital intensive care units (ICU)."),
              tags$li("The x axis is the date of admission, commencing 12 Mar 2020."),
              tags$li("The y axis is the number of ICU admissions."),
              tags$li("There are two traces: a light blue trace which shows the number of ICU admissions each day;",
                      "and a dark blue trace overlayed which has the 7 day average of this."),
              tags$li("There were large peaks in ICU admissions in Apr 2020, Jan 2021",
                      "and Sep 2021. Since then the overall trend has been a decline",
                      "in ICU admissions over time.")
              )
            )

# Hospital occupancy ----

altTextServer("hospital_occupancy_modal",
              title = "Number of patients with COVID-19 in hospital",
              content = tags$ul(
                tags$li("This is a plot of the number of patients with COVID-19 in hospital."),
                tags$li("The x axis is the date, commencing 08 Sep 2020."),
                tags$li("The y axis is the number of people with COVID-19 in hospital."),
                tags$li("There are two traces: a light blue trace which shows the number of",
                        "patients with COVID-19 in hospital each day;",
                        "and a dark blue trace overlayed which has the 7 day average of this."),
                tags$li("There were peaks in COVID-19 occupancy in Nov 2020, Jan 2021, Jul 2021,",
                        "Sep 2021, Jan 2022, Apr 2022, Jul 2022 and Oct 2022.")
                )
              )

altTextServer("icu_occupancy_modal",
              title = "Number of patients with COVID-19 in ICU",
              content = tags$ul(
               tags$li("This is a plot of the 7 day average of the number of",
                       "patients with COVID-19 in hospital intensive care units (ICU)."),
               tags$li("The x axis is the date, commencing 13 Sep 2020."),
               tags$li("The y axis is the 7 day average number of people in ICU."),
               tags$li("There are two traces broken down by length of stay in ICU:",
                       "one for length of stay 28 days or less (blue; trace commences 13 Sep 2020);",
                       "the other for length of stay greater than 28 days (red; trace commences 27 Jan 2021)."),
               tags$li("Since Oct 2021 the overarching trend has been a decrease in the number of",
                       "patients with COVID-19 in ICU.")
               )
             )

# Respiratory ----

# Flu ----

altTextServer("respiratory_flu_over_time_modal",
              title = "Influenza cases over time by subtype",
              content = tags$ul(
                tags$li("This is a plot of the influenza cases in a given NHS health board",
                        "over time."),
                tags$li("The cases are presented as a rate, i.e. the number of people with",
                        "influenza for every 10,000 people in that NHS health board."),
                tags$li("For Scotland there is an option to view the absolute number of cases."),
                tags$li("The x axis is the date, commencing 02 Oct 2016."),
                tags$li("The y axis is either the rate of cases or the number of cases."),
                tags$li("There is a trace for each subtype of Influenza."),
                tags$li("The trend is that each winter there is a peak in cases.")
              )
)

altTextServer("respiratory_flu_by_season_modal",
              title = "Influenza cases over time by season",
              content = tags$ul(
                tags$li("This is a plot of the influenza cases for a given subtype",
                        "over each influenza season."),
                tags$li("There is a trace for each influenza season, starting in 2016/2017."),
                tags$li("The x axis is the isoweek. The first isoweek is the first week of the year (in January)",
                        "and the 52nd isoweek is the last week of the year."),
                tags$li("The y axis is the rate of cases of the chosen influenza subtype in Scotland."),
                tags$li("The trend is that each winter there is a peak in cases. The peak was",
                        "highest in 2017/2018 at about 2,800 cases.")
              )
)

altTextServer("respiratory_flu_age_sex_modal",
              title = "Influenza cases by age and/or sex in Scotland",
              content = tags$ul(
                tags$li("This is a plot of the total influenza cases in Scotland."),
                tags$li("The information is displayed for a selected influenza season and week."),
                tags$li("One of three different plots is displayed depending on the breakdown",
                        "selected: either Age; Sex; or Age + Sex."),
                tags$li("All three plots show rate per 100,000 people on the y axis."),
                tags$li("For the x axis the first plot shows age group, the second shows",
                        "sex, and the third shows age group and sex."),
                tags$li("The first plot (Age) is a bubble plot. This is a scatter plot",
                        "where both the position and the area of the circle correspond",
                        "to the rate per 100,000 people."),
                tags$li("The second and third plots are bar charts where the left hand column",
                        "corresponds to female (F) and the right hand column to male (M)."),
                tags$li("The youngest and oldest groups have the highest rates of influenza.")
              )
)

# Non-flu ----

altTextServer("respiratory_nonflu_over_time_modal",
              title = "Non-influenza cases over time by subtype",
              content = tags$ul(
                tags$li("This is a plot of the non-influenza cases in a given NHS health board",
                        "over time."),
                tags$li("The cases are presented as a rate, i.e. the number of people with",
                        "non-influenza respiratory illness for every 10,000 people in that NHS health board."),
                tags$li("For Scotland there is an option to view the absolute number of cases."),
                tags$li("The x axis is the date, commencing 02 Oct 2016."),
                tags$li("The y axis is either the rate of cases or the number of cases."),
                tags$li("There is a trace for each subtype of respiratory illness."),
                tags$li("The trend is that each winter there is a peak in cases.")
              )
)

altTextServer("respiratory_nonflu_by_season_modal",
              title = "Non-influenza cases over time by season",
              content = tags$ul(
                tags$li("This is a plot of the non-influenza cases for a given subtype",
                        "over each season."),
                tags$li("There is a trace for eachseason, starting in 2016/2017."),
                tags$li("The x axis is the isoweek. The first isoweek is the first week of the year (in January)",
                        "and the 52nd isoweek is the last week of the year."),
                tags$li("The y axis is the rate of cases of the chosen respiratory illness subtype in Scotland."),
                tags$li("The trend is that each winter there is a peak in cases.")
              )
)

altTextServer("respiratory_nonflu_age_sex_modal",
              title = "Non-influenza cases by age and/or sex in Scotland",
              content = tags$ul(
                tags$li("This is a plot of the total non-influenza cases in Scotland."),
                tags$li("The information is displayed for a selected season and week."),
                tags$li("One of three different plots is displayed depending on the breakdown",
                        "selected: either Age; Sex; or Age + Sex."),
                tags$li("All three plots show rate per 100,000 people on the y axis."),
                tags$li("For the x axis the first plot shows age group, the second shows",
                        "sex, and the third shows age group and sex."),
                tags$li("The first plot (Age) is a bubble plot. This is a scatter plot",
                        "where both the position and the area of the circle correspond",
                        "to the rate per 100,000 people."),
                tags$li("The second and third plots are bar charts where the left hand column",
                        "corresponds to female (F) and the right hand column to male (M)."),
                tags$li("The youngest and oldest groups have the highest rates of respiratory illness.")
              )
)




# Vaccines ----

# vaccine_wastage_modal <- altTextServer("vaccine_wastage_modal",
#                                      title = "COVID-19 vaccine wastage",
#                                      content = tags$ul(
#                                        tags$li("This is a plot of the number of COVID-19 vaccine doses wasted."),
#                                        tags$li("The x axis is the month."),
#                                        tags$li("The y axis is the number of doses."),
#                                        tags$li("The plot is a stacked bar chart: the bottom stack (blue) is the number",
#                                                "of doses administered each month; the top stack (red) is the number",
#                                                "of doses wasted each month."),
#                                        tags$li("There is a vertical dotted line at Dec 2021 indicating that before",
#                                                "Dec 2021 the plot refers to doses 1 and 2 only, but after 2021",
#                                                "relevant later doses are included.")
#                                        )
#                                      )
#
# vaccine_wastage_reason_modal <- altTextServer("vaccine_wastage_reason_modal",
#                                        title = "Reasons for COVID-19 vaccine wastage",
#                                        content = tags$ul(
#                                          tags$li("This is a plot of the reasons for COVID-19 vaccine wastage."),
#                                          tags$li("The y axis is the reason for wastage."),
#                                          tags$li("The x axis is the percentage of doses wasted which belong to that reason."),
#                                          tags$li("The reasons for wastage are split into: excess stock; expired shelf life;",
#                                                  "and other reasons."),
#                                          tags$li("The plot is a bar chart."),
#                                          tags$li("Excess stock is the biggest reason for wastage, followed by expired",
#                                                  "shelf life, then other reasons. The corresponding data table contains",
#                                                  "the exact figures.")
#                                          )
#                                        )













