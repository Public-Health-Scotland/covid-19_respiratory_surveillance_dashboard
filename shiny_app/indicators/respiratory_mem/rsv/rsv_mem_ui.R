# create values for headline boxes
rsv_cases_last_week<-Respiratory_Scot %>%
  filter(Pathogen == "Respiratory syncytial virus") %>%
  group_by(Pathogen) %>%
  mutate(last_sunday= max(WeekEnding) )%>%
  filter(WeekEnding==last_sunday)%>%
  ungroup %>%
  mutate(last_sunday= as.character(last_sunday)) %>%
  mutate(last_sunday=as.Date(last_sunday, format = "%Y%m%d")) %>%
  rename(rsv_cases_last_week=NumberCasesPerWeek)

rsv_cases_prev_week<-Respiratory_Scot %>%
  filter(Pathogen == "Respiratory syncytial virus") %>%
  group_by(Pathogen) %>%
  mutate(last_sunday_minus_7=max(WeekEnding-7)) %>%
  filter(WeekEnding==last_sunday_minus_7)%>%
  ungroup%>%
  mutate(last_sunday_minus_7= as.character(last_sunday_minus_7)) %>%
  mutate(last_sunday_minus_7=as.Date(last_sunday_minus_7, format = "%Y%m%d")) %>%
  select(rsv_cases_prev_week=NumberCasesPerWeek, last_sunday_minus_7, Pathogen)


rsv_cases_summary<-rsv_cases_last_week %>%
  left_join(rsv_cases_prev_week, by=c("Pathogen")) %>%
  mutate(PercentageDifference=round_half_up((rsv_cases_last_week-rsv_cases_prev_week)/rsv_cases_prev_week*100,0),
         ChangeFactor = case_when(PercentageDifference < 0 ~ "decrease",
                                  PercentageDifference > 0 ~ "increase",
                                  PercentageDifference == 0 ~ "no change"),
         icon= case_when(ChangeFactor == "decrease"~"arrow-down",
                         ChangeFactor == "increase"~ "arrow-up",
                         ChangeFactor == "no change"~"equals"))

rm(rsv_cases_last_week, rsv_cases_prev_week)
###

tagList(
  fluidRow(width = 12,
           metadataButtonUI("respiratory_rsv_mem"),
           linebreaks(1),
           h1("RSV Incidence Rates"),
           p("Respiratory syncytial virus (RSV) is a virus that generally causes mild cold like",
             "symptoms but may occasionally result in severe lower respiratory infection such as",
             "bronchiolitis or pneumonia, particularly in infants and young children or in adults",
             "with compromised cardiac, pulmonary, or immune systems. RSV has an annual seasonality",
             "with peaks of activity in the winter months. Additional information can be found on the PHS page for RSV."),
           linebreaks(1)),


    fluidRow(width = 12,
             tabPanel(stringr::str_to_sentence("influenza"),
                      # headline figures for the week in Scotland
                      tagList(h2(glue("Summary of RSV cases in Scotland")),
                              tags$div(class = "headline",
                                       h3(glue("Total number of RSV cases in Scotland over the last two weeks")),
                                       # this week total number
                                       valueBox(value = {rsv_cases_summary %>% .$rsv_cases_last_week %>% format(big.mark=",")},
                                           subtitle = glue("Week ending {rsv_cases_summary %>% .$last_sunday%>% format('%d %b %y')}"),
                                           color = "teal",
                                           icon = icon_no_warning_fn("calendar-week")),
                                       # previous week total number
                                        valueBox(value = {rsv_cases_summary %>% .$rsv_cases_prev_week %>% format(big.mark=",")},
                                           subtitle = glue("Week ending {rsv_cases_summary %>% .$last_sunday_minus_7%>% format('%d %b %y')}"),
                                           color = "teal",
                                           icon = icon_no_warning_fn("calendar-week")),
                                       # percentage difference between the previous weeks
                                       valueBox(value = glue("{rsv_cases_summary%>% .$PercentageDifference}%"),
                                          subtitle = glue("{rsv_cases_summary %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                           color = "teal",
                                           icon = icon_no_warning_fn({rsv_cases_summary %>%  .$icon})),
                                        # This text is hidden by css but helps pad the box at the bottom
                                       h6("hidden text for padding page")
                                                                 )))), # headline

  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population in Scotland"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_plot")),
                            )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow

  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population by NHS Health Board"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_hb_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_mem_hb_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow


  fluidRow(width = 12,
           tagList(h2("RSV incidence rate per 100,000 population by age group"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("rsv_mem_age_modal"),
                            withNavySpinner(plotlyOutput("rsv_mem_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("rsv_mem_age_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  )#, # fluidRow

)
