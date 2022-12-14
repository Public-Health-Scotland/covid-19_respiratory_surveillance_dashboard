
tagList(
  fluidRow(width = 12,
           h1("COVID-19 vaccine wastage"),
           linebreaks(2)),

  tags$div(class = "headline",
           h3(glue("Figures from {Vaccine_Wastage %>% tail(1) %>%
                .$Month %>% convert_opendata_date() %>% convert_date_to_month()}")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$NumberOfDosesAdministered %>%
               format(big.mark = ",")},
               subtitle = "Doses administered",
               color = "blue",
               icon = icon_no_warning_fn("syringe")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$NumberOfDosesWasted %>%
               format(big.mark = ",")},
               subtitle = "Doses wasted",
               color = "blue",
               icon = icon_no_warning_fn("dumpster")),
           valueBox(value = {Vaccine_Wastage %>% tail(1) %>%
               .$PercentageWasted %>%
               paste0("%")},
               subtitle = "Percent wasted",
               color = "blue",
               icon = icon_no_warning_fn("percent")),
           # These linebreaks are here to make the banner big enough to
           # include all the valueBoxes
           linebreaks(6)
           ),

  fluidRow(height = "50px", br()),

  tabBox(width = NULL,
         #height = 610,
         type = "pills",
         tabPanel("Plot",
                  tagList(h3("COVID-19 vaccine wastage"),
                          withSpinner(plotlyOutput("vaccine_wastage_plot")))),
         tabPanel("Data",
                  tagList(h3("COVID-19 vaccine wastage data"),
                          withSpinner(dataTableOutput("vaccine_wastage_table"))))),

  #fluidRow(height = "25px", linebreaks(1)),

  fluidRow(box(width = NULL,
           tagList(
           h3("Reasons for wastage"),
           column(width = 6,
                  withSpinner(plotlyOutput("vaccine_wastage_reason_plot"))),
           column(width = 6,
                  withSpinner(dataTableOutput("vaccine_wastage_reason_table"))),
           linebreaks(13))))




)#taglist



