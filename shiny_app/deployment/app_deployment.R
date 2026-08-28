########################################
############ Deploying app #############
########################################
# Source this file to deploy the app


#Change this to set the test to true. This should bypass the PRA.
# If deploying to PRA or live, put test as FALSE and update line 16 pra variable.

######## ***ALSO CHANGE TEST STATUS IN app.R line 399*** .#############

test <- FALSE

# Set this to TRUE to deploy for pre-release access (password protected)
# Set this to FALSE to deploy to the public app
pra <- TRUE

# Get deployment functions
source("shiny_app/deployment/deployment_functions.R")

# Get secrets for deployment
# NB: you must set this file up using information from colleagues
source("shiny_app/deployment/deployment_secrets.R")


# This deploys the app
deploy(app_loc, test = test, pra = pra)

# Check logs of deployed app
check_logs(app_loc, test=test, pra = pra)

###########################################################
##END
