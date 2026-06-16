# create values for headline boxes

parainfluenza_cari_recent_week <- Respiratory_Pathogens_CARI_Scot %>% 
  filter(Pathogen == 'Parainfluenza Virus') %>%
  tail(2) %>%
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

# CARI HB data
parainfluenza_cari_hb <- Respiratory_Pathogens_CARI_HB %>% 
  filter(Pathogen == 'Parainfluenza Virus') %>%
  mutate(SwabPositivity = as.numeric(SwabPositivity),
         SwabPositivityLCL = as.numeric(SwabPositivityLCL),
         SwabPositivityUCL = as.numeric(SwabPositivityUCL)) %>%
  mutate(HBName = factor(HBName, levels = c("Scotland", setdiff(Respiratory_Pathogens_CARI_HB$HBName, "Scotland"))))

# CARI Age data
parainfluenza_cari_age <- Respiratory_Pathogens_CARI_Age %>% 
  filter(Pathogen == 'Parainfluenza Virus') %>%
  mutate(SwabPositivity = as.numeric(SwabPositivity),
         SwabPositivityLCL = as.numeric(SwabPositivityLCL),
         SwabPositivityUCL = as.numeric(SwabPositivityUCL)) %>%
  mutate(AgeGroup = factor(AgeGroup, levels = c("All ages", "0-4 years", "5-14 years", "15-44 years", 
                                                "45-64 years", "65-74 years", "75+ years")))

parainfluenza_cari_subtype <- Respiratory_Pathogens_CARI_Scot %>%
  filter(substr(Pathogen,1,19) %in% "Parainfluenza Virus") %>%
  mutate(WeekEnding = as.Date(WeekEnding)) %>%
  mutate(Pathogen = case_when(
    Pathogen == "Parainfluenza Virus" ~ "HPIV",
    Pathogen == "Parainfluenza Virus - Type 1" ~ "HPIV-1",
    Pathogen == "Parainfluenza Virus - Type 2" ~ "HPIV-2",
    Pathogen == "Parainfluenza Virus - Type 3" ~ "HPIV-3",
    Pathogen == "Parainfluenza Virus - Type 4" ~ "HPIV-4",
  )) %>%
  mutate(Pathogen = factor(Pathogen, levels = c("HPIV", "HPIV-1", "HPIV-2", "HPIV-3", "HPIV-4")))


tagList(
  
  fluidRow(width = 12,
           p("CARI surveillance is a sentinel community surveillance programme monitoring COVID-19, ",
             "influenza A and B, Respiratory Syncytial Virus (RSV), adenovirus, coronavirus (non-COVID19),", 
             "human metapneumovirus (HMPV), rhinovirus, parainfluenza and Mycoplasma pneumoniae. The ",
             "programme is open to GP practices across all NHS Boards in Scotland. To become a sentinel site,", 
             "GP practices voluntarily opt into the CARI programme. Patients in the community who consult a ",
             "sentinel GP practice with respiratory symptoms and who meet the case definition for acute ",
             "respiratory infection (ARI) are recruited, consented, and tested for the CARI programme.")#,
  ),
  
  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("parainfluenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Parainfluenza test positivity in the Community Acute Respiratory Infection (CARI) sentinel surveillance programme")),
                            tags$div(class = "headline",
                                     br(),
                                     # previous week total number
                                     valueBox(value = glue("{parainfluenza_cari_recent_week %>% .$SwabPositivityLastWeek}%"),
                                              subtitle = glue("Week ending {parainfluenza_cari_recent_week %>% .$DateLastWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{parainfluenza_cari_recent_week %>% .$SwabPositivityThisWeek}%"),
                                              subtitle = glue("Week ending {parainfluenza_cari_recent_week %>% .$DateThisWeek %>% format('%d %b %y')}"),
                                              color = "navy",
                                              icon = icon_no_warning_fn("calendar-week")),
                                     # percentage difference between the previous weeks
                                     valueBox(value = glue("{parainfluenza_cari_recent_week %>% .$Difference}%"),
                                              subtitle = glue("{parainfluenza_cari_recent_week %>%.$ChangeFactor %>%  str_to_sentence()} in the last week"),
                                              color = "navy",
                                              icon = icon_no_warning_fn({parainfluenza_cari_recent_week %>%  .$icon})),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline
  
  
  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Parainfluenza"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_cari_modal"),
                            swabposDefinitionUI("cari_parainfluenza_swabpos"),
                            ciDefinitionUI("cari_parainfluenza_ci"),
                            withNavySpinner(plotlyOutput("parainfluenza_cari_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_cari_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Parainfluenza by age group")),
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    br(),
                    pickerInput("parainfluenza_cari_selected_age", "Select age group(s) of interest:", 
                                choices = sort(unique(parainfluenza_cari_age$AgeGroup)),
                                selected = sort(unique(parainfluenza_cari_age$AgeGroup))[1],
                                multiple = TRUE),
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_cari_age_modal"),
                            swabposDefinitionUI("cari_parainfluenza_age_swabpos"),
                            withNavySpinner(plotlyOutput("parainfluenza_cari_age_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_cari_age_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Parainfluenza by NHS Health Board")),
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    br(),
                    pickerInput("parainfluenza_cari_selected_boards", "Select NHS Health Board(s) of interest:", 
                                choices = sort(unique(parainfluenza_cari_hb$HBName)),
                                selected = sort(unique(parainfluenza_cari_hb$HBName))[1],
                                multiple = TRUE),
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_cari_hb_modal"),
                            swabposDefinitionUI("cari_parainfluenza_hb_swabpos"),
                            withNavySpinner(plotlyOutput("parainfluenza_cari_hb_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_cari_hb_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("CARI - Test positivity for Parainfluenza by subtype")),
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    br(),
                    pickerInput("parainfluenza_cari_selected_subtype1", "Select subtype(s):", 
                                choices = sort(unique(parainfluenza_cari_subtype$Pathogen)),
                                selected = sort(unique(parainfluenza_cari_subtype$Pathogen))[1],
                                multiple = TRUE),
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_cari_subtype1_modal"),
                            swabposDefinitionUI("cari_parainfluenza_swabpos"),
                            withNavySpinner(plotlyOutput("parainfluenza_cari_subtype1_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_cari_subtype1_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("CARI - Number of positive samples by Parainfluenza subtype"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("parainfluenza_cari_subtype2_modal"),
                            withNavySpinner(plotlyOutput("parainfluenza_cari_subtype2_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("parainfluenza_cari_subtype2_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ) # fluidRow
  
)
