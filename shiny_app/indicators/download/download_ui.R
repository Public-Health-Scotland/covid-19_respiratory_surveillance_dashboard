tagList(
  div(

    fluidRow(width=12, height="50px", br()),

    # Filters and toggles
    fluidRow(width=12,
             box(width=NULL, height="400px",
                 tagList(
                   p(strong("Follow the steps below to generate the dataset to download.")),
                   radioButtons("download_indicator",
                                "1. Select indicator ",
                                choices = c("COVID-19 cases",
                                            "COVID-19 hospital admissions",
                                            "COVID-19 hospital occupancy",
                                            "Vaccine wastage"),
                                selected = "COVID-19 cases",
                                inline = TRUE),
                   pickerInput("download_dataset",
                               "2. Choose dataset    ",
                               choices = NULL,
                               selected = NULL,
                               inline = TRUE,
                               multiple = FALSE,
                               width = "100%",
                               options = pickerOptions(
                                 showTick = TRUE)
                   ),
                   pickerInput("download_filetype",
                               "3. Choose file type   ",
                               choices = c(".csv", ".xlsx"),
                               selected = ".csv",
                               inline = TRUE,
                               multiple = FALSE,
                               width = "100%",
                               options = pickerOptions(
                                 showTick = TRUE)
                   )

                 )
             ) # box
    ), # fluidrow

    fluidRow(width=12, height="100px", br()),

    # Data download area
    fluidRow(width=12,
             h3("Download data "),
             downloadButton("data_download_output",
                            "Download data"),
             tabBox(width=NULL, type="pills", side="right", height="800px",

                    tabPanel("Data summary",
                             tagList(

                               h3("Summary of data to download: "),
                               linebreaks(1),
                               verbatimTextOutput("data_download_summary")


                             ) # taglist
                    ), # tabpanel
                    tabPanel("Data preview",
                             tagList(

                               h3("Preview of data to download (first 10 rows): "),
                               linebreaks(1),
                               dataTableOutput("data_download_table")

                             ))

             ) # box

    ), # fluidrow

    fluidRow(width=12, height="50px", br())

  ) # div
) # tagList

