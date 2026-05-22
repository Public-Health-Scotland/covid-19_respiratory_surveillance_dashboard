

#Naviagtion buttons on intro page ----
observeEvent(input$jump_to_summary, {updateTabsetPanel(session, "intabset", selected = "at_a_glance")})
observeEvent(input$jump_to_respiratory, {updateTabsetPanel(session, "intabset", selected = "repiratory_pathogens")})
observeEvent(input$jump_to_wastewater, {updateTabsetPanel(session, "intabset", selected = "wastewater")})
observeEvent(input$jump_to_syndromic, {updateTabsetPanel(session, "intabset", selected = "syndromic_surveillance")})
observeEvent(input$jump_to_mortality, {updateTabsetPanel(session, "intabset", selected = "mortality")})
observeEvent(input$jump_to_metadata, {updateTabsetPanel(session, "intabset", selected = "metadata")})
observeEvent(input$jump_to_download, {updateTabsetPanel(session, "intabset", selected = "download")})

## To be used while dashboard is updating 4-weekly. Can remove final bold sentence below after we revert to weekly publication on 8/10/26
next_dashboard_date <- (floor_date(as.Date(Deployment_Date, format = "%d %B %Y") + weeks(4), "week", 7) + days(4)) %>% format("%d %B")

output$introduction_about <- renderUI({

  tagList(h3(tags$b("Viral Respiratory Diseases (including Influenza and COVID-19) Surveillance in Scotland")),
          #p(strong("The next release of this dashboard will be 08 August 2024.")),
          p("Surveillance of viral respiratory diseases (including influenza and COVID-19) is a key public health activity.
            The spectrum of respiratory illnesses vary from asymptomatic illness to mild/moderate symptoms
            to severe complications including death."),
          p("This interactive dashboard presents data on viral respiratory diseases in Scotland to support the understanding
            of transmission of infection and NHS service planning and policy."),
                    p("Please note that release of information involving small numbers carries a risk that individuals could be identified.",
            "We have carefully considered and assessed these risks, taking steps to reduce them as much as possible,",
            "and balancing them with the need to release useful information."#,
            #"Between 22 May and October 2025, Public Health Scotland (PHS) will be reporting",
            #"Scotland level admissions for COVID-19, Influenza and RSV, due to low levels of hospital admissions.", 
            #"This approach aligns to the pre-pandemic reporting schedule for respiratory pathogens, which typically follow a",
            #"seasonal pattern with most cases/admissions occurring between October and April/May."
            ), 
          p(glue("This dashboard was last updated on {Deployment_Date} to include data up to {data_recent_date}.")),
         # br(),
         ##Note below to be removed after 8/10/26
          strong(glue("Public Health Scotland (PHS) continue to consider timely ways to provide the public with official statistics. 
                 Between 23 April and 8 October 2026, PHS are reducing the frequency of the Viral respiratory diseases in 
                 Scotland dashboard to four-weekly. The dashboard will next be updated on {next_dashboard_date}.")),
          br(),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_summary", "At a glance"))),
            column(8, p("This section provides updates on headline viral respiratory
                        surveillance indicators, including COVID-19, influenza and RSV."))),
          br(),


          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_respiratory", "Respiratory pathogens"))),
            column(8, p("This section contains trend information for a range of viral respiratory infections
                        in Scotland."))),
          br(),
          
          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_wastewater", "Wastewater"))),
            column(8, p("This section contains trend information for COVID-19 wastewater surveillance 
                        in Scotland."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                    actionButton("jump_to_syndromic", "Syndromic surveillance"))),
            column(8, p("This section contains trend information of calls to NHS24 for respiratory symptoms
                        and trend information for General Practitioners consultations for Influenza-Like Illnesses (ILI)."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                    actionButton("jump_to_mortality", "Mortality"))),
            column(8, p("This section presents estimates of weekly all-cause excess
                        mortality, using the European monitoring system (Euromomo)."))),
          br(),


          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_metadata", "Metadata"))),
            column(8, p("Information on the different indicators and their data sources.",
                        "Also includes a glossary of technical terms."))),
          br(),

          fluidRow(
            column(4,tags$div(class = "special_button",
                              actionButton("jump_to_download", "Open data"))),
            column(8, p("Data pertaining to selected indicators presented in this dashboard can be downloaded as open data."))),

          br()


  )# tagList
})

output$introduction_use <- renderUI({
  tagList(h3(tags$b("Interacting with the dashboard")),
          p(tags$li("Click on tabs in the blue navigation bar at the top to view each section"),
            tags$img(src = "intro_images/nav_bar.png", height = 50,
                       alt ="Image of a part of the navigation bar for reference")),
          p(tags$li("Click on 'At a glance' to view the most recently available main statistics"),
            tags$img(src = "intro_images/at_a_glance_tab.png", height = 50,
                       alt ="Image of the 'At a glance' tab in the navigation bar")),
          p(tags$li("Click on 'Respiratory Pathogens', 'Syndromic Surveillance' or
                    'Mortality' to view each topic"),
            tags$img(src = "intro_images/respiratory_pathogens.png", height = 50,
                       alt ="Image of the 'Respiratory pathogens' tab in the navigation bar"),
            tags$img(src = "intro_images/syndromic_surveillance.png", height = 50,
                       alt ="Image of the'Syndromic surveillance' tab in the navigation bar"),
            tags$img(src = "intro_images/mortality.png", height = 50,
                       alt ="Image of the 'Mortality' tab in the navigation bar")),
          p(tags$li("Click on 'Metadata' to view notes about the data"),
            tags$img(src = "intro_images/metadata_tab.png", height = 50,
                       alt ="Image of the 'Metadata' tab in the navigation bar")),
          #p(tags$li("Click on 'Download data' to download datasets as an Excel or CSV file"),
          p(tags$li("Click on 'Download data' to access the open data platform"),
            tags$img(src = "intro_images/download_data_tab.png", height = 50,
                       alt ="Image of the 'download data' tab in the navigation bar")),
          br(),
          p(tags$b("Within each tab")),
          p(tags$li("Click the 'Metadata' button in each tab to navigate to corresponding notes"),
            tags$img(src = "intro_images/metadata_btn.png", height = 50,
                       alt ="Image of the metadata button")),
          p(tags$li("Click on the toggles to change the visible sub-topic"),
            "e.g.", tags$img(src = "intro_images/tab_toggles_v2.png", height = 50,
                       alt ="Image of the tab toggle options used in the tabs. This image shows an example of the toggles
                       in the 'Respiratory pathogens COVID-19' tab")),
          p(tags$li("Summary banners display the most recently available headline figures")),
          p(tags$li("Click 'Plot/Data' toggle to switch between chart and data table view"),
            tags$img(src = "intro_images/plot_data_toggle.png", height = 60,
                       alt ="Image of the plot and data toggle")),
          br(),
          p(tags$b("Interacting with the charts")),
          p(tags$li("Click the 'Plot description' button for a summary of the plot content"),
            tags$img(src = "intro_images/plot_description.png", height = 50,
                       alt ="Image of the plot description button")),
          p(tags$li("Move the cursor over the data points in the charts to see the data values")),
          p(tags$li("Click the magnifying glass in the top right of the charts to enable zoom capabilities.
                    Then zoom into the plot by holding down the cursor and dragging to select the region"),
            tags$a(img(src = "intro_images/zoom_graph.png", height = 60,
                       alt ="Image of the zoom button on the graphs"))),
          p(tags$li("Click the pan button (four way arrows) in the top right of the charts to enable panning capabilites.
                    Then move the chart around by holding down the cursor and dragging"),
            tags$img(src = "intro_images/pan_graph.png", height = 60,
                       alt ="Image of the pan button")),
          p(tags$li("Alter the x axis range by dragging the vertical white bars on the left and right of the bottom panel")),
          p(tags$li("Click the home button in the top right to reset the axes"),
            tags$img(src = "intro_images/home_graph.png", height = 50,
                       alt ="Image of the home button on the graphs used to reset the axes")),
          p(tags$li("Single click on legend variables to remove the corresponding trace")),
          p(tags$li("Double click on legend variables to isolate the corresponding trace")),
          p(tags$li("Double click on the legend to restore all traces")),
          p(tags$li("Click the camera icon in the top right to download the plot as a png file"),
            tags$a(img(src = "intro_images/camera.png", height = 50,
                       alt ="Image of the camera button on the graphs used to download the plot as a png file"))),
          p(tags$li("Next to each chart click the 'Using the plot' button for a recap of the information in this section"),
            tags$img(src = "intro_images/using_the_plot.png", height = 50,
                       alt ="Image of the 'using the plot' button on the charts which when clicked,
                       provides a recap of the 'ineracxting with the charts' section")),
          br(),
          p(tags$b("Downloading data")),
          p(tags$li("Data can be downloaded in open data format from the ",
                    tags$a(href="https://www.opendata.nhs.scot",
                           "Scottish Health and Social Care Open Data platform (external website)", target="_blank"))
          )
  )
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
                   "Viral Respiratory Diseases (including influenza and COVID-19) in Scotland Surveillance Report (external website)", target="_blank" ), "."),
    tags$li("Information on vaccine uptake for the COVID-10 and influenza vaccine programmes is available via",
            tags$a(href = "https://scotland.shinyapps.io/phs-vaccination-surveillance/",
                   "Public Health Scotland - Vaccination Surveillance Dashboard", target="_blank"), "."),
    tags$li("Information on the wider impacts on the health care system from COVID-19 are available on the",
            tags$a(href = "https://scotland.shinyapps.io/phs-covid-wider-impact/",
                   "Wider Impacts dashboard (external website)", target="_blank" ), "."),
    tags$li("Information and support on a range of topics in regards to COVID-19 are available on the",
            tags$a(href = "https://www.gov.scot/coronavirus-covid-19/",
                   "Scottish Government website (external website)", target="_blank" ), "."),
    tags$li("Information on deaths involving COVID-19 is available on the",
            tags$a(href = "https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/general-publications/weekly-and-monthly-data-on-births-and-deaths/deaths-involving-coronavirus-covid-19-in-scotland/",
                   "National Records Scotland website (external website)", target="_blank" ), "."),
    tags$li("Information from the UK Government (UKHSA) for data and insights on COVID-19 are available on the",
            tags$a(href = "https://coronavirus.data.gov.uk/",
                   "UKHSA dashboard", target="_blank", ".")),
    tags$li("Information from the World Health Organisation on COVID-19 is available on the",
            tags$a(href = "https://covid19.who.int/",
                   "WHO Coronavirus (COVID-19) dashboard (external website)", target="_blank" ), ".")

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
          p("You can download viral respiratory disease data presented in this dashboard from the ",
            tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
                   "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website)", target="_blank"),
            ".")
  ) # tagList

})

