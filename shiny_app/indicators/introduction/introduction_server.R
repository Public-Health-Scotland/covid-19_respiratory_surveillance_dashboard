

#Naviagtion buttons on intro page ----
observeEvent(input$jump_to_summary, {updateTabsetPanel(session, "intabset", selected = "summary")})
observeEvent(input$jump_to_cases, {updateTabsetPanel(session, "intabset", selected = "cases")})
observeEvent(input$jump_to_hospital_admissions, {updateTabsetPanel(session, "intabset", selected = "hospital_admissions")})
observeEvent(input$jump_to_hospital_occupancy, {updateTabsetPanel(session, "intabset", selected = "hospital_occupancy")})
observeEvent(input$jump_to_respiratory, {updateTabsetPanel(session, "intabset", selected = "respiratory")})
observeEvent(input$jump_to_metadata, {updateTabsetPanel(session, "intabset", selected = "metadata")})
observeEvent(input$jump_to_download, {updateTabsetPanel(session, "intabset", selected = "download")})


output$introduction_about <- renderUI({

  tagList(h3(tags$b("COVID-19 & Respiratory Surveillance in Scotland")),
          p("Surveillance of COVID-19 and respiratory infection is a key public health activity.
            The spectrum of respiratory illnesses vary from asymptomatic illness to mild/moderate symptoms
            to severe complications including death. There is no single respiratory surveillance component
            that can describe the onset, severity and impact of respiratory infections."),
          p("This dashboard consolidates existing COVID-19 dashboards into a single product and summarises
            the current COVID-19 and respiratory data in Scotland, presenting statistics on infection levels
            and key healthcare indicators."),
          p("All covid rules and restrictions have been lifted in Scotland, but the virus has not gone away.
            We all need to play our part in protecting ourselves and others. You can do this by following
            NHS Inform Website advice on: ", tags$a(href = "https://www.gov.scot/coronavirus-covid-19/",
                                                    "https://www.gov.scot/coronavirus-covid-19/.")),
          p("Please note that release of information involving small numbers carries a risk that individuals could be identified.",
            "We have carefully considered and assessed these risks, taking steps to reduce them as much as possible,",
            "and balancing them with the need to release useful information.",
            "We have been monitoring and reviewing our approach to how we release local-level information."),
          p(glue("This dashboard was last updated on {Deployment_Date}")),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_summary", "At a glance"))),
            column(8, p("This section provides an overview of headline COVID-19 and respiratory
                        surveillance indicators held within this dashboard."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_cases", "COVID-19 cases"))),
            column(8, p("This section shows the latest information on the number and rate of
                        estimated infection levels in Scotland."),
                   p("The Office for National Statistics (ONS) COVID-19 Infection Survey is
                     Scotland’s current best understanding of community population prevalence.
                     Outbreaks and trends are also monitored by measuring concentrations of COVID-19 in wastewater.
                     PHS also monitor the number of reported positive COVID-19 cases as this
                     offers a valuable early insight into trends of infection rates in Scotland."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_hospital_admissions", "COVID-19 hospital admissions"))),
            column(8, p("Alongside the estimated infection levels and reported COVID-19 cases presented
                        in this dashboard, PHS also monitor COVID-19 hospital admissions as it is a
                        measure of severe disease and captures pressures facing NHS hospitals.
                        The latest information on acute COVID-19 hospital admissions are detailed in this section."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_hospital_occupancy", "COVID-19 hospital occupancy"))),
            column(8, p("This section contains the latest information on the number of patients
                        in hospital with COVID-19. This is an indicative measure of the pressure on hospitals,
                        as these patients still require isolation from other patients for infection control purposes."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_respiratory", "Respiratory infection activity"))),
            column(8, p("Latest information on the number and rate of flu and non-flu cases in Scotland."))),
          br(),


          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_metadata", "Metadata"))),
            column(8, p("Information on the different indicators and their data sources.",
                        "Also includes a glossary of technical terms."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_download", "Download data"))),
            column(8, p("Data pertaining to selected indicators presented in this dashboard can be filtered and downloaded. "))),

          br()


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
          ) #tagList
})

output$introduction_contact <- renderUI({
  tagList(h3(tags$b("Contact us")),
  p("Please contact the ", tags$a(href="mailto:phs.Covid19Data&Analytics@phs.scot", "Covid-19 Data & Analytics team"),
    "if you have any questions about the data in this dashboard."),

  p(tags$b("Further sources of information")),
     p(tags$li("You can access the code used to produce this tool in this ",
               tags$a(href="https://github.com/Public-Health-Scotland/covid-19_dashboard", "GitHub repository (external website)",  target="_blank"), ".")
       )

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

output$introduction_open_data <- renderUI({
  tagList(h3("Open data"),
          tags$a(img(src = "open-data-logo.png", height = 30,
              alt ="Go to Scottish Health and Social Care Open Data platform (external site)"),
              href = "https://www.opendata.nhs.scot",
              target = "_blank"),
          p(""),
          p("The ", tags$a(href="https://www.opendata.nhs.scot",
                           "Scottish Health and Social Care Open Data platform (external website)", target="_blank"),
            "gives access to statistics and reference data for information and re-use. ",
            "The platform is managed by Public Health Scotland. ",
            "Data is released under the Open Government Licence."),
          p("You can download COVID-19 data presented in this dashboard from the ",
            tags$a(href="https://www.opendata.nhs.scot/dataset/covid-19-in-scotland",
            "COVID-19 Statistical Data in Scotland page (external website)", target="_blank"),
            ".")
  ) # tagList

})

