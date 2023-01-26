# Deployment functions

set_deployment_date <- function(){

  Deployment_Date <- lubridate::today() %>% format("%d %B %Y")
  saveRDS(Deployment_Date, paste0(app_loc, "/data/Deployment_Date.rds"))

}

password_protect <- function(protect = TRUE){

  if(protect){
    message("Password protecting app")
  } else {
    message("No password protection on app")
  }

  saveRDS(protect, paste0(app_loc, "/data/Password_Protect.rds"))

}

deploy <- function(app_loc, pra = TRUE){

  #protected <- is_password_protected(app_loc)

  if(pra) {
    app_name = "phs-respiratory-covid-19-pra"
    password_protect(TRUE)

  } else {
    app_name = "phs-respiratory-covid-19"
    password_protect(FALSE)

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

