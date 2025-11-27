#This script creates "CASES" open data outputs
#07/10/2025
#Nipuni Rajapaksha

#data sourced from 0_Raw_data_ADMISSIONS.R

################## CASES ##########################

#1.Scotland level--------------------------------------------------------

##final df - admissions all pathogens Scotland----

all_pathogens_scotland_admissions<-
  rbind(i_admsn_all_pathogens_scotland,i_admsn_flu_scotland) %>% 
  arrange(WeekBeginning,Pathogen) %>% 
  mutate(Country="S92000003") %>% 
  merge(season_week,by=c("WeekBeginning","WeekEnding")) %>% 
  #add population
  merge(ref_pop_scotland) %>% 
  #add rates
  mutate(RateAdmissionsPerWeek=round((NumberAdmissionsPerWeek/Population)*100000,
                                digits = 1)) %>% 
  relocate(Country,.after = WeekEnding) %>% 
  relocate(c(Season,ISOyear,ISOweek),.before=WeekBeginning) %>% 
  relocate(RateAdmissionsPerWeek,.before = Population) %>% 
  arrange(WeekBeginning,Pathogen) %>% 
  mutate(WeekBeginning=str_remove_all(WeekBeginning,"-"),
         WeekEnding=str_remove_all(WeekEnding,"-"))
  

##write csv----
message("Writing Admissions_All_respiratory_pathogens_Scotland")
write_csv(all_pathogens_scotland_admissions,
          paste0(file_paths$Outputs$Output_folder,
                 "Admissions_All_respiratory_pathogens_Scotland_",od_report_date,".csv"))

#2.by Age group-----------------------------------------------------------------

covid19_flu_rsv_ageGp_Sex_admissions<-
  i_admsn_covid19_flu_rsv_ageGp_Sex %>% 
  mutate(Pathogen=recode(Pathogen,
                         "cov"= "COVID-19",
                         "flu"="Influenza (All)",
                         "rsv"="RSV"),
         AgeGroup=recode(AgeGroup,"All"="Total"),
         Sex=recode(Sex,"All"="Total",
                    "F"="Female",
                    "M"="Male"),
         AgeGroupQF=if_else(AgeGroup=="Total","d",""),
         SexQF=if_else(Sex=="Total","d",""),
         Country="S92000003",
         RateAdmissionsPerWeek=round(RateAdmissionsPerWeek,digits = 1)) %>% 
  merge(season_week) %>% 
  select(Season,ISOyear,ISOweek,WeekBeginning,WeekEnding,Country,Pathogen,
         AgeGroup,AgeGroupQF,Sex,SexQF,NumberAdmissionsPerWeek,
         RateAdmissionsPerWeek,Population) %>% 
  arrange(WeekBeginning) %>% 
  mutate(WeekBeginning=str_remove_all(WeekBeginning,"-"),
         WeekEnding=str_remove_all(WeekEnding,"-"))


##write csv----
message("Writing Admissions_COVID19_FLU_RSV_by_AgeGroup_Sex")
write_csv(covid19_flu_rsv_ageGp_Sex_admissions,
          paste0(file_paths$Outputs$Output_folder,
                 "Admissions_COVID19_FLU_RSV_by_AgeGroup_Sex_",od_report_date,".csv"))


#3.by Health board--------------------------------------------------------------

all_resp_hb_admissions_a<-
  i_admsn_all_resp_hb %>% 
  mutate(HB=str_squish(HB),
         HBcode=recode(HB,
                       "NATIONAL FACILITY"="SB0801",
                       #"NHS AYRSHIRE & ARRAN"="S08000015",
                       "NHS AYRSHIRE AND ARRAN"="S08000015",
                       "NHS BORDERS"="S08000016",
                       "NHS FIFE"="S08000029",
                       "NHS FORTH VALLEY"="S08000019",                  
                       "NHS GRAMPIAN"="S08000020",
                       #"NHS DUMFRIES & GALLOWAY"= "S08000017",
                       "NHS DUMFRIES AND GALLOWAY" = "S08000017",
                       #"NHS GREATER GLASGOW & CLYDE"="S08000031",
                       "NHS GREATER GLASGOW AND CLYDE"="S08000031",
                       "NHS HIGHLAND"="S08000022",
                       "NHS LOTHIAN"="S08000024",
                       "NHS ORKNEY"="S08000025",
                       "NHS SHETLAND"="S08000026",
                       "NHS WESTERN ISLES"="S08000028",
                       "NHS TAYSIDE"="S08000030",
                       "NHS LANARKSHIRE"="S08000032")) %>% 
  merge(season_week)%>% 
  filter(WeekBeginning>="2020-09-28")  %>%
  merge(df_template_hb_admissions %>% 
          filter(WeekBeginning>="2020-09-28" &
                   Pathogen %in% c("Influenza (All)","RSV","COVID-19")&
                   HBName != "Scotland"),
        all=TRUE) %>% 
  select(-HB)%>% 
  group_by(Season,HBcode) %>% 
  fill(.direction ="updown", Population) %>% 
  mutate(RateAdmissionsPerWeek=replace_na(RateAdmissionsPerWeek,0),
         RateAdmissionsPerWeek=round(RateAdmissionsPerWeek,digits=1))

all_resp_hb_admissions<-
  #add scotland level rows
  rbind(all_pathogens_scotland_admissions %>% 
          filter(Pathogen %in% c("Influenza (All)","RSV","COVID-19")) %>% 
          rename(HBcode=Country) %>% 
          mutate(HBName="Scotland",
                 WeekBeginning = ymd(WeekBeginning),
                 WeekEnding = ymd(WeekEnding)),all_resp_hb_admissions_a) %>% 
  relocate(HBName,.before = HBcode) %>% 
  mutate(HBQF=if_else(HBName=="Scotland","d",""),
         NumberAdmissionsPerWeek=
           if_else(is.na(NumberAdmissionsPerWeek),
                   0,NumberAdmissionsPerWeek)) %>% 
  arrange(ISOyear,ISOweek,Pathogen,HBQF) %>% 
  relocate(HBQF,.after = HBcode) %>% 
  relocate(Pathogen,.before = HBName) %>%
  #no estimate for golden jubilee
  mutate(across(.cols = c(Population,RateAdmissionsPerWeek),
                ~if_else(HBcode=="SB0801",NaN,.))
         ) %>% 
  mutate(WeekBeginning=str_remove_all(WeekBeginning,"-"),
         WeekEnding=str_remove_all(WeekEnding,"-")) 

##write csv----
message("Writing Admissions_All_respiratory_pathogens_by_HB")
write_csv(all_resp_hb_admissions,
          paste0(file_paths$Outputs$Output_folder,
                 "Admissions_COVID19_FLU_RSV_by_HB_",od_report_date,".csv")) 


#4.by SIMD ---------------------------------------------------------------------
covid19_flu_rsv_simd_admissions<-
  i_admsn_covid19_flu_rsv_simd %>% 
  pivot_longer(cols = c(starts_with("Total"),ends_with("rate"))) %>% 
  mutate(parameter=str_extract_all(name, "Total"),
         parameter=as.character(parameter),
         parameter=if_else(parameter!="Total","Rate",parameter)) %>% 
  rename(Pathogen=name, Population=pop) %>% 
  mutate(Pathogen=str_remove_all(Pathogen,"Total_"),
         Pathogen=str_remove_all(Pathogen,"_rate")) %>% 
  mutate(Pathogen=recode(Pathogen,
                         "cov"="COVID-19",
                         "flu"="Influenza (All)",
                         "rsv"="RSV")) %>% 
  pivot_wider(names_from = parameter,values_from = value) %>% 
  rename(NumberAdmissionsPerWeek=Total, RateAdmissionsPerWeek=Rate) %>% 
  merge(season_week) %>% 
  arrange(WeekBeginning) %>% 
  mutate(Country="Scotland",
         RateAdmissionsPerWeek=round(RateAdmissionsPerWeek,digits = 1)) %>% 
  select(Season,ISOyear,ISOweek,WeekBeginning,WeekEnding,Country,
         Pathogen,SIMD=simd,NumberAdmissionsPerWeek,RateAdmissionsPerWeek,
         Population) %>% 
  arrange(WeekBeginning,Pathogen,SIMD) %>% 
  mutate(WeekBeginning=str_remove_all(WeekBeginning,"-"),
         WeekEnding=str_remove_all(WeekEnding,"-"))

##write csv----
message("Writing Admissions_COVID19_FLU_RSV_by_SIMD")
write_csv(covid19_flu_rsv_simd_admissions,
          paste0(file_paths$Outputs$Output_folder,
                 "Admissions_COVID19_FLU_RSV_by_SIMD_",od_report_date,".csv")) 




############################# END ########################################-

rm(i_admsn_all_pathogens_scotland,admsn_df_start,i_admsn_flu_scotland,
   i_admsn_covid19_flu_rsv_simd,i_admsn_all_resp_hb,
   i_admsn_covid19_flu_rsv_ageGp_Sex,covid19_flu_rsv_simd_admissions,
   all_pathogens_scotland_admissions,all_resp_hb_admissions_a,
   all_resp_hb_admissions,
   covid19_flu_rsv_ageGp_Sex_admissions)

gc()
