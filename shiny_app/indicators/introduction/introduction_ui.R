sidebarLayout(
  sidebarPanel(width = 4,
               radioGroupButtons("home_select", status = "home",
                                 choices = home_list,
                                 direction = "vertical", justified = T)),

  mainPanel(width = 8,
            # About
            conditionalPanel(
              condition= "input.home_select == 'about'",
              # These have to be uiOutputs rather than just tagLists because otherwise
              # the ui loads before the conditional panel hides the info so for some
              # time at the beginning of the app all of the panels are visible
              withNavySpinner(uiOutput("introduction_about"))
            ), # conditionalPanel

            # Using the dashboard
            conditionalPanel(
              condition= "input.home_select == 'use'",
              withNavySpinner(uiOutput("introduction_use"))
                      ), # condtionalPanel

            # Further information
            conditionalPanel(
              condition= "input.home_select == 'contact'",
              withNavySpinner(uiOutput("introduction_contact"))
            ), # conditionalPanel

            # Accessibility
            conditionalPanel(
              condition= "input.home_select == 'accessibility'",
              withNavySpinner(uiOutput("introduction_accessibility"))
            ), # conditonalPanel

            #Open data
            conditionalPanel(
              condition= "input.home_select == 'open_data'",
              withNavySpinner(uiOutput("introduction_open_data"))
            ) # conditonalPanel
                      ) # mainPanel
              ) # sidebarLayout


