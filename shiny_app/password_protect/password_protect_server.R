# Get credentials for securing app ----
credentials <- readRDS("password_protect/credentials.rds")

# Shinymanager Auth
res_auth <- secure_server(
  check_credentials = check_credentials(credentials),
  timeout = 30
)

output$auth_output <- renderPrint({
  reactiveValuesToList(res_auth)
})
