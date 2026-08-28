# Deployment functions


password_protect <- function(protect = TRUE){

  if(protect){
    message("Password protecting app")
  } else {
    message("No password protection on app")
  }

  saveRDS(protect, paste0(app_loc, "/data/Password_Protect.rds"))

}

deploy <- function(app_loc, test = TRUE, pra = TRUE){

  #protected <- is_password_protected(app_loc)
  if(test) {
    app_name = "phs-respiratory-covid-19-test"
    password_protect(TRUE)
  }

  else if(pra) {
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

check_logs <- function(app_loc, test = TRUE, pra = TRUE){
  
  if(test) {
    app_name = "phs-respiratory-covid-19-test"
    password_protect(TRUE)
  }

  else if(pra) {
    app_name = "phs-respiratory-covid-19-pra"

  } else {
    app_name = "phs-respiratory-covid-19"

  }

  rsconnect::showLogs(appPath = app_loc,
                      appName = app_name,
                      account = "scotland")
}

