
# Adds vertical lines with notes in the legend ----
add_lines_and_notes <- function(p,           # plot to add lines to
                                dataframe,   # dataframe the plot is based off
                                ycol,        # colname of dataframe col which defines the y trace
                                             #    to get ymin and ymax of vertical line from
                                xs,          # vector of x locations for vertical lines
                                notes,       # vector of notes for each vertical line
                                colors){     # vector of colours for each line

  for (i in seq(length(xs))){

    p %<>% add_segments(x = xs[i], xend = xs[i],
                        y = 0,
                        yend = max(dataframe[[ycol]]),
                        name = c(notes[i]),
                        line = list(color = colors[i],
                                    width = 1,
                                    dash = "dot")
    )

  }

  return(p)
}

