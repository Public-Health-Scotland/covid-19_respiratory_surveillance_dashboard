# create values for headline boxes

seasonal_coronavirus_cari_recent_week <- Respiratory_Pathogens_CARI_Scot %>%
  filter(Pathogen == 'Seasonal Coronavirus (non-COVID-19)') %>%
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
           metadataButtonUI("respiratory_seasonal_coronavirus_cari"),
           linebreaks(1),
  ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("seasonal_coronavirus"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Seasonal Coronavirus test positivity in the Community Acute Respiratory Infection (CARI) sentinel surveillance programme")),
                            tags$div(class = "headline",
                                     br(),
                                     # previous week total number
                                     valueBox(value = glue("{seasonal_coronavirus_cari_recent_week %>% .$SwabPositivityLastWeek}%"),
                                              subtitle = glue("Week ending {seasonal_coronavirus_cari_recent_week %>% .$DateLastWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{seasonal_coronavirus_cari_recent_week %>% .$SwabPositivityThisWeek}%"),
                                              subtitle = glue("Week ending {seasonal_coronavirus_cari_recent_week %>% .$DateThisWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{seasonal_coronavirus_cari_recent_week %>% .$Difference}%"),
                                              subtitle = glue("{seasonal_coronavirus_cari_recent_week %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({seasonal_coronavirus_cari_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline


  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Seasonal Coronavirus"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_cari_modal"),
                            swabposDefinitionUI("cari_seasonal_coronavirus_swabpos"),
                            ciDefinitionUI("cari_seasonal_coronavirus_ci"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_cari_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Seasonal Coronavirus by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("seasonal_coronavirus_cari_age_modal"),
                            swabposDefinitionUI("cari_seasonal_coronavirus_age_swabpos"),
                            ciDefinitionUI("cari_seasonal_coronavirus_age_ci"),
                            withNavySpinner(plotlyOutput("seasonal_coronavirus_cari_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("seasonal_coronavirus_cari_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
)
