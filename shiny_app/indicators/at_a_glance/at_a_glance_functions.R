
#Load in necessary files and variables from the files controlled by the 'Routine Surveillance and Health Protection Team (formerly the viral team)
#As of 17/10/2025, the point of contact for these files are Peter Menzies and Annemarie Van Heelsum

file_paths <- rjson::fromJSON(file = "/PHI_conf/Respiratory_Surveillance_Viral/ECOSS/Routine Scripts/ECOSS_Activity_Level_Reporting_V1.0/file_paths.json")

source("/PHI_conf/Respiratory_Surveillance_Viral/ECOSS/Routine Scripts/ECOSS_Activity_Level_Reporting_V1.0/R/System/A02_Date_Calculations.R")

PHS_colours <- 
  rjson::fromJSON(
    file = "/PHI_conf/Respiratory_Surveillance_Viral/R Resources/Reporting Resources/PHS_colour_palette.json"
  )

#function for season indicators/arrows used in stacked bar charts
CreateArrowVals <- function(x) {
  
  # arrow head linetype can't be dotted, so separate values are required for arrow head and arrow line
  d <- x %>% 
    
    # find the date of the midpoint for each season
    mutate(min_previous = case_when(FluSeason == previous_season & ISOweek == 40 ~ ISOweek_beginning,
                                    T ~ NA),
           max_previous = case_when(FluSeason == previous_season & ISOweek == 39 ~ ISOweek_beginning+5,
                                    T ~ NA),
           min_current = case_when(FluSeason == current_season & ISOweek == 40 ~ ISOweek_beginning,
                                   T ~ NA),
           max_current = case_when(FluSeason == current_season & ISOweek == 39 ~ ISOweek_beginning+5,
                                   T ~ NA)) %>% 
    tidyr::fill(c(min_previous, max_previous, min_current, max_current), .direction = "updown") %>% 
    mutate(midpoint_previous = max_previous - ((max_previous - min_previous)/2),
           midpoint_current = max_current - ((max_current - min_current)/2)) %>% 
    
    # previous season arrow values
    mutate(arrowhead_A_start_previous = case_when(FluSeason == previous_season & ISOweek == 40 ~ ISOweek_beginning-2,
                                                  T ~ NA),
           arrowhead_A_end_previous = case_when(FluSeason == previous_season & ISOweek == 41 ~ ISOweek_beginning-3,
                                                T ~ NA),
           arrow_A_start_previous = case_when(FluSeason == previous_season & ISOweek == 41 ~ ISOweek_beginning-3,
                                              T ~ NA),
           arrow_A_end_previous = case_when(FluSeason == previous_season & ISOweek == 7 ~ ISOweek_beginning+1,
                                            T ~ NA),
           arrow_B_start_previous = case_when(FluSeason == previous_season & ISOweek == 21 ~ ISOweek_beginning-1,
                                              T ~ NA),
           arrow_B_end_previous = case_when(FluSeason == previous_season & ISOweek == 38 ~ ISOweek_beginning+3,
                                            T ~ NA),
           arrowhead_B_start_previous = case_when(FluSeason == previous_season & ISOweek == 38 ~ ISOweek_beginning+3,
                                                  T ~ NA),
           arrowhead_B_end_previous = case_when(FluSeason == previous_season & ISOweek == 39 ~ ISOweek_beginning+2,
                                                T ~ NA)) %>% 
    # current season arrow values
    mutate(arrowhead_A_start_current = case_when(FluSeason == current_season & ISOweek == 40 ~ ISOweek_beginning-2,
                                                 T ~ NA),
           arrowhead_A_end_current = case_when(FluSeason == current_season & ISOweek == 40 ~ ISOweek_beginning+4,
                                               T ~ NA),
           arrow_A_start_current = case_when(FluSeason == current_season & ISOweek == 40 ~ ISOweek_beginning+4,
                                             T ~ NA),
           arrow_A_end_current = case_when(FluSeason == current_season & ISOweek == 7 ~ ISOweek_beginning+1,
                                           T ~ NA),
           arrow_B_start_current = case_when(FluSeason == current_season & ISOweek == 21 ~ ISOweek_beginning-1,
                                             T ~ NA),
           arrow_B_end_current = case_when(FluSeason == current_season & ISOweek == 38 ~ ISOweek_beginning+3,
                                           T ~ NA),
           arrowhead_B_start_current = case_when(FluSeason == current_season & ISOweek == 38 ~ ISOweek_beginning+3,
                                                 T ~ NA),
           arrowhead_B_end_current = case_when(FluSeason == current_season & ISOweek == 39 ~ ISOweek_beginning+2,
                                               T ~ NA)) %>% 
    
    # arrow position on y axis and season divide line postion
    mutate(y_start = ymax_value,
           y_end = ymax_value,
           season_line = case_when(FluSeason == current_season & ISOweek == 40 ~ ISOweek_beginning-3.5,
                                   T ~ NA)) %>% 
    select(starts_with("arrow"), y_start, y_end, midpoint_previous, midpoint_current, season_line) %>% 
    tidyr::fill(everything(), .direction = "updown") %>% 
    distinct() %>% 
    mutate(Organism = "NULL") # required for ggplot
}

# list of pathogen names
all_pathogens_list <- c("COVID-19", "Adenovirus", "HMPV", "Influenza (A or B)",
                        "Mycoplasma pneumoniae", "Parainfluenza (Any Type)",
                        "RSV", "Rhinovirus", "Seasonal coronavirus")

#create dummy data of 0's for current season
current_dummy_data <- tibble()
for (i in all_pathogens_list){
  #create dummy data for each organism
  d <- tibble(FluSeason = current_season,
              ISOweek = c(1:52),
              Year = case_when(between(ISOweek, 40, 52) ~ substr(current_season, 1,4),
                               between(ISOweek, 1, 39) ~ substr(current_season, 6,9)),
              Organism = i,
              count = 0,
              rate = 0,
              Pop = 0)
  # bind it onto the full dummy dataset
  current_dummy_data <- rbind(current_dummy_data, d)
  # add week 53 if required
  if(current_season_has_53_weeks == TRUE){
    current_dummy_data <- current_dummy_data %>% 
      add_row(FluSeason = current_season,
              ISOweek = 53,
              Year = substr(current_season,1,4),
              Organism = i,
              count = 0,
              rate = 0,
              Pop = 0)
  }
  rm(i, d)
}
# remove the dummy data that from current ISOweek and prior
current_dummy_data <- current_dummy_data %>% 
  filter((Year == current_report_ISOyear &
            ISOweek > current_report_ISOweek)|
           Year > current_report_ISOyear)



all_pathogen_data <- all_pathogen_data %>% 
  filter(FluSeason %in% c(current_season, previous_season)) %>% 
  select(FluSeason, Year, ISOweek, Organism, count, rate, Pop) %>% 
  # join dummy data to the end of the season
  rbind(current_dummy_data) %>% 
  mutate(Year = as.double(Year)) %>% 
  left_join(isoweek_dates, by = c("FluSeason", "ISOweek")) %>% 
  arrange(FluSeason, ISOweek) %>%
  mutate(Organism = recode(Organism,
                           "Adenovirus" = "Adenovirus",
                           "Covid-19" = "COVID-19",
                           "Seasonal coronavirus" = "Seasonal coronavirus (non-COVID-19)",
                           "HMPV" = "Human metapneumovirus (HMPV)", 
                           "Mycoplasma pneumoniae" = "Mycoplasma pneumoniae",
                           "Parainfluenza (Any Type)" = "Parainfluenza",
                           "RSV" = "RSV",
                           "Rhinovirus" = "Rhinovirus")) %>% 
  mutate(Organism = factor(Organism, 
                           levels = c("Adenovirus", "COVID-19", "Human metapneumovirus (HMPV)",
                                      "Influenza (A or B)", "Mycoplasma pneumoniae", "Parainfluenza", 
                                      "RSV", "Rhinovirus", "Seasonal coronavirus (non-COVID-19)")))  




ymax_value <- all_pathogen_data %>% 
  group_by(FluSeason, ISOweek) %>% 
  summarise(week_total = sum(count)) %>% 
  ungroup() %>% 
  filter(week_total == max(week_total)) %>% 
  mutate(week_total = plyr::round_any(week_total, 500, 
                                      f = ceiling)) %>% 
  select(week_total) %>% 
  pull()

arrow_vals <- CreateArrowVals(all_pathogen_data)

arrow_colour <- "#a3a2a9"

## individual pathogen totals per week 2 season plot

pathogen_cari_colours <- c("Rhinovirus" = "#A8CCE8", "RSV" = "#28A197", "COVID-19" = "#F46A25", "Influenza (A or B)" = "#801650", 
                           "Adenovirus" = "#12436D", "Seasonal coronavirus (non-COVID-19)" = "#3E8ECC",  "Human metapneumovirus (HMPV)" = "#B4DEDB", 
                           "Parainfluenza (Any Type)" = "#A285D1", "Mycoplasma pneumoniae" = "#3F085C")

legend_label <- c("Adenovirus" ="Adenovirus", "COVID-19" = "COVID-19",
                  "Human metapneumovirus (HMPV)"=  "Human metapneumovirus<br>(HMPV)",
                  "Influenza (A or B)" = "Influenza (A or B)", 
                  "Mycoplasma pneumoniae" = "*Mycoplasma pneumoniae*", 
                  "Parainfluenza (Any Type)" = "Parainfluenza", 
                  "RSV" = "RSV", "Rhinovirus" = "Rhinovirus", 
                  "Seasonal coronavirus (non-COVID-19)" = "Seasonal coronavirus<br>(non-COVID-19)")


create_pathogen_barchart <- function() {
  all_pathogen_data %>% 
    left_join(x_axis_date_ref_every2, by = c("Year", "ISOweek")) %>% 
    
    ggplot(aes(x = ISOweek_beginning, y = count, fill = Organism)) +
    
    geom_col(position = "stack",
             width=6) +
    # assign pathogen colours
    scale_fill_manual(values = pathogen_cari_colours,
                      labels = legend_label,
                      name = "Pathogen") + 
    scale_y_continuous(name = "Number of cases",
                       # breaks = seq(0, 4200, 500),
                       breaks = seq(0, ymax_value, 500),
                       limits = c(0, ymax_value+100),
                       expand = c(0, 0)) +
    
    guides(fill = guide_legend(reverse = FALSE,
                               drop = TRUE)) +
    # season divide line 
    # geom_vline(xintercept = arrow_vals$season_line, 
    #            linetype = "dashed",
    #            color = arrow_colour) +
    # position of season labels on y axis
    geom_text(data = arrow_vals,
              aes(x = midpoint_previous-2,
                  y = y_start),
              # color = PHS_colours$Purple$`100% Tint`,
              color = arrow_colour,
              label = glue("{previous_season}"),
              size = 4.7) +
    geom_text(data = arrow_vals,
              aes(x = midpoint_current-2,
                  y = y_start),
              # color = PHS_colours$Purple$`100% Tint`,
              color = arrow_colour,
              label = glue("{current_season}"),
              size = 4.7) +
    
    # create previous season arrows
    geom_segment(data = arrow_vals,
                 aes(x = arrowhead_A_start_previous,
                     y = y_start,
                     xend = arrowhead_A_end_previous,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 size = 0.8,
                 color = arrow_colour, 
                 arrow = arrow(length = unit(0.3, "cm"),
                               ends = "first",
                               type = "open")) +
    geom_segment(data = arrow_vals,
                 aes(x = arrow_A_start_previous,
                     y = y_start,
                     xend = arrow_A_end_previous,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 linetype = "99",
                 size = 0.8,
                 color = arrow_colour) +
    geom_segment(data = arrow_vals,
                 aes(x = arrowhead_B_start_previous,
                     y = y_start,
                     xend = arrowhead_B_end_previous,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 size = 0.8,
                 color = arrow_colour,
                 arrow = arrow(length = unit(0.3, "cm"),
                               ends = "last",
                               type = "open")) +
    geom_segment(data = arrow_vals,
                 aes(x = arrow_B_start_previous,
                     y = y_start,
                     xend = arrow_B_end_previous,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 linetype = "99",
                 size = 0.8,
                 color = arrow_colour) +
    
    # create current season arrows
    geom_segment(data = arrow_vals,
                 aes(x = arrowhead_A_start_current,
                     y = y_start,
                     xend = arrowhead_A_end_current,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 size = 0.8,
                 color = arrow_colour,
                 arrow = arrow(length = unit(0.3, "cm"),
                               ends = "first",
                               type = "open")) +
    geom_segment(data = arrow_vals,
                 aes(x = arrow_A_start_current,
                     y = y_start,
                     xend = arrow_A_end_current,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 linetype = "99",
                 size = 0.8,
                 color = arrow_colour) +
    geom_segment(data = arrow_vals,
                 aes(x = arrowhead_B_start_current,
                     y = y_start,
                     xend = arrowhead_B_end_current,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 size = 0.8,
                 color = arrow_colour,
                 arrow = arrow(length = unit(0.3, "cm"),
                               ends = "last",
                               type = "open")) +
    geom_segment(data = arrow_vals,
                 aes(x = arrow_B_start_current,
                     y = y_start,
                     xend = arrow_B_end_current,
                     yend = y_end),
                 lineend = "round",
                 linejoin = "round",
                 linetype = "99",
                 size = 0.8,
                 color = arrow_colour) +
    
    
    scale_x_date(breaks = seq.Date(from = min(all_pathogen_data$ISOweek_beginning), 
                                   to = max(all_pathogen_data$ISOweek_beginning), 
                                   by = "4 weeks"),
                 labels = function(x) {
                   iso_weeks <- isoweek(x)
                   iso_weeks
                 },
                 name = "Week number",
                 expand = c(0, 0)) +
    
    geom_text(y = 0, aes(x = ISOweek_beginning, label = month_label),
              size = 4, colour = PHS_colours$Teal$`100% Tint`, hjust = 0.5, vjust =2.3)+
    coord_cartesian(clip = "off") +
    #labs(caption=paste0("Source: PHS - Electronic Communication of Surveillance Scotland (ECOSS)\nData up to week ", 
                        #current_report_ISOweek, ", ", 
                        #current_report_ISOyear),
         #colour = NULL) +
    
    
    theme(
      axis.title = element_text(colour = "#3F3685", family = "sans"),
      axis.text.x = element_text(colour = "black", size = 12),
      axis.text.y = element_text(colour = "black", size = 12),
      axis.title.x = element_text(size = 14),
      axis.title.y = element_text(size = 14),
      legend.title = element_text(size = 12, colour = "#3F3685"),
      legend.text = element_markdown(size = 12, colour = "black"),
      legend.background = element_rect(fill = "#f0eff3", colour = NA),
      legend.position = "right",
      legend.direction = "vertical",
      panel.background = element_rect(fill = "#f0eff3", colour = NA),
      plot.background = element_rect(fill = "#f0eff3", colour = NA),
      panel.grid.major = element_line(colour = "#e6e6e6", size = 0.3),
      panel.grid.minor = element_line(colour = "#f0eff3", size = 0.2),
      axis.line.x = element_line(colour = "black"),
      axis.line.y = element_line(colour = "black"),
      plot.caption = element_text(hjust = 0, size = 12, vjust = -10),
      plot.caption.position = "plot",
      plot.margin = margin(t = 0.25, r = 0.1, b = 1.1, l = 0.1, "cm")
    )
  
}
