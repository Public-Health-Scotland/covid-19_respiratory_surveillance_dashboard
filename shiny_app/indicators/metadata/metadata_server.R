observeEvent(input$jump_to_metadata_cases,
             {updateTabsetPanel(session, "intabset", selected = "metadata")
              updateCollapse(session, "notes_collapse", open = "Cases")})

observeEvent(input$jump_to_metadata_vaccines,
             {updateTabsetPanel(session, "intabset", selected = "metadata")
               updateCollapse(session, "notes_collapse", open = "Vaccine wastage")})

observeEvent(input$jump_to_metadata_hospital_admissions,
             {updateTabsetPanel(session, "intabset", selected = "metadata")
               updateCollapse(session, "notes_collapse", open = "Hospital admissions")})

observeEvent(input$jump_to_metadata_hospital_occupancy,
             {updateTabsetPanel(session, "intabset", selected = "metadata")
               updateCollapse(session, "notes_collapse", open = "Hospital occupancy")})

observeEvent(input$jump_to_metadata_respiratory,
             {updateTabsetPanel(session, "intabset", selected = "metadata")
               updateCollapse(session, "notes_collapse", open = "Respiratory")})
