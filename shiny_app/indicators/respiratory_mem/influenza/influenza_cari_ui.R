# create values for headline boxes

influenza_cari_recent_week <- Respiratory_Pathogens_CARI_Scot %>% 
  filter(Pathogen == 'Influenza') %>%
  tail(2) %>%
  select(-WeekBeginning) %>%
  rename(Date = WeekEnding) %>%
  mutate(DateLastWeek = .$Date[1],
         DateThisWeek = .$Date[2],
         SwabPositivityLastWeek = .$`SwabPositivity`[1],
         SwabPositivityThisWeek = .$`SwabPositivity`[2],
         Difference = round(SwabPositivityThisWeek-SwabPositivityLastWeek, digits = 1)) %>%
  mutate(ChangeFactor = case_when(
    Difference < 0 ~ "Decrease",
    Difference > 0 ~ "Increase",
    TRUE                     ~ "No change"),
    icon= case_when(ChangeFactor == "Decrease"~"arrow-down",
                    ChangeFactor == "Increase"~ "arrow-up",
                    ChangeFactor == "No change"~"equals")
  ) %>%
  select(DateLastWeek, DateThisWeek, SwabPositivityLastWeek, SwabPositivityThisWeek, Difference, ChangeFactor, icon) %>%
  head(1)
###

tagList(
  
  fluidRow(width = 12,
           metadataButtonUI("respiratory_influenza_cari"),
           linebreaks(1),
  ),
  
  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Influenza test positivity in the Community Acute Respiratory Infection (CARI) sentinel surveillance programme")),
                            tags$div(class = "headline",
                                     br(),
                                     # previous week total number
                                     valueBox(value = glue("{influenza_cari_recent_week %>% .$SwabPositivityLastWeek}%"),
                                              subtitle = glue("Week ending {influenza_cari_recent_week %>% .$DateLastWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{influenza_cari_recent_week %>% .$SwabPositivityThisWeek}%"),
                                              subtitle = glue("Week ending {influenza_cari_recent_week %>% .$DateThisWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{influenza_cari_recent_week %>% .$Difference}%"),
                                              subtitle = glue("{influenza_cari_recent_week %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({influenza_cari_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline



  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Influenza"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_cari_modal"),
                            swabposDefinitionUI("cari_influenza_swabpos"),
                            ciDefinitionUI("cari_influenza_ci"),
                            withNavySpinner(plotlyOutput("influenza_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_cari_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Influenza by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_cari_age_modal"),
                            swabposDefinitionUI("cari_influenza_age_swabpos"),
                            ciDefinitionUI("cari_influenza_age_ci"),
                            withNavySpinner(plotlyOutput("influenza_cari_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("influenza_cari_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
)
