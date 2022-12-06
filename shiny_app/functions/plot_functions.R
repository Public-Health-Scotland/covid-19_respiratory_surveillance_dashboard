# vline functions ----
vline <- function(x, width=3.0, color="black", ...) {
  l_shape = list(
    type = "line",
    y0 = 0, y1 = 1, yref = "paper", # i.e. y as a proportion of visible region
    x0 = x, x1 = x,
    line = list(color = color)
  )
  return(l_shape)
}

annotation <- function(frac, y, note, color){
  ann <- list(yref = "paper",
              xref = "paper",
              y = y,
              x = frac,
              text = note,
              # Styling annotations' text:
              font = list(color = color,
                          size = 14),
              showarrow=FALSE)
  return(ann)
}

add_vline <- function(p, x, ...){
  l_shape <- vline(x, ...)
  p %>% layout(shapes=list(l_shape))
}


add_lines_and_notes <- function(p, dataframe, ycol, xs, notes, colors){



  for (i in seq(length(xs))){

    p %<>% add_segments(x = xs[i], xend = xs[i],
                        y = 0,
                        yend = max(dataframe[[ycol]]),
                        name = c(notes[i]),
                        line = list(color = colors[i], width = 3)
    )

  }

  return(p)
}

