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

filtered_cases_covid = Cases_Weekly %>% 
  filter(as.numeric(substr(WeekEnding, 1, 4)) >= 2023) # only include cases from 2023

covid_cases_intro = covid_cases_intro %>% 
  mutate(Num_cases = list(filtered_cases_covid$NumberCasesPerWeek)) %>% #add the number of cases to the data frame as list
  select(Pathogen,cases_number_previous_week,cases_rate_previous_week,cases_number_latest_week,cases_rate_latest_week,Num_cases)#arrange the columns in required order

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

flu_cases = Respiratory_AllData %>%
  filter(FluOrNonFlu == "flu") %>%
  filter(Organism == "Influenza - Type A or B") %>%
  filter(BreakDown == "Scotland") %>%
  group_by(Date) %>%
  summarise(cases_number = sum(Count)) %>%
  filter(as.numeric(substr(Date, 1, 4)) >= 2023) %>% #only take the cases since 2023
  ungroup() 

flu_cases_intro = flu_cases_intro %>% 
  mutate(Num_cases = list(flu_cases$cases_number))%>% 
  select(Pathogen,cases_number_previous_week,cases_rate_previous_week,cases_number_latest_week,cases_rate_latest_week,Num_cases)

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
  mutate(Pathogen = recode(Pathogen, "Seasonal coronavirus (Non-SARS-CoV-2)"="Seasonal Coronavirus (non-COVID-19)")) %>%
  mutate(Pathogen =  factor(Pathogen, levels = c("Respiratory syncytial virus", "Adenovirus", "Human metapneumovirus",
                                                 "Mycoplasma pneumoniae", "Parainfluenza virus", "Rhinovirus",
                                                 "Seasonal Coronavirus (non-COVID-19)"))) %>%
  arrange(Pathogen)

nonflu_cases = Respiratory_AllData %>%
  filter(FluOrNonFlu == "nonflu") %>%
  filter(Organism != "Total") %>%
  filter(BreakDown == "Scotland") %>%
  #tail(14) %>% # 7 pathogens, last 2 weeks
  group_by(Date, Organism) %>%
  summarise(cases_number = sum(Count)) %>%# simplify the dataframe
  ungroup()

nonflu_cases = nonflu_cases %>% 
  filter(as.numeric(substr(Date, 1, 4)) >= 2023) %>% #only take number of cases since 2023
  group_by(Organism) %>% 
  summarise(Num_cases = list(cases_number)) 


nonflu_cases_intro = nonflu_cases_intro %>%
  arrange(tolower(nonflu_cases_intro[[1]])) %>% 
  mutate(Num_cases = nonflu_cases$Num_cases)
  
  
  

# combine the three intermediate dataframes
whole_data <- covid_cases_intro %>%
  bind_rows(flu_cases_intro) %>%
  bind_rows(nonflu_cases_intro) %>% 
  mutate(Metric = "Respiratory pathogen cases") %>% 
  select(Metric,Pathogen,cases_number_previous_week,cases_rate_previous_week,cases_number_latest_week,cases_rate_latest_week,Num_cases) %>% 
  rename(previous_week_numbers = cases_number_previous_week) %>% 
  rename(previous_week_rates = cases_rate_previous_week) %>% 
  rename(latest_week_numbers = cases_number_latest_week) %>% 
  rename(latest_week_rates = cases_rate_latest_week) %>% 
  rename(trend = Num_cases)
 

# 
# colnames(cases_intro)[4] <- paste("Number of cases (", as.character(latest_week_cases_title),")")
# colnames(cases_intro)[5] <- paste("Rate per 100,000 population (", as.character(latest_week_cases_title),")")
# colnames(cases_intro)[2] <- paste("Number of cases (", as.character(previous_week_cases_title),")")
# colnames(cases_intro)[3] <- paste("Rate per 100,000 population (", as.character(previous_week_cases_title),")")

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
  # select(Pathogen,
  #        'Number of admissions (previous week)'= admissions_number_previous_week,
  #        'Rate of admissions per 100,000 population (previous week)'= admissions_rate_previous_week,
  #        'Number of admissions (latest week)'= admissions_number_latest_week,
  #        'Rate of admissions per 100,000 population (latest week)'= admissions_rate_latest_week  ) %>%
  # mutate(Pathogen =  factor(Pathogen, levels = c("COVID-19", "Influenza", "RSV"))) %>%
  arrange(Pathogen) %>%
  mutate(Pathogen=if_else(Pathogen=="RSV", "RSV admissions",Pathogen)) %>% 
  mutate(Pathogen=if_else(Pathogen=="COVID-19", "COVID admissions",Pathogen)) %>% 
  mutate(Pathogen=if_else(Pathogen=="Influenza", "Influenza admissions",Pathogen))

hosp_adms_intro = hosp_adms_intro %>% 
  mutate(Metric = "Secondary care surveillance") %>% 
  rename(previous_week_numbers = admissions_number_previous_week) %>% 
  rename(previous_week_rates = admissions_rate_previous_week) %>% 
  rename(latest_week_numbers = admissions_number_latest_week) %>% 
  rename(latest_week_rates = admissions_rate_latest_week) %>% 
  select(Metric,Pathogen,previous_week_numbers,previous_week_rates,latest_week_numbers,latest_week_rates)

hosp_adms = Respiratory_admissions_summary %>% 
  group_by(CaseDefinition) %>% 
  summarise(Admissions = list(Admissions))

hosp_adms_intro=hosp_adms_intro %>% 
  mutate(trend = hosp_adms$Admissions)

whole_data= whole_data %>% 
  bind_rows(hosp_adms_intro)
# 
# colnames(hosp_adms_intro)[4] <- paste("Number of admissions (", as.character(latest_week_admissions_title),")")
# colnames(hosp_adms_intro)[5] <- paste("Rate of admissions per 100,000 population (", as.character(latest_week_admissions_title),")")
# colnames(hosp_adms_intro)[2] <- paste("Number of admissions (", as.character(previous_week_admissions_title),")")
# colnames(hosp_adms_intro)[3] <- paste("Rate of admissions per 100,000 population (", as.character(previous_week_admissions_title),")")

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
output$cases_intro_table <- renderReactable({
  reactable(whole_data,
            pagination = FALSE,
             # theme = reactableTheme(
             #   tableStyle = list(borderCollapse = "collapse") 
             #   
             # ),
        
            columns=list(
              #Metric column
              Metric = colDef(name = " ",
                              minWidth = 125,
                              # this JS function hides the name Metric from appearing on every row
                              # i.e. gives appearance of 'merged' cells
                              style = JS("function(rowInfo, column, state) {
                                         const prevRow = state.pageRows[rowInfo.viewIndex - 1]
                                         if (prevRow && rowInfo.values['Metric'] === prevRow['Metric']) {
                                           return {visibility: 'hidden'}
                                         } else { return {fontWeight: 100 } }
                                       }
                                     ")
              ),
              Pathogen = colDef(
                name =" ",
                maxWidth = 200,
                # headerStyle = list(color = "black"),
                style = list(borderRight = "1px solid black"),
                ),
              
              
              previous_week_numbers=colDef(
                name = "Number",
                align= "center",
                class="border-left",
                minWidth = 80,
                headerStyle = list(color = "#9B4393"),
                style = list(color = "#9B4393", fontWeight = "bold", align = "right" )
              ),
              previous_week_rates = colDef(
                name = "Rate per 100,000 population",
                align= "center",
                class="border-right",
                minWidth = 80,
                headerStyle = list(color = "#9B4393"),
                style = list(color = "#9B4393", fontWeight = "bold", align = "right",borderRight = "1px solid black" )
              ),
              latest_week_numbers=colDef(
                name = "Number",
                align= "center",
                class="border-left",
                minWidth = 80,
                headerStyle = list(color = "#006cbe"),
                style = list(color = "#006cbe", fontWeight = "bold", align = "right" )
              ),
              latest_week_rates = colDef(
                name = "Rate per 100,000 population",
                align= "center",
                class="border-right",
                minWidth = 80,
                headerStyle = list(color = "#006cbe"),
                style = list(color = "#006cbe", fontWeight = "bold", align = "right",borderRight = "1px solid black" )
              ),
              trend = colDef(
                name = " ",
                align = "center",
                minWidth = 120,
                headerStyle = list(color = "#387477"),
                cell = react_sparkline(whole_data,
                                       height = 50,
                                       decimals = 1,
                                       show_area = TRUE,
                                       min_value = 0,
                                       max_value = "max_val", # ensures all on this row plot to the same maximum, so are comparable
                                       tooltip = FALSE,
                                       line_color = "#655E9D",
                                       line_width = 2
                                       
                ))),
            columnGroups = list(
              colGroup(name = "Metric", 
                       columns = c("Metric"),
                       headerStyle = list(background = "#010068",color = "white")),
              colGroup(name = "Pathogen", 
                       columns = c("Pathogen"),
                       headerStyle = list(background = "#010068",color = "white")),
              colGroup(name = paste("Previous week (", as.character(previous_week_admissions_title),")"), align="center",
                       columns = c("previous_week_numbers", "previous_week_rates"),
                       headerStyle = list(background = "#010068", color = "white")),
              colGroup(name = paste("Latest week (", as.character(latest_week_cases_title),")"), align="center",
                       columns = c("latest_week_numbers", "latest_week_rates"),
                       headerStyle = list(background = "#010068", color = "white")),
              colGroup(name = "Trend",
                       columns = c("trend"),
                       headerStyle =list(background = "#010068", color = "white") )
            )
            
  )
  
  
})

# Hospital admissions table
# output$hosp_adms_intro_table <- renderDataTable({
#   hosp_adms_intro %>%
#     make_summary_table()

#})

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


