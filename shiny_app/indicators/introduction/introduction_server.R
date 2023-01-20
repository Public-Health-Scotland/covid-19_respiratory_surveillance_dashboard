

#Naviagtion buttons on intro page ----
observeEvent(input$jump_to_summary, {updateTabsetPanel(session, "intabset", selected = "summary")})
observeEvent(input$jump_to_cases, {updateTabsetPanel(session, "intabset", selected = "cases")})
observeEvent(input$jump_to_hospital_admissions, {updateTabsetPanel(session, "intabset", selected = "hospital_admissions")})
observeEvent(input$jump_to_hospital_occupancy, {updateTabsetPanel(session, "intabset", selected = "hospital_occupancy")})
observeEvent(input$jump_to_vaccines, {updateTabsetPanel(session, "intabset", selected = "vaccines")})
observeEvent(input$jump_to_metadata, {updateTabsetPanel(session, "intabset", selected = "metadata")})
observeEvent(input$jump_to_download, {updateTabsetPanel(session, "intabset", selected = "download")})


output$introduction_about <- renderUI({
  tagList(h3(tags$b("COVID-19 in Scotland")),
          p("text here"),
          tags$div(class = "special_button",
                   actionButton("jump_to_summary", "At a glance"),
                   actionButton("jump_to_cases", "Cases"),
                   actionButton("jump_to_hospital_admissions", "Hospital admissions"),
                   actionButton("jump_to_hospital_occupancy", "Hospital occupancy"),
                   actionButton("jump_to_vaccines", "Vaccine wastage"),
                   actionButton("jump_to_metadata", "Metadata"),
                   actionButton("jump_to_download", "Download data")

          )#div
  )# tagList
})

output$introduction_use <- renderUI({
  tagList(h3(tags$b("Interacting with the dashboard")),
          p("Click on tabs in the navigation bar at the top to view each topic. Click on 'At a glance' to view the most recently available
            main statistics. Click on 'Metadata' to view notes about the data. Click on 'Download data' to download datasets as an Excel or CSV file."),
          br(),
          p(tags$b("Within each tab")),
          p(tags$li("Click the 'Metadata' button to navigate to relevant notes")),
          p(tags$li("Click on the toggles to change the visible sub-topic")),
          p(tags$li("Summary banners display the most recently available headline figures")),
          p(tags$li("Click 'Plot/Data' toggle to switch between chart and data table view")),
          br(),
          p(tags$b("Interacting with the charts")),
          p(tags$li("Click the 'Plot description' button for a summary of the plot content")),
          p(tags$li("Move the cursor over the data points to see the data values")),
          p(tags$li("Zoom into the plot by holding down the cursor and dragging to select the region")),
          p(tags$li("Alter the x axis range by dragging the vertical white bars on the left and right of the bottom panel")),
          p(tags$li("Click the home button in the top right to reset the axes")),
          p(tags$li("Single click on legend variables to remove the corresponding trace")),
          p(tags$li("Double click on legend variables to isolate the corresponding trace")),
          p(tags$li("Double click on the legend to restore all traces")),
          p(tags$li("Click the camera icon in the top right to download the plot as a png file")),
          br(),
          p(tags$b("Downloading data")),
          p(tags$li("Data can be downloaded in open data format from the 'Download data' tab as well as from the",
                    tags$a(href="https://www.opendata.nhs.scot",
                           "Scottish Health and Social Care Open Data platform (external website).", target="_blank"))),
          p(tags$li("On the 'Download data' tab you can select the dataset and file type you wish to download")),
          p(tags$li("You can view a data summary and a data preview before downloading")),
          p(tags$li("To download an image of any of the charts in the dashboard, click the camera icon in the top-right
                    corner of the chart and a png image file will automatically download.")),
          br(),
          p(tags$b("Disclosure")),
          p("Note that some numbers may not sum to the total as disclosure control methods have been applied
            to the data in order to protect patient confidentiality.")
          ) #tagList
})

output$introduction_info <- renderUI({
  tagList(h3(tags$b("Further sources of information")),
          p(tags$li("You can access the code used to produce this tool in this ",
                    tags$a(href="https://github.com/Public-Health-Scotland/covid-19_dashboard", "GitHub repository (external website)",  target="_blank"), ".")),


          p(tags$b("Contact us")),
          p("Please contact the ", tags$a(href="mailto:phs.Covid19Data&Analytics@phs.scot", "Covid-19 Data & Analytics team"),
            "if you have any questions about the data in this dashboard.")
  ) # tagList

})

output$introduction_accessibility <- renderUI({
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
                                   version 2.1 level AA standard. We are currently working towards an evaluation."),
          br(),
          p(tags$b("Accessible features")),
          p("We have taken the following steps to make this dashboard more accessible:"),
          p(tags$li("Colours have been chosen to meet colour contrast standards")),
          p(tags$li("Plot colours have been chosen to be colour blind friendly")),
          p(tags$li("The dashboard can be navigated using a keyboard")),
          p(tags$li("The content is still readable at 400% zoom")),
          p(tags$li("Alternative descriptions of plot contents have been provided via 'Plot description' buttons")),
          p(tags$li("Data tables have been provided alongside plots where possible")),
          p(tags$li("Hover content has been replaced with clickable content where possible")),
          br(),
          p(tags$b("Reporting any accessibility problems with this website")),
          p("If you wish to contact us about any accessibility issues you encounter on this
                                   site, please email ", tags$a(href="mailto:phs.covid19data&analytics@phs.scot", "phs.covid19data&analytics@phs.scot", ".")),

          p(tags$b("Enforcement procedure")),
          p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the
                                   Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations
                                   2018 (the ‘accessibility regulations’). If you’re not happy with how we respond to your complaint,",
            tags$a(href="https://www.equalityadvisoryservice.com/", "contact the Equality Advisory and Support Service (EASS) (external website).",
                   target = "_blank")),

          p(tags$b("Preparation of this accessibility statement")),
          p("This statement was prepared on 13 January 2023. It was last reviewed on 13 January 2023.")
  ) # tagList
})

