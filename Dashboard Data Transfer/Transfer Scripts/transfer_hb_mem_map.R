
# Output
# this section would go at the end of the respitatory transfer script after the creation of the 
 # Respiratory_Pathogens_MEM_HB.csv along with Scot and Age MEM csvs

respiratory_pathogens_MEM_hb<- read_csv(glue(output_folder, "Respiratory_Pathogens_MEM_HB.csv"))

# write_csv(respiratory_pathogens_MEM_agegp, glue(output_folder, "Respiratory_Pathogens_MEM_Age.csv"))


#### for use in spatial mem maps ####

# create small dataframe for use in maps

last_two_seasons <- respiratory_pathogens_MEM_hb%>%
  filter(Pathogen == "Influenza" & HBName == "NHS Ayrshire and Arran") %>%
  select(Season) %>%
  arrange(Season) %>%
  distinct() %>%
  tail(2) 
last_two_seasons <- last_two_seasons$Season


respiratory_pathogens_MEM_hb_two_seasons<-respiratory_pathogens_MEM_hb %>%
  filter(Season%in%last_two_seasons) %>% 
  select(WeekEnding, Season, Year, ISOWeek,HB, HBName, Pathogen, 
         RatePer100000,ActivityLevel, Weekord ) %>% 
  mutate(ActivityLevelColour = case_when(
    ActivityLevel == "Baseline" ~ "#01A148",
    ActivityLevel == "Low" ~ "#FFDE17",
    ActivityLevel == "Moderate" ~ "#F36523",
    ActivityLevel == "High" ~ "#ED1D24",
    ActivityLevel == "Extraordinary" ~ "#7D4192"  )) %>%
  mutate(Pathogen=if_else(Pathogen=="Coronavirus","Seasonal Coronavirus (non-COVID-19)" ,Pathogen),
         Pathogen= factor(Pathogen,levels = c("Influenza",
                                              "Respiratory Syncytial Virus",
                                              "Adenovirus","Human Metapneumovirus",
                                              "Mycoplasma Pneumoniae",
                                              "Parainfluenza Virus","Rhinovirus","Seasonal Coronavirus (non-COVID-19)"
         )))  %>%
  arrange(HBName, Pathogen)

write_csv(respiratory_pathogens_MEM_hb_two_seasons, glue(output_folder, "Respiratory_Pathogens_MEM_HB_Two_Seasons.csv"))

rm(respiratory_pathogens_MEM_hb_two_seasons, last_season, this_season, last_two_seasons )
#### end map section  ####
