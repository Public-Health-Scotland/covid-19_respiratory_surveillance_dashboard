# create values for headline boxes

rsv_cari_recent_week <- Respiratory_Pathogens_CARI_Scot %>% 
  filter(Pathogen == 'Respiratory Syncytial Virus') %>%
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
           metadataButtonUI("respiratory_rsv_cari"),
           linebreaks(1),
  ),
  
  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("rsv"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Summary of RSV swab positivity in the Community Acute Respiratory Infection (CARI) surveillance programme")),
                            tags$div(class = "headline",
                                     br(),
                                     # previous week total number
                                     valueBox(value = glue("{rsv_cari_recent_week %>% .$SwabPositivityLastWeek}%"),
                                              subtitle = glue("Week ending {rsv_cari_recent_week %>% .$DateLastWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{rsv_cari_recent_week %>% .$SwabPositivityThisWeek}%"),
                                              subtitle = glue("Week ending {rsv_cari_recent_week %>% .$DateThisWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{rsv_cari_recent_week %>% .$Difference}%"),
                                              subtitle = glue("{rsv_cari_recent_week %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({rsv_cari_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline
  
  
  fluidRow(width = 12,
           tagList(h2("CARI - Swab positivity for RSV"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_cari_modal"),
                            ciDefinitionUI("cari_rsv_ci"),
                            withNavySpinner(plotlyOutput("rsv_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_cari_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("CARI - Swab positivity for RSV by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_cari_age_modal"),
                            ciDefinitionUI("cari_rsv_age_ci"),
                            withNavySpinner(plotlyOutput("rsv_cari_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_cari_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ) # fluidRow
)
