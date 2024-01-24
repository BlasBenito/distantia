#' Plots Multivariate Sequences
#'
#' @param x
#' @param vertical
#' @param center
#' @param scale
#' @param color
#' @param width
#' @param cex
#'
#' @return
#' @export
#'
#' @examples
plot_sequence <- function(
    x,
    color = NULL,
    title = NULL,
    xlab = NULL,
    ylab = NULL,
    vertical = FALSE,
    center = FALSE,
    scale = FALSE,
    width = NULL,
    subpanel = FALSE,
    cex = 1
){

  #axis title
  axis_title_distance <- 1.4
  axis_title_cex <- 0.9 * cex

  #axis labels
  axis_labels_cex <- 0.7 * cex

  #title
  main_title_distance <- 1.2
  main_title_cex <- 1.2 * cex

  if(subpanel == FALSE){

    axis_title_distance <- 2.2
    axis_labels_cex <- 0.8 * cex

  }

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

  #first plot
  if(vertical == FALSE){

    x <- df.time
    y <- df[, df.columns[1]]
    x.axis.side <- 1
    y.axis.side <- 2
    y.lim <- range(df, na.rm = TRUE)
    x.lim <- NULL
    df.name.x <- df.name
    df.name.y <- NULL

  } else {

    x <- df[, df.columns[1]]
    y <- df.time
    x.axis.side <- 2
    y.axis.side <- 3
    y.lim <- NULL
    x.lim <- rev(range(df, na.rm = TRUE))
    df.name.x <- NULL
    df.name.y <- df.name

  }

  #first plot
  graphics::plot(
    x = x,
    y = y,
    xlab = "",
    type = "l",
    ylab = "",
    xaxt = "n",
    yaxt = "n",
    ylim = y.lim,
    xlim = x.lim,
    col = color[1]
  )

  graphics::axis(
    side = x.axis.side,
    las = 1,
    cex.axis = axis_labels_cex
  )

  graphics::axis(
    side = y.axis.side,
    las = 1,
    cex.axis = axis_labels_cex
  )

  #add all the other lines
  for(i in seq(2, length(df.columns))){

    if(vertical == FALSE){
      x <- df.time
      y <- df[, df.columns[i]]
    } else {
      x <- df[, df.columns[i]]
      y <- df.time
    }

    lines(
      x = x,
      y = y,
      col = color[i]
    )

  }

  #decoration
  if(subpanel == FALSE){

    graphics::title(
      main = ifelse(
        test = is.null(title),
        yes = df.name,
        no = title
      ),
      cex.main = main_title_cex,
      line = main_title_distance
    )

    graphics::title(
      xlab = ifelse(
        test = is.null(xlab),
        yes = "Time",
        no = xlab
      ),
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

  } else {

    graphics::title(
      xlab = df.name.x,
      ylab = df.name.y,
      cex.lab = axis_title_cex,
      line = axis_title_distance
    )


  }



}


