#' Plot Multivariate Zoo Time Series
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#' @param center (optional, logical) If TRUE, the columns of `x` are centered via [scale()]. Default: FALSE
#' @param scale (optional, logical) If TRUE, the columns of `x` are scaled via [scale()]. Default: FALSE
#' @param xlim (optional, numeric vector) Numeric vector with the limits of the x axis. Default: NULL
#' @param ylim (optional, numeric vector) Numeric vector with the limits of the x axis. Default: NULL
#' @param color (optional, character vector) vector of colors for the distance or cost matrix. If NULL, uses an appropriate palette generated with [grDevices::palette.colors()]. Default: NULL
#' @param width (optional, numeric vector) Widths of the sequence curves. Default: 1
#' @param title (optional, character string) Main title of the plot. If NULL, it's set to the name of the sequence. Default: NULL
#' @param xlab (optional, character string) Title of the x axis. Disabled if `subpanel` or `vertical` are TRUE. If NULL, the word "Time" is used. Default: NULL
#' @param ylab (optional, character string) Title of the x axis. Disabled if `subpanel` or `vertical` are TRUE. If NULL, it is left empty. Default: NULL
#' @param text_cex (optional, numeric) Multiplicator of the text size. Default: 1
#' @param guide (optional, logical) If TRUE, plots a legend. Default: TRUE
#' @param guide_position (optional, character string) Position of the guide. Accepted values are: "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" and "center". Default: "topright"
#' @param guide_cex (optional, numeric) Size of the guide's text and separation between the guide's rows. Default: 0.7.
#' @param vertical (optional, logical) For internal use within the package in multipanel plots. Switches the plot axes. Disabled if `subpanel = FALSE`. Default: FALSE
#' @param subpanel (optional, logical) For internal use within the package in multipanel plots. Strips down the plot for a sub-panel. Default: FALSE
#'
#' @return A plot.
#' @export
#'
#' @examples
zoo_plot <- function(
    x = NULL,
    center = FALSE,
    scale = FALSE,
    xlim = NULL,
    ylim = NULL,
    color = NULL,
    width = 1,
    title = NULL,
    xlab = NULL,
    ylab = NULL,
    text_cex = 1,
    box = FALSE,
    guide = TRUE,
    guide_position = "topright",
    guide_cex = 0.8,
    vertical = FALSE,
    subpanel = FALSE
){

  #check x
  x <- utils_check_zoo_args(x = x)

  #axis title
  axis_title_distance <- 1.4
  axis_title_cex <- 0.9 * text_cex

  #axis labels
  axis_labels_cex <- 0.7 * text_cex

  #title
  main_title_distance <- 1.2
  main_title_cex <- 1.2 * text_cex

  if(subpanel == FALSE){

    axis_title_distance <- 2.2
    axis_labels_cex <- 0.8 * text_cex
    vertical <- FALSE

  }

  if(vertical == TRUE){

    axis_title_distance <- 2.4

  }

  df <- scale(
    x = x,
    scale = scale,
    center = center
  ) |>
    as.data.frame()

  #time column
  df.time <- zoo::index(x)

  #name
  name <- attributes(x)$name
  if(is.null(name)){
    name <- ""
  }

  #names of columns to plot
  x_colnames <- colnames(df)

  #default palette
  if(is.null(names(color))){
    color <- utils_line_color(
      x = x,
      color = color
    )
  }

  color <- color[names(color) %in% x_colnames]

  #width
  if(length(width) == 1){
    width <- rep(
      x = width,
      times = length(x_colnames)
    )
  }

  if(length(width) != length(x_colnames)){
    if(width[1] < width[length(width)]){
      width <- seq(
        from = min(width),
        to = max(width),
        length.out = length(x_colnames)
      )
    } else {
      width <- seq(
        from = max(width),
        to = min(width),
        length.out = length(x_colnames)
      )
    }
  }

  #data limits
  if(is.null(ylim)){
    ylim <- range(df, na.rm = TRUE)
  }
  if(is.null(xlim)){
    xlim <- range(zoo::index(x))
  }

  if(subpanel == TRUE){
    ylim[which.max(ylim)] <- ylim[which.max(ylim)] + (diff(ylim)/5)
  }

  #first plot
  if(vertical == FALSE){

    plot.x <- df.time
    plot.y <- df[, names(color)[1]]
    x.axis.side <- 1
    y.axis.side <- 2
    name.x <- name
    name.y <- NULL

  } else {

    plot.x <- df[, names(color)[1]]
    plot.y <- df.time
    x.axis.side <- 3
    y.axis.side <- 2
    xlim <- rev(ylim)
    ylim <- NULL
    name.x <- NULL
    name.y <- name

  }

  # par(bty = "n")

  #first plot
  graphics::plot(
    x = plot.x,
    y = plot.y,
    xlab = "",
    type = "l",
    ylab = "",
    xaxt = "n",
    yaxt = "n",
    frame.plot = FALSE,
    ylim = ylim,
    xlim = xlim,
    lwd = width[1],
    col = color[1]
  )

  if("Date" %in% class(plot.x)){
    graphics::axis.Date(
      side = x.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }

  if("POSIXct" %in% class(plot.x)){
    graphics::axis.POSIXct(
      side = x.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }

  if("numeric" %in% class(plot.x)){
    graphics::axis(
      side = x.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }

  if("Date" %in% class(plot.y)){
    graphics::axis.Date(
      side = y.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }

  if("POSIXct" %in% class(plot.y)){
    graphics::axis.POSIXct(
      side = y.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }

  if("numeric" %in% class(plot.y)){
    graphics::axis(
      side = y.axis.side,
      las = 1,
      cex.axis = axis_labels_cex
    )
  }


  #add all the other lines
  if(length(x_colnames) > 1){

    for(i in seq(from = 2, to = length(x_colnames), by = 1)){

      if(vertical == FALSE){
        line.x <- df.time
        line.y <- df[, names(color)[i]]
      } else {
        line.x <- df[, names(color)[i]]
        line.y <- df.time
      }

      graphics::lines(
        x = line.x,
        y = line.y,
        lwd = width[i],
        col = color[i]
      )

    }

  }


  #decoration
  if(subpanel == FALSE){

    graphics::title(
      main = ifelse(
        test = is.null(title),
        yes = name,
        no = title
      ),
      cex.main = main_title_cex,
      line = main_title_distance
    )

    graphics::title(
      xlab = ifelse(
        test = is.null(xlab),
        yes = "",
        no = xlab
      ),
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

    graphics::title(
      ylab = ifelse(
        test = is.null(ylab),
        yes = "",
        no = ylab
      ),
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

  } else {

    graphics::title(
      xlab = name.x,
      ylab = name.y,
      cex.lab = axis_title_cex,
      line = axis_title_distance
    )


  }

  if(guide == TRUE){

    utils_line_guide(
      x = x,
      position = guide_position,
      color = color,
      width = width,
      text_cex = guide_cex,
      subpanel = FALSE
    )

  }



}


