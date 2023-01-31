

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
          p(glue("This dashboard was last updated on {Deployment_Date}.")),
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
            column(8, p("Latest information on the number and rate of influenza and non-influenza cases in Scotland."))),
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
          p(tags$li("Click on tabs in the blue navigation bar at the top to view each section"),
            tags$a(img(src = "intro_images/nav_bar.png", height = 50,
                       alt ="Image of the a part of the navigation bar for reference"))),
          p(tags$li("Click on 'At a glance' to view the most recently available main statistic."),
            tags$a(img(src = "intro_images/at_a_glance_tab.png", height = 50,
                       alt ="Image of the 'At a glance' tab in the navigation bar"))),
          p(tags$li("Click on 'COVID-19 cases', 'COVID-19 hospital admissions', 'COVID-19 hospital occupancy' or
                    'Respiratory infection activity' to view each topic."),
            tags$a(img(src = "intro_images/cases.png", height = 50,
                       alt ="Image of the 'COVID-19 cases' tab in the navigation bar")),
            tags$a(img(src = "intro_images/admissions.png", height = 50,
                       alt ="Image of the 'COVID-19 hospital admissions' tab in the navigation bar")),
            tags$a(img(src = "intro_images/occupancy.png", height = 50,
                       alt ="Image of the'COVID-19 hospital occupancy' tab in the navigation bar")),
            tags$a(img(src = "intro_images/respiratory.png", height = 50,
                       alt ="Image of the 'Respiratory infection activity' tab in the navigation bar"))),
          p(tags$li("Click on 'Metadata' to view notes about the data"),
            tags$a(img(src = "intro_images/metadata_tab.png", height = 50,
                       alt ="Image of the 'Metadata' tab in the navigation bar"))),
          p(tags$li("Click on 'Download data' to download datasets as an Excel or CSV file"),
            tags$a(img(src = "intro_images/download_data_tab.png", height = 50,
                       alt ="Image of the 'download data' tab in the navigation bar"))),
          br(),
          p(tags$b("Within each tab")),
          p(tags$li("Click the 'Metadata' button, as below, in each tab to navigate to corresponding notes"),
            tags$a(img(src = "intro_images/metadata_btn.png", height = 50,
                       alt ="Image of the metadata button"))),
          p(tags$li("Click on the toggles to change the visible sub-topic"),
            tags$a("e.g.", img(src = "intro_images/tab_toggles.png", height = 50,
                       alt ="Image of the tab toggle options used in the tabs. This image shows an example of the toggles
                       in the 'COVID-19 hospital admissions' tab"))),
          p(tags$li("Summary banners display the most recently available headline figures")),
          p(tags$li("Click 'Plot/Data' toggle, as below, to switch between chart and data table view"),
            tags$a(img(src = "intro_images/plot_data_toggle.png", height = 60,
                       alt ="Image of the plot and data toggle"))),
          br(),
          p(tags$b("Interacting with the charts")),
          p(tags$li("Click the 'Plot description' button, as below, for a summary of the plot content"),
            tags$a(img(src = "intro_images/plot_description.png", height = 50,
                       alt ="Image of the plot description button"))),
          p(tags$li("Move the cursor over the data points in the charts to see the data values")),
          p(tags$li("Click the magnifying glass in the top right of the charts to enable zoom capabilities.
                    Then zoom into the plot by holding down the cursor and dragging to select the region"),
            tags$a(img(src = "intro_images/zoom_graph.png", height = 60,
                       alt ="Image of the zoom button on the graphs"))),
          p(tags$li("Click the pan button (four way arrows) in the top right of the charts to enable panning capabilites.
                    Then move the chart around by holding down the cursor and dragging."),
            tags$a(img(src = "intro_images/pan_graph.png", height = 60,
                       alt ="Image of the pan button"))),
          p(tags$li("Alter the x axis range by dragging the vertical white bars on the left and right of the bottom panel")),
          p(tags$li("Click the home button in the top right to reset the axes"),
            tags$a(img(src = "intro_images/home_graph.png", height = 50,
                       alt ="Image of the home button on the graphs used to reset the axes"))),
          p(tags$li("Single click on legend variables to remove the corresponding trace")),
          p(tags$li("Double click on legend variables to isolate the corresponding trace")),
          p(tags$li("Double click on the legend to restore all traces")),
          p(tags$li("Click the camera icon in the top right to download the plot as a png file"),
            tags$a(img(src = "intro_images/camera.png", height = 50,
                       alt ="Image of the camera button on the graphs used to download the plot as a png file"))),
          p(tags$li("Click on the 'Using the plot' buttons as below next to each graph for ")),
          br(),
          p(tags$b("Downloading data")),
          p(tags$li("Data can be downloaded in open data format from the 'Download data' tab by clicking the 'Download Data' button, as below,
                    as well as from the",
                    tags$a(href="https://www.opendata.nhs.scot",
                           "Scottish Health and Social Care Open Data platform (external website).", target="_blank")),
            tags$a(img(src = "intro_images/download_data.png", height = 50,
                       alt ="Image of the download data button"))
            ),
          p(tags$li("On the 'Download data' tab you can select the dataset and file type you wish to download")),
          p(tags$li("You can view a data summary and a data preview before downloading by click ing between the toggles as below"),
            tags$a(img(src = "intro_images/summary_preview.png", height = 60,
                       alt ="Image of the data summary and data preview toggle"))),
          p(tags$li("To download an image of any of the charts in the dashboard, click the camera icon in the top-right
                    corner of the chart and a png image file will automatically download."),
            tags$a(img(src = "intro_images/camera.png", height = 50,
                       alt ="Image of the camera button on the graphs used to download the plot as a png file")))
          ) #tagList
})

output$introduction_contact <- renderUI({
  tagList(h3(tags$b("Contact us")),
  p("Please contact the ", tags$a(href="mailto:phs.Covid19Data&Analytics@phs.scot", "Covid-19 Data & Analytics team"),
    "if you have any questions about the data in this dashboard."),

  p(tags$b("Further sources of information")),

  p(tags$li("You can access the code used to produce this tool in this ",
            tags$a(href="https://github.com/Public-Health-Scotland/covid-19_respiratory_surveillance_dashboard", "GitHub repository (external website)",  target="_blank"), "."),
    tags$li("New releases will be published at the same time as the Public Health Scotland",
            tags$a(href = "https://www.publichealthscotland.scot/publications/weekly-national-respiratory-infection-and-covid-19-statistical-report/",
                   "Weekly national respiratory infection and COVID-19 statistical report (external website)", target="_blank" ), "."),
    tags$li("Information on the wider impacts on the health care system from COVID-19 are available on the",
            tags$a(href = "https://scotland.shinyapps.io/phs-covid-wider-impact/",
                   "Wider Impacts dashboard (external website)", target="_blank" ), "."),
    tags$li("Information and support on a range of topics in regards to COVID-19 are available on the",
            tags$a(href = "https://www.gov.scot/coronavirus-covid-19/",
                   "Scottish Government website (external website)", target="_blank" ), "."),
    tags$li("Information on deaths involving COVID-19 is available on the",
            tags$a(href = "https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/",
                   "National Records Scotland website (external website)", target="_blank" ), "."),
    tags$li("Information from the World Health Organisation on COVID-19 is available on the",
            tags$a(href = "https://covid19.who.int/",
                   "WHO Coronovirus (COVID-19) dashboard (external website)", target="_blank" ), ".")

  ),

  p()

  ) # tagList

})

output$introduction_accessibility <- renderUI({
  tagList(h3(tags$b("Accessibility")),
          p("This website is run by ", tags$a(href="https://www.publichealthscotland.scot/",
                                              "Public Health Scotland", target="_blank"),
            ", Scotland's national organisation for public health. As a new organisation formed
                                   on 01 April 2020, Public Health Scotland is currently reviewing its web estate. Public
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

