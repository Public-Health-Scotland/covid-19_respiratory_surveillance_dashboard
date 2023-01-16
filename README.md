# COVID-19 Dashboard

* This is a Public Health Scotland R shiny app available to the public [here (external link)]()
* The data underlying the app can be found on the [PHS open data website (external link)](https://www.opendata.nhs.scot/)

## Deploying the R shiny app

1. Navigate to `Dashboard Data Transfer/dashboard_data_transfer.R` and source. This prepares the data for use in the app.

2. Run `app_data_preparation.R` to transfer the prepared files to `shiny_app/data`.

3. Run app from `shiny_app/app.R` to view app locally to check content.

4. Obtain `shiny_app/AppDeployment.R` from colleagues. Edit the paths to point to your local `shiny_app` folder. Run to deploy the app.

## Developing the R shiny app

### Data transfer layout

* `Dashboard Data Transfer` contains the data transfer code. This is for transferring data from mixed inputs to open data format ready for use in the app.

* `dashboard_data_transfer.R` is the script for doing the transfer

* `Transfer Scripts` contains individual scripts called from `dashboard_data_transfer.R`


### App code layout

* `shiny_app` contains all the app code

* `app.R` is the main app file

* `setup.R` contains the necessary packages and some settings. This is run once on deployment and not for every new user. It also loads all the data in `shiny_app/data`.

* `AppDeployment.R` (not committed; obtain from colleagues) is for deploying the app

* `data` contains all the data needed for the shiny app. It is populated using the `app_data_preparation.R` script

* `functions` contains general functions used in several places across the app. 

  * `core_functions.R` includes general functions and also functions for making data tables
  
  * `plot_functions.R` includes general plotting functions
  
* `www` contains static images as well as additional css and javascript code

* `modules` contains sub-folders of shiny modules used by the app

* `indicators` contains sub-folders for each topic/tab in the app. Each sub-folder contains a ui script, a server script and a functions script.




