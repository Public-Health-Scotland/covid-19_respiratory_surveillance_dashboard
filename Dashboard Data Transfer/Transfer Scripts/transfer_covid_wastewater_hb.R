# Dashboard data transfer for Wastewater HB data
# Sourced from ../dashboard_data_transfer.R

i_healthboard <- read_csv_with_options(glue(input_data, "HBtable_NHSLothian{report_date-1}.csv")) %>% 
  select(-1)

hb_avg <- i_healthboard %>% 
  select(1,2,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33) %>% 
  pivot_longer(cols = c(3:18), names_to = "health_board", values_to = "average") %>% 
  mutate(health_board = gsub(" Avg", "", health_board))

hb_cov <- i_healthboard %>% 
  select(1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34) %>% 
  pivot_longer(cols = c(3:18), names_to = "health_board", values_to = "coverage")%>% 
  mutate(health_board = gsub(" Coverage", "", health_board))

g_healthboard <- hb_avg %>% 
  left_join(hb_cov)

write_csv(g_healthboard,
          glue(output_folder, "COVID_Wastewater_HB_table.csv"))

rm(i_healthboard, g_healthboard, hb_avg, hb_cov)
