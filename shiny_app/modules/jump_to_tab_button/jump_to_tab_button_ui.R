#### Buttons for jumping to a tab
#### This doesn't include the big buttons on the introduction page

jumpToTabButtonUI <- function(id,
                              location_pretty # e.g. "hospital admissions"
                              ){

  ns <- NS(id)

  actionButton(ns("jump_to_tab"),
               label = glue("Go to tab"),
               class = "jump-to-tab-btn",
               icon = icon_no_warning_fn("paper-plane")
  )

}