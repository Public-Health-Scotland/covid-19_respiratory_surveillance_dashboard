#### CONFIDENCE INTERVAL DEFINITION ####
ciDefinitionUI <- function(id) {
  ns <- NS(id)
  
  summaryButtonUI(ns("ci_definition"),
                  title = "What is a confidence interval?",
                  content = paste("A confidence interval gives an indication of the degree of uncertainty of an estimate,",
                                  "showing the precision of a sample estimate. The 95% confidence intervals are calculated so",
                                  "that if we repeated the study many times, 95% of the time the true unknown value would lie",
                                  "between the lower and upper confidence limits. A wider interval indicates more uncertainty",
                                  "in the estimate. Overlapping confidence intervals indicate that there may not be a true",
                                  "difference between two estimates."),
                  placement = "bottom",
                  label = "What is a confidence interval?",
                  icon = "circle-question",
                  class = "plotinfo-btn"
  )
  
  
}

#### SWAB POSITIVITY DEFINITION ####
swabposDefinitionUI <- function(id) {
  ns <- NS(id)
  
  summaryButtonUI(ns("swabpos_definition"),
                  title = "What is swab positivity?",
                  content = paste("Swab positivity is the percentage of positive laboratory results among a defined number of ",
                                  "laboratory tested samples, i.e. number of positives divided by total number of laboratory tests done."),
                  placement = "bottom",
                  label = "What is swab positivity?",
                  icon = "circle-question",
                  class = "plotinfo-btn"
  )
  
  
}
