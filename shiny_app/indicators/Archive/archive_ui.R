tagList(
  fluidRow(width = 12,
           tagList(h2("Estimated COVID-19 infection rate"),
                   h4("(ONS winter covid infection survey (November 2023 to March 2024))"),
                   p("The Office for National Statistics (ONS) winter covid infection survey (CIS) conducted between November 2023 to March 2024. Winter CIS survey closed on 06 March 2024 with the final report ",
                     tags$a(href="https://www.gov.uk/government/statistics/winter-coronavirus-covid-19-infection-study-estimates-of-epidemiological-characteristics-england-and-scotland-2023-to-2024", "UKHSA Winter Coronavirus Infection Study (external website)",  target="_blank"), " published on 14 March 2024."),
           ),
           linebreaks(1)),

  fluidRow(width = 12,
           tagList(h4("(ONS covid infection survey (November 2020 to March 2023))"),
                   p("The Office for National Statistics (ONS) published their",
                     tags$a(href="https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/bulletins/coronaviruscovid19infectionsurveypilot/24march2023", "final COVID-19 Infection Survey report (external website)",  target="_blank"), " on 24 March 2023."),
           ),
           linebreaks(1)),

  fluidRow(width=12,
           tagList(h2("COVID-19 admissions to Intensive Care Units (ICU)"),
                   p("From 08 June 2023, these data are no longer updated and will be monitored internally by PHS as part of routine surveillance. The final published numbers are available via our",
                     tags$a(href="https://www.opendata.nhs.scot/dataset/covid-19-in-scotland/resource/2dd8534b-0a6f-4744-9253-9565d62f96c2", "ARCHIVED open dataset on Daily Case Trends by Health Board (external website)",  target="_blank"), "."),
                   ),
             ),

  fluidRow(
    width =12, br()),

  fluidRow(width = 12,
           tagList(h2("COVID-19 patients in Intensive Care Units (ICU)"),
                   p("From 08 May 2023, manual data collections from NHS Boards on the number of patients in ICU paused. The number of patients in ICU for 28 days or less, and the number of patients in ICU for more than 28 days are no longer updated. The final published numbers are available via our",
                     tags$a(href="https://www.opendata.nhs.scot/dataset/covid-19-in-scotland/resource/2dd8534b-0a6f-4744-9253-9565d62f96c2", "ARCHIVED open dataset on Daily Case Trends by Health Board (external website)",  target="_blank"), "."),
                   ),
           linebreaks(1)),

  fluidRow(
    br())
)



