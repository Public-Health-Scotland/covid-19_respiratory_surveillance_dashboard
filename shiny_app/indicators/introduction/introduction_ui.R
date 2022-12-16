sidebarLayout(
  sidebarPanel(width = 4,
               radioGroupButtons("home_select", status = "home",
                                 choices = home_list,
                                 direction = "vertical", justified = T)),

  mainPanel(width = 8,
            # About
            conditionalPanel(
              condition= 'input.home_select == "about"',
                tagList(h3(tags$b("COVID-19 in Scotland")),
                        p("text here"),
                       tags$div(class = "special_button",
                                actionButton("jump_to_summary", "Summary"),
                                                actionButton("jump_to_cases", "Cases"),
                                                actionButton("jump_to_hospital_admissions", "Hospital admissions"),
                                                actionButton("jump_to_hospital_occupancy", "Hospital occupancy"),
                                                actionButton("jump_to_vaccines", "Vaccine wastage"),
                                               actionButton("jump_to_metadata", "Metadata"),
                                               actionButton("jump_to_download", "Download data")

                       )#div
                )# tagList
            ), # conditionalPanel

            # Using the dashboard
            conditionalPanel(
              condition= 'input.home_select == "use"',
              tagList(h3(tags$b("Using the dashboard")),
                      p("There are tabs across the top for the each topic area within the dashboard....."),
                      p("Note that some numbers may not sum to the total as disclosure control methods have been applied
                        to the data in order to protect patient confidentiality."), br(),

                      p(tags$b("Interacting with the dashboard")),
                      p(tags$li("On each tab there are........")),
                      p(tags$li("On the line charts,
                                clicking on a category in the legend will remove it from the chart. This is useful to reduce the number of lines
                                on the chart and makes them easier to see. A further click on the categories will add them back into the chart.")),
                      p(tags$li("There are.....")), br(),
                      p(tags$b("Downloading data")),
                      p(tags$li("Some of the data is also available on the ",
                                tags$a(href="https://www.opendata.nhs.scot/dataset/hospital-standardised-mortality-ratios",
                                       "Scottish Health and Social Care Open Data platform (external website).", target="_blank"))),
                      p(tags$li("To download an image of any of the charts in the dashboard, click the camera icon in the top-right
                                corner of the chart and a png image file will automatically download."))
                      ) #tagList
                      ), # condtionalPanel

            # Further information
            conditionalPanel(
              condition= 'input.home_select == "info"',
              tagList(h3(tags$b("Further sources of information")),
                      p(tags$li("You can access the code used to produce this tool in this ",
                                tags$a(href="https://github.com/Public-Health-Scotland/covid-19_dashboard", "GitHub repository (external website)",  target="_blank"), ".")),


                      p(tags$b("Contact us")),
                      p("Please contact the ", tags$a(href="mailto:phs.Covid19Data&Analytics@phs.scot", "Covid-19 Data & Analytics team"),
                        "if you have any questions about the data in this dashboard.")
              ) # tagList
            ), # conditionalPanel

            # Accessibility
            conditionalPanel(
              condition= 'input.home_select == "accessibility"',
              tagList(h3(tags$b("Accessibility")),
                      p("This website is run by ", tags$a(href="https://www.publichealthscotland.scot/",
                                                          "Public Health Scotland", target="_blank"),
                        ", Scotland's national organisation for public health. As a new organisation formed
                                   on 1 April 2020, Public Health Scotland is currently reviewing its web estate. Public
                                   Health Scotland is committed to making its website accessible, in accordance with
                                   the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility
                                   Regulations 2018. This accessibility statement applies to the dashboard that accompanies
                                   the HSMR quarterly publication."),
                      p(tags$a(href="https://mcmw.abilitynet.org.uk/", "AbilityNet (external website)", target="_blank"),
                        " has advice on making your device easier to use if you have a disability."),

                      p(tags$b("Compliance status")),
                      p("This site has not yet been evaluated against Web Content Accessibility Guidelines
                                   version 2.1 level AA standard."),

                      p(tags$b("Reporting any accessibility problems with this website")),
                      p("If you wish to contact us about any accessibility issues you encounter on this
                                   site, please email ", tags$a(href="mailto:phs.qualityindicators@phs.scot", "phs.qualityindicators@phs.scot", ".")),

                      p(tags$b("Enforcement procedure")),
                      p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the
                                   Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations
                                   2018 (the ‘accessibility regulations’). If you’re not happy with how we respond to your complaint,",
                        tags$a(href="https://www.equalityadvisoryservice.com/", "contact the Equality Advisory and Support Service (EASS) (external website).",
                               target = "_blank")),

                      p(tags$b("Preparation of this accessibility statement")),
                      p("This statement was prepared on 15 June 2022. It was last reviewed on 08 December 2022.")
              ) # tagList
            ) # conditonalPanel
                      ) # mainPanel
              ) # sidebarLayout
