
metadataButtonServer(id="respiratory_influenza_admissions",
                     panel="Respiratory infection activity",
                     parent = session)




altTextServer("influenza_admissions_modal",
              title = "Influenza hospital admissions in Scotland",
              content = tags$ul(tags$li("This is a plot showing the number of influenza hospital admissions in Scotland."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. ",
                                        "Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis shows the number of hospital admissions."),
                                tags$li("There is a trace for each of the following season from 2016/2017 to 2022/2023")))

altTextServer("flu_adm_age_sex",
              title = glue("Acute influenza admissions by age and sex in Scotland"),
              content = tags$ul(
                tags$li(glue("This is a pyramid plot of rate per 100,000 people of acute influenza hospital admissions in Scotland by age and sex.")),
                tags$li("The information is displayed for a selected  winter respiratory season.",
                        "Respiratory seasons start at ISO week 40 and finish at ISO week 39."),
                tags$li("Weekly rate data for age and sex on a weekly basis are available in ",
                        "the PHS Open Data platform ",
                        tags$a(href="https://www.opendata.nhs.scot/dataset/viral-respiratory-diseases-including-influenza-and-covid-19-data-in-scotland",
                               "Viral Respiratory Diseases (Including Influenza and COVID-19) Data in Scotland page (external website).",
                               target="_blank")),
                tags$li("The y axis shows the age group. The left side of the y axis corresponds to females (F) and the right side to males (M)."),
                tags$li("For the x axis the plot shows rate per 100,000 people.")
                # tags$li("The youngest and oldest groups have the highest rates of illness.")
              )
)



altTextServer("flu_los_modal",
              title = "Length of stay of acute influenza hospital admissions",
              content = tags$ul(
                tags$li("This is a plot of the distribution of lengths of stay in hospital",
                        "for acute influenza hospital admissions by respiratory season.",
                        "The information is displayed for a selected  winter respiratory season.",
                        "Respiratory seasons start at ISO week 40 and finish at ISO week 390"),
                tags$li("There is a drop down above the chart which allows you to select",
                        "the respiratory season for plotting. The default is the current season."),
                tags$li("The legend shows five categories for length of stay: 1 day or less;",
                        "2-3 days, 4-5 days, 6-7 days, 8+ days. See the metadata tab for further detail."),
                tags$li("The x axis shows a break down of admissions by age groups: 0-17, 18-64, 65-74, 75+ and finally by All ages."),
                tags$li("The y axis is the percentage of admissions in a given age group category."),
                tags$li("The plot is a stacked bar chart, where the",
                        "sections of vertical bars correspond to different length of stay categories.",
                        "The bar sections are ordered from smallest length of stay to largest",
                        "length of stay from bottom to top.") ))


# Influenza admissions table
output$influenza_admissions_table <- renderDataTable({
  Influenza_admissions %>%
    filter(FluType == "Influenza A & B") %>%
    arrange(desc(Date)) %>%
    select(Season, ISOWeek, Admissions) %>%
    mutate(Season = factor(Season),
           ISOWeek = factor(ISOWeek)) %>%
    rename(`ISO Week` = ISOWeek) %>%
    make_table(filter_cols = c(1,2))
})


# Influenza Adms plot
output$influenza_admissions_plot <- renderPlotly({
  Influenza_admissions %>%
    filter(FluType == "Influenza A & B") %>%
    create_flu_adms_linechart()

})


observeEvent(input$respiratory_season,
             {
               updatePickerInput(session, inputId = "respiratory_date",
                                 choices = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% unique() %>% as.Date() %>% format("%d %b %y")},
                                 selected = {Respiratory_AllData %>% filter(Season == input$respiratory_season) %>%
                                     .$Date %>% max() %>% as.Date() %>% format("%d %b %y")})

             }
)

# HB Table
output$flu_admissions_hb_table <- renderDataTable({
  Flu_Admissions_HB_3wks %>%
    #filter(WeekEnding %in% adm_hb_dates) %>%
    mutate(WeekEnding = format(WeekEnding, format = "%d %b %y")) %>%
    pivot_wider(names_from = WeekEnding,
                values_from = TotalInfections) %>%
    mutate(HealthBoardOfTreatment = factor(HealthBoardOfTreatment,
                                levels = c("NHS Ayrshire and Arran", "NHS Borders", "NHS Dumfries and Galloway", "NHS Fife", "NHS Forth Valley", "NHS Grampian",
                                           "NHS Greater Glasgow and Clyde", "NHS Highland", "NHS Lanarkshire", "NHS Lothian", "NHS Orkney", "NHS Shetland",
                                           "NHS Tayside", "NHS Western Isles", "Golden Jubilee National Hospital","Scotland"))) %>%
    arrange(HealthBoardOfTreatment) %>%
    dplyr::rename(`Health Board of treatment` = HealthBoardOfTreatment) %>%
    make_summary_table(maxrows = 16)
})

#-----------------------#
#### Flu adm pyramid ####
#-----------------------#
# 
# output$flu_adm_pyr_title <- renderUI({h3(glue("Acute influenza hospital admissions by age and sex in Scotland; ",
#                                               input$flu_age_sex_adm_season))})

# pyramid plot that shows the breakdown by age and sex
output$flu_adm_age_sex_pyramid_plot = renderPlotly({
  Admissions_AgeSex_Season %>%
    filter(Pathogen == "flu",
           Sex %in% c("M", "F"),
           Season == input$flu_age_sex_adm_season) %>%
    make_age_sex_adm_pyramid_plot # hospital_admissions_functions
})


output$flu_adm_age_sex_pyramid_table = renderDataTable({

  flu_adm_age_sex_pyramid_table <- Admissions_AgeSex_Season %>%
    filter(Pathogen == "flu",
           Season == input$flu_age_sex_adm_season) %>%
    select(Season, AgeGroup, Sex, Rate) %>%
    mutate(Season = factor(Season)) %>%
    arrange(desc(Season), AgeGroup, Sex) %>%
    dplyr::rename("Season" = "Season",
                  "Age group" = "AgeGroup",
                  "Rate per 100,000" = "Rate") %>%
    mutate(Sex = factor(Sex, levels = c("All", "F", "M")),
           `Age group` = factor(`Age group`, levels =
                                  c("All","Under 18","18-64","65-74","75+"))) %>%
    arrange(desc(`Season`), `Age group`, Sex) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3))

})
# 
# ### LENGTH OF STAY ### ----
# 
# # los plot reactive title
 output$flu_los_title <- renderUI({h3(glue("Influenza length of stay by age group in Season ",
                                           input$los_season_flu))})

# # Plot
 output$flu_los_plot<-  renderPlotly({
   avg_flu_los_plot <- Average_Length_of_Stay %>% 
     filter(Pathogen == "Influenza",
            Season == input$los_season_flu) %>% 
     make_hospital_admissions_los_plot() #function in "/...../indicators/hospital_admissions/hospital_admissions_functions.R"
   
 })

# # Table
output$flu_los_table <- renderDataTable({
  avg_flu_los_table <- Average_Length_of_Stay %>% 
    filter(Pathogen == "Influenza",
           Season == input$los_season_flu) %>% 
    mutate(AverageLengthOfStay = round(AverageLengthOfStay,2)) %>% 
    select(Season, 'Age group' = AgeGroup, 'Average Length of stay' = AverageLengthOfStay)
})

