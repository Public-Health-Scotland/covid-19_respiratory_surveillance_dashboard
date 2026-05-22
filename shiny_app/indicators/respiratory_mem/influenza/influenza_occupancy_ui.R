influenza_occupancy_recent_week <- occupancy_rapid_new %>%
  filter(Pathogen == "Influenza (All)") %>%
  tail(3) %>%
  #select(-Rate_per_100000) %>%
  pivot_wider(names_from = Pathogen,
              values_from = SevenDayAverageInpatients) %>%
  mutate(DateTwoWeek = .$WeekEnding[1],
         DateLastWeek = .$WeekEnding[2],
         DateThisWeek = .$WeekEnding[3],
         OccupancyTwoWeek = .$`Influenza (All)`[1],
         OccupancyLastWeek = .$`Influenza (All)`[2],
         OccupancyThisWeek = .$`Influenza (All)`[3]) %>%
  select(DateTwoWeek, DateLastWeek, DateThisWeek, OccupancyTwoWeek, OccupancyLastWeek, OccupancyThisWeek) %>%
  head(1)


tagList(
  # fluidRow(width = 12,
  #          metadataButtonUI("hospital_occupancy"),
  #          linebreaks(1),
  #          #h1("Hospital occupancy (inpatients)"),
  #          #linebreaks(1)
  #          ),


#headline values are created in the setup script, occupancy updated to use the weekly HB values, filtered to Scotland
  fluidRow(width = 12,
           tagList(h2("Number of inpatients with influenza in hospital (seven day average) in Scotland"),
                   tags$div(class = "headline",
                            br(),
                            valueBox(value = {influenza_occupancy_recent_week %>%
                            .$OccupancyTwoWeek %>% format(big.mark=",")},
                            subtitle = glue("Week ending {influenza_occupancy_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}"),
                            color = "navy",
                            icon = icon_no_warning_fn("calendar-week")),
                            # previous week total number
                            valueBox(value = {influenza_occupancy_recent_week %>%
                            .$OccupancyLastWeek %>% format(big.mark=",")},
                            subtitle = glue("Week ending {influenza_occupancy_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                            color = "navy",
                            icon = icon_no_warning_fn("calendar-week")),
                            # this week total number
                            valueBox(value = glue("{influenza_occupancy_recent_week %>%
                                         .$OccupancyThisWeek %>% format(big.mark=",")}*"),
                            subtitle = glue("Week ending {influenza_occupancy_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                            color = "navy",
                            icon = icon_no_warning_fn("calendar-week")),
                            h4("*Snapshot as at a Sunday"),
                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page")),

),

           linebreaks(1)),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("influenza_occupancy_modal"),
                            withNavySpinner(plotlyOutput("influenza_occupancy_plot"))#,
                            # fluidRow(
                            #   width=12, linebreaks(4))
                    ) # taglist
           ), # tabpanel

           tabPanel("Data",
                    tagList(h3("Number of inpatients with influenza in hospital data"),
                            withNavySpinner(dataTableOutput("influenza_occupancy_table"))
                    ) # taglist
           ) # tabpanel
    ) #tabbox

  ), # fluid row

fluidRow(width = 12,
         tagList(h2("Number of inpatients with influenza in hospital by NHS Health Board of treatment")),
         linebreaks(1)),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  br(),
                  pickerInput(
                    inputId = "influenza_occupancy_selected_seasons", 
                    label = "Select season", 
                    choices = tail(sort(unique(occupancy_rapid_hb_new$Season)), 3),
                    selected = tail(sort(unique(occupancy_rapid_hb_new$Season)), 1)  # current season
                  ),
                  tagList(linebreaks(1),
                          altTextUI("influenza_occupancy_hb_modal"),
                          withNavySpinner(plotlyOutput("influenza_occupancy_hb_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("influenza_occupancy_hb_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)
), 

  # tagList(h2("Seven day average of inpatients with COVID-19 in hospital by NHS Health Board of treatment; week ending")),
  # 
  # 
  # fluidRow(width=12,
  #          box(width = NULL,
  #              withNavySpinner(dataTableOutput("hospital_occupancy_hb_table"))),
  # ),

  fluidRow(
    br()),

) # taglist



