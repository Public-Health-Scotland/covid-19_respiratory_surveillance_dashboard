### Setup data -----
#cases labels-(matches covid-cases data set)

latest_week_cases_title <- Cases_Weekly %>%
  tail(1) %>%
  select(WeekEnding) %>% 
  convert_opendata_date()

latest_week_cases_title %<>%
    format("%d %b %y")
  
previous_week_cases_title <- Cases_Weekly %>%
  tail(2) %>%
  filter(WeekEnding== min(WeekEnding)) %>% 
  select(WeekEnding) %>% 
  convert_opendata_date() 

previous_week_cases_title %<>%
  format("%d %b %y")

# admissions labels- (matches Respiratory_admissions_summary data set)
latest_week_admissions_title <-Respiratory_admissions_summary %>%
  tail(1) %>%
  select(Date) 
  
# Convert to the correct format
latest_week_admissions_title$Date<- format(latest_week_admissions_title $Date, "%d %b %y")
  
# make it a value 
latest_week_admissions_title <- latest_week_admissions_title$Date
  
previous_week_admissions_title <- Respiratory_admissions_summary %>%
  filter(CaseDefinition=='RSV') %>% 
  tail(2) %>%
  filter(Date== min(Date)) %>% 
  select(Date) 
  
# Convert to correct format
 previous_week_admissions_title $Date<- format(previous_week_admissions_title $Date, "%d %b %y")
   
# make it a value
previous_week_admissions_title <- previous_week_admissions_title$Date
   
# occupancy labels- (uses weekly covid HB occupancy i.e. same dataframe that produces the table)

latest_week_occupancy_title<- Occupancy_Weekly_Hospital_HB %>% 
     filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
     tail(1) %>%
     select(Date=WeekEnding)
# Convert to the correct format
latest_week_occupancy_title$Date<- format(latest_week_occupancy_title$Date, "%d %b %y")
   
# Convert to the correct format
latest_week_occupancy_title<-latest_week_occupancy_title$Date
   
previous_week_occupancy_title<- Occupancy_Weekly_Hospital_HB %>% 
     filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
     tail(2) %>%
     select(Date=WeekEnding) %>% 
     filter(Date== min(Date))
   
# Convert to the correct format
   previous_week_occupancy_title$Date<- format(previous_week_occupancy_title$Date, "%d %b %y")
   
# makle it a value
   previous_week_occupancy_title<- previous_week_occupancy_title$Date
   
# create value to produce population rate values
pop_scot_total <- i_population_v2 %>%
  filter(AgeGroup == "Total", Sex == "Total") %>%
  .$PopNumber


### Cases

# create intermediate data frames for covid,flu and non-flu pathogens
# limit  each data frame to the last 2 weeks and add a flag latest week /previous week
# pivot the tables by dates
# Order the pathogens in a consistent manner
# join into one table
# rename and add week titles for the dashboard

covid_cases_intro <- Cases_Weekly %>%
  tail(2) %>% # retain last 2 weeks
  rename(cases_number =NumberCasesPerWeek) %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
  mutate(flag = ifelse(WeekEnding ==max(WeekEnding), "latest_week", "previous_week")) %>%
  select(-Cumulative, -WeekEnding) %>%
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  mutate(Pathogen = "COVID-19")

flu_cases_intro <- Respiratory_AllData %>%
  filter(FluOrNonFlu == "flu") %>%
  filter(Organism == "Influenza - Type A or B") %>%
  filter(BreakDown == "Scotland") %>%
  tail(2) %>%
  group_by(Date) %>%
  summarise(cases_number = sum(Count)) %>%
  ungroup() %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
  mutate(flag = ifelse(Date==max(Date), "latest_week", "previous_week")) %>%
  select(-Date) %>%
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  mutate(Pathogen = "Influenza")

nonflu_cases_intro <- Respiratory_AllData %>%
  filter(FluOrNonFlu == "nonflu") %>%
  filter(Organism != "Total") %>%
  filter(BreakDown == "Scotland") %>% 
     tail(14) %>% # 7 pathogens, last 2 weeks
  group_by(Date, Organism) %>%
  summarise(cases_number = sum(Count)) %>%# simplify the dataframe
  ungroup() %>%
  mutate(flag = ifelse(Date==max(Date), "latest_week", "previous_week")) %>% # add flag
  select(-Date) %>%
  mutate(cases_rate = round_half_up(100000 * cases_number / pop_scot_total,1)) %>%
  pivot_wider(names_from = flag, values_from = cases_number:cases_rate) %>%
  select(-c(flag_latest_week, flag_previous_week)) %>%
  rename(Pathogen = Organism) %>%
  mutate(Pathogen =  factor(Pathogen, levels = c("Respiratory syncytial virus", "Adenovirus", "Human metapneumovirus",
                                                 "Mycoplasma pneumoniae", "Parainfluenza virus", "Rhinovirus",
                                                 "Seasonal coronavirus (Non-SARS-CoV-2)"))) %>%
  arrange(Pathogen)

# combine the three intermediate dataframes
cases_intro <- covid_cases_intro %>%
  bind_rows(flu_cases_intro) %>%
  bind_rows(nonflu_cases_intro) %>%
  select(Pathogen,
         'Number of cases (previous week)'= cases_number_previous_week,
         'Rate per 100,000 population (previous week)'= cases_rate_previous_week,
         'Number of cases (latest week)'= cases_number_latest_week,
         'Rate per 100,000 population (latest week)'= cases_rate_latest_week
         )


colnames(cases_intro)[4] <- paste("Number of cases (", as.character(latest_week_cases_title),")")
colnames(cases_intro)[5] <- paste("Rate per 100,000 population (", as.character(latest_week_cases_title),")")
colnames(cases_intro)[2] <- paste("Number of cases (", as.character(previous_week_cases_title),")")
colnames(cases_intro)[3] <- paste("Rate per 100,000 population (", as.character(previous_week_cases_title),")")

###Hosp Adms
# create intermediate data frames for covid,flu and rsv using Respiratory_admissions_summary dataframe
# (same dataframe as that used for admissions graph below)
# limit  each data frame to the last 2 weeks and add a flag latest week /previous week
# pivot the tables by flags
# Order the pathogens in a consistent manner
# join into one table
# rename and add week titles for the dashboard

hosp_adms_intro <- Respiratory_admissions_summary %>%
  tail(6) %>% 
  mutate(flag = ifelse(Date==max(Date), "latest_week", "previous_week")) %>%
  select(-Date) %>%
  mutate(admissions_rate = round_half_up(100000 * Admissions / pop_scot_total,1)) %>% 
  select(flag, Pathogen=CaseDefinition, admissions_number = Admissions,
         admissions_rate) %>% 
   pivot_wider(names_from = flag, values_from = admissions_number:admissions_rate) %>%
  select(Pathogen,
         'Number of admissions (previous week)'= admissions_number_previous_week,
         'Rate of admissions per 100,000 population (previous week)'= admissions_rate_previous_week,
         'Number of admissions (latest week)'= admissions_number_latest_week,
         'Rate of admissions per 100,000 population (latest week)'= admissions_rate_latest_week  ) %>% 
  mutate(Pathogen =  factor(Pathogen, levels = c("COVID-19", "Influenza", "RSV"))) %>%
  arrange(Pathogen) %>% 
  mutate(Pathogen=if_else(Pathogen=="RSV", "Respiratory syncytial virus",Pathogen))

colnames(hosp_adms_intro)[4] <- paste("Number of admissions (", as.character(latest_week_admissions_title),")")
colnames(hosp_adms_intro)[5] <- paste("Rate of admissions per 100,000 population (", as.character(latest_week_admissions_title),")")
colnames(hosp_adms_intro)[2] <- paste("Number of admissions (", as.character(previous_week_admissions_title),")")
colnames(hosp_adms_intro)[3] <- paste("Rate of admissions per 100,000 population (", as.character(previous_week_admissions_title),")")

###Inpatients
# only one data frame at the moment for Covid inpatients
# limit data frame to the last 2 weeks and add a flag latest week /previous week
# pivot the tables by flags
# Order the pathogens in a consistent manner
# join into one table
# rename and add week titles for the dashboard

covid_inpatients_intro <- Occupancy_Weekly_Hospital_HB %>% 
  filter(HealthBoardQF== "d") %>%#use weekly value, filter to Scotland
  tail(2) %>% #last 2 weeks
  mutate(flag= if_else(WeekEnding_od==max(WeekEnding_od),"Latest Week", "Previous Week")) %>% #add flags
  select(flag, SevenDayAverage) %>%
  pivot_wider(names_from = flag, values_from = SevenDayAverage) %>%
  mutate(Pathogen = "COVID-19") %>%
  select(Pathogen, `Previous Week`, `Latest Week`)

colnames(covid_inpatients_intro)[3] <- paste("Seven day average number (", as.character(latest_week_occupancy_title),")")
colnames(covid_inpatients_intro)[2] <- paste("Seven day average number (", as.character(previous_week_occupancy_title),")")


### Data tables -----

# Cases table
output$cases_intro_table <- renderDataTable({
  cases_intro %>%
   make_summary_table()

})

##########
# Cases table
output$three_week_mem_table <- renderDataTable({
  pivot_scot_mem %>%
    make_summary_table()
  
})

##########
# Hospital admissions table
output$hosp_adms_intro_table <- renderDataTable({
  hosp_adms_intro %>%
    make_summary_table()

})

# Inpatients table
output$inpatients_intro_table <- renderDataTable({
  covid_inpatients_intro%>%
    make_summary_table()

})

altTextServer("adms_summary_modal",
              title = "Number of acute hospital admissions due to COVID-19, influenza and RSV",
              content = tags$ul(tags$li("This is a plot of the number of acute hospital admissions due to COVID-19, influenza and RSV."),
                                tags$li("The x axis is the week ending"),
                                tags$li("The y axis is the number of admissions"),
                                tags$li("There are three traces: a blue dashed trace which shows the number of admissions due to influenza;",
                                        "a green solid trace which shows the number of admissions due to RSV;",
                                        "and a purple dotted trace which showss the number of admissions due to COVID-19.")
              )
)

### Plot -----
output$hosp_adms_intro_plot <- renderPlotly({
  Respiratory_admissions_summary %>%
    make_adms_summary_plot()#create_summary_adms_linechart()

})

#mem labels-(matches MEM_Scot data set)
#latest sunday
latest_week_mem_title <-Respiratory_Pathogens_MEM_Scot %>%
  tail(1) %>%
  select(Date=WeekEnding)
# Convert to correct format
latest_week_mem_title$Date<- format(latest_week_mem_title$Date, "%d %b %y")
# make it a value
latest_week_mem_title <- latest_week_mem_title$Date


 #middle sundau
middle_week_mem_title <-Respiratory_Pathogens_MEM_Scot %>%
  filter(Pathogen==("Influenza")) %>% 
  tail(2) %>%
  filter(WeekEnding==min(WeekEnding)) %>% 
  select(Date=WeekEnding)
# Convert to correct format
  middle_week_mem_title$Date<- format(middle_week_mem_title$Date, "%d %b %y")
# make it a value
  middle_week_mem_title <- middle_week_mem_title$Date

#earliest sunday
  earliest_week_mem_title <-Respiratory_Pathogens_MEM_Scot %>%
    filter(Pathogen==("Influenza")) %>% 
    tail(3) %>%
    filter(WeekEnding==min(WeekEnding)) %>% 
    select(Date=WeekEnding)
  # Convert to correct format
  earliest_week_mem_title$Date<- format(earliest_week_mem_title$Date, "%d %b %y")
  # make it a value
  earliest_week_mem_title <-earliest_week_mem_title$Date



pivot_scot_mem<-Respiratory_Pathogens_MEM_Scot %>% 
  tail(24) %>% 
  select(WeekEnding,Pathogen, RatePer100000, ActivityLevel) %>% 
  #mutate(date = as.numeric(WeekEnding))
  mutate(
    min_date = min(WeekEnding),
    max_date = max(WeekEnding),
    flag = case_when(
      WeekEnding == min_date ~ "3rdSunday",
      WeekEnding == max_date ~ "1stSunday",
      TRUE ~ "2ndSunday")) %>% 
  select(-min_date, -max_date, -WeekEnding)  %>% 
  pivot_wider(names_from = flag, values_from = RatePer100000: ActivityLevel)
  

colnames(pivot_scot_mem)[2] <- paste("Infection Rate (", as.character(earliest_week_mem_title),")")
colnames(pivot_scot_mem)[3] <- paste("Infection Rate (", as.character(middle_week_mem_title),")")
colnames(pivot_scot_mem)[4] <- paste("Infection Rate (", as.character(latest_week_mem_title),")")
colnames(pivot_scot_mem)[4] <- paste("Activity Level (", as.character(earliest_week_mem_title),")")
colnames(pivot_scot_mem)[6] <- paste("Activity Level (", as.character(middle_week_mem_title),")")
colnames(pivot_scot_mem)[7] <- paste("Activity Level (", as.character(latest_week_mem_title),")")


# Create the Plotly heatmap
heatmap_plot <- plot_ly(
  data=pivot_scot_mem,
  z = pivot_scot_mem,
  x = colnames(heatmap_data),
  y = rownames(heatmap_data),
  type = "heatmap",
  colorscale = "Viridis",  # You can choose another colorscale
  reversescale = TRUE,
  showscale = TRUE,
  hoverinfo = "z+text",
  text = heatmap_data
)

# Show the plot
heatmap_plot
