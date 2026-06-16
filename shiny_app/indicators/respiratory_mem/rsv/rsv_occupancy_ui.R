rsv_occupancy_recent_week <- occupancy_rapid_new %>%
  filter(Pathogen == "RSV") %>%
  tail(3) %>%
  pivot_wider(names_from = Pathogen,
              values_from = SevenDayAverageInpatients) %>%
  mutate(DateTwoWeek = .$WeekEnding[1],
         DateLastWeek = .$WeekEnding[2],
         DateThisWeek = .$WeekEnding[3],
         OccupancyTwoWeek = .$`RSV`[1],
         OccupancyLastWeek = .$`RSV`[2],
         OccupancyThisWeek = .$`RSV`[3]) %>%
  select(DateTwoWeek, DateLastWeek, DateThisWeek, OccupancyTwoWeek, OccupancyLastWeek, OccupancyThisWeek) %>%
  head(1)


tagList(
#headline values are created in the setup script, occupancy updated to use the weekly HB values, filtered to Scotland
  fluidRow(width = 12,
           tagList(h2("Number of inpatients with RSV in hospital (seven day average) in Scotland"),
                   tags$div(class = "headline",
                            br(),
                            valueBox(value = {rsv_occupancy_recent_week %>%
                            .$OccupancyTwoWeek %>% format(big.mark=",")},
                            subtitle = glue("Week ending {rsv_occupancy_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}"),
                            color = "navy",
                            icon = icon_no_warning_fn("calendar-week")),
                            # previous week total number
                            valueBox(value = {rsv_occupancy_recent_week %>%
                            .$OccupancyLastWeek %>% format(big.mark=",")},
                            subtitle = glue("Week ending {rsv_occupancy_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                            color = "navy",
                            icon = icon_no_warning_fn("calendar-week")),
                            # this week total number
                            valueBox(value = glue("{rsv_occupancy_recent_week %>%
                                         .$OccupancyThisWeek %>% format(big.mark=",")}*"),
                            subtitle = glue("Week ending {rsv_occupancy_recent_week %>%
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
                            altTextUI("rsv_occupancy_modal"),
                            withNavySpinner(plotlyOutput("rsv_occupancy_plot"))#,
                    ) # taglist
           ), # tabpanel

           tabPanel("Data",
                    tagList(h3("Number of inpatients with RSV in hospital data"),
                            withNavySpinner(dataTableOutput("rsv_occupancy_table"))
                    ) # taglist
           ) # tabpanel
    ) #tabbox

  ), # fluid row

fluidRow(width = 12,
         tagList(h2("Number of patients with RSV in hospital by NHS Health Board of treatment")),
         linebreaks(1)),

fluidRow(
  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  br(),
                  pickerInput(
                    inputId = "rsv_occupancy_selected_seasons", 
                    label = "Select season", 
                    choices = tail(sort(unique(occupancy_rapid_hb_new$Season)), 3),
                    selected = tail(sort(unique(occupancy_rapid_hb_new$Season)), 1)  # current season
                  ),
                  tagList(linebreaks(1),
                          altTextUI("rsv_occupancy_hb_modal"),
                          withNavySpinner(plotlyOutput("rsv_occupancy_hb_plot")),
                  )),
         tabPanel("Data",
                  tagList(linebreaks(1),
                          withNavySpinner(dataTableOutput("rsv_occupancy_hb_table"))
                  ) # tagList
         ) # tabPanel
         
  ), # tabBox
  linebreaks(1)
), 
) # taglist



