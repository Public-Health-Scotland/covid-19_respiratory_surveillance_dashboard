# Recent weeks admissions

rsv_admissions_recent_week <- RSV_admissions %>%
  tail(2) %>%
  mutate(DateLastWeek = .$Date[1],
         DateThisWeek = .$Date[2],
         AdmissionsLastWeek = .$Admissions[1],
         AdmissionsThisWeek = .$Admissions[2],
         PercentageDifference = round((AdmissionsThisWeek/AdmissionsLastWeek - 1)*100, digits = 2)) %>%
  mutate(ChangeFactor = case_when(
    PercentageDifference < 0 ~ "Decrease",
    PercentageDifference > 0 ~ "Increase",
    TRUE                     ~ "No change"),
    icon= case_when(ChangeFactor == "Decrease"~"arrow-down",
                    ChangeFactor == "Increase"~ "arrow-up",
                    ChangeFactor == "No change"~"equals")
  ) %>%
  select(DateLastWeek, DateThisWeek, AdmissionsLastWeek, AdmissionsThisWeek, PercentageDifference, ChangeFactor, icon) %>%
  head(1)

tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_rsv_admissions"),
           linebreaks(1),
           #h1("RSV Hospital Admissions"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Number of acute RSV admissions to hospital")),
                            tags$div(class = "headline",
#                                     h3(glue("Total number of RSV hospital admissions in Scotland over the last two weeks")),
                                     # previous week total number
                                     valueBox(value = {rsv_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = {rsv_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{rsv_admissions_recent_week %>%
                                                  .$PercentageDifference}%"),
                                              subtitle = glue("{rsv_admissions_recent_week %>%
                                                     .$ChangeFactor %>% str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({rsv_admissions_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline

#  fluidRow(width = 12,
#           tagList(h2("Number of acute RSV admissions to hospital"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_admissions_modal"),
                            withNavySpinner(plotlyOutput("rsv_admissions_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_admissions_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow


)



