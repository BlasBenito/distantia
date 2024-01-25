plot_line_guide <- function(
    x,
    position_x = "center",
    position_y = "center",
    horiz = FALSE,
    color = NULL,
    width = 1,
    title = NULL,
    cex = 1,
    subpanel = FALSE
){

  title_cex <- 0.8 * cex
  axis_labels_cex <- 0.7 * cex
  title_distance <- 0.75

  #check x
  x <- check_args_x(x = x)

  #to data frame
  df <- as.data.frame(x)

  #names of columns to plot
  df.columns <- colnames(df)

  #default palette
  if(is.null(color)){
    color <- grDevices::hcl.colors(
      n = length(df.columns),
      palette = "Zissou 1"
    )
  } else {
    #subset input palette
    if(length(color) > (length(df.columns) * 2)){
      color <- color[
        seq(
          from = 1,
          to = length(color),
          length.out = length(df.columns))
      ]
    }
  }

  #width
  if(length(width) == 1){
    width <- rep(
      x = width,
      times = length(df.columns)
    )
  }

  if(length(width) != length(df.columns)){
    if(width[1] < width[length(width)]){
      width <- seq(
        from = min(width),
        to = max(width),
        length.out = length(df.columns)
      )
    } else {
      width <- seq(
        from = max(width),
        to = min(width),
        length.out = length(df.columns)
      )
    }
  }

  if(subpanel == TRUE){
    bty <- "n"
  } else {
    bty <- "o"
  }

  #plot legend
  plot(
    NULL,
    xaxt='n',
    yaxt='n',
    bty='n',
    ylab='',
    xlab='',
    xlim=0:1,
    ylim=0:1
    )

  graphics::legend(
    x = position_x,
    y = position_y,
    legend = df.columns,
    col = color,
    border = "black",
    lwd = width,
    bty = bty,
    bg = par("bg"),
    box.lwd = par("lwd"),
    box.lty = par("lty"),
    box.col = par("fg"),
    cex = cex,
    horiz = horiz,
    title = title
  )



}
