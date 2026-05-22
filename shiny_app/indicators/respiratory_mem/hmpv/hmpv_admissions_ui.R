# Recent weeks admissions

hmpv_admissions_recent_week <- admissions_scotland %>%
  filter(Pathogen=="HMPV") %>% 
  tail(3) %>%
  make_admissions_value_boxes()


tagList(
  # fluidRow(width = 12,
  # 
  #          metadataButtonUI("respiratory_hmpv_admissions"),
  #          linebreaks(1),
  #          #h1("Influenza Hospital Admissions"),
  #          #linebreaks(1)
  #          ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("HMPV"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Number of acute HMPV admissions to hospital in Scotland")),
                            tags$div(class = "headline",
                                     br(),
#                                     h3(glue("Total number of influenza hospital admissions in Scotland over the last two weeks")),
                                     # Two week ago total number
                                     valueBox(value = {hmpv_admissions_recent_week %>%
                                     .$AdmissionsTwoWeek %>% format(big.mark=",")},
                                     subtitle = tagList(tags$strong(glue("({format(round_half_up(hmpv_admissions_recent_week %>% .$RateTwoWeek,1), nsmall = 1)} per 100,000)")),
                                                        tags$br(),
                                                        glue("Week ending {hmpv_admissions_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}")),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {hmpv_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle = tagList(tags$strong(glue("({format(round_half_up(hmpv_admissions_recent_week %>% .$RateLastWeek,1), nsmall = 1)} per 100,000)")),
                                                            tags$br(),
                                                            glue("Week ending {hmpv_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}")),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{hmpv_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")}*"),
                                              subtitle = tagList(tags$strong(glue("({format(round_half_up(hmpv_admissions_recent_week %>% .$RateThisWeek,1), nsmall = 1)} per 100,000)")),
                                                                 tags$br(),
                                                                 glue("Week ending {hmpv_admissions_recent_week %>%
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
                                     h6("hidden text for padding page")
                            )))), # headline
  fluidRow(width = 12,
         tagList(h2("Rate of acute HMPV hospital admissions per 100,000 population in Scotland"))),

  # fluidRow(width = 12,
  #          tagList(h2("Number of acute adenovirus admissions to hospital"))),

   fluidRow(
     tabBox(width = NULL,
            type = "pills",
            tabPanel("Plot",
                     tagList(linebreaks(1),
                             altTextUI("hmpv_admissions_modal"),
                             withNavySpinner(plotlyOutput("hmpv_admissions_plot")),
                     ),
                     fluidRow(column(
                       width=12, linebreaks(1),
                       p("*Hospital admissions for the most recent week may be incomplete,",
                         "and should be treated as provisional and interpreted with caution."),
                     ))),
            tabPanel("Data",
                     tagList(linebreaks(1),
                             withNavySpinner(dataTableOutput("hmpv_admissions_table"))
                     ) # tagList
            ) # tabPanel

     ), # tabBox
     linebreaks(1)
       ), # fluidRow

  fluidRow(width=12, tagList(h2("Rate of acute HMPV hospital admissions per 100,000 population by age group"))),

#),
#br(),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  br(),
                  pickerInput(inputId = "adm_season_hmpv_age",
                              label = "Select season",
                              choices = {admissions_seasons %>%  tail(6) },
                              selected = {admissions_seasons %>% tail(1)}),
                  tagList(linebreaks(1),
                          altTextUI("hmpv_admissions_age_modal"),
                          withNavySpinner(plotlyOutput("hmpv_admissions_age_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("hmpv_admissions_age_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)
), # fluidRow

# Padding out the bottom of the page
fluidRow(height="200px", width=12, linebreaks(5))

)#taglist


