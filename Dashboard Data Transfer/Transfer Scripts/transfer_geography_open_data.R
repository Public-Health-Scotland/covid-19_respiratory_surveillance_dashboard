# Open data transfer for Geography
# Sourced from ../dashboard_data_transfer.R



#open data date to read in combined file
od_date <- floor_date(today(), "week", 1) + 1
od_sunday<- floor_date(today(), "week", 1) -1

#lookups
SPD <- readRDS("/conf/linkage/output/lookups/Unicode/Geography/Scottish Postcode Directory/Scottish_Postcode_Directory_2024_1.rds")

CA_lookup <-SPD %>%
  select(ca2019,ca2019name)%>%
  distinct(ca2019,ca2019name)%>%
  rename(local_authority=ca2019name)

HB_lookup<- SPD %>%
  select(hb2019,hb2019name)%>%
  distinct(hb2019,hb2019name)%>%
  mutate(reporting_health_board=str_replace_all(string=hb2019name, pattern="NHS ", repl=""))


HBnames <- HB_lookup %>%
  select(hb2019,hb2019name)%>%
  rename(location_code=hb2019,location_name=hb2019name)

LAnames <- CA_lookup %>%
  rename(location_code=ca2019,location_name=local_authority)

location_names <- bind_rows(HBnames,LAnames)

rm(HBnames,LAnames)

#Populations
base_hb_population <- readRDS(glue("//conf/linkage/output/lookups/Unicode/Populations/Estimates/HB2019_pop_est_5year_agegroups_1981_2021.rds"))
base_la_population <- readRDS(glue("//conf/linkage/output/lookups/Unicode/Populations/Estimates/CA2019_pop_est_5year_agegroups_1981_2021.rds"))

scotland_pop <- base_hb_population %>%
  filter(year == 2021) %>%
  mutate(location_code = "Scotland")%>%
  group_by(location_code) %>%
  summarise(Pop = sum(pop))

hb_pop <- base_hb_population %>%
  filter(year == 2021) %>%
  rename(location_code = hb2019)%>%
  group_by(location_code) %>%
  summarise(Pop = sum(pop))

la_pop <- base_la_population %>%
  filter(year == 2021) %>%
  rename(location_code = ca2019) %>%
  group_by(location_code) %>%
  summarise(Pop = sum(pop))

populations <- bind_rows(hb_pop, la_pop, scotland_pop)

rm(base_hb_population,base_la_population, hb_pop, la_pop, scotland_pop)

#read in combined file
i_combined_pcr_lfd_tests<- readRDS(glue("/PHI_conf/Real_Time_Epi/Data/PCR_Data/weekly_report_pcr_lfd_tests_reinf_{od_date}.rds"))%>%
  mutate(Sex = case_when(is.na(subject_sex)~submitted_subject_sex,TRUE ~ subject_sex))%>%
  mutate(test_source = case_when(test_result_record_source %in% c("NHS DIGITAL","ONS","SGSS") ~ "UK Gov",
                                 test_result_record_source %in% c( "ECOSS","SCOT","SGSS")~ "NHS Lab"))%>%
  mutate(test_source = case_when((test_result_record_source == "SGSS" & SGSS_ID == "Pillar 2") ~ "UK Gov",
                                 (test_result_record_source == "SGSS" & SGSS_ID == "Pillar 1") ~ "NHS Lab",
                                 TRUE~test_source))%>%
  mutate(pillar=case_when(test_source=="UK Gov"~"Pillar 2", test_source=="NHS Lab"~"Pillar 1"))%>%
  mutate(pillar=case_when(test_type=="LFD"~"LFD",TRUE ~pillar))%>%
  select(specimen_id, SubLab, reporting_health_board, local_authority, postcode, specimen_date,
         test_result, Sex, age, date_reporting, date_test_received_at_bi,
         test_result_record_source, laboratory_code, pillar, flag_covid_case,
         derived_covid_case_type, episode_number_deduplicated, episode_derived_case_type)

##############Cumulatives############################

##### Cases
#Read in cases data
cases_data <- i_combined_pcr_lfd_tests %>%
  mutate(PostCode=str_replace_all(string=postcode, pattern=" ", repl=""))%>%
  left_join(CA_lookup,by="local_authority")%>%
  left_join(HB_lookup,by="reporting_health_board")%>%
  mutate(episode_number_deduplicated = replace_na(episode_number_deduplicated,0),
         flag_episode = ifelse(episode_number_deduplicated>0,1,0),
         flag_first_infection = ifelse(episode_number_deduplicated==1,1,0),
         flag_reinfection = ifelse(episode_number_deduplicated>1,1,0))%>%
  #filter(episode_number_deduplicated != 0) %>%
  filter(!(reporting_health_board %in% c("UK (not resident in Scotland)",
                                         "Outside UK",NA))) %>%
  mutate(Date=as.Date(specimen_date)) %>%
  filter(Date <= as.Date(od_sunday))

Scotland_geog <- cases_data %>%
  group_by()%>%
  summarise(total_positive = sum(flag_episode))%>%
  mutate(location_code="Scotland",geography="Scotland")

HB_geog <- cases_data %>%
  group_by(hb2019)%>%
  summarise(total_positive = sum(flag_episode))%>%
  rename(location_code=hb2019)%>%
  mutate(geography="Health Board")

LA_geog <- cases_data %>%
  group_by(ca2019)%>%
  summarise(total_positive = sum(flag_episode))%>%
  rename(location_code=ca2019)%>%
  mutate(geography="Local Authority")

Geog <- bind_rows(Scotland_geog, HB_geog, LA_geog)%>%
  mutate(test_type="Combined") %>%
  select(total_positive, location_code, geography, test_type)

test_type_scotland <- cases_data %>%
  group_by(episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode))%>%
  mutate(test_type=episode_derived_case_type,
         geography="Scotland", location_code="Scotland")%>%
  select(total_positive, location_code, geography, test_type)

test_type_hb <- cases_data %>%
  group_by(hb2019,episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode))%>%
  mutate(test_type=episode_derived_case_type,
         geography="Health Board")%>%
  rename(location_code=hb2019)%>%
  select(total_positive, location_code, geography, test_type)

test_type_ca <- cases_data %>%
  group_by(ca2019,episode_derived_case_type)%>%
  summarise(total_positive = sum(flag_episode))%>%
  mutate(test_type=episode_derived_case_type,
         geography="Local Authority")%>%
  rename(location_code=ca2019)%>%
  select(total_positive, location_code, geography, test_type)

Geog_all <- bind_rows(Geog, test_type_scotland, test_type_hb, test_type_ca)%>%
  left_join(populations,by=c("location_code"))%>%
  mutate(crude_rate_positive=round_half_up((total_positive/Pop)*100000),0)%>%
  filter(location_code!='NA')%>%
  mutate(Date=od_date)%>%
  left_join(location_names, by=c("location_code"))%>%
  mutate(location_name=case_when(is.na(location_name)~"Scotland", TRUE ~ location_name))%>%
  select(Date, geography, location_code, location_name, test_type, total_positive, Pop,
         crude_rate_positive)

rm(Scotland_geog, HB_geog, LA_geog, Geog, test_type_scotland, test_type_hb, test_type_ca)

Combined_geog <- Geog_all %>%
  filter(test_type=="Combined")%>%
  select(-test_type) %>%
  rename(total_crude_rate_positive=crude_rate_positive)

pcr_geog <- Geog_all %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive)%>%
  rename(pcr_positive=total_positive)

lfd_geog <- Geog_all %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive)%>%
  rename(lfd_positive=total_positive)

pcr_and_lfd_geog <- Geog_all %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type, -Pop, -crude_rate_positive)%>%
  rename(pcr_and_lfd_positive=total_positive)

Geog_all_cases <- Combined_geog %>%
  left_join(pcr_geog, by=c("Date","geography","location_name","location_code"))%>%
  left_join(lfd_geog, by=c("Date","geography","location_name","location_code"))%>%
  left_join(pcr_and_lfd_geog, by=c("Date","geography","location_name","location_code"))%>%
  select(Date,location_code,location_name,geography,Pop, total_positive,
         total_crude_rate_positive, pcr_positive, lfd_positive, pcr_and_lfd_positive)

rm(Geog_all, Combined_geog, pcr_geog, lfd_geog, pcr_and_lfd_geog)

g_total_cases <- Geog_all_cases %>%
  rename("CumulativeCases" = "total_positive") %>%
  rename("CumulativePCROnlyCases" = "pcr_positive") %>%
  rename("CumulativeLFDOnlyCases" = "lfd_positive") %>%
  rename("CumulativeLFDAndPCRCases" = "pcr_and_lfd_positive") %>%
  rename("Geography" = "location_code") %>%
  rename("GeographyName" = "location_name") %>%
  rename("CrudeRatePositiveCases" = "total_crude_rate_positive") %>%
  mutate(Geography = recode(Geography, "Scotland" = "S92000003")) %>%
  mutate(GeographyQF = if_else(Geography == "S92000003", "d", "")) %>%
  select(Date, Geography, GeographyQF, GeographyName, CumulativeCases, CrudeRatePositiveCases,
         CumulativePCROnlyCases, CumulativeLFDOnlyCases, CumulativeLFDAndPCRCases, geography)%>%
  arrange(Geography)

rm(Geog_all_cases)

##### Tests
#Read in positive test data
pos_test_data <- i_combined_pcr_lfd_tests%>%
  left_join(CA_lookup,by="local_authority")%>%
  left_join(HB_lookup,by="reporting_health_board")%>%
  mutate(Date = as.Date(specimen_date)) %>%
  filter(Date <= as.Date(od_sunday))

#Cumulative figures for Scotland by pillar
cumulatives_pillar_scotland <- pos_test_data%>%
  group_by(pillar)%>%
  summarise(positive_tests=n())%>%
  mutate(location_code="Scotland")%>%
  mutate(Date=od_date)%>%
  select(Date,location_code,pillar,positive_tests)

#Cumulative figures by Board and pillar
cumulatives_pillar_board <- pos_test_data%>%
  group_by(pillar,hb2019)%>%
  summarise(positive_tests=n())%>%
  mutate(Date=od_date)%>%
  rename(location_code=hb2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests)

#Cumulative figures by LA and pillar
cumulatives_pillar_LA <- pos_test_data%>%
  group_by(pillar,ca2019)%>%
  summarise(positive_tests=n())%>%
  mutate(Date=od_date)%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(Date,location_code,pillar,positive_tests)

cumulatives_all <- bind_rows(cumulatives_pillar_scotland,cumulatives_pillar_board,cumulatives_pillar_LA)

rm(cumulatives_pillar_scotland, cumulatives_pillar_board, cumulatives_pillar_LA)

pillar1 <- cumulatives_all %>%
  filter(pillar=="Pillar 1")%>%
  rename(pillar1_positive_tests=positive_tests)%>%
  select(Date,location_code,pillar1_positive_tests)

pillar2 <- cumulatives_all %>%
  filter(pillar=="Pillar 2")%>%
  rename(pillar2_positive_tests=positive_tests)%>%
  select(Date,location_code,pillar2_positive_tests)

lfd_tests <- cumulatives_all %>%
  filter(pillar=="LFD")%>%
  rename(lfd_positive_tests=positive_tests)%>%
  select(Date,location_code,lfd_positive_tests)

Geog_all_pos_tests <- pillar1 %>%
  left_join(pillar2, by=c("Date","location_code"))%>%
  left_join(lfd_tests, by=c("Date","location_code"))%>%
  mutate(pillar1_positive_tests = replace(pillar1_positive_tests, is.na(pillar1_positive_tests), 0),
         pillar2_positive_tests = replace(pillar2_positive_tests, is.na(pillar2_positive_tests), 0),
         lfd_positive_tests = replace(lfd_positive_tests, is.na(lfd_positive_tests), 0))%>%
  mutate(total_positive_tests = pillar1_positive_tests + pillar2_positive_tests + lfd_positive_tests)

rm(cumulatives_all, pillar1, pillar2, lfd_tests)

g_pos_tests <- Geog_all_pos_tests %>%
  rename("Geography" = "location_code",
         CumulativePositiveTests = total_positive_tests,
         CumulativePositivePillar1Tests	= pillar1_positive_tests,
         CumulativePositivePillar2Tests = pillar2_positive_tests,
         CumulativePositiveLFDTests = lfd_positive_tests)%>%
  mutate(Geography = recode(Geography, "Scotland" = "S92000003"))%>%
  select(Date, Geography, CumulativePositiveTests, CumulativePositivePillar1Tests, CumulativePositivePillar2Tests, CumulativePositiveLFDTests)

rm(Geog_all_pos_tests)

#Read in all test data
all_test_data <-readRDS(glue("/PHI_conf/Real_Time_Epi/Routine_Reporting/Time_Series/Outputs/PCR_LFD/Tests_specimendate_{od_date}.rds")) %>%
  filter(specimen_date <= as.Date(od_sunday))

all_tests_scotland <- all_test_data %>%
  group_by(test_source)%>%
  summarise(tests=sum(tests))%>%
  mutate(location_name="Scotland", location_code="Scotland", geography="Scotland")

all_tests_HB <- all_test_data %>%
  group_by(reporting_health_board, test_source)%>%
  summarise(tests=sum(tests))%>%
  mutate(location_name=paste("NHS",reporting_health_board, sep=" "), geography="Health Board")%>%
  left_join(location_names,by=c("location_name"))%>%
  filter(!is.na(location_code))%>%
  ungroup()%>%
  select(-reporting_health_board)

all_tests_LA <- all_test_data %>%
  group_by(local_authority, test_source)%>%
  summarise(tests=sum(tests))%>%
  rename(location_name=local_authority)%>%
  left_join(location_names,by=c("location_name"))%>%
  mutate(geography="Local Authority")%>%
  filter(!is.na(location_code))

Geog_all_tests <- bind_rows(all_tests_scotland, all_tests_HB, all_tests_LA)%>%
  pivot_wider(names_from = test_source, values_from = tests)%>%
  rename(Pillar1_tests_cumulative = "NHS Lab", Pillar2_tests_cumulative = "UK Gov",
         LFD_tests_cumulative = "LFD self reported")%>%
  mutate_if(is.numeric, ~replace_na(., 0))%>%
  mutate(Total_tests_cumulative = Pillar1_tests_cumulative + Pillar2_tests_cumulative + LFD_tests_cumulative)

rm(all_tests_scotland, all_tests_HB, all_tests_LA)

g_all_tests <- Geog_all_tests %>%
  rename("Geography" = "location_code",
         CumulativeTests = Total_tests_cumulative,
         CumulativePillar1Tests	= Pillar1_tests_cumulative,
         CumulativePillar2Tests = Pillar2_tests_cumulative,
         CumulativeLFDTests = LFD_tests_cumulative)%>%
  mutate(Date=od_date)%>% #Should this be od_Sunday as with weekly geog? filtering above is to OD_sunday
  mutate(Geography = recode(Geography, "Scotland" = "S92000003"))%>%
  select(Date, Geography, CumulativeTests, CumulativePillar1Tests, CumulativePillar2Tests, CumulativeLFDTests)

rm(Geog_all_tests)

##### Combine Cumulative cases, pos tests and all tests into one open data file #####
g_cumulative_geog <- g_total_cases %>%
  left_join(g_pos_tests, by=c("Date", "Geography")) %>%
  left_join(g_all_tests, by=c("Date", "Geography"))%>%
  mutate(Date = format(strptime(Date, format = "%Y-%m-%d"), "%Y%m%d")) %>%
select(Date, Geography, GeographyQF, GeographyName,
       CumulativeTests, CumulativePillar1Tests, CumulativePillar2Tests, CumulativeLFDTests,
       CumulativePositiveTests, CumulativePositivePillar1Tests, CumulativePositivePillar2Tests, CumulativePositiveLFDTests,
       CumulativeCases, CrudeRatePositiveCases, CumulativePCROnlyCases, CumulativeLFDOnlyCases, CumulativeLFDAndPCRCases, geography)
rm(g_total_cases, g_pos_tests, g_all_tests)

g_cumulative_geog_hb <- g_cumulative_geog %>%
  filter(!(geography == "Local Authority")) %>%
  select(LatestDate=Date, 
         HB=Geography, HBQF=GeographyQF, #HBName=GeographyName,
         CumulativeTests, CumulativePillar1Tests, CumulativePillar2Tests, 
         CumulativeLFDTests, CumulativePositiveTests, 
         CumulativePositivePillar1Tests, CumulativePositivePillar2Tests, 
         CumulativePositiveLFDTests,
         CumulativeCases, CrudeRateCumulativeCases= CrudeRatePositiveCases, 
         CumulativePCROnlyCases, CumulativeLFDOnlyCases, CumulativeLFDAndPCRCases)

g_cumulative_geog_la <- g_cumulative_geog %>%
  filter(geography == "Local Authority") %>%
  select(LatestDate=Date, CA= Geography,  #CAName=GeographyName, 
         CumulativeTests, CumulativePositiveTests,
         CumulativeCases, CrudeRateCumulativeCases= CrudeRatePositiveCases, 
         CumulativePCROnlyCases, CumulativeLFDOnlyCases, CumulativeLFDAndPCRCases)

#save out cumulative geography open data file
write_csv(g_cumulative_geog_hb, glue(od_folder, "cumulative_tests_cases_HB_{od_report_date}.csv"), na = "")
write_csv(g_cumulative_geog_la, glue(od_folder, "cumulative_tests_cases_CA_{od_report_date}.csv"), na = "")


rm(g_cumulative_geog, g_cumulative_geog_hb, g_cumulative_geog_la)

##############  Weekly ############################

#### weekly Cases #####

Scotland_week_cases <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  mutate(location_code="Scotland")

HB_week_cases <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, hb2019)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  rename(location_code=hb2019)

LA_week_cases <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, ca2019)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  rename(location_code=ca2019)

#add files together
Geog_week <- bind_rows(Scotland_week_cases, HB_week_cases, LA_week_cases )%>%
  distinct(week_ending, location_code, weekly_positive)%>%
  rename(total_weekly_positive=weekly_positive)

rm(Scotland_week_cases, HB_week_cases, LA_week_cases)

test_type_scotland_week <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, episode_derived_case_type)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  mutate(location_code="Scotland")%>%
  rename(test_type=episode_derived_case_type)

test_type_hb_week <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, hb2019, episode_derived_case_type)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  rename(test_type=episode_derived_case_type, location_code=hb2019)

test_type_la_week <- cases_data %>%
  filter(Date>as.Date("2020/02/27")) %>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, ca2019, episode_derived_case_type)%>%
  summarise(weekly_positive = sum(flag_episode))%>%
  rename(test_type=episode_derived_case_type, location_code=ca2019)

test_type_week <- rbind(test_type_scotland_week, test_type_hb_week, test_type_la_week)

rm(test_type_scotland_week, test_type_hb_week, test_type_la_week)

pcr_week <- test_type_week %>%
  filter(test_type=="PCR POSITIVE CASE")%>%
  select(-test_type)%>%
  rename(pcr_weekly_positive=weekly_positive)

lfd_week <- test_type_week %>%
  filter(test_type=="ANTIGEN POSITIVE CASE")%>%
  select(-test_type)%>%
  rename(lfd_weekly_positive=weekly_positive)

pcr_and_lfd_week <- test_type_week %>%
  filter(test_type=="ANTIGEN AND PCR POSITIVE CASE")%>%
  select(-test_type)%>%
  rename(pcr_and_lfd_weekly_positive=weekly_positive)

Geog_all_week <- Geog_week %>%
  left_join(pcr_week, by=c("week_ending","location_code"))%>%
  left_join(lfd_week, by=c("week_ending","location_code"))%>%
  left_join(pcr_and_lfd_week, by=c("week_ending","location_code"))%>%
  mutate_if(is.numeric, ~replace_na(., 0))%>%
  arrange(location_code, week_ending)%>%
  group_by(location_code)%>%
  mutate(total_cumulative_positive=cumsum(total_weekly_positive), pcr_cumulative_positive=cumsum(pcr_weekly_positive),
         lfd_cumulative_positive=cumsum(lfd_weekly_positive), pcr_and_lfd_cumulative_positive=cumsum(pcr_and_lfd_weekly_positive))%>%
  filter(total_cumulative_positive!=0)%>%
  left_join(location_names, by=c("location_code"))%>%
  mutate(location_name=case_when(is.na(location_name)~"Scotland", TRUE ~ location_name))%>%
  mutate(geography=case_when(location_code=="Scotland"~"Scotland",
                             substr(location_code,1,3)=="S08"~ "Health Board",
                             substr(location_code,1,3)=="S12"~"Local Authority"))%>%
  filter(week_ending<=as.Date(od_sunday)) %>%
  select(week_ending, location_code, location_name, geography,
         total_weekly_positive, total_cumulative_positive, pcr_weekly_positive, pcr_cumulative_positive,
         lfd_weekly_positive, lfd_cumulative_positive, pcr_and_lfd_weekly_positive, pcr_and_lfd_cumulative_positive) %>%
  arrange(week_ending, location_code)

rm(Geog_week, test_type_week, pcr_week, lfd_week, pcr_and_lfd_week)

g_cases_weekly <- Geog_all_week %>%
  rename("WeeklyPositiveCases" = "total_weekly_positive") %>%
  rename("CumulativePositiveCases" = "total_cumulative_positive") %>%
  rename("WeeklyPositivePCROnlyCases" = "pcr_weekly_positive") %>%
  rename("CumulativePositivePCROnlyCases" = "pcr_cumulative_positive") %>%
  rename("WeeklyPositiveLFDOnlyCases" = "lfd_weekly_positive") %>%
  rename("CumulativePositiveLFDOnlyCases" = "lfd_cumulative_positive") %>%
  rename("WeeklyPositivePCRAndLFDCases" = "pcr_and_lfd_weekly_positive") %>%
  rename("CumulativePositivePCRAndLFDCases" = "pcr_and_lfd_cumulative_positive") %>%
  rename("Geography" = "location_code") %>%
  rename("GeographyName" = "location_name") %>%
  mutate(Geography = recode(Geography, "Scotland" = "S92000003")) %>%
  mutate(GeographyQF = if_else(Geography == "S92000003", "d", "")) %>%
  select(week_ending, geography, Geography, GeographyQF, GeographyName, WeeklyPositiveCases, CumulativePositiveCases, WeeklyPositivePCROnlyCases,
         CumulativePositivePCROnlyCases, WeeklyPositiveLFDOnlyCases, CumulativePositiveLFDOnlyCases, WeeklyPositivePCRAndLFDCases, CumulativePositivePCRAndLFDCases)%>%
  arrange(Geography)

rm(Geog_all_week)

#### weekly Positive Tests #######
weekly_pillar_scotland <- pos_test_data%>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, pillar)%>%
  summarise(weekly_positive_tests=n())%>%
  mutate(location_code="Scotland")%>%
  select(week_ending, location_code, pillar, weekly_positive_tests)

#Weekly figures by Board and pillar
weekly_pillar_board <- pos_test_data%>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, pillar, hb2019)%>%
  summarise(weekly_positive_tests=n())%>%
  rename(location_code=hb2019)%>%
  filter(location_code!="")%>%
  select(week_ending, location_code, pillar, weekly_positive_tests)

#Weekly figures by LA and pillar
weekly_pillar_LA <- pos_test_data%>%
  mutate(week_ending = ceiling_date(Date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, pillar,ca2019)%>%
  summarise(weekly_positive_tests=n())%>%
  rename(location_code=ca2019)%>%
  filter(location_code!="")%>%
  select(week_ending, location_code, pillar, weekly_positive_tests)

weekly_all <- bind_rows(weekly_pillar_scotland, weekly_pillar_board, weekly_pillar_LA)

rm(weekly_pillar_scotland, weekly_pillar_board, weekly_pillar_LA)

weekly_pillar1 <- weekly_all %>%
  filter(pillar=="Pillar 1")%>%
  rename(pillar1_weekly_positive_tests=weekly_positive_tests)%>%
  select(week_ending, location_code, pillar1_weekly_positive_tests)

weekly_pillar2 <- weekly_all %>%
  filter(pillar=="Pillar 2")%>%
  rename(pillar2_weekly_positive_tests=weekly_positive_tests)%>%
  select(week_ending, location_code, pillar2_weekly_positive_tests)

weekly_lfd_tests <- weekly_all %>%
  filter(pillar=="LFD")%>%
  rename(lfd_weekly_positive_tests=weekly_positive_tests)%>%
  select(week_ending, location_code, lfd_weekly_positive_tests)

rm(weekly_all)

Geog_weekly_all_pos_tests <- weekly_pillar1 %>%
  left_join(weekly_pillar2, by=c("week_ending","location_code"))%>%
  left_join(weekly_lfd_tests, by=c("week_ending","location_code"))%>%
  mutate(pillar1_weekly_positive_tests = replace(pillar1_weekly_positive_tests, is.na(pillar1_weekly_positive_tests), 0),
         pillar2_weekly_positive_tests = replace(pillar2_weekly_positive_tests, is.na(pillar2_weekly_positive_tests), 0),
         lfd_weekly_positive_tests = replace(lfd_weekly_positive_tests, is.na(lfd_weekly_positive_tests), 0))%>%
  mutate(total_weekly_positive_tests = pillar1_weekly_positive_tests + pillar2_weekly_positive_tests + lfd_weekly_positive_tests)

rm(weekly_pillar1, weekly_pillar2, weekly_lfd_tests)

g_weekly_pos_tests <- Geog_weekly_all_pos_tests %>%
  rename("Geography" = "location_code",
         TotalPositiveTests = total_weekly_positive_tests,
         PositivePillar1Tests	= pillar1_weekly_positive_tests,
         PositivePillar2Tests = pillar2_weekly_positive_tests,
         PositiveLFDTests = lfd_weekly_positive_tests)%>%
  mutate(Geography = recode(Geography, "Scotland" = "S92000003"))%>%
  select(week_ending, Geography, TotalPositiveTests, PositivePillar1Tests,PositivePillar2Tests, PositiveLFDTests)

rm(Geog_weekly_all_pos_tests)

#All Tests
weekly_all_tests_scotland <- all_test_data %>%
  mutate(week_ending = ceiling_date(specimen_date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, test_source)%>%
  summarise(tests=sum(tests))%>%
  mutate(location_name="Scotland", location_code="Scotland", geography="Scotland")

weekly_all_tests_HB <- all_test_data %>%
  mutate(week_ending = ceiling_date(specimen_date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, reporting_health_board, test_source)%>%
  summarise(tests=sum(tests))%>%
  mutate(location_name=paste("NHS",reporting_health_board, sep=" "), geography="Health Board")%>%
  left_join(location_names,by=c("location_name"))%>%
  filter(!is.na(location_code))%>%
  ungroup()%>%
  select(-reporting_health_board)

weekly_all_tests_LA <- all_test_data %>%
  mutate(week_ending = ceiling_date(specimen_date, unit = "week", change_on_boundary = F)) %>%
  group_by(week_ending, local_authority, test_source)%>%
  summarise(tests=sum(tests))%>%
  rename(location_name=local_authority)%>%
  left_join(location_names,by=c("location_name"))%>%
  mutate(geography="Local Authority")%>%
  filter(!is.na(location_code))

Geog_weekly_all_tests <- bind_rows(weekly_all_tests_scotland, weekly_all_tests_HB, weekly_all_tests_LA)%>%
  pivot_wider(names_from = test_source, values_from = tests)%>%
  rename(Pillar1_tests_weekly = "NHS Lab", Pillar2_tests_weekly = "UK Gov",
         LFD_tests_weekly = "LFD self reported")%>%
  mutate_if(is.numeric, ~replace_na(., 0))%>%
  mutate(Total_tests_weekly = Pillar1_tests_weekly + Pillar2_tests_weekly + LFD_tests_weekly)

rm(weekly_all_tests_scotland, weekly_all_tests_HB, weekly_all_tests_LA)

g_all_tests_weekly <- Geog_weekly_all_tests %>%
  rename("Geography" = "location_code",
         TotalTests = Total_tests_weekly,
         TotalPillar1Tests	= Pillar1_tests_weekly,
         TotalPillar2Tests = Pillar2_tests_weekly,
         TotalLFDTests = LFD_tests_weekly)%>%
  mutate(Date=od_date)%>%
  mutate(Geography = recode(Geography, "Scotland" = "S92000003"))%>%
  select(week_ending, Geography, TotalTests, TotalPillar1Tests, TotalPillar2Tests, TotalLFDTests)

rm(Geog_weekly_all_tests)


#### join tests and cases  ####

#Weekly HB file
g_weekly_hb <- g_cases_weekly %>%
  filter(!(geography == "Local Authority")) %>%
  left_join(g_weekly_pos_tests, by=c("week_ending", "Geography")) %>%
  left_join(g_all_tests_weekly, by=c("week_ending", "Geography")) %>%
  select(-geography) %>%
  arrange(week_ending, Geography)%>%
  mutate(TotalPositiveTests = replace(TotalPositiveTests, is.na(TotalPositiveTests), 0),
         PositivePillar1Tests = replace(PositivePillar1Tests, is.na(PositivePillar1Tests), 0),
         PositivePillar2Tests = replace(PositivePillar2Tests, is.na(PositivePillar2Tests), 0)) %>%
  mutate(week_ending = format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d")) %>%
  select(WeekEnding=week_ending, 
         HB= Geography, 
         HBQF=GeographyQF, 
         #HBName=GeographyName, 
         WeeklyTotalTests= TotalTests, 
         WeeklyTotalPillar1Tests= TotalPillar1Tests, 
         WeeklyTotalPillar2Tests= TotalPillar2Tests, 
         WeeklyTotalLFDTests= TotalLFDTests,
         WeeklyTotalPositiveTests= TotalPositiveTests, 
         WeeklyPositivePillar1Tests= PositivePillar1Tests,
         WeeklyPositivePillar2Tests= PositivePillar2Tests, 
         WeeklyPositiveLFDTests= PositiveLFDTests,
         WeeklyCases= WeeklyPositiveCases,
         WeeklyPCROnlyCases= WeeklyPositivePCROnlyCases,
         WeeklyLFDOnlyCases= WeeklyPositiveLFDOnlyCases, 
         WeeklyPCRAndLFDCases= WeeklyPositivePCRAndLFDCases, 
         CumulativeCases= CumulativePositiveCases,
         CumulativePCROnlyCases= CumulativePositivePCROnlyCases,
         CumulativeLFDOnlyCases= CumulativePositiveLFDOnlyCases, 
         CumulativePCRAndLFDCases= CumulativePositivePCRAndLFDCases)

write_csv(g_weekly_hb, glue(od_folder, "weekly_tests_cases_HB_{od_report_date}.csv"), na = "")

rm(g_weekly_hb)

#Weekly LA file
g_weekly_la <- g_cases_weekly %>%
  filter(geography == "Local Authority") %>%
  left_join(g_weekly_pos_tests, by=c("week_ending", "Geography")) %>%
  left_join(g_all_tests_weekly, by=c("week_ending", "Geography")) %>%
  select(-geography) %>%
  arrange(week_ending, Geography)%>%
  mutate(TotalPositiveTests = replace(TotalPositiveTests, is.na(TotalPositiveTests), 0),
         PositivePillar1Tests = replace(PositivePillar1Tests, is.na(PositivePillar1Tests), 0),
         PositivePillar2Tests = replace(PositivePillar2Tests, is.na(PositivePillar2Tests), 0)) %>%
  mutate(week_ending = format(strptime(week_ending, format = "%Y-%m-%d"), "%Y%m%d")) %>%
  select(WeekEnding=week_ending, CA=Geography, #CAName=GeographyName,
         WeeklyTotalTests= TotalTests, 
         WeeklyTotalPositiveTests= TotalPositiveTests, 
         WeeklyCases= WeeklyPositiveCases,
         WeeklyPCROnlyCases= WeeklyPositivePCROnlyCases,
         WeeklyLFDOnlyCases= WeeklyPositiveLFDOnlyCases, 
         WeeklyPCRAndLFDCases= WeeklyPositivePCRAndLFDCases, 
         CumulativeCases= CumulativePositiveCases,
         CumulativePCROnlyCases= CumulativePositivePCROnlyCases,
         CumulativeLFDOnlyCases= CumulativePositiveLFDOnlyCases,
         CumulativePCRAndLFDCases= CumulativePositivePCRAndLFDCases)

write_csv(g_weekly_la, glue(od_folder, "weekly_tests_cases_CA_{od_report_date}.csv"), na = "")


rm(CA_lookup, HB_lookup, location_names, populations, SPD, i_combined_pcr_lfd_tests, pos_test_data, all_test_data,
   cases_data, g_weekly_la, g_cases_weekly, g_weekly_pos_tests,
   g_all_tests_weekly)#, g_adms_weekly_all)

###### end of script ######