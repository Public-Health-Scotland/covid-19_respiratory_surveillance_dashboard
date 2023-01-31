
tagList(
  fluidRow(width = 12,
           metadataButtonUI("vaccines"),
           h1("COVID-19 vaccine wastage"),
           linebreaks(2)),

  tags$div(class = "headline",
           h3(glue("Figures from {Vaccine_Wastage %>% tail(1) %>%
                .$Month %>% convert_opendata_date() %>% convert_date_to_month()}")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$NumberOfDosesAdministered %>%
               format(big.mark = ",")},
               subtitle = "Doses administered",
               color = "teal",
               icon = icon_no_warning_fn("syringe")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$NumberOfDosesWasted %>%
               format(big.mark = ",")},
               subtitle = "Doses wasted",
               color = "teal",
               icon = icon_no_warning_fn("dumpster")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$PercentageWasted %>%
               paste0("%")},
               subtitle = "Percent wasted",
               color = "teal",
               icon = icon_no_warning_fn("percent")),
           # This text is hidden by css but helps pad the box at the bottom
           h6("hidden text for padding page")
           ),

  fluidRow(height = "50px", br()),

  tabBox(width = NULL,
         type = "pills",
         tabPanel("Plot",
                  tagList(h3("COVID-19 vaccine wastage"),
                          linebreaks(1),
                          altTextUI("vaccine_wastage_modal"),
                          withNavySpinner(plotlyOutput("vaccine_wastage_plot")))),
         tabPanel("Data",
                  tagList(h3("COVID-19 vaccine wastage data"),
                          withNavySpinner(dataTableOutput("vaccine_wastage_table"))))),

  #fluidRow(height = "25px", linebreaks(1)),

  fluidRow(box(width = NULL,
           tagList(
           h3("Reasons for wastage"),
          # linebreaks(1),
           altTextUI("vaccine_wastage_reason_modal"),
           column(width = 6,
                  withNavySpinner(plotlyOutput("vaccine_wastage_reason_plot"))),
           column(width = 6,
                  withNavySpinner(dataTableOutput("vaccine_wastage_reason_table"))),
           linebreaks(13))))




)#taglist



