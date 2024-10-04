#### CONFIDENCE INTERVAL DEFINITION ####
ciDefinitionUI <- function(id) {
  ns <- NS(id)
  
  summaryButtonUI(ns("ci_definition"),
                  title = "What is a confidence interval?",
                  content = paste("A confidence interval gives an indication of the degree of uncertainty of an estimate,",
                                  "showing the precision of a sample estimate. The 95% confidence intervals are calculated so",
                                  "that if we repeated the study many times, 95% of the time the confidence interval would contain", 
                                  "the true unknown value. A wider interval indicates more uncertainty",
                                  "in the estimate. Overlapping confidence intervals indicate that there may not be a true",
                                  "difference between two estimates."),
                  placement = "bottom",
                  label = "What is a confidence interval?",
                  icon = "circle-question",
                  class = "plotinfo-btn"
  )
  
  
}

#### SWAB POSITIVITY DEFINITION ####
# in the dashboard "Swab positivity"  now referred to as "Test positivity", 
swabposDefinitionUI <- function(id) {
  ns <- NS(id)
  
  summaryButtonUI(ns("swabpos_definition"),
                  title = "What is test positivity?",
                  content = paste("Test positivity is the percentage of positive laboratory results among a defined number of ",
                                  "laboratory tested samples, i.e. number of positives divided by total number of laboratory tests done."),
                  placement = "bottom",
                  label = "What is test positivity?",
                  icon = "circle-question",
                  class = "plotinfo-btn"
  )
  
  
}
