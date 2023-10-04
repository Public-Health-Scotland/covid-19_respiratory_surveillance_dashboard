tagList(
  fluidRow(width = 12,
           metadataButtonUI("hospital_occupancy"),
           linebreaks(1),
           #h1("Hospital occupancy (inpatients)"),
           #linebreaks(1)
           ),



  fluidRow(width = 12,
           tagList(h2("Number of inpatients with COVID-19 in hospital"),
                   tags$div(class = "headline",
                            h3(glue("Hospital occupancy (inpatients) on the Sunday of the latest three weeks available")),
                            valueBox(#value = glue("{occupancy_headlines[[1]]$HospitalOccupancy %>% format(big.mark=",")}*"),
                              value = {occupancy_headlines[[1]]$HospitalOccupancy %>% format(big.mark=",")},
                              subtitle = glue("As at {names(occupancy_headlines)[[1]]}"),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                            valueBox(#value = glue("{occupancy_headlines[[2]]$HospitalOccupancy %>% format(big.mark=",")}*"),
                              value = {occupancy_headlines[[2]]$HospitalOccupancy %>% format(big.mark=",")},
                              subtitle = glue("As at {names(occupancy_headlines)[[2]]}"),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                            valueBox(value = {occupancy_headlines[[3]]$HospitalOccupancy %>% format(big.mark=",")},
                                     subtitle = glue("As at {names(occupancy_headlines)[[3]]}"),
                                     color = "navy",
                                     icon = icon_no_warning_fn("calendar-week")),
                            h4("*Change to inpatient definition from 08 May 2023 (max number 10 days)"),
                            # This text is hidden by css but helps pad the box at the bottom
                            h6("hidden text for padding page"))),
           linebreaks(1)),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("hospital_occupancy_modal"),
                            withNavySpinner(plotlyOutput("hospital_occupancy_plot")),
                            fluidRow(
                              width=12, linebreaks(5))
                    ) # taglist
           ), # tabpanel

           tabPanel("Data",
                    tagList(h3("Number of inpatients with COVID-19 in hospital data"),
                            withNavySpinner(dataTableOutput("hospital_occupancy_table"))
                    ) # taglist
           ) # tabpanel
    ) #tabbox

  ), # fluid row

  fluidRow(
    br()),

) # taglist



