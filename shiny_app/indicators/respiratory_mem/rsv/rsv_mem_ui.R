rsv_cases_seasons <- 
  Respiratory_Pathogens_Test_Positivity_by_Age %>% 
  filter(pathogen == "RSV") %>% 
  select(season) %>% 
  unique() %>% 
  tail(6)

# create values for headline boxes
pop_scot_total <- i_population_v2 %>%
  filter(AgeGroup == "Total", Sex == "Total") %>%
  .$PopNumber

rsv_cases_recent_week <- Respiratory_AllData %>%
  filter(Organism == "Respiratory syncytial virus") %>%
  filter(Measure == "Scotland") %>%
  arrange(Date) %>% 
  select(-Pathogen) %>% 
  rename(Pathogen = Organism,
         NumberCasesPerWeek = Count) %>%
  select(Date, Pathogen, NumberCasesPerWeek) %>% 
  tail(2) %>%
  mutate(DateLastWeek = .$Date[1],
         DateThisWeek = .$Date[2],
         CasesLastWeek = .$`NumberCasesPerWeek`[1],
         CasesThisWeek = .$`NumberCasesPerWeek`[2],
         PercentageDifference = round((CasesThisWeek/CasesLastWeek - 1)*100, digits = 2),
         RateLastWeek = round_half_up(100000 *  .$`NumberCasesPerWeek`[1]/pop_scot_total,1),
         RateThisWeek = round_half_up(100000 *  .$`NumberCasesPerWeek`[2]/pop_scot_total,1)) %>%
  mutate(ChangeFactor = case_when(
    PercentageDifference < 0 ~ "Decrease",
    PercentageDifference > 0 ~ "Increase",
    TRUE                     ~ "No change"),
    icon= case_when(ChangeFactor == "Decrease"~"arrow-down",
                    ChangeFactor == "Increase"~ "arrow-up",
                    ChangeFactor == "No change"~"equals")
  ) %>%
  select(DateLastWeek, DateThisWeek, CasesLastWeek, CasesThisWeek, PercentageDifference, RateLastWeek, RateThisWeek, ChangeFactor, icon) %>%
  head(1)
###

tagList(

    fluidRow(width = 12,
             tabPanel(stringr::str_to_sentence("influenza"),
                      # headline figures for the week in Scotland
                      tagList(h2(glue("Summary of laboratory-confirmed RSV cases in Scotland")),
                              tags$div(class = "headline",
                                       br(),
                                       # previous week total number
                                        valueBox(value = {rsv_cases_recent_week %>% .$CasesLastWeek %>% format(big.mark=",")},               
                                           subtitle = tagList(tags$strong(glue("({format(rsv_cases_recent_week %>% .$RateLastWeek, nsmall = 1)} per 100,000)")),
                                           br(),
                                           glue("Week ending {rsv_cases_recent_week %>% .$DateLastWeek%>% format('%d %b %y')}")),
                                           color = "navy",
                                           icon = icon_no_warning_fn("calendar-week")),
                                       # this week total number
                                       valueBox(value = {rsv_cases_recent_week %>% .$CasesThisWeek %>% format(big.mark=",")},
                                                subtitle = tagList(tags$strong(glue("({format(rsv_cases_recent_week %>% .$RateThisWeek, nsmall = 1)} per 100,000)")),
                                                                tags$br(),
                                                glue("Week ending {rsv_cases_recent_week %>% .$DateThisWeek%>% format('%d %b %y')}")),
                                                color = "navy",
                                                icon = icon_no_warning_fn("calendar-week")),
                                       # percentage difference between the previous weeks
                                       valueBox(value = glue("{round(rsv_cases_recent_week%>% .$PercentageDifference, 1)}%"),
                                          subtitle = glue("{rsv_cases_recent_week %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                           color = "navy",
                                           icon = icon_no_warning_fn({rsv_cases_recent_week %>%  .$icon})),
                                        # This text is hidden by css but helps pad the box at the bottom
                                       h6("hidden text for padding page")
                                                                 )))), # headline
  
  fluidRow(width = 12,
           tagList(h2("RSV percentage test positivity"),
                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   tagList(linebreaks(1),
                                           altTextUI("rsv_positivity_modal"),
                                           swabposDefinitionUI("rsv_swabpos"),
                                           withNavySpinner(plotlyOutput("rsv_positivity_plot")))),
                          tabPanel("Data",
                                   tagList(
                                     withNavySpinner(dataTableOutput("rsv_positivity_table"))
                                   ) # tagList
                          ) # tabPanel
                   ) # tabBox
           ) # tagList
  ), #fluidrow

  
  
  fluidRow(width = 12,
           tagList(h2("RSV percentage test positivity by age"),
                   tabBox(width = NULL,
                          type = "pills",
                          tabPanel("Plot",
                                   br(),
                                   pickerInput(inputId = "test_pos_rsv_age",
                                               label = "Select season",
                                               choices = {rsv_cases_seasons %>% tail(6)},
                                               selected = {rsv_cases_seasons %>% tail(1)}),
                                   tagList(linebreaks(1),
                                           altTextUI("rsv_positivity_age_modal"),
                                           swabposDefinitionUI("rsv_age_swabpos"),
                                           withNavySpinner(plotlyOutput("rsv_positivity_age_plot")))),
                          tabPanel("Data",
                                   tagList(
                                     withNavySpinner(dataTableOutput("rsv_positivity_age_table"))
                                   ) # tagList
                          ) # tabPanel
                   ) # tabBox
           ) # tagList
  ), #fluidrow
  
  
  fluidRow(width = 12,
           tagList(h2("Laboratory-confirmed RSV incidence per 100,000 population in Scotland"))),

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
         tagList(h2("Laboratory-confirmed RSV incidence per 100,000 population by NHS Health Board"))),

fluidRow(
  
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  tagList(linebreaks(1),
                          altTextUI("rsv_mem_hb_modal"),
                          withNavySpinner(plotlyOutput("rsv_mem_hb_plot", height = "500px")),
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
           tagList(h2("Laboratory-confirmed RSV incidence per 100,000 population by age group"))),

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
  ), # fluidRow

fluidRow(
  tagList(h2(glue("Laboratory-confirmed RSV cases by age and sex in Scotland")),

          tabBox(width = NULL,
                 type = "pills",
                 tabPanel("Plot",
                          tagList(
                            linebreaks(1),
                            # adding selection for flu subtype
                            fluidRow(
                              column(4, pickerInput("rsv_respiratory_season",
                                                    label = "Select a season",
                                                    choices = {Respiratory_AllData %>% filter(FluOrNonFlu == "nonflu") %>%
                                                        .$Season %>% unique() %>% gsub("/", "/20", .) %>% tail(6)},
                                                    selected = {Respiratory_AllData %>% filter(FluOrNonFlu == "nonflu") %>%
                                                        .$Season %>% unique() %>% gsub("/", "/20", .) %>% tail(1)})
                              )
                            ),
                            altTextUI("rsv_age_sex"),
                            withNavySpinner(plotlyOutput("rsv_age_sex_pyramid_plot"))
                          ) # tagList
                 ), # tabPanel
                 tabPanel("Data",
                          withNavySpinner(dataTableOutput("rsv_age_sex_pyramid_table")))
          ) # tabbox
  ), # tagList
  linebreaks(1)
)


)
