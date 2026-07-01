### Set the position of weekly data labels - 'label_shift' details how many weeks it is shifted to
### the left from the right-hand axis (i.e. from week 52). We may wish to shift this further left
### during winter months when the peak is on the right-hand side.

label_shift <- 12


#### CASES DATA

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
         lab_x_pos = max(WeekEnding) - weeks(label_shift)) %>% 
  group_by(Pathogen) %>% 
  mutate(change = cases_number - lag (cases_number))


cases_latest <- cases_intro_spark %>% 
  filter(WeekEnding == max(WeekEnding))




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
         lab_x_pos = max(WeekEnding) - weeks(label_shift)) %>%  
  group_by(Pathogen) %>% 
  mutate(change = SwabPositivity - lag (SwabPositivity))

cari_latest <- cari_at_a_glance_spark  %>% 
  filter(WeekEnding == max(WeekEnding))



#### ADMISSIONS DATA

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
         lab_x_pos = max(WeekEnding) - weeks(label_shift)) %>% 
  group_by(Pathogen) %>% 
  mutate(change = NumberAdmissionsPerWeek - lag (NumberAdmissionsPerWeek))

admissions_latest <- admissions_at_a_glance_spark  %>% 
  filter(WeekEnding == max(WeekEnding))



### Plot settings

# # Activity levels
activity_levels <- c("Baseline", "Low", "Medium", "High", "Very high")

# Colours for thresholds
colour_map <- c("Baseline" = "#FDE725FF",
                "Low"= "#5DC863FF",
                "Medium" = "#21908CFF",
                "High" = "#3B528BFF",
                "Very high" = "#440154FF")


colour_map_alpha <- scales::alpha(colour_map, 0.3)

facets <- levels(cases_intro_spark$Pathogen)



### CREATE PLOTS AND COMBINE

label_column <- create_label_column(facets)


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
