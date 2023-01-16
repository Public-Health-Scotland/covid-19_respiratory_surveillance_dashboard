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
              withSpinner(uiOutput("introduction_about"))
            ), # conditionalPanel

            # Using the dashboard
            conditionalPanel(
              condition= "input.home_select == 'use'",
              withSpinner(uiOutput("introduction_use"))
                      ), # condtionalPanel

            # Further information
            conditionalPanel(
              condition= "input.home_select == 'info'",
              withSpinner(uiOutput("introduction_info"))
            ), # conditionalPanel

            # Accessibility
            conditionalPanel(
              condition= "input.home_select == 'accessibility'",
              withSpinner(uiOutput("introduction_accessibility"))
            ) # conditonalPanel
                      ) # mainPanel
              ) # sidebarLayout


