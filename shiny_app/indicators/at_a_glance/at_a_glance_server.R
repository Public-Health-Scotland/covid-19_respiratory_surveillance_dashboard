### Setup data -----
#cases labels-(matches covid-cases data set)
# 
# latest_week_cases_title <- Cases_Weekly %>%
#   tail(1) %>%
#   select(WeekEnding) %>%
#   convert_opendata_date()
# 
# latest_week_cases_title %<>%
#     format("%d %b %y")
# 
# previous_week_cases_title <- Cases_Weekly %>%
#   tail(2) %>%
#   filter(WeekEnding== min(WeekEnding)) %>%
#   select(WeekEnding) %>%
#   convert_opendata_date()
# 
# previous_week_cases_title %<>%
#   format("%d %b %y")
# 
# # admissions labels- (matches Respiratory_admissions_summary data set)
# latest_week_admissions_title <- admissions_scotland %>%
#   tail(1) %>%
#   select(WeekEnding)
# 
# # Convert to the correct format
# latest_week_admissions_title$WeekEnding<- format(latest_week_admissions_title$WeekEnding, "%d %b %y")
# 
# # make it a value
# latest_week_admissions_title <- latest_week_admissions_title$Date
# 
# previous_week_admissions_title <- admissions_scotland %>%
#   filter(Pathogen=='RSV') %>%
#   tail(2) %>%
#   filter(WeekEnding== min(WeekEnding)) %>%
#   select(WeekEnding)
# 
# # Convert to correct format
#  previous_week_admissions_title$WeekEnding<- format(previous_week_admissions_title$WeekEnding, "%d %b %y")
# 
# # make it a value
# previous_week_admissions_title <- previous_week_admissions_title$WeekEnding
# 
# # occupancy labels- (uses weekly covid HB occupancy i.e. same dataframe that produces the table)
# 
# # latest_week_occupancy_title<- Occupancy_Weekly_Hospital_HB %>%
# #      filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
# #      tail(1) %>%
# #      select(Date=WeekEnding)
# # # Convert to the correct format
# # latest_week_occupancy_title$Date<- format(latest_week_occupancy_title$Date, "%d %b %y")
# # 
# # # Convert to the correct format
# # latest_week_occupancy_title<-latest_week_occupancy_title$Date
# # 
# # previous_week_occupancy_title<- Occupancy_Weekly_Hospital_HB %>%
# #      filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
# #      tail(2) %>%
# #      select(Date=WeekEnding) %>%
# #      filter(Date== min(Date))
# # 
# # # Convert to the correct format
# #    previous_week_occupancy_title$Date<- format(previous_week_occupancy_title$Date, "%d %b %y")
# # 
# # # makle it a value
# #    previous_week_occupancy_title<- previous_week_occupancy_title$Date
# 
# latest_week_occupancy_title <- occupancy_rapid_new %>%
#   tail(1) %>%
#   select(WeekEnding) %>%
#   mutate(WeekEnding = format(WeekEnding, "%d %b %y")) %>%
#   .$WeekEnding
# 
# previous_week_occupancy_title <- occupancy_rapid_new %>%
#   tail(4) %>%
#   select(WeekEnding) %>%
#   filter(WeekEnding == min(WeekEnding)) %>%
#   mutate(WeekEnding = format(WeekEnding, "%d %b %y")) %>%
#   .$WeekEnding
# 
# # create value to produce population rate values
# pop_scot_total <- i_population_v2 %>%
#   filter(AgeGroup == "Total", Sex == "Total") %>%
#   .$PopNumber
# 
# 
# ### Cases
# 
# # create intermediate data frames for covid,flu and non-flu pathogens
# # limit  each data frame to the last 2 weeks and add a flag latest week /previous week
# # pivot the tables by dates
# # Order the pathogens in a consistent manner
# # join into one table
# # rename and add week titles for the dashboard
# 
# covid_cases_intro <- Cases_Weekly %>%
#   tail(2) %>% # retain last 2 weeks
#   rename(cases_number =NumberCasesPerWeek) %>%
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   mutate(flag = ifelse(WeekEnding ==max(WeekEnding), "latest_week", "previous_week")) %>%
#   select(-Cumulative, -WeekEnding) %>%
#   pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
#   mutate(Pathogen = "COVID-19")
# 
# flu_cases_intro <- Respiratory_AllData %>%
#   arrange(Date) %>% 
#   filter(FluOrNonFlu == "flu") %>%
#   filter(Organism == "Influenza - Type A or B") %>%
#   filter(BreakDown == "Scotland") %>%
#   tail(2) %>%
#   group_by(Date) %>%
#   summarise(cases_number = sum(Count)) %>%
#   ungroup() %>%
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   mutate(flag = ifelse(Date==max(Date), "latest_week", "previous_week")) %>%
#   select(-Date) %>%
#   pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
#   mutate(Pathogen = "Influenza")
# 
# nonflu_cases_intro <- Respiratory_AllData %>%
#   arrange(Date) %>% 
#   filter(FluOrNonFlu == "nonflu") %>%
#   filter(Organism != "Total") %>%
#   filter(BreakDown == "Scotland") %>%
#      tail(14) %>% # 7 pathogens, last 2 weeks
#   group_by(Date, Organism) %>%
#   summarise(cases_number = sum(Count)) %>%# simplify the dataframe
#   ungroup() %>%
#   mutate(flag = ifelse(Date==max(Date), "latest_week", "previous_week")) %>% # add flag
#   select(-Date) %>%
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
#   select(-c(flag_latest_week, flag_previous_week)) %>%
#   rename(Pathogen = Organism) %>%
#   mutate(Pathogen = recode(Pathogen, "Seasonal coronavirus (Non-SARS-CoV-2)"="Seasonal Coronavirus (non-COVID-19)")) %>%
#   mutate(Pathogen =  factor(Pathogen, levels = c("Respiratory syncytial virus", "Adenovirus", "Human metapneumovirus",
#                                                  "Mycoplasma pneumoniae", "Parainfluenza virus", "Rhinovirus",
#                                                  "Seasonal Coronavirus (non-COVID-19)"))) %>%
#   arrange(Pathogen)
# 
# # combine the three intermediate dataframes
# cases_intro <- covid_cases_intro %>%
#   bind_rows(flu_cases_intro) %>%
#   bind_rows(nonflu_cases_intro) %>%
#   select(Pathogen,
#          'Number of cases (previous week)'= cases_number_previous_week,
#          'Rate per 100,000 population (previous week)'= cases_rate_previous_week,
#          'Number of cases (latest week)'= cases_number_latest_week,
#          'Rate per 100,000 population (latest week)'= cases_rate_latest_week
#          )
# 
# 
# colnames(cases_intro)[4] <- paste("Number of cases (", as.character(latest_week_cases_title),")")
# colnames(cases_intro)[5] <- paste("Rate per 100,000 population (", as.character(latest_week_cases_title),")")
# colnames(cases_intro)[2] <- paste("Number of cases (", as.character(previous_week_cases_title),")")
# colnames(cases_intro)[3] <- paste("Rate per 100,000 population (", as.character(previous_week_cases_title),")")
# 
# ###Hosp Adms
# # create intermediate data frames for covid,flu and rsv using Respiratory_admissions_summary dataframe
# # (same dataframe as that used for admissions graph below)
# # limit  each data frame to the last 2 weeks and add a flag latest week /previous week
# # pivot the tables by flags
# # Order the pathogens in a consistent manner
# # join into one table
# # rename and add week titles for the dashboard
# 
# hosp_adms_intro <- admissions_scotland %>%
#   filter(!Pathogen %in% c("Influenza A", "Influenza B")) %>%
#   tail(18) %>%
#   mutate(flag = ifelse(WeekEnding==max(WeekEnding), "latest_week", "previous_week")) %>%
#   select(-WeekEnding) %>%
#   #mutate(admissions_rate = round_half_up(100000 * Admissions / pop_scot_total,1)) %>%
#   select(flag, Pathogen, admissions_number = NumberAdmissionsPerWeek,
#          admissions_rate=RateAdmissionsPerWeek) %>%
#    pivot_wider(names_from = flag, values_from = admissions_number:admissions_rate) %>%
#   select(Pathogen,
#          'Number of admissions (previous week)'= admissions_number_previous_week,
#          'Rate of admissions per 100,000 population (previous week)'= admissions_rate_previous_week,
#          'Number of admissions (latest week)'= admissions_number_latest_week,
#          'Rate of admissions per 100,000 population (latest week)'= admissions_rate_latest_week  ) %>%
#   mutate(Pathogen =  factor(Pathogen, levels = c("COVID-19", "Influenza (All)", "RSV", "Adenovirus",  "HMPV",  "Mycoplasma pneumoniae", "Parainfluenza (Any Type)", "Rhinovirus", "Seasonal coronavirus"))) %>%
#   arrange(Pathogen) %>%
#   mutate(Pathogen=if_else(Pathogen=="RSV", "Respiratory syncytial virus", Pathogen)) %>% 
#   mutate(Pathogen=if_else(Pathogen=="Seasonal coronavirus", "Seasonal Coronavirus (non COVID-19)", Pathogen)) %>% 
#   mutate(Pathogen=if_else(Pathogen=="HMPV", "Human Metapneumovirus", Pathogen)) %>% 
#   mutate(Pathogen=if_else(Pathogen=="Parainfluenza (Any Type)", "Parainfluenza", Pathogen)) %>% 
#   mutate(Pathogen=if_else(Pathogen=="Influenza (All)", "Influenza", Pathogen))
# 
# 
# 
# 
# colnames(hosp_adms_intro)[4] <- paste("Number of admissions (", as.character(latest_week_admissions_title),")")
# colnames(hosp_adms_intro)[5] <- paste("Rate of admissions per 100,000 population (", as.character(latest_week_admissions_title),")")
# colnames(hosp_adms_intro)[2] <- paste("Number of admissions (", as.character(previous_week_admissions_title),")")
# colnames(hosp_adms_intro)[3] <- paste("Rate of admissions per 100,000 population (", as.character(previous_week_admissions_title),")")
# 
# ###Inpatients
# # only one data frame at the moment for Covid inpatients
# # limit data frame to the last 2 weeks and add a flag latest week /previous week
# # pivot the tables by flags
# # Order the pathogens in a consistent manner
# # join into one table
# # rename and add week titles for the dashboard
# 
# # covid_inpatients_intro <- Occupancy_Weekly_Hospital_HB %>%
# #   filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
# #   tail(2) %>% #last 2 weeks
# #   mutate(flag= if_else(WeekEnding_od==max(WeekEnding_od),"Latest Week", "Previous Week")) %>% #add flags
# #   select(flag, SevenDayAverage) %>%
# #   pivot_wider(names_from = flag, values_from = SevenDayAverage) %>%
# #   mutate(Pathogen = "COVID-19") %>%
# #   select(Pathogen, `Previous Week`, `Latest Week`)
# # 
# # colnames(covid_inpatients_intro)[3] <- paste("Seven day average number (", as.character(latest_week_occupancy_title),")")
# # colnames(covid_inpatients_intro)[2] <- paste("Seven day average number (", as.character(previous_week_occupancy_title),")")
# 
# inpatients_intro <- occupancy_rapid_new %>%
#   tail(6) %>%
#   mutate(flag= if_else(WeekEnding == max(WeekEnding),"Latest Week", "Previous Week")) %>% #add flags
#   select(Pathogen, flag, SevenDayAverageInpatients) %>%
#   pivot_wider(names_from = flag, values_from = SevenDayAverageInpatients) %>%
#   mutate(Pathogen = case_when(Pathogen=="Influenza (All)" ~ "Influenza",
#                               TRUE ~ Pathogen)) 
# 
# colnames(inpatients_intro)[3] <- paste("Seven day average number (", as.character(latest_week_occupancy_title),")")
# colnames(inpatients_intro)[2] <- paste("Seven day average number (", as.character(previous_week_occupancy_title),")")
# 
# ### Data tables -----
# 
# # Cases table
# output$cases_intro_table <- renderDataTable({
#   cases_intro %>%
#    make_summary_table()
# 
# })
# 
# # Hospital admissions table
# output$hosp_adms_intro_table <- renderDataTable({
#   hosp_adms_intro %>%
#     make_summary_table()
# 
# })
# 
# # Inpatients table
# output$inpatients_intro_table <- renderDataTable({
#   inpatients_intro%>%
#     make_summary_table()
# 
# })
# 
# altTextServer("adms_summary_modal",
#               title = "Number of acute hospital admissions due to each pathogen",
#               content = tags$ul(tags$li("This is a plot of the number of acute hospital admissions due to each of a variety of pathogens."),
#                                 tags$li("The x axis is the week ending"),
#                                 tags$li("The y axis is the number of admissions"),
#                                 tags$li("There are nine traces representing the number of admissions due to each pathogen.")
#               )
# )
# 
# altTextServer("cari_summary_modal",
#               title = "Test positivity in the CARI sentinel surveillance programme",
#               content = tags$ul(tags$li("This is a plot showing the test positivity rate of any and individual pathogens in the Community Acute Respiratory Infection (CARI) surveillance programme."),
#                                 tags$li("The x axis is the week ending date, starting 09 October 2022."),
#                                 tags$li("The y axis is the test positivity rate."),
#                                 tags$li("The plot contains a trace showing the test positivity rate for the selected pathogen(s).")))
# 
# 
# ### Plot -----
# output$hosp_adms_intro_plot <- renderPlotly({
#   admissions_scotland %>%
#     mutate(Pathogen=if_else(Pathogen=="RSV", "Respiratory syncytial virus", Pathogen)) %>% 
#     mutate(Pathogen=if_else(Pathogen=="HMPV", "Human Metapneumovirus", Pathogen)) %>% 
#     mutate(Pathogen=if_else(Pathogen=="Parainfluenza (Any Type)", "Parainfluenza", Pathogen)) %>% 
#     mutate(Pathogen=if_else(Pathogen=="Influenza (All)", "Influenza", Pathogen)) %>% 
#     mutate(Pathogen=if_else(Pathogen=="Mycoplasma pneumoniae", "Mycoplasma Pneumoniae", Pathogen)) %>% 
#     mutate(Pathogen=if_else(Pathogen=="Seasonal coronavirus", "Seasonal Coronavirus (non-COVID-19)", Pathogen)) %>% 
#     mutate(Pathogen =  factor(Pathogen, levels = c("COVID-19", "Influenza", "Respiratory syncytial virus", "Adenovirus",  
#                                                                "Human Metapneumovirus",  "Mycoplasma Pneumoniae", 
#                                                                "Parainfluenza", "Rhinovirus", "Seasonal Coronavirus (non-COVID-19)"))) %>%
#     arrange(Pathogen) %>%
# 
#     #mutate(WeekEnding = ymd(WeekEnding)) %>%
#     make_adms_summary_plot()#create_summary_adms_linechart()
# 
# })
# 
# 
# ### Plot -----
# output$cari_intro_plot <- renderPlotly({
#   cari_at_a_glance %>%
#     filter(Pathogen %in% input$cari_selected_pathogen) %>%
#     create_cari_pathogen_linechart()
#   
# })


#### ALL PATHOGENS AT A GLANCE PLOT


# 
# covid_cases_spark <- Cases_Weekly %>%
# tail(52) %>% # retain last 2 weeks
#   rename(cases_number =NumberCasesPerWeek,
#          Date = WeekEnding) %>%
#   mutate(Date = ymd(Date)) %>%
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   select(-Cumulative) %>%
#   mutate(Pathogen = "COVID-19")
# 
# flu_cases_spark <- Respiratory_AllData %>%
#   arrange(Date) %>% 
#   filter(FluOrNonFlu == "flu") %>%
#   filter(Organism == "Influenza - Type A or B") %>%
#   filter(BreakDown == "Scotland") %>%
#   tail(52) %>%
#   group_by(Date) %>%
#   summarise(cases_number = sum(Count)) %>%
#   ungroup() %>%
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   mutate(Pathogen = "Influenza")
# 
# nonflu_cases_spark <- Respiratory_AllData %>%
#   arrange(Date) %>% 
#   filter(FluOrNonFlu == "nonflu") %>%
#   filter(Organism != "Total") %>%
#   filter(BreakDown == "Scotland") %>%
#   tail(7*52) %>% # 7 pathogens, last 52 weeks
#   group_by(Date, Organism) %>%
#   summarise(cases_number = sum(Count)) %>%# simplify the dataframe
#   ungroup() %>%
#   
#   mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
#   
#   rename(Pathogen = Organism) %>%
#   mutate(Pathogen = recode(Pathogen, "Seasonal coronavirus (Non-SARS-CoV-2)"="Seasonal Coronavirus (non-COVID-19)")) #%>%


################### 

cases_intro_spark <- Respiratory_Pathogens_MEM_Scot %>% 
  select(WeekEnding, Pathogen, cases_number=Count, ActivityLevel) %>% 
  mutate(Pathogen = recode(Pathogen, 
                           "Coronavirus"="Seasonal Coronavirus (non-COVID-19)",
                           "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
                           "Parainfluenza Virus" = "Parainfluenza",
                           "Covid-19" = "COVID-19")) %>%
  mutate(Pathogen = factor(Pathogen, levels = c("COVID-19", "Influenza",
                                                "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
                                                "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
                                                "Seasonal Coronavirus (non-COVID-19)"))) 


cases_intro_spark <- cases_intro_spark %>% 
  tail(52*9) %>%   
  mutate(lab_y_pos = max(cases_number)*0.8,
         lab_x_pos = max(WeekEnding) - weeks(12)) %>% 
  group_by(Pathogen) %>% 
  mutate(change = cases_number - lag (cases_number))


cases_latest <- cases_intro_spark %>% 
  filter(WeekEnding == max(WeekEnding))

# # combine the three intermediate dataframes
# cases_intro_spark <- covid_cases_spark %>%
#   bind_rows(flu_cases_spark) %>%
#   bind_rows(nonflu_cases_spark) %>% 
#   rename(WeekEnding = Date) %>% 
#   mutate(Pathogen = recode(Pathogen, 
#                            "Human metapneumovirus" = "Human Metapneumovirus",
#                            "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
#                            "Parainfluenza virus" = "Parainfluenza",
#                            "Respiratory syncytial virus" = "Respiratory Syncytial Virus")) %>%
#   mutate(Pathogen = factor(Pathogen, levels = c("COVID-19", "Influenza",
#                                                 "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
#                                                 "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
#                                                 "Seasonal Coronavirus (non-COVID-19)"))) 
# cases_intro_spark <- cases_intro_spark %>% 
#   mutate(lab_y_pos = max(cases_number)*0.8,
#          lab_x_pos = max(WeekEnding) - weeks(12)) %>% 
#   group_by(Pathogen) %>% 
#   mutate(change = cases_number - lag (cases_number))
# 
# 
# cases_latest <- cases_intro_spark %>% 
#   filter(WeekEnding == max(WeekEnding))


#### CARI DATA

cari_at_a_glance_spark <- Respiratory_Pathogens_CARI_Scot %>%
  mutate(WeekEnding = as.Date(WeekEnding)) %>%
  filter(Pathogen %in% c("Adenovirus", "COVID-19", "Human Metapneumovirus", "Influenza",
                         "Mycoplasma Pneumoniae", "Parainfluenza Virus",
                         "Respiratory Syncytial Virus", "Rhinovirus", "Seasonal Coronavirus (non-COVID-19)")) %>%
  mutate(Pathogen = ifelse(Pathogen == "Parainfluenza Virus", "Parainfluenza", as.character(Pathogen))) %>%
  mutate(Pathogen = factor(Pathogen, levels = c("COVID-19", "Influenza",
                                                "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
                                                "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
                                                "Seasonal Coronavirus (non-COVID-19)"))) %>% 
  tail(52*9) %>% 
  #group_by(Pathogen) %>% 
  mutate(lab_y_pos = max(SwabPositivity)*0.8,
         lab_x_pos = max(WeekEnding) - weeks(16)) %>%  
  group_by(Pathogen) %>% 
  mutate(change = SwabPositivity - lag (SwabPositivity))

cari_latest <- cari_at_a_glance_spark  %>% 
  filter(WeekEnding == max(WeekEnding))


## ADMISSIONS DATA

admissions_at_a_glance_spark <- admissions_scotland %>%
  filter(!Pathogen %in% c("Influenza A", "Influenza B")) %>% 
  mutate(Pathogen = recode(Pathogen, 
                           "Seasonal coronavirus"="Seasonal Coronavirus (non-COVID-19)",
                           "HMPV" = "Human Metapneumovirus",
                           "Influenza (All)" = "Influenza",
                           "RSV" = "Respiratory Syncytial Virus",
                           "Mycoplasma pneumoniae" = "Mycoplasma Pneumoniae",
                           "Parainfluenza (Any Type)" = "Parainfluenza")) %>%
  mutate(Pathogen = factor(Pathogen, levels = c("COVID-19", "Influenza",
                                                "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
                                                "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
                                                "Seasonal Coronavirus (non-COVID-19)"))) %>% 
  tail(52*9) %>% 
  #group_by(Pathogen) %>% 
  mutate(lab_y_pos = max(NumberAdmissionsPerWeek)*0.8,
         lab_x_pos = max(WeekEnding) - weeks(12)) %>% 
  group_by(Pathogen) %>% 
  mutate(change = NumberAdmissionsPerWeek - lag (NumberAdmissionsPerWeek))

admissions_latest <- admissions_at_a_glance_spark  %>% 
  filter(WeekEnding == max(WeekEnding))




### PLOTTING FUNCTIONS

# # Activity levels
activity_levels <- c("Baseline", "Low", "Medium", "High", "Very high")

# Colours for thresholds
colour_map <- c("Baseline" = "#FDE725FF",
                "Low"= "#5DC863FF",
                "Medium" = "#21908CFF",
                "High" = "#3B528BFF",
                "Very high" = "#440154FF")


colour_map_alpha <- scales::alpha(colour_map, 0.3)

## SPARKLINES ##

sparkline_faceted_plotly <- function(data, latest, 
                                     x, y, facet_var,
                                     colour, title,
                                     label_suffix = "",
                                     left_marg = 20,
                                     right_marg=20, 
                                     Metric = NA) {
  
  facets <- levels(data[[facet_var]])
  x_range <- range(data[[x]], na.rm = TRUE)
  y_range <- range(data[[y]], na.rm = TRUE)
  
  
  # latest <- latest %>%
  #   left_join(
  #     Respiratory_Pathogens_MEM_Scot %>%
  #       filter(WeekEnding == max(WeekEnding)) %>%
  #       mutate(Pathogen = recode(Pathogen,
  #                                "Coronavirus"="Seasonal Coronavirus (non-COVID-19)",
  #                                "Covid-19" = "COVID-19",
  #                                "Parainfluenza Virus" = "Parainfluenza")) %>% 
  #       select(Pathogen, ActivityLevel),
  #     by = "Pathogen"
  #   )
  # 
  
  subplot_list <- lapply(facets, function(f) {
    
    df_f      <- data   %>% filter(.data[[facet_var]] == f)
    latest_f <- latest %>% filter(.data[[facet_var]] == f)
    
    plot_ly(df_f, x = ~.data[[x]], y = ~.data[[y]],
            type = "scatter", mode = "lines",
            line = list(color = colour),
            showlegend=FALSE,
            hovertemplate = paste0(
              "Week ending: %{x|%d %b %Y}<br>",
              "Value: %{y}",
              label_suffix,
              "<extra></extra>")
    ) %>%
      
      # ribbon (area under curve)
      add_ribbons(ymin = 0, ymax = ~.data[[y]],
                  fillcolor = colour,
                  opacity = 0.2,
                  line = list(width = 0),
                  showlegend = FALSE) %>%
      
      # label
      
      
      add_annotations(
        data = latest_f,
        x = ~lab_x_pos,
        y = ~lab_y_pos,
        
        
        text = ~{
          arrow <- ifelse(change > 0, "▲",
                          ifelse(change < 0, "▼", "="))
          
          activity_text <- if(isTRUE(Metric == "Cases")) {
            paste0(
              "<br>",
              "<span style='font-size:16px'>", ActivityLevel, "</span>"
            )
          } else {
            ""
          }
          
          paste0(
            "<b>", .data[[y]], label_suffix, " ", "</b>",
            "<span style='font-size:14px'>", arrow, "</span>",
            activity_text
          )
        }
        ,
        
        showarrow = FALSE,
        
        xanchor = "left",
        align = "center",
        
        # ✅ BOX STYLING
        bgcolor = ~ifelse(
          Metric == "Cases",
          colour_map_alpha[ActivityLevel],  # coloured for cases
          "white"                           # neutral for others
        ),
        
        bordercolor = "black",
        borderwidth = 1,
        borderpad = 6,
        
        font = list(size = 14, color = "black"),
        opacity = 1
      ) %>%
      
      layout(
        yaxis = list(title = "", 
                     showticklabels = FALSE, 
                     zeroline = FALSE,
                     range=y_range),
        xaxis = list(
          range = x_range,
          title = "Week Ending",
          tickformat = "%b",
          dtick = "M3"
        ),
        margin = list(l = left_marg, r = right_marg, t = 60, b = 40)
      )
  })
  
  subplot(
    subplot_list,
    nrows = length(facets),
    shareX = TRUE
  ) %>%
    layout(
      title = NULL
    )
  # )
}


### CREATE LABEL COLUMN

create_label_column <- function(facets) {
  
  n <- length(facets)
  
  spacing <- 0.02
  
  heights <- rep((1 - spacing * (n - 1)) / n, n)
  midpoints <- rev(cumsum(c(0, head(heights, -1) + spacing))) + heights / 2
  
  plot_ly(
    x = 0,
    y = 0,
    type = "scatter",
    mode = "markers",
    marker = list(opacity = 0),   # 👈 invisible
    showlegend = FALSE,
    hoverinfo = "none"
  ) %>%
    add_annotations(
      text = str_wrap(paste0("<b>", facets, "</b>"), 25),
      x = 1,   # right edge of label panel
      y = midpoints,
      xref = "paper",
      yref = "y domain",
      showarrow = FALSE,
      xanchor = "right",
      align = "right",
      yanchor = "middle",
      font = list(size = 16)
    ) %>%
    layout(
      xaxis = list(visible = FALSE),
      yaxis = list(visible = FALSE),
      margin = list(l = 10, r = 10, t = 60, b = 40)
    )
}


facets <- levels(cases_intro_spark$Pathogen)

label_column <- create_label_column(facets)

# #### CREATE THRESHOLD COLUMN
# 
# # # Activity levels
# # activity_levels <- c("Baseline", "Low", "Medium", "High", "Very high")
# 
# # Colours for thresholds
# colour_map <- c("Baseline" = "#FDE725FF", 
#                 "Low"= "#5DC863FF", 
#                 "Medium" = "#21908CFF", 
#                 "High" = "#3B528BFF", 
#                 "Very high" = "#440154FF")
# 
# 
# colour_map_alpha <- scales::alpha(colour_map, 0.5)
# 
# status_vec <- Respiratory_Pathogens_MEM_Scot %>% 
#   filter(WeekEnding==max(WeekEnding)) %>% 
#   mutate(Pathogen = recode(Pathogen,
#                            "Coronavirus"="Seasonal Coronavirus (non-COVID-19)",
#                            "Covid-19" = "COVID-19",
#                            "Parainfluenza Virus" = "Parainfluenza")) %>%
#   mutate(Pathogen = factor(Pathogen, levels = c("COVID-19", "Influenza",
#                                                 "Respiratory Syncytial Virus", "Adenovirus", "Human Metapneumovirus",
#                                                 "Mycoplasma Pneumoniae", "Parainfluenza", "Rhinovirus", 
#                                                 "Seasonal Coronavirus (non-COVID-19)"))) %>% 
#   arrange(Pathogen) %>% 
#   select(ActivityLevel) %>% 
#   c() %>% 
#   unlist()
# 
# status_vec <- factor(status_vec, levels = names(colour_map))
# 
# ## Function
# 
# create_status_column <- function(facets, status_vec, colour_map, font_size = 12) {
# 
#   data <- data.frame(
#     y = seq_along(facets),
#     status = as.character(status_vec)
#   )
# 
#   # Build rectangle shapes (one per row)
#   shapes <- lapply(seq_len(nrow(data)), function(i) {
#     list(
#       type = "rect",
#       x0 = 0, x1 = 1,                  # full width of subplot
#       y0 = data$y[i] - 0.4,
#       y1 = data$y[i] + 0.4,
#       xref = "x2 domain",               # within this subplot
#       yref = "y",
#       fillcolor = colour_map[data$status[i]],
#       line = list(color = "white", width = 1),
#       layer = "below"                  # behind text ✅
#     )
#   })
# 
#   plot_ly(data,
#           x = 0.5,
#           y = ~y,
#           type = "scatter",
#           mode = "text",
#           text = ~paste0("<b>", status, "</b>"),
#           textposition = "middle center",
#           textfont = list(size = font_size, color = "black"),
#           hoverinfo = "none"
#   ) %>%
#     layout(
#       xaxis = list(visible = FALSE, range = c(0, 1)),
#       yaxis = list(
#         visible = FALSE,
#         autorange = "reversed",
#         range = c(length(facets) + 0.5, 0.5)
#       ),
#       shapes = shapes,
#       margin = list(l = 10, r = 10, t = 60, b = 40)
#     )
# }
# 
# 
# status_column <- create_status_column(facets, status_vec, colour_map_alpha)

### CREATE PLOTS AND COMBINE

cases_plotly <- sparkline_faceted_plotly(
  data       = cases_intro_spark,
  latest     = cases_latest,
  x          = "WeekEnding",
  y          = "cases_number",
  facet_var  = "Pathogen",
  colour     = "#12436D",#phs_colours("phs-blue"),
  title      = "Lab-confirmed cases (per 100,000)",
  left_marg  = 0,
  Metric = "Cases"#,
  #right_marg = 0
)


cari_plotly <- sparkline_faceted_plotly(
  data       = cari_at_a_glance_spark,
  latest     = cari_latest,
  x          = "WeekEnding",
  y          = "SwabPositivity",
  facet_var  = "Pathogen",
  colour     = "#28A197",#phs_colours("phs-purple"),
  title      = "CARI Test Positivity (%)",
  label_suffix = "%"
)


admissions_plotly <- sparkline_faceted_plotly(
  data       = admissions_at_a_glance_spark,
  latest     = admissions_latest,
  x          = "WeekEnding",
  y          = "NumberAdmissionsPerWeek",
  facet_var  = "Pathogen",
  colour     = "#801650",#phs_colours("phs-teal"),
  title      = "Admissions (per 100,000)"
)



## CREATE OVERALL PLOT
col_widths <- c(0.16, 0.28, 0.28, 0.28)
centers <- (cumsum(col_widths) - col_widths / 2)#[-1]

figure_plotly <- subplot(
  label_column,
  # subplot(status_column,
  #         cases_plotly,
  #         widths=c(0.25, 0.75), 
  #         margin=0.001,
  #         shareY = FALSE),
  cases_plotly,
  cari_plotly,
  admissions_plotly,
  nrows  = 1,
  widths = col_widths,
  shareY = FALSE
)   %>% 
  layout(
    annotations = list(
      list(
        text = str_wrap("<b>Pathogen</b>", 25),
        x = 1,
        y = 1.08,
        xref = "x1 domain",
        yref = "paper",
        xanchor = "right",
        align = "right",
        showarrow = FALSE,
        font = list(size=17)
      ),
      
      list(
        text = str_wrap("<b>Lab-Confirmed Case Counts/ Activity Level</b>", 30),
        x = (centers[2]),
        y = 1.08,
        xref = "paper",
        yref = "paper",
        xanchor = "center",
        align = "center",
        showarrow = FALSE,
        font = list(size=17)
      ),
      
      list(
        text = str_wrap("<b>CARI Test Positivity (%)</b>", 25),
        x = centers[3],
        y = 1.08,
        xref = "paper",
        yref = "paper",
        xanchor = "center",
        align = "center",
        showarrow = FALSE,
        font = list(size=17)
      ),
      
      list(
        text = str_wrap("<b>Hospital Admissions</b>", 25),
        x = centers[4],
        y = 1.08,
        xref = "paper",
        yref = "paper",
        xanchor = "center",
        align = "center", 
        showarrow = FALSE,
        font = list(size=17)
      )
      
    ),
    margin = list(t = 100)
  )



## PLOT
output$all_paths_at_a_glance_plot <- renderPlotly({
  
  figure_plotly 
  
})
