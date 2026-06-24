
altTextServer("duodetections_cari_modal",
              title = "CARI - Relative frequency (%) of each pathogen in all samples with two-pathogen co-detections",
              content = tags$ul(tags$li("This is a plot showing how often each individual pathogen is identified (expressed as a percentage of all pathogens identified) in all samples with two-pathogen co-detections in the Community Acute Respiratory Infection (CARI) surveillance programme."),
                                tags$li("The x axis shows the ISO week of sample, from week 40 to week 39. Week 40 is typically the start of October and when the winter respiratory season starts."),
                                tags$li("The y axis is the percentage of all pathogens identified.")))

altTextServer("codetections_cari_modal",
              title = "CARI - Proportion of positive samples that are co-detections by age group",
              content = tags$ul(tags$li("This is a plot showing the proportion of positive samples that are co-detections in the Community Acute Respiratory Infection (CARI) surveillance programme, by age group."),
                                tags$li("The x axis is the four-week ending date, starting October 2022."),
                                tags$li("The y axis is the percentage of positive samples.")))


# CARI - Overall Rhinovirus swabpos table
output$duodetections_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_duodetections %>%
    arrange(desc(WeekEnding), desc(pathogen)) %>%
    select(Season, ISOWeekNo, pathogen, perc) %>%
    mutate(pathogen = as.character(pathogen)) %>%
    mutate(Season = factor(Season),
           ISOWeekNo = factor(ISOWeekNo),
           pathogen = factor(pathogen)) %>%
    mutate(perc = round_half_up(perc,1)) %>%
    rename(`ISO Week` = ISOWeekNo,
           `Pathogen` = pathogen,
           `Percentage (%)` = perc) %>%
    make_table(add_separator_cols_1dp = c(4),
               filter_cols = c(1,2,3))
})


# CARI - Overall Rhinovirus swabpos plot
output$duodetections_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_duodetections %>%
    filter(Season==input$cari_season) %>% 
    mutate(ISOWeekNo = as.numeric(ISOWeekNo)) %>% 
    create_cari_duodetection_chart_stacked()

})


# CARI - Overall Rhinovirus swabpos table
output$codetections_cari_table <- renderDataTable({
  Respiratory_Pathogens_CARI_codetections %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("All ages", "0-4 years", "5-14 years",
                                                  "15-44 years", "45-64 years", "65+ years"))) %>%
    arrange(desc(FourWeekEnding), AgeGroup) %>%
    mutate(AgeGroup = factor(AgeGroup)) %>%
    select(FourWeekEnding, AgeGroup, perc) %>%
    mutate(perc = round_half_up(perc,1)) %>%
    rename(`Four-Week Ending` = FourWeekEnding,
           `Age Group` = AgeGroup,
           `Percentage of positive samples (%)` = perc) %>%
    make_table(add_separator_cols_1dp = c(3),
               filter_cols = c(1,2))
})


# CARI - Overall Rhinovirus swabpos plot
output$codetections_cari_plot <- renderPlotly({
  Respiratory_Pathogens_CARI_codetections %>%
    mutate(AgeGroup = factor(AgeGroup, levels = c("All ages", "0-4 years", "5-14 years",
                                                  "15-44 years", "45-64 years", "65+ years"))) %>%
    filter(AgeGroup %in% input$codetection_cari_selected_age) %>%
    create_cari_codetection_age_linechart()
  
})

