plot_sequence <- function(
  x,
  vertical = FALSE,
  center = FALSE,
  scale = FALSE,
  color = NULL,
  width = NULL,
  cex = 1
){

  axis_labels_cex <- 0.7 * cex
  axis_title_cex <- 0.9 * cex
  axis_title_distance <- 1.2

  #x to data frame
  if(any(c(center, scale))){

    df <- scale(
      x = x,
      scale = scale,
      center = center,
    ) |>
      as.data.frame()

  } else {
    #to data frame
    df <- as.data.frame(x)
  }

  #time column
  df.time <- as.numeric(attributes(x)$time)

  #name
  df.name <- attributes(x)$sequence_name

  #names of columns to plot
  df.columns <- colnames(df)

  #color
  if(is.null(color)){
    color <- grDevices::hcl.colors(
      n = length(df.columns),
      palette = "Zissou 1"
    )
  } else {
    if(length(color) > (length(df.columns) * 2)){
      color <- color[seq(from = 1, to = length(color), length.out = length(df.columns))]
    }
  }

  #first plot
  if(vertical == FALSE){

    graphics::plot(
      x = df.time,
      y = df[, df.columns[1]],
      xlab = df.name,
      type = "l",
      ylab = "",
      xaxt = "n",
      yaxt = "n",
      ylim = range(df, na.rm = TRUE),
      col = color[1],
      box = FALSE
    )

    graphics::title(
      xlab = df.name,
      cex.lab = axis_title_cex,
      line = axis_title_distance
    )

    graphics::axis(
      side = 1,
      las = 1,
      cex.axis = axis_labels_cex
    )

    graphics::axis(
      side = 2,
      las = 1,
      cex.axis = axis_labels_cex
    )

    for(i in seq(2, length(df.columns))){
      lines(
        x = df.time,
        y = df[, df.columns[i]],
        col = color[i]
      )
    }

  } else {

    plot(
      y = df.time,
      x = df[, df.columns[1]],
      xlab = "",
      ylab = "",
      type = "l",
      xaxt = "n",
      yaxt = "n",
      xlim = rev(range(df, na.rm = TRUE)),
      col = color[1],
      lwd = width,
      box = FALSE
    )

    graphics::title(
      ylab = df.name,
      cex.lab = axis_title_cex,
      line = axis_title_distance
    )

    graphics::axis(
      side = 2,
      las = 2,
      cex.axis = axis_labels_cex
    )

    graphics::axis(
      side = 3,
      las = 1,
      cex.axis = axis_labels_cex
    )

    for(i in seq(2, length(df.columns))){
      lines(
        y = df.time,
        x = df[, df.columns[i]],
        col = color[i],
        lwd = width
      )
    }


  }

}
