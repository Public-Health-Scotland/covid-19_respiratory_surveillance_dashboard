
###########################
### HOSPITAL ADMISSIONS ###
###########################

# Weekly  Hospital Admissions plot
# need to  split the last week of admission data from the rest of the data and flag it as provisional
# BUT to show it as a line on the chart - need to slice the last 2 week's of data (i.e a start & end date)
# BUT to allow the hover text for the last data point of the **non-provisional** data  to show
# the provisional data must show a gap on the x-axis. This is done by creating
# a proxy start date (i.e. Sunday plus one) for the plotted provisional data. 
# to further complicate things the  provisional data's hover text needs to only appear over the last Sunday, 
# (i.e.not over the proxy Monday date point). To do this the  wrangle creates **a 3rd dataframe**
# that only contains the last Sunday's datafor use asthe hover text (but it has no line element)

make_hospital_admissions_plot <- function(data){

  # Wrangle Data
  data <-data %>%
    arrange(desc(AdmissionDate)) %>%
    mutate(AdmissionDate = convert_opendata_date(AdmissionDate))

  # slice last two weeks of data for use in provisional line on chart
  prov_data_2wk<-  slice_head(data, n = 2) %>% 
    select(AdmissionDate, TotalInfections) 
  
  min_last_sun_date <- min(prov_data_2wk$AdmissionDate) # use to create proxy date
  
  prov_data_2wk%<>%
    mutate(proxy_day = ifelse(AdmissionDate == min_last_sun_date ,  1, 0)) %>% # use to add a day to the start of the dataframe
    mutate(AdmissionDate_Adj= AdmissionDate+proxy_day) %>% 
    select(AdmissionDate=AdmissionDate_Adj, TotalInfections) # provisional proxy now has a day gap between it and the non-provional data
  
  # Provisional data used for hover text
  prov_data_1wk <- data %>%
    filter(ProvisionalFlag == 1) %>%
    select(AdmissionDate, TotalInfections)

  # Remainder of the data
  non_prov_data <- data %>%
    filter(ProvisionalFlag == 0) %>%
    select(AdmissionDate, TotalInfections)

  # Create axis titles
  yaxis_title <- "Number of admissions"
  xaxis_title <- ""

  #Modifying standard layout
  yaxis_plots[["title"]] <- yaxis_title
  xaxis_plots[["title"]] <- xaxis_title

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  #Text for tooltip
  tooltip_trend <- c(paste0("Week ending: ", format(non_prov_data$AdmissionDate, "%d %b %y"),
                            "<br>", "Admissions: ", non_prov_data$TotalInfections))
                           
  # Text for tooltip (provisional data, using 1 week dataframe)
  tooltip_trend_prov <- c(paste0("Provisional data: ",
                                 "<br>", "Week ending: ", format(prov_data_1wk$AdmissionDate, "%d %b %y"),
                                 "<br>", "Admissions: ", prov_data_1wk$TotalInfections))

    
    # #Creating time trend plot
    p <- plot_ly(non_prov_data, x = ~AdmissionDate) %>%
    add_lines(y = ~TotalInfections,
              line = list(color = "navy"),
              text = tooltip_trend, hoverinfo = "text",
              name = "Weekly hospital admissions") %>%

    # # Add in provisional data using 2 weeks of data
    add_lines(data = prov_data_2wk,
              x = ~AdmissionDate,
              y = ~TotalInfections,
              line = list(color = phs_colours("phs-graphite-50"),
                          dash = "dash"), # make it dashed to mask the "missing day" of data
              hoverinfo = "none", # no hover for this line
    # text = tooltip_trend_prov, hoverinfo = "text",
     name = "Weekly hospital admissions (provisional)") %>%
    # 
    # # Add in provisional dataframe with only the Sunday for use in the hover text
    add_lines(data = prov_data_1wk,
              x = ~AdmissionDate,
              y = ~TotalInfections,
              line = list(color = phs_colours("phs-graphite-50")),
              text = tooltip_trend_prov, hoverinfo = "text",
              showlegend = FALSE 
              ) %>%

  # Add in vertical lines
    # Adding vertical lines for notes on chart
    add_lines_and_notes(dataframe = data,
                        ycol = "TotalInfections",
                        xs= c("2022-01-06", "2022-05-01"),
                        notes=c("From 5 Jan cases  include PCR + LFD",
                                "Change in testing policy on 1 May"),
                        colors=c(phs_colours("phs-teal"),
                                 phs_colours("phs-purple"))) %>%
  # Add layout and config
    layout(margin = list(b = 80, t = 5),
                yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
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

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  p <- plot_ly(data) %>%
    add_trace(x = ~WeekEnding, y = ~NumberOfAdmissions, split = ~SIMD, text=~SIMD,
              type="scatter", mode="lines",
              color=~SIMD,
              colors=phs_colours(c("phs-rust", "phs-liberty-30", "phs-liberty-30",
                                   "phs-liberty-30", "phs-blue")),
              linetype = ~SIMD,
              linetypes = c("dash", "solid", "solid", "solid", "dot"),
              hovertemplate = paste0('<b>Week ending</b>: %{x}<br>',
                                     '<b>SIMD quintile</b>: %{text}<br>',
                                     '<b>Number of admissions</b>: %{y}')
    ) %>%
    layout(margin = list(b = 100, t = 5),
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h'),
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

  xaxis_plots[["title"]] <- 'Admission date by week ending'
  yaxis_plots[["title"]] <- 'Percentage of admissions'
  yaxis_plots[["ticksuffix"]] <- "%"

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  p <- table %>%
    plot_ly(x = ~`Week Ending`,
            y = ~Percent,
            color = ~`Length of Stay`,
            type = 'bar',
            colors = paste(phs_palettes$`main-blues`),
            text = tooltip_trend,
            hoverinfo = "text",
            marker = list(line = list(width=.5,
                                      color = 'rgb(0,0,0)'))
          ) %>%
    layout(barmode = "stack",
           yaxis = yaxis_plots,
           xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.6, orientation = 'h', traceorder = 'normal'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>%
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE,
           modeBarButtonsToRemove = bttn_remove )

  return(p)

}


########################################
### HOSPITAL ADMISSIONS BY ETHNICITY ###
########################################

# Hospital Admissions by Ethnicity Plot
make_hospital_admissions_ethnicity_plot <- function(data){

  yaxis_plots[["title"]] <- "COVID-19 admissions"

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE


  #Creating time trend plot
  p <- plot_ly(data = data,
          text = ~paste0("<b>Month beginning</b>: ", format(MonthBegining, "%b %Y") ,"\n",
                        "<b>Ethnic group</b>: ", EthnicGroup, "\n",
                        "<b>Hospital admissions</b>: ", format(Admissions, big.mark=",")),
          hovertemplate = "%{text}",
          textposition = "none"
          ) %>%
    add_trace(x = ~MonthBegining,
              y = ~Admissions,
              color = ~EthnicGroup,
              colors = phs_colours(c("phs-graphite",
                                     "phs-purple",
                                     "phs-teal",
                                     "phs-blue",
                                     "phs-green",
                                     "phs-magenta",
                                     "phs-rust")),
              type = "bar",
              marker = list(line = list(width=.5,
                                        color = 'rgb(0,0,0)'))) %>%
    #Layout
    layout(margin = list(b = 100, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", yanchor = "top", x = 0.5, y = -0.8, orientation = 'h'),
           barmode = "stack",
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
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

  yaxis_plots[["title"]] <- "Number of ICU admissions"
  xaxis_plots[["title"]] <- "Date of admission"

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  #Text for tooltip
  tooltip_trend <- c(paste0("Date: ", format(data$DateFirstICUAdmission, "%d %b %y"),
                            "<br>", "ICU admissions: ", data$NewCovidAdmissionsPerDay,
                            "<br>", "7 Day average: ", format(data$SevenDayAverage, nsmall=0, digits=3)))


  #Creating time trend plot
  p <- plot_ly(data,
               x = ~DateFirstICUAdmission) %>%
    add_lines(y = ~NewCovidAdmissionsPerDay,
              line = list(color = phs_colours("phs-blue-30")),
              text = tooltip_trend, hoverinfo = "text",
              name = "ICU admissions") %>%
    add_lines(y = ~SevenDayAverage,
              line = list(color = "navy",
                          dash = "dash"),
              text = tooltip_trend, hoverinfo = "text",
              name = "7 day average") %>%
    #Layout
    layout(margin = list(b = 80, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove )

  return(p)

}


# Daily ICU admissions plot
make_icu_admissions_weekly_plot <- function(data){

  # Wrangle Data
  data <- data %>%
    arrange(desc(WeekEndingFirstICUAdmission)) %>%
    mutate(WeekEndingFirstICUAdmission = convert_opendata_date(WeekEndingFirstICUAdmission)) %>%
    select(WeekEndingFirstICUAdmission, NewCovidAdmissionsPerWeek)

  yaxis_plots[["title"]] <- "Number of ICU admissions"
  xaxis_plots[["title"]] <- "Week ending of admission"

  # Adding slider
  xaxis_plots[["rangeslider"]] <- list(type = "date")
  yaxis_plots[["fixedrange"]] <- FALSE

  #Text for tooltip
  tooltip_trend <- c(paste0("Week ending: ", format(data$WeekEndingFirstICUAdmission, "%d %b %y"),
                            "<br>", "ICU admissions: ", data$NewCovidAdmissionsPerWeek))


  #Creating time trend plot
  p <- plot_ly(data,
               x = ~WeekEndingFirstICUAdmission) %>%
    add_lines(y = ~NewCovidAdmissionsPerWeek,
              line = list(color = "navy"),
              text = tooltip_trend, hoverinfo = "text",
              name = "ICU admissions") %>%
    #Layout
    layout(margin = list(b = 80, t = 5), #to avoid labels getting cut out
           yaxis = yaxis_plots, xaxis = xaxis_plots,
           legend = list(xanchor = "center", x = 0.5, y = -0.5, orientation = 'h'),
           paper_bgcolor = phs_colours("phs-liberty-10"),
           plot_bgcolor = phs_colours("phs-liberty-10")) %>% #position of legend
    # leaving only save plot button
    config(displaylogo = F, displayModeBar = TRUE, modeBarButtonsToRemove = bttn_remove )

  return(p)

}

