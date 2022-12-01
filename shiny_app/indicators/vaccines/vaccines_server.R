

output$vaccine_wastage_table <- DT::renderDataTable({
  Vaccine_Wastage %>%
    arrange(desc(Month)) %>%
    mutate(Month = convert_date_to_month(convert_opendata_date(Month))) %>%
    dplyr::rename(`Number of doses administered` = NumberOfDosesAdministered, `Number of doses wasted` = NumberOfDosesWasted,
                  `Percentage wasted` = PercentageWasted) %>%
    make_table(add_separator_cols = c(2,3), add_percentage_cols = 4)
  })


