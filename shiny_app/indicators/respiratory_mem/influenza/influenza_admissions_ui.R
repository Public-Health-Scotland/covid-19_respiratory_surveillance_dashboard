# Recent weeks admissions

influenza_admissions_recent_week <- Influenza_admissions %>%
  filter(FluType == "Influenza A & B") %>%
  tail(3) %>%
  #select(-Rate_per_100000) %>%
  pivot_wider(names_from = FluType,
              values_from = Admissions) %>%
  mutate(DateTwoWeek = .$Date[1],
         DateLastWeek = .$Date[2],
         DateThisWeek = .$Date[3],
         AdmissionsTwoWeek = .$`Influenza A & B`[1],
         AdmissionsLastWeek = .$`Influenza A & B`[2],
         AdmissionsThisWeek = .$`Influenza A & B`[3]) %>%
  select(DateTwoWeek, DateLastWeek, DateThisWeek, AdmissionsTwoWeek, AdmissionsLastWeek, AdmissionsThisWeek) %>%
  head(1)

tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_influenza_admissions"),
           linebreaks(1),
           #h1("Influenza Hospital Admissions"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Number of acute influenza admissions to hospital in Scotland")),
                            tags$div(class = "headline",
                                     br(),
#                                     h3(glue("Total number of influenza hospital admissions in Scotland over the last two weeks")),
                                     # Two week ago total number
                                     valueBox(value = {influenza_admissions_recent_week %>%
                                     .$AdmissionsTwoWeek %>% format(big.mark=",")},
                                     subtitle = glue("Week ending {influenza_admissions_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}"),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {influenza_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {influenza_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{influenza_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")}*"),
                                         subtitle = glue("Week ending {influenza_admissions_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     h4("* provisional figures",
                                        actionButton("glossary",
                                        label = "Go to glossary",
                                        icon = icon_no_warning_fn("paper-plane")
                                    )),
p("Between 22 May and October 2025, Public Health Scotland (PHS) will be",
  "reporting Scotland level admissions for COVID-19,",
  "Influenza and RSV, due to low levels of hospital admissions."),

                                                                      # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline

#  fluidRow(width = 12,
#           tagList(h2("Number of acute influenza admissions to hospital"))),

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
      ), # fluidRow

tagList(h2("Rate of acute influenza hospital admissions by age group")),

#),
br(),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  tagList(linebreaks(1),
                          altTextUI("influenza_admissions_age_modal"),
                          withNavySpinner(plotlyOutput("influenza_admissions_age_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("influenza_admissions_age_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)
), # fluidRow
# fluidRow(width = 12,
#          tagList(h2("Number of acute influenza admissions to hospital by NHS Health Board of Treatment; week ending")),
#          linebreaks(1)), #fluidRow
# 
# fluidRow(width=12,
#          box(width = NULL,
#              withNavySpinner(dataTableOutput("flu_admissions_hb_table"))),
#          fluidRow(
#            width=12, linebreaks(1))
# ),

# pyramid sections 
# 
# fluidRow(  
# 
#   tagList(uiOutput("flu_adm_pyr_title"),
#           #tagList(h2(glue("Acute influenza admissions by age and sex in Scotland")),
#           tabBox(width = NULL,
#                  type = "pills",
#                  tabPanel("Plot",
#                           tagList(
#                             linebreaks(1),
#                             fluidRow( column(4, pickerInput("flu_age_sex_adm_season",
#                                                             label = "Select a season",
#                                                             choices = {Admissions_AgeSex_Season %>% 
#                                                                 filter(Pathogen == "flu") %>%
#                                                                 .$Season %>% unique()},
#                                                             selected = "2024-2025")
#                               )
#                             ),
#                             altTextUI("flu_adm_age_sex"),
#                             withNavySpinner(plotlyOutput("flu_adm_age_sex_pyramid_plot"))
#                             ) # tagList
#                  ), # tabPanel
#                  tabPanel("Data",
#                           withNavySpinner(dataTableOutput("flu_adm_age_sex_pyramid_table")))
#           ) # tabbox
#   ), # tagList
#   linebreaks(1),
# ),

##### LOS section
 tagList(h2("Length of stay of acute influenza hospital admissions by age group"),
         br(),
         tabBox( width = NULL, type = "pills",
                 tabPanel("Plot",
                          #tagList(uiOutput("flu_los_title")),
                          tagList(h5("Use the drop-down menu to select a season.")),
                          pickerInput(inputId = "los_season_flu",
                                      label = "Select season",
                                      choices = {Median_LOS_by_Age  %>%
                                          .$Season %>% unique() },
                                      selected = {Median_LOS_by_Age  %>%
                                          .$Season %>% unique() %>% tail(1)}),
                          # selectInput(inputId = "los_flu_age", 
                          #             label = "Select age group(s) of interest:", 
                          #             choices = unique(Median_LOS_by_Age$los_age_band),
                          #             selected = sort(unique(Median_LOS_by_Age$los_age_band), decreasing = TRUE)[1],
                          #             multiple = TRUE),
                          altTextUI("flu_los_modal"),
                          withNavySpinner( plotlyOutput("flu_los_plot"))
                 ),#tabPanel,
                 tabPanel("Data",
                          tagList(linebreaks(1),
                                  withNavySpinner(dataTableOutput("flu_los_table")) )
                 ) # tabPanel
                 ),#tabbox
                 ### end LOS section
#                  h3(glue("Median length of stay of acute influenza hospital admissions for 4 week period {los_date_start %>% format('%d %b %y')} to {los_date_end%>% format('%d %b %y')} ")),
#                  valueBox(value = glue("{Length_of_Stay_Median %>% 
#                                        filter(AgeGroup == 'All Ages') %>% 
#                                        filter(Pathogen =='flu') %>%
#                                        .$MedianLengthOfStay %>% round_half_up(1)} days"),
#                           subtitle = glue("All ages"),
#                           color = "navy",
#                           icon = icon_no_warning_fn("clock")),# valuebox
#                  valueBox(value = glue("{flu_los_median_min$MedianLengthOfStay %>%
#                                        round_half_up(1)} days"),
#                           subtitle = glue("Shortest median stay ({flu_los_median_min$AgeGroup})"),
#                           color = "navy",
#                           icon = icon_no_warning_fn("clock")),# value box
#                  valueBox(value = glue("{flu_los_median_max$MedianLengthOfStay %>%
#                                        round_half_up(1)} days"),
#                           subtitle = glue("Longest median stay ({flu_los_median_max$AgeGroup})"),
#                           color = "navy",
#                           icon = icon_no_warning_fn("clock")),
#                  # This text is hidden by css but helps pad the box at the bottom
#                  h6("hidden text for padding page"))
# ),
# br(),
# 
# tabBox(width = NULL, type = "pills",
#        tabPanel("Plot",
#                 tagList(uiOutput("flu_los_title")),
#                 tagList(h5("Use the drop-down menu to select a season."),
#                         pickerInput(inputId = "los_season_flu",
#                                     label = "Select season",
#                                     choices = admission_seasons,
#                                     selected = "2024/2025"),
#                         altTextUI("flu_los_modal"),
#                         withNavySpinner(plotlyOutput("flu_los_plot") ),
#                         )),
#        tabPanel("Data",
#                 tagList(linebreaks(1),
#                         withNavySpinner(dataTableOutput("flu_los_table")) )
#                 
#        ) # tabPanel
#       ),#tabbox
### end LOS section

# Padding out the bottom of the page
fluidRow(height="200px", width=12, linebreaks(5))

)#taglist
)


