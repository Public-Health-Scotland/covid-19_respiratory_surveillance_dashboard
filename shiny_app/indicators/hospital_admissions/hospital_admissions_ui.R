tagList(
  fluidRow(width = 12,
           metadataButtonUI("hospital_admissions"),
           linebreaks(1),
           #h1("Acute COVID-19 hospital admissions"),
           #linebreaks(1)
           ),

  fluidRow(width = 12,
                  tabPanel("Acute hospital admissions",
                           tagList(h2("Number of acute COVID-19 admissions to hospital in Scotland"),
                                   tags$div(class = "headline",
                                            linebreaks(1),
                                            #h3("Weekly totals from last three weeks"),

                                            valueBox(value = {admissions_headlines[1,2] %>% .$cov %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {admissions_headlines[1,1] %>% .$Date %>%
                                                                format('%d %b %y')}"),
                                                color = "navy",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = {admissions_headlines[2,2] %>% .$cov %>%
                                                format(big.mark = ",")},
                                                subtitle = glue("Week ending {admissions_headlines[2,1] %>% .$Date %>%
                                                                format('%d %b %y')}"),
                                                color = "navy",
                                                icon = icon_no_warning_fn("calendar-week")),
                                            valueBox(value = glue("{admissions_headlines[3,2] %>% .$cov %>% 
                                                                    format(big.mark = ",")}*"),
                                                     subtitle = glue("Week ending {admissions_headlines[3,1] %>% .$Date %>%
                                                                format('%d %b %y')}"),
                                                     color = "navy",
                                                     icon = icon_no_warning_fn("calendar-week")),
                                            h4("* provisional figures",
                                               actionButton("glossary",
                                                            label = "Go to glossary",
                                                            icon = icon_no_warning_fn("paper-plane")
                                                            )), 
                                               p("Between 22 May and October 2025, Public Health Scotland (PHS) will be",
                                                 "reporting Scotland level admissions for COVID-19,",
                                                 "Influenza and RSV, due to low levels of hospital admissions."),
                                               h6("hidden text for padding page")
                                              
                                               ,
                                            ),


                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_modal"),
                                             withNavySpinner(plotlyOutput("hospital_admissions_plot"))),
                                           fluidRow(column(
                                             width=12, linebreaks(1),
                                             p("*Hospital admissions for the most recent week may be incomplete,",
                                               "and should be treated as provisional and interpreted with caution."),
                                           ))),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(dataTableOutput("hospital_admissions_table")))
                                           ),

                           ),
                           
                           tagList(h2("Rate of acute COVID-19 hospital admissions by age group")),
                           
                           #),
                           br(),
                           fluidRow(
                             tabBox(width = NULL,
                                    type = "pills",
                                    tabPanel("Plot",
                                             tagList(linebreaks(1),
                                                     altTextUI("hospital_admissions_age_modal"),
                                                     withNavySpinner(plotlyOutput("covid_admissions_age_plot")),
                                             )),
                                    tabPanel("Data",
                                             tagList(linebreaks(1),
                                                     withNavySpinner(dataTableOutput("covid_admissions_age_table"))
                                             ) # tagList
                                    ) # tabPanel
                                    
                             ), # tabBox
                             linebreaks(1)
                           ), # fluidRow
                           


                           #          tagList(h2("Number of acute COVID-19 admissions to hospital by NHS Health Board of treatment; week ending")),
                           # 
                           # 
                           # fluidRow(width=12,
                           #          box(width = NULL,
                           #              withNavySpinner(dataTableOutput("hospital_admissions_hb_table"))),
                           # ),

                           tagList(h2("Weekly number of acute COVID-19 hospital admissions by deprivation category (SIMD)"))

                           ),
                           br(),

                           tabBox(width = NULL, type = "pills",
                                  tabPanel("Plot",
                                           tagList(
                                             linebreaks(1),
                                             altTextUI("hospital_admissions_simd_modal"),
                                             actionButton("btn_modal_simd",
                                                          label = "What is SIMD?",
                                                          class = "simd-btn",
                                                          icon = icon_no_warning_fn("circle-question")
                                             ),
                                             withNavySpinner(
                                               plotlyOutput("hospital_admissions_simd_plot"))
                                            )
                                           ),
                                  tabPanel("Data",
                                           tagList(
                                             withNavySpinner(
                                               dataTableOutput("hospital_admissions_simd_table"))
                                            )
                                           )

                           ),
                           tagList(h2("Number of acute COVID-19 admissions to hospital by ethnicity"),
                                   #  temporary caveat for no Ethnicity information
                                   tagList("Public Health Scotland have paused reporting of  COVID-19 admissions to",
                                           "hospital broken down by ethnic group",
                                           " as we undertake developments",
                                           "to include this analysis for other respiratory pathogens.")),
##### age/sex admissions pyramid        
           
           # #tagList(h2(glue("Acute COVID-19 cases by age and sex in Scotland")),
           # tagList(uiOutput("cov_adm_pyr_title")),
           # tabBox(width = NULL,
           #        type = "pills",
           #        tabPanel("Plot",
           #                 tagList(linebreaks(1),
           #                         fluidRow(column(4, pickerInput("cov_age_sex_adm_season",
           #                                                        label = "Select a season",
           #                                                        choices = {Admissions_AgeSex_Season %>% 
           #                                                            filter(Pathogen == "cov") %>%
           #                                                            .$Season %>% unique()},
           #                                                        selected = "2024-2025")  )),#tfluidrow
           #                                                   altTextUI("covid_adm_age_sex"),
           #                         withNavySpinner(plotlyOutput("covid_adm_age_sex_pyramid_plot"))
           #                                                 ) # tagList
           #                                        ), # tabPanel
           #        tabPanel("Data",
           #                 withNavySpinner(dataTableOutput("covid_adm_age_sex_pyramid_table"))) #tabpanel
           #               ), # tabbox
           #                         #), #age/sex 
           #                # ),
##### LOS section
                      tagList(h2("Length of stay of acute COVID-19 hospital admissions by age group")),
                      br(),
                              #  temporary caveat for no LOS information
                              # tagList("Public Health Scotland have paused reporting of the Length",
                              #         "of Stay of acute COVID-19 hospital admissions as we undertake developments",
                              #         "to include this analysis for other respiratory pathogens.")),


                           # tagList(h2("Length of stay of acute COVID-19 hospital admissions"),
                           #         tags$div(class = "headline",
                           #                  h3(glue("Median length of stay of acute COVID-19 hospital admissions for 4 week period {los_date_start %>% format('%d %b %y')} to {los_date_end%>% format('%d %b %y')} ")),
                           #                  valueBox(value = glue("{
                           #                                       Length_of_Stay_Median %>% 
                           #                                       filter(AgeGroup == 'All Ages') %>% 
                           #                                       filter(Pathogen =='cov') %>%
                           #                                       .$MedianLengthOfStay %>% round_half_up(1)} days"),
                           #                           subtitle = glue("All ages"),
                           #                           color = "navy",
                           #                           icon = icon_no_warning_fn("clock")),# valuebox
                           #                  valueBox(value = glue("{cov_los_median_min$MedianLengthOfStay %>%
                           #                                        round_half_up(1)} days"),
                           #                           subtitle = glue("Shortest median stay ({cov_los_median_min$AgeGroup})"),
                           #                           color = "navy",
                           #                           icon = icon_no_warning_fn("clock")),# value box
                           #                  valueBox(value = glue("{cov_los_median_max$MedianLengthOfStay %>%
                           #                                        round_half_up(1)} days"),
                           #                           subtitle = glue("Longest median stay ({cov_los_median_max$AgeGroup})"),
                           #                           color = "navy",
                           #                           icon = icon_no_warning_fn("clock")),
                           #                 # This text is hidden by css but helps pad the box at the bottom
                           #                 h6("hidden text for padding page"))
                           #         ),
                           # br(), 
                           tabBox( width = NULL, type = "pills",
                                   tabPanel("Plot",
                                            #tagList(uiOutput("cov_los_title")),
                                            tagList(h5("Use the drop-down menu to select a season.")),
                                                   pickerInput(inputId = "los_season_cov",
                                                               label = "Select season",
                                                               choices = {Median_LOS_by_Age  %>%
                                                                   .$Season %>% unique() },
                                                               selected = {Median_LOS_by_Age  %>%
                                                                   .$Season %>% unique() %>% tail(1)}),
                                            # selectInput(inputId = "los_cov_age", 
                                            #             label = "Select age group(s) of interest:", 
                                            #             choices = unique(Median_LOS_by_Age$los_age_band),
                                            #             selected = sort(unique(Median_LOS_by_Age$los_age_band), decreasing = TRUE)[1],
                                            #             multiple = TRUE),
                                            altTextUI("cov_los_modal"),
                                                   withNavySpinner( plotlyOutput("cov_los_plot"))
                                            ),#tabPanel,
                                  tabPanel("Data",
                                           tagList(linebreaks(1),
                                                   withNavySpinner(dataTableOutput("cov_los_table")) )
                                   ) # tabPanel
                                  #)#tabbox
### end LOS section
                           )#tabBox
                           )), #fluid row



  # Padding out the bottom of the page
  fluidRow(height="200px", width=12, linebreaks(5))

)#taglist
