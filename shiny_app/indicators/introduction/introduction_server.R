

#Naviagtion buttons on intro page ----
observeEvent(input$jump_to_summary, {updateTabsetPanel(session, "intabset", selected = "summary")})
observeEvent(input$jump_to_cases, {updateTabsetPanel(session, "intabset", selected = "cases")})
observeEvent(input$jump_to_hospital_admissions, {updateTabsetPanel(session, "intabset", selected = "hospital_admissions")})
observeEvent(input$jump_to_hospital_occupancy, {updateTabsetPanel(session, "intabset", selected = "hospital_occupancy")})
observeEvent(input$jump_to_vaccines, {updateTabsetPanel(session, "intabset", selected = "vaccines")})
observeEvent(input$jump_to_notes, {updateTabsetPanel(session, "intabset", selected = "notes")})
observeEvent(input$jump_to_download, {updateTabsetPanel(session, "intabset", selected = "download")})