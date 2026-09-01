## SPARKLINES FUNCTION ##

sparkline_faceted_plotly <- function(data, latest, 
                                     x, y, facet_var,
                                     colour, title,
                                     label_suffix = "",
                                     left_marg = 20,
                                     right_marg=20, 
                                     Metric = NA) {
  
  facets <- levels(data[[facet_var]])
  x_range <- range(data[[x]], na.rm = TRUE)
  y_range <- range(data[[y]], na.rm = TRUE)
  
  
  subplot_list <- lapply(facets, function(f) {
    
    df_f      <- data   %>% filter(.data[[facet_var]] == f)
    latest_f <- latest %>% filter(.data[[facet_var]] == f)
    
    plot_ly(df_f, x = ~.data[[x]], y = ~.data[[y]],
            type = "scatter", mode = "lines",
            line = list(color = colour),
            showlegend=FALSE,
            hovertemplate = paste0(
              "Week ending: %{x|%d %b %Y}<br>",
              "Value: %{y}",
              label_suffix,
              "<extra></extra>")
    ) %>%
      
      # ribbon (area under curve)
      add_ribbons(ymin = 0, ymax = ~.data[[y]],
                  fillcolor = colour,
                  opacity = 0.2,
                  line = list(width = 0),
                  showlegend = FALSE) %>%
      
      # label
      
      
      add_annotations(
        data = latest_f,
        x = ~lab_x_pos,
        y = ~lab_y_pos,
        
        
        text = ~{
          arrow <- ifelse(change > 0, "▲",
                          ifelse(change < 0, "▼", "="))
          
          activity_text <- if(isTRUE(Metric == "Cases")) {
            paste0(
              "<br>",
              "<span style='font-size:16px'>", ActivityLevel, "</span>"
            )
          } else {
            ""
          }
          
          paste0(
            "<b>", .data[[y]], label_suffix, " ", "</b>",
            "<span style='font-size:14px'>", arrow, "</span>",
            activity_text
          )
        }
        ,
        
        showarrow = FALSE,
        
        xanchor = "left",
        align = "center",
        
        # ✅ BOX STYLING
        bgcolor = ~ifelse(
          Metric == "Cases",
          colour_map_alpha[ActivityLevel],  # coloured for cases
          "white"                           # neutral for others
        ),
        
        bordercolor = "black",
        borderwidth = 1,
        borderpad = 6,
        
        font = list(size = 14, color = "black"),
        opacity = 1
      ) %>%
      
      layout(
        yaxis = list(title = "", 
                     showticklabels = FALSE, 
                     zeroline = FALSE,
                     range=y_range),
        xaxis = list(
          range = x_range,
          title = "Week Ending",
          tickformat = "%b",
          dtick = "M3"
        ),
        margin = list(l = left_marg, r = right_marg, t = 60, b = 40)
      )
  })
  
  subplot(
    subplot_list,
    nrows = length(facets),
    shareX = TRUE
  ) %>%
    layout(
      title = NULL
    )
  # )
}


### CREATE LABEL COLUMN

create_label_column <- function(facets) {
  
  n <- length(facets)
  
  spacing <- 0.02
  
  heights <- rep((1 - spacing * (n - 1)) / n, n)
  midpoints <- rev(cumsum(c(0, head(heights, -1) + spacing))) + heights / 2
  
  plot_ly(
    x = 0,
    y = 0,
    type = "scatter",
    mode = "markers",
    marker = list(opacity = 0),   # 👈 invisible
    showlegend = FALSE,
    hoverinfo = "none"
  ) %>%
    add_annotations(
      text = str_wrap(paste0("<b>", facets, "</b>"), 25),
      x = 1,   # right edge of label panel
      y = midpoints,
      xref = "paper",
      yref = "y domain",
      showarrow = FALSE,
      xanchor = "right",
      align = "right",
      yanchor = "middle",
      font = list(size = 16)
    ) %>%
    layout(
      xaxis = list(visible = FALSE),
      yaxis = list(visible = FALSE),
      margin = list(l = 10, r = 10, t = 60, b = 40)
    )
}


