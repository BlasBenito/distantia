#' Guide for Time Series Plots
#'
#' @param x (required, sequence) a zoo time series or a time series list. Default: NULL
#' @param position (optional, vector of xy coordinates or character string). This is a condensed version of the `x` and `y` arguments of the [graphics::legend()] function. Coordinates (in the range 0 1) or keyword to position the legend. Accepted keywords are: "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" and "center". Default: "topright".
#' @param color (optional, character vector) vector of colors for the time series columns. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#' @param width (optional, numeric vector) Widths of the time series lines. Default: 1
#' @param length (optional, numeric) maps to the argument `seg.len` of [graphics::legend()]. Length of the lines drawn in the legend. Default: 1
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 0.7
#' @param ncol (optional, integer) Number of columns in which to set the legend items. Default: 1.
#' @param subpanel (optional, logical) internal argument used when generating the multipanel plot produced by [distantia_plot()].
#'
#' @return plot
#' @examples
#' x <- zoo_simulate()
#'
#' if(interactive()){
#'
#'   zoo_plot(x, guide = FALSE)
#'
#'   utils_line_guide(
#'     x = x,
#'     position = "right"
#'   )
#'
#' }
#'
#' @autoglobal
#' @export
#' @family internal_plotting
utils_line_guide <- function(
    x,
    position = "topright",
    color = NULL,
    width = 1,
    length = 1,
    text_cex = 0.7,
    ncol = 1,
    subpanel = FALSE
){

  title_cex <- 0.8 * text_cex
  axis_labels_cex <- 0.7 * text_cex
  title_distance <- 0.75

  #default palette
  color <- utils_line_color(
    x = x,
    color = color
  )

  #width
  if(length(width) == 1){
    width <- rep(
      x = width,
      times = length(color)
    )
  }

  if(length(width) != length(color)){
    if(width[1] < width[length(width)]){
      width <- seq(
        from = min(width),
        to = max(width),
        length.out = length(color)
      )
    } else {
      width <- seq(
        from = max(width),
        to = min(width),
        length.out = length(color)
      )
    }
  }


  if(is.numeric(position)){
    position_x <- position[1]
    position_y <- position[2]
  } else {
    position_x <- position
    position_y <- NULL
  }

  #plot legend
  if(subpanel == TRUE){

    graphics::plot(
      NULL,
      xaxt = 'n',
      yaxt = 'n',
      bty = 'n',
      frame.plot = FALSE,
      ylab = '',
      xlab = '',
      xlim = 0:1,
      ylim = 0:1
    )

  }

  xcoords <- c(0, cumsum(graphics::strwidth(names(color), cex = 0.5))[-length(names(color))])
  secondvector <- (1:length(names(color)))-1
  textwidths <- xcoords/secondvector
  textwidths[1] <- 0

  graphics::legend(
    x = position_x,
    y = position_y,
    legend = names(color),
    col = color,
    border = "black",
    lwd = width,
    bty = 'n',
    cex = text_cex,
    ncol = ncol,
    horiz = FALSE,
    title = NULL,
    y.intersp = text_cex,
    x.intersp = text_cex,
    xjust = 0.5,
    text.width = textwidths,
    seg.len = length
  )



}
