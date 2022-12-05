
tagList(

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
               subtitle = "Percentage",
               color = "teal",
               icon = icon_no_warning_fn("percent"))),

  fluidRow(height = "50px", br()),

  tabBox(width = NULL, type = "pills",
         tabPanel("Plot",
                  tagList(h3("COVID-19 vaccine wastage"),
                          plotlyOutput("vaccine_wastage_plot"))),
         tabPanel("Data",
                  tagList(h3("COVID-19 vaccine wastage data"),
                          dataTableOutput("vaccine_wastage_table")))),

  fluidRow(column(width = 6,
                  plotlyOutput("vaccine_wastage_reason_plot")),
           column(width = 6,
                  dataTableOutput("vaccine_wastage_reason_table")))



)



