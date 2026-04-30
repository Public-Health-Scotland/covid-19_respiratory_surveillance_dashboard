tagList(
  fluidRow(width = 12,
           
           #metadataButtonUI("nhs24_mem"),
           # linebreaks(1),
           h1("NHS24 Calls for Respiratory Symptoms"),
           p("NHS24 is a telephone service operated by NHS Scotland to triage patients with an urgent,",
             "but not life-threatening, need for medical attention. Trends in calls to NHS24, for",
             "respiratory symptoms, are compared against historic data to assess activity levels of acute",
             "respiratory illness in the community. As NHS24 is often patients first contact with the NHS,",
             "increases in activity will be reported here before they are detected by other surveillance",
             "systems, thus it can act as an early warning system for acute respiratory infections."),
           #             "More information on NHS24 can be found…"),
           #linebreaks(1)
           # p(strong("Note: Data for ISO week 48 are temporarily unavailable due to technical issues. Data presented",
           #          "here is therefore up to ISO week 47 only. Reporting will resume once these issues are resolved."))
  ),
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current plot"))),

  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel

    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current plot - bolder current season"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot2")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current report style"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_report")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current colours and report linetypes"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed1")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current colours and two variations of dashed linetypes (1)"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed2")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Current colours and two variations of dashed linetypes (2)"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed3")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Alternative plot 1 - alternative colours, bolder current season"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_alt1")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Alternative plot 2 - above plot with different linetypes"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_alt2")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  
  fluidRow(width = 12,
           tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
           tagList(h3("Alternative plot 3 - three colours, solid/dotted lines"))),
  
  fluidRow(
    tabBox(width = NULL,
           type = "pills",
           tabPanel("Plot",
                    tagList(linebreaks(1),
                            altTextUI("nhs24_mem_modal"),
                            withNavySpinner(plotlyOutput("nhs24_mem_plot_alt3")),
                    )),
           tabPanel("Data",
                    tagList(linebreaks(1),
                            withNavySpinner(dataTableOutput("nhs24_mem_table"))
                    ) # tagList
           ) # tabPanel
           
    ), # tabBox
    linebreaks(1)
  ), # fluidRow
  
  
  
  
  
  
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("Alternative plot 2 - above with different linetypes (1)"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_alt2")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  # 
  # 
  # 
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("Alternative plot 3  - above with different linetypes (2)"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_alt3")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("Current plot - new colours"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_new")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  # 
  # 
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("New colours and report linetypes"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed1_new")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  # 
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("New colours and two variations of dashed linetypes (1)"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed2_new")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  # 
  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) in Scotland")),
  #          tagList(h3("New colours and two variations of dashed linetypes (2)"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_plot_mixed3_new")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #          
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow
  
  
  

  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) by NHS Health Board"))),
  #
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_hb_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_hb_plot")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_hb_table"))
  #                   ) # tagList
  #          ) # tabPanel
  #
  #   ), # tabBox
  #   linebreaks(1)
  # ), # fluidRow


  # fluidRow(width = 12,
  #          tagList(h2("NHS24 calls for respiratory symptoms (%) by age group"))),
  # 
  # fluidRow(
  #   tabBox(width = NULL,
  #          type = "pills",
  #          tabPanel("Plot",
  #                   tagList(linebreaks(1),
  #                           altTextUI("nhs24_mem_age_modal"),
  #                           withNavySpinner(plotlyOutput("nhs24_mem_age_plot")),
  #                   )),
  #          tabPanel("Data",
  #                   tagList(linebreaks(1),
  #                           withNavySpinner(dataTableOutput("nhs24_mem_age_table"))
  #                   ) # tagList
  #          ) # tabPanel
  # 
  #   ), # tabBox
  #   linebreaks(1)
  # )#, # fluidRow

)



