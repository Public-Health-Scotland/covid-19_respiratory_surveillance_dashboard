tagList(
  div(

    fluidRow(width = 12,
             linebreaks(1),
             metadataButtonUI("download"),
             h1("Download data"),
             linebreaks(1)),

    # Filters and toggles
    fluidRow(width=12,
             box(width=NULL,
                 tagList(
                   p(strong("Follow the steps below to generate the dataset to download.")),
                   radioButtons("download_indicator",
                                "1. Select indicator ",
                                choices = c("COVID-19 cases",
                                            "Acute COVID-19 hospital admissions",
                                            "COVID-19 hospital occupancy",
                                            "Respiratory infection activity"),
                                selected = "COVID-19 cases",
                                inline = TRUE),
                   pickerInput("download_dataset",
                               "2. Choose dataset    ",
                               choices = NULL,
                               selected = NULL,
                               inline = TRUE,
                               multiple = FALSE,
                               options = pickerOptions(
                                 showTick = TRUE)
                   ),
                   linebreaks(1),
                   radioButtons("download_filetype",
                               "3. Choose file type   ",
                               choices = c(".csv", ".xlsx"),
                               selected = ".csv",
                               inline = TRUE
                   )

                 )
             ) # box
    ), # fluidrow

    fluidRow(width=12,
             br()),

    # Data download area
    fluidRow(width=12,
             h3("Download data "),
             uiOutput("data_download_open_data_statement"),
             br(),
             downloadButton("data_download_output",
                            "Download data"),
             popify(bsButton("click",
                             label = "Statistical qualifiers",
                             icon = icon("circle-info"),
                             size = "default"),
                    title = "Statistical qualifiers",
                    content = paste(strong("b"), "break in time series<br>",
                                    strong("c"), "confidential<br>",
                                    strong("†"), "earliest revision<br>",
                                    strong("e"), "estimated<br>",
                                    strong("f"), "forecast<br>",
                                    strong("~"), "less than half the final digit shown and different from a real zero<br>",
                                    strong("u"), "low reliability<br>",
                                    strong("z"), "not applicable<br>",
                                    strong(":"), "not available<br>",
                                    strong("n"), "not significant<br>",
                                    strong("p"), "provisional<br>",
                                    strong("r"), "revised<br>",
                                    strong("*"), "significant at 0.05 level<br>",
                                    strong("**"), "significant at 0.01 level<br>",
                                    strong("***"),  "significant at 0.001 level<br>",
                                    strong("d"), "derived<br>",
                                    strong("x"), "archived or expired<br>",
                                    strong("y"), "incomplete<br>",
                                    "<br>",
                                    strong("Click again to close.")),
                    trigger = "click",
                    options = list(id = "qualifiers-popover", container = "body", html = "true")
             ),
             tabBox(width=NULL, type="pills", side="right",

                    tabPanel("Data summary",
                             tagList(

                               h3("Summary of data to download: "),
                               linebreaks(1),
                               withNavySpinner(dataTableOutput("data_download_summary_table"))


                             ) # taglist
                    ), # tabpanel
                    tabPanel("Data preview",
                             tagList(

                               h3("Preview of data to download (first 10 rows): "),
                               linebreaks(1),
                               withNavySpinner(dataTableOutput("data_download_table"))

                             ))

             ) # box

    ), # fluidrow

    fluidRow(width=12,
             br())

  ) # div
) # tagList

