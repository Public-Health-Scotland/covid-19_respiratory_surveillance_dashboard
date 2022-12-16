
###########################
### HOSPITAL ADMISSIONS ###
###########################

# Daily Hospital Admissions plot
make_hospital_admissions_plot <- function(data){

  # Wrangle Data
  data <- data %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(AdmissionDate = convert_opendata_date(AdmissionDate))

  # Provisional data
  prov_data <- data %>%
    filter(ProvisionalFlag == 1) %>%
    select(AdmissionDate, TotalInfections, SevenDayAverage)

  # Remainder of the data
  non_prov_data <- data %>%
    filter(ProvisionalFlag == 0) %>%
    select(AdmissionDate, TotalInfections, SevenDayAverage)

  # Create axis titles
  yaxis_title <- "Number of admissions"
  xaxis_title <- ""

  #Modifying standard layout
  yaxis_plots[["title"]] <- yaxis_title
  xaxis_plots[["title"]] <- xaxis_title

  #Text for tooltip
  tooltip_trend <- c(paste0("Date: ", format(non_prov_data$AdmissionDate, "%d %b %y"),
                            "<br>", "Admissions: ", non_prov_data$TotalInfections,
                            "<br>", "7 day average: ", format(non_prov_data$SevenDayAverage, nsmall=0, digits=3)))

  # Text for tooltip (provisional data)
  tooltip_trend_prov <- c(paste0("Provisional data: ",
                                 "<br>", "Date: ", format(prov_data$AdmissionDate, "%d %b %y"),
                                 "<br>", "Admissions: ", prov_data$TotalInfections,
                                 "<br>", "7 day average: ", format(prov_data$SevenDayAverage, nsmall=0, digits=3)))

  #Creating time trend plot
  p <- plot_ly(non_prov_data, x = ~AdmissionDate) %>%
    add_lines(y = ~TotalInfections,
              line = list(color = phs_colours("phs-blue-30")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Daily hospital admissions") %>%
    add_lines(y = ~SevenDayAverage,
              line = list(color = phs_colours("phs-blue")),
              text = tooltip_trend, hoverinfo = "text",
              name = "7 day average") %>%

     # Add in provisional data
    add_lines(data = prov_data,
               x = ~AdmissionDate,
               y = ~TotalInfections,
               line = list(color = phs_colours("phs-graphite-10")),
               text = tooltip_trend_prov, hoverinfo = "text",
               name = "Daily hospital admissions (provisional)") %>%
    add_lines(data = prov_data,
              y = ~SevenDayAverage,
              line=list(color = phs_colours("phs-graphite")),
              text = tooltip_trend_prov, hoverinfo = "text",
              name = "7 day average (provisional)") %>%

  # Add in vertical lines
    # Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                        ycol = "TotalInfections",
                        xs= c("2022-01-06", "2022-05-01"),
                        notes=c("From 5 Jan cases  include PCR + LFD",
                                "Change in testing policy on 1 May"),
                        colors=c(phs_colours("phs-rust"),
                                 phs_colours("phs-purple"))) %>%
  # Add layout and config
    layout(margin = list(b = 80, t = 5),
                yaxis = yaxis_plots, xaxis = xaxis_plots,
                legend = list(x = 100, y = 0.5),
                paper_bgcolor = phs_colours("phs-liberty-10"),
                plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)


  return(p)

}

# Weekly Admissions by SIMD plot
make_hospital_admissions_simd_plot <- function(data){

  data <- Admissions_SimdTrend

  data %<>%
    arrange(desc(WeekEnding)) %>%
    mutate(WeekEnding = convert_opendata_date(WeekEnding))

  yaxis_plots[["title"]] <- "Number of admissions"
  xaxis_plots[["title"]] <- "Week ending"

  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~NumberOfAdmissions, split = ~SIMD, text=~SIMD,
              type="scatter", mode="lines",
              color=~SIMD,
              colors=phs_colours(c("phs-blue", "phs-liberty-30", "phs-liberty-30",
                                   "phs-liberty-30", "phs-green")),
              hovertemplate = paste0('<b>Week ending</b>: %{x}<br>',
                                     '<b>SIMD quintile</b>: %{text}<br>',
                                     '<b>Number of admissions</b>: %{y}')
    ) %>%
    layout(margin = list(b = 80, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%

    config(displaylogo = FALSE, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove)

  return(p)

}

# Hospital Admissions LOS plot
make_hospital_admissions_los_plot <- function(data){

  table <- data %>%
    arrange(desc(AdmissionWeekEnding)) %>%
    mutate(AdmissionWeekEnding = convert_opendata_date(AdmissionWeekEnding),
           Percent = ProportionOfAdmissions*100) %>%
    select(AdmissionWeekEnding, AgeGroup, LengthOfStay, Percent) %>%
    dplyr::rename(`Week Ending` = AdmissionWeekEnding,
                  `Age Group` = AgeGroup,
                  `Length of Stay` = LengthOfStay)

  table = table %>%
    filter(`Age Group` == input$los_age) %>%
    mutate(`Length of Stay` = factor(`Length of Stay`,
                                     levels = c("1 day or less",
                                                "2-3 days", "4-5 days",
                                                "6-7 days", "8+ days")))

  tooltip_trend <- paste0("Week ending: ", format(table$`Week Ending`, "%d %b %y"), "<br>",
                        "Length of stay: ", table$`Length of Stay`, "<br>",
                        "Percent: ", round(table$Percent, 1), "%")

  xaxis_plots[["title"]] <- 'Admission date by Week Ending'
  yaxis_plots[["title"]] <- 'Percentage of Admissions'
  yaxis_plots[["ticksuffix"]] <- "%"

  p <- table %>%
    plot_ly(x = ~`Week Ending`,
            y = ~Percent,
            color = ~`Length of Stay`,
            type = 'bar',
            colors = paste(phsstyles::phs_palettes$`main-blues`),
            text = tooltip_trend,
            hoverinfo = "text"#,
           # marker = list(line = list(width=.5,
          #                            color = 'rgb(0,0,0)'))
          ) %>%
    layout(barmode = "stack",
           yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

    return(p)
}

######################
### ICU ADMISSIONS ###
######################

# Daily ICU admissions plot
make_icu_admissions_plot <- function(data){

  # Wrangle Data
  data <- data %>%
    arrange(desc(DateFirstICUAdmission)) %>%
    mutate(DateFirstICUAdmission = convert_opendata_date(DateFirstICUAdmission)) %>%
    select(DateFirstICUAdmission, NewCovidAdmissionsPerDay, SevenDayAverage)

  # Create axis titles
  yaxis_title <- "Number of ICU admissions"
  xaxis_title <- ""

  #Modifying standard layout
  yaxis_plots[["title"]] <- yaxis_title
  xaxis_plots[["title"]] <- xaxis_title

  #Text for tooltip
  tooltip_trend <- c(paste0("Date: ", format(data$DateFirstICUAdmission, "%d %b %y"),
                            "<br>", "ICU Admissions: ", data$NewCovidAdmissionsPerDay,
                            "<br>", "7 Day Average: ", format(data$SevenDayAverage, nsmall=0, digits=3)))


  #Creating time trend plot
  p <- plot_ly(data, x = ~DateFirstICUAdmission) %>%
    add_lines(y = ~NewCovidAdmissionsPerDay, line = list(color = '#0078D4', width=0.8),
              text = tooltip_trend, hoverinfo = "text",
              name = "Count") %>%
    add_lines(y = ~SevenDayAverage, line = list(color = '#000000'),
              text = tooltip_trend, hoverinfo = "text",
              name = "7 day average") %>%
    #Layout
    layout(margin = list(b = 80, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove )

  return(p)

}

########################################
### HOSPITAL ADMISSIONS BY ETHNICITY ###
########################################

# Hospital Admissions by Ethnicity Plot
make_hospital_admissions_ethnicity_plot <- function(data){

  yaxis_title <- "COVID-19 Admissions"

  yaxis_plots[["title"]] <- yaxis_title

  # Star out any NAs for tooltip trend
  data2 <- data %>%
    mutate(across(.cols = starts_with(c("admissions", "percentage")), ~ ifelse(is.na(.), "*", as.character(.))))

  #Text for tooltip
  tooltip_trend <- c(paste0("Month: ", format(data2$month_begining, "%b %Y"),
                            "<br>",yaxis_title, " - White: ", data2$admissions_white, " (", data2$percentage_white,"%)",
                            "<br>",yaxis_title, " - Black/Caribbean: ", data2$admissions_caribbean_or_black," (", data2$percentage_caribbean_or_black,"%)",
                            "<br>",yaxis_title, " - Mixed/Multiple Ethnic Groups: ", data2$admissions_mixed_or_multiple_ethnic_groups," (", data2$percentage_mixed_or_multiple_ethnic_groups,"%)",
                            "<br>",yaxis_title, " - African: ", data2$admissions_african," (", data2$percentage_african,"%)",
                            "<br>",yaxis_title, " - Asian/Asian Scottish/Asian British: ", data2$admissions_asian_asian_scottish_or_asian_british," (", data2$percentage_asian_asian_scottish_or_asian_british,"%)",
                            "<br>",yaxis_title, " - Other: ", data2$admissions_other," (", data2$percentage_other,"%)",
                            "<br>",yaxis_title, " - Unknown: ", data2$admissions_unknown," (", data2$percentage_unknown,"%)"))

  #Creating time trend plot
  plot_ly(data = data, x = ~month_begining) %>%
    add_lines(y = ~data$admissions_white, line = list(color = phs_colors("phs-purple")),
              text = tooltip_trend, hoverinfo="text",
              name = "White") %>%
    add_lines(y = ~data$admissions_caribbean_or_black, line = list(color = phs_colors("phs-magenta")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Black/Caribbean") %>%
    add_lines(y = ~data$admissions_mixed_or_multiple_ethnic_groups, line = list(color = phs_colors("phs-teal")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Mixed/Multiple Ethnic Groups") %>%
    add_lines(y = ~data$admissions_african, line = list(color = phs_colors("phs-rust")),
              text = tooltip_trend, hoverinfo = "text",
              name = "African") %>%
    add_lines(y = ~data$admissions_asian_asian_scottish_or_asian_british, line = list(color = phs_colors("phs-green")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Asian/Asian Scottish/Asian British") %>%
    add_lines(y = ~data$admissions_other, line = list(color = phs_colors("phs-liberty")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Other") %>%
    add_lines(y = ~data$admissions_unknown, line = list(color = phs_colors("phs-blue")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Unknown") %>%
    #Layout
    layout(margin = list(b = 80, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove )
}

# Hospital Admissions by Ethnicity (Percentage) Plot
make_hospital_admissions_ethnicity_perc_plot <- function(data){

  yaxis_title <- "% of COVID-19 Admissions"

  yaxis_plots[["title"]] <- yaxis_title

  # Star out any NAs for tooltip trend
  data2 <- data %>%
    mutate(across(.cols = starts_with(c("admissions", "percentage")), ~ ifelse(is.na(.), "*", as.character(.))))

  #Text for tooltip
  tooltip_trend <- c(paste0("Month: ", format(data2$month_begining, "%b %Y"),
                            "<br>COVID-19 Admissions -  White: ", data2$admissions_white, " (", data2$percentage_white,"%)",
                            "<br>COVID-19 Admissions -  Black/Caribbean: ", data2$admissions_caribbean_or_black," (", data2$percentage_caribbean_or_black,"%)",
                            "<br>COVID-19 Admissions -  Mixed/Multiple Ethnic Groups: ", data2$admissions_mixed_or_multiple_ethnic_groups," (", data2$percentage_mixed_or_multiple_ethnic_groups,"%)",
                            "<br>COVID-19 Admissions -  African: ", data2$admissions_african," (", data2$percentage_african,"%)",
                            "<br>COVID-19 Admissions -  Asian/Asian Scottish/Asian British: ", data2$admissions_asian_asian_scottish_or_asian_british," (", data2$percentage_asian_asian_scottish_or_asian_british,"%)",
                            "<br>COVID-19 Admissions -  Other: ", data2$admissions_other," (", data2$percentage_other,"%)",
                            "<br>COVID-19 Admissions -  Unknown: ", data2$admissions_unknown," (", data2$percentage_unknown,"%)"))

  #Creating time trend plot
  plot_ly(data = data, x = ~month_begining) %>%
    add_lines(y = ~data$percentage_white, line = list(color = phs_colors("phs-purple")),
              text = tooltip_trend, hoverinfo="text",
              name = "White") %>%
    add_lines(y = ~data$percentage_caribbean_or_black, line = list(color = phs_colors("phs-magenta")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Black/Caribbean") %>%
    add_lines(y = ~data$percentage_mixed_or_multiple_ethnic_groups, line = list(color = phs_colors("phs-teal")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Mixed/Multiple Ethnic Groups") %>%
    add_lines(y = ~data$percentage_african, line = list(color = phs_colors("phs-rust")),
              text = tooltip_trend, hoverinfo = "text",
              name = "African") %>%
    add_lines(y = ~data$percentage_asian_asian_scottish_or_asian_british, line = list(color = phs_colors("phs-green")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Asian/Asian Scottish/Asian British") %>%
    add_lines(y = ~data$percentage_other, line = list(color = phs_colors("phs-liberty")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Other") %>%
    add_lines(y = ~data$percentage_unknown, line = list(color = phs_colors("phs-blue")),
              text = tooltip_trend, hoverinfo = "text",
              name = "Unknown") %>%
    #Layout
    layout(margin = list(b = 80, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(x = 100, y = 0.5),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove )

}

