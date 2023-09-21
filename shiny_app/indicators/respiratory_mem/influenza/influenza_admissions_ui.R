# Recent weeks admissions

influenza_admissions_recent_week <- Influenza_admissions %>%
  filter(FluType == "Influenza A & B") %>%
  tail(2) %>%
  #select(-Rate_per_100000) %>%
  pivot_wider(names_from = FluType,
              values_from = Admissions) %>%
  mutate(DateLastWeek = .$Date[1],
         DateThisWeek = .$Date[2],
         AdmissionsLastWeek = .$`Influenza A & B`[1],
         AdmissionsThisWeek = .$`Influenza A & B`[2],
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

           metadataButtonUI("respiratory_influenza_admissions"),
           linebreaks(1),
           h1("Influenza Hospital Admissions"),
           linebreaks(1)),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Summary of influenza hospital admissions in Scotland")),
                            tags$div(class = "headline",
                                     h3(glue("Total number of influenza hospital admissions in Scotland over the last two weeks")),
                                     # this week total number
                                     valueBox(value = {influenza_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {influenza_admissions_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                         color = "teal",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {influenza_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {influenza_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                                         color = "teal",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{influenza_admissions_recent_week %>%
                                                  .$PercentageDifference}%"),
                                              subtitle = glue("{influenza_admissions_recent_week %>%
                                                     .$ChangeFactor %>% str_to_sentence()} in the last week"),
                                              color = "teal",
                                              icon = icon_no_warning_fn({influenza_admissions_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline

  fluidRow(width = 12,
           tagList(h2("Influenza admissions in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_admissions_modal"),
                            withNavySpinner(plotlyOutput("influenza_admissions_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_admissions_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow


)


