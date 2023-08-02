########################################
############ Deploying app #############
########################################

# Source this file to deploy the app
# Set this to TRUE to deploy for pre-release access (password protected)
# Set this to FALSE to deploy to the public app
pra <- FALSE

# Get deployment functions
source("shiny_app/deployment/deployment_functions.R")

# Get secrets for deployment
# NB: you must set this file up using information from colleagues
source("shiny_app/deployment/deployment_secrets.R")

# Set deployment date
set_deployment_date()

# This deploys the app
deploy(app_loc, pra = pra)

# Check logs of deployed app
check_logs(app_loc, pra = pra)

###########################################################
##END
