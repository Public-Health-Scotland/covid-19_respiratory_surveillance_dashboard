# Recent weeks admissions

rsv_admissions_recent_week <- RSV_admissions %>%
  tail(3) %>%
  mutate(DateTwoWeek = .$Date[1],
         DateLastWeek = .$Date[2],
         DateThisWeek = .$Date[3],
         AdmissionsTwoWeek = .$Admissions[1],
         AdmissionsLastWeek = .$Admissions[2],
         AdmissionsThisWeek = .$Admissions[3]) %>%
  select(DateTwoWeek, DateLastWeek, DateThisWeek, AdmissionsTwoWeek, AdmissionsLastWeek, AdmissionsThisWeek) %>%
  head(1)

tagList(
  fluidRow(width = 12,

           metadataButtonUI("respiratory_rsv_admissions"),
           linebreaks(1),
           #h1("RSV Hospital Admissions"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
           tabPanel(stringr::str_to_sentence("influenza"),
                    # headline figures for the week in Scotland
                    tagList(h2(glue("Number of acute RSV admissions to hospital")),
                            tags$div(class = "headline",
                                     br(),
#                                     h3(glue("Total number of RSV hospital admissions in Scotland over the last two weeks")),
                                     # two weeks ago total number
                                     valueBox(value = {rsv_admissions_recent_week %>%
                                     .$AdmissionsTwoWeek %>% format(big.mark=",")},
                                     subtitle = glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateTwoWeek %>% format('%d %b %y')}"),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                                     # previous week total number
                                     valueBox(value = {rsv_admissions_recent_week %>%
                                         .$AdmissionsLastWeek %>% format(big.mark=",")},
                                         subtitle = glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateLastWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     # this week total number
                                     valueBox(value = glue("{rsv_admissions_recent_week %>%
                                         .$AdmissionsThisWeek %>% format(big.mark=",")}*"),
                                         subtitle = glue("Week ending {rsv_admissions_recent_week %>%
                                                .$DateThisWeek %>% format('%d %b %y')}"),
                                         color = "navy",
                                         icon = icon_no_warning_fn("calendar-week")),
                                     h4("* provisional figures",
                                     actionButton("glossary",
                                     label = "Go to glossary",
                                     icon = icon_no_warning_fn("paper-plane")
                                    )),
                                     # This text is hidden by css but helps pad the box at the bottom
                                     h6("hidden text for padding page")
                            )))), # headline

#  fluidRow(width = 12,
#           tagList(h2("Number of acute RSV admissions to hospital"))),

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
# 
fluidRow(width = 12,
         tagList(h2("Number of acute RSV admissions to hospital by NHS Health Board of Treatment; week ending")),
         linebreaks(1)), #fluidRow

fluidRow(width=12,
         box(width = NULL,
             withNavySpinner(dataTableOutput("rsv_admissions_hb_table"))),
         fluidRow(
           width=12, linebreaks(1))
),

)



