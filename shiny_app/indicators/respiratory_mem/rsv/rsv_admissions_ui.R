## Format RSV admissions data from age_rate_data_all_path - should no longer need RSV_admissions.csv from Output folder

# rsv_admissions <- age_rate_data_all_path %>% 
#   filter(age_band == "All Ages") %>% 
#   add_season() %>% 
#   select(week_ending, rsv, rsv_rate, Season) %>% 
#   rename(Date = week_ending,
#          Admissions = rsv,
#          RatePer100000 = rsv_rate) %>% 
#   mutate(Year = year(Date),
#          ISOWeek = isoweek(Date)) %>% 
#   mutate(Season = paste0(substr(Season, 1, 4), "/", substr(Season, 6, 9)),
#          Weekord = case_when(ISOWeek >= 40 ~ ISOWeek - 39,
#                              ISOWeek < 40 ~ ISOWeek + 13)) 

rsv_admissions <- admissions_scotland %>% 
  filter(Pathogen == "RSV") %>% 
  mutate(ISOweek = as.numeric(ISOweek)) %>% 
  mutate(Weekord = case_when(ISOweek >= 40 ~ ISOweek - 39,
                             ISOweek < 40 ~ ISOweek + 13)) %>% 
  rename(Date = WeekEnding,
         Admissions = NumberAdmissionsPerWeek,
         RatePer100000 = RateAdmissionsPerWeek,
         Year = ISOyear,
         ISOWeek = ISOweek)
# Get recent seasons
rsv_adm_seasons <- tail(sort(unique(rsv_admissions$Season)), 6)

# Recent weeks admissions

rsv_admissions_recent_week <- admissions_scotland %>%
  filter(Pathogen=="RSV") %>% 
  tail(3) %>%
  make_admissions_value_boxes()

tagList(
  # fluidRow(width = 12,
  # 
  #          metadataButtonUI("respiratory_rsv_admissions"),
  #          linebreaks(1),
  #          #h1("RSV Hospital Admissions"),
  #          #linebreaks(1)
  #          ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Number of acute RSV admissions to hospital in Scotland")),
                            tags$div(class = "headline",
                                     br(),
#                                     h3(glue("Total number of RSV hospital admissions in Scotland over the last two weeks")),
                                     # two weeks ago total number
                                     valueBox(value ={rsv_admissions_recent_week %>%
                                     .$AdmissionsTwoWeek %>% format(big.mark=",")},
                                     subtitle =  tagList(tags$strong(glue("({format(round(rsv_admissions_recent_week %>% .$RateTwoWeek,1), nsmall = 1)} per 100,000)")),
                                     tags$br(),
                                     glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}")),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {rsv_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle =tagList(tags$strong(glue("({format(round(rsv_admissions_recent_week %>% .$RateLastWeek,1), nsmall = 1)} per 100,000)")),
                                         tags$br(),
                                         glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}")),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{rsv_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")}*"),
                                         subtitle = tagList(tags$strong(glue("({format(round(rsv_admissions_recent_week %>% .$RateThisWeek,1), nsmall = 1)} per 100,000)")),
                                       tags$br(),
                                         glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}")),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     h4("* provisional figures",
                                     actionButton("glossary",
                                     label = "Go to glossary",
                                     icon = icon_no_warning_fn("paper-plane")
                                    )),
# p("Between 22 May and October 2025, Public Health Scotland (PHS) will be",
#   "reporting Scotland level admissions for COVID-19,",
#   "Influenza and RSV, due to low levels of hospital admissions."),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page"),

                           )))), # headline

#  fluidRow(width = 12,
#           tagList(h2("Number of acute RSV admissions to hospital"))),
    fluidRow(width = 12, tagList(h2("Rate of acute RSV hospital admissions per 100,000 population in Scotland"))),

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
  ), # fluidRow


fluidRow(width = 12, tagList(h2("Rate of acute RSV hospital admissions per 100,000 population by age group"))),

#),
#br(),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  br(),
                  pickerInput(inputId = "adm_season_rsv_age",
                              label = "Select season",
                              choices = {admissions_seasons %>%  tail(6) },
                              selected = {admissions_seasons %>% tail(1)}),
                  tagList(linebreaks(1),
                          altTextUI("rsv_admissions_age_modal"),
                          withNavySpinner(plotlyOutput("rsv_admissions_age_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("rsv_admissions_age_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)
),

fluidRow(width = 12,
         tagList(h2("Rate of RSV admissions per 100,000 population by NHS Health Board of treatment"))),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  br(),
                  pickerInput(
                    inputId = "rsv_adms_selected_seasons", 
                    label = "Select season", 
                    choices = tail(sort(unique(admissions_hb_new$Season)), 6),
                    selected = tail(sort(unique(admissions_hb_new$Season)), 1)  # current season
                  ),
                  
                  tagList(linebreaks(1),
                          altTextUI("rsv_admissions_hb_modal"),
                          withNavySpinner(plotlyOutput("rsv_admissions_hb_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("rsv_admissions_hb_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)

# fluidRow
), # fluidRow

tagList(h2("Rate of acute RSV hospital admissions per 100,000 population by deprivation category (SIMD)")),

#br(),

tabBox(width = NULL, type = "pills",
       tabPanel("Plot",
                br(),
                pickerInput(inputId = "adm_season_rsv_simd",
                            label = "Select season",
                            choices = {admissions_seasons %>%  tail(6) },
                            selected = {admissions_seasons %>% tail(1)}),
                tagList(
                  linebreaks(1),
                  altTextUI("rsv_admissions_simd_modal"),
                  actionButton("btn_modal_simd",
                               label = "What is SIMD?",
                               class = "simd-btn",
                               icon = icon_no_warning_fn("circle-question")
                  ),
                  withNavySpinner(
                    plotlyOutput("rsv_admissions_simd_plot"))
                )
       ),
       tabPanel("Data",
                tagList(
                  withNavySpinner(
                    dataTableOutput("rsv_admissions_simd_table"))
                )
       )
       
),
# 
# fluidRow(width = 12,
#          tagList(h2("Number of acute RSV admissions to hospital by NHS Health Board of Treatment; week ending")),
#          linebreaks(1)), #fluidRow
# 
# fluidRow(width=12,
#          box(width = NULL,
#              withNavySpinner(dataTableOutput("rsv_admissions_hb_table"))),
#          fluidRow(
#            width=12, linebreaks(1))
# ),
# pyramid sections 
# fluidRow(  
#   
#   tagList(uiOutput("rsv_adm_pyr_title"),
#           tabBox(width = NULL,
#                  type = "pills",
#                  tabPanel("Plot",
#                           tagList(
#                             linebreaks(1),
#                             fluidRow( column(4, pickerInput("rsv_age_sex_adm_season",
#                                                             label = "Select a season",
#                                                             choices = {Admissions_AgeSex_Season %>% 
#                                                                 filter(Pathogen == "rsv") %>%
#                                                                 .$Season %>% unique()},
#                                                             selected = "2024-2025")
#                             )
#                             ),
#                             altTextUI("rsv_adm_age_sex"),
#                             withNavySpinner(plotlyOutput("rsv_adm_age_sex_pyramid_plot"))
#                           ) # tagList
#                  ), # tabPanel
#                  tabPanel("Data",
#                           withNavySpinner(dataTableOutput("rsv_adm_age_sex_pyramid_table")))
#           ) # tabbox
#   ), # tagList
#   linebreaks(1)
# ),

##### LOS section
tagList(h2("Average length of stay of acute RSV hospital admissions"),
        tabBox( width = NULL, type = "pills",
                tabPanel("Plot",
                         #tagList(uiOutput("rsv_los_title")),
                         tagList(h5("Use the drop-down menu to select a season."),
                                 pickerInput(inputId = "los_season_rsv",
                                             label = "Select season",
                                             choices = admission_seasons,
                                             selected = tail(admission_seasons, 1)),
                                 altTextUI("rsv_los_modal"),
                                 withNavySpinner( plotlyOutput("rsv_los_plot")),
                                 #linebreaks(1)
                         ),
                         fluidRow(column(
                           width=12, linebreaks(1),
                           textOutput("rsv_los_text")
                         ))), #taglist
                tabPanel("Data",
                         tagList(linebreaks(1),
                                 withNavySpinner(dataTableOutput("rsv_los_table")) )
                ) # tabPanel
        )#tabbox
        ###
        ### end LOS section

# Padding out the bottom of the page
#fluidRow(height="200px", width=12, linebreaks(5))
),

# Padding out the bottom of the page
fluidRow(height="200px", width=12, linebreaks(5))

)#taglist


