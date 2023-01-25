# Deployment functions

is_password_protected <- function(app_loc){

  # Read whether password protect is set to TRUE or not in file
  protected <- grep("password_protect <-", readr::read_lines(paste0(app_loc, "/app.R")),
                    value=TRUE) %>%
    # Is password_protect set to TRUE?
    grepl("TRUE", .)

  return(protected)

}

deploy <- function(app_loc, pra = TRUE){

  protected <- is_password_protected(app_loc)

  if(pra) {
    app_name = "phs-respiratory-covid-19-pra"
    if (!protected){
      stop("Set password_protect to TRUE in app.R to deploy to PRA.")
    }

  } else {
    app_name = "phs-respiratory-covid-19"
    if(protected){
      stop("Set password_protect to FALSE in app.R to deploy to public app.")
    }
  }

  rsconnect::deployApp(appDir = app_loc,
                       # appFiles = public_files,
                       appName = app_name,
                       account = "scotland",
                       logLevel = "verbose"
  )

}

check_logs <- function(app_loc, pra = TRUE){

  if(pra) {
    app_name = "phs-respiratory-covid-19-pra"

  } else {
    app_name = "phs-respiratory-covid-19"

  }

  rsconnect::showLogs(appPath = app_loc,
                      appName = app_name,
                      account = "scotland")
}

