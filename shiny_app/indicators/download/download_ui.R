tagList(
  div(

    fluidRow(width = 12,
             metadataButtonUI("download"),
             h1("Download data"),
             linebreaks(2)),


    # Filters and toggles
    fluidRow(width=12,
             box(width=NULL,
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
             downloadButton("data_download_output",
                            "Download data"),
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

