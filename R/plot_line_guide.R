#' Legend for Sequence Plots
#'
#' @param x (required, sequence) a sequence generated via [prepare_sequences()]. Default: NULL
#' @param position (optional, vector of xy coordinates or character string). This is a condensed version of the `x` and `y` arguments of the [graphics::legend()] function. Coordinates (in the range 0 1) or keyword to position the legend. Accepted keywords are: "bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" and "center". Default: "topright".
#' @param color (optional, character vector) vector of colors for the sequence columns. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#' @param width (optional, numeric vector) Widths of the sequence curves. Default: 1
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 0.7
#' @param box (optional, logical) If TRUE, a box is drawn around the guide. The box features can be controlled with the [par()] arguments  `"lwd"` (line width of the box), `"lty"` (line type of the box) `"bg"` (background color), and `"fg"` (line color). Default: FALSE
#' @param subpanel (optional, logical) internal argument used when generating the multipanel plot produced by [plot_distantia()].
#'
#' @return A plot.
#' @examples
#' data(sequencesMIS)
#'
#' x <- prepare_sequences(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#'
#' plot_line_guide(
#'   x = x[["MIS-9"]],
#'   position = "center"
#' )
#' @autoglobal
#' @export
plot_line_guide <- function(
    x,
    position = "topright",
    color = NULL,
    width = 1,
    text_cex = 0.7,
    box = FALSE,
    subpanel = FALSE
){

  title_cex <- 0.8 * text_cex
  axis_labels_cex <- 0.7 * text_cex
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


  if(is.numeric(position)){
    position_x <- position[1]
    position_y <- position[2]
  } else {
    position_x <- position
    position_y <- NULL
  }

  if(box == TRUE){
    bty <- "o"
  } else {
    bty <- "n"
  }

  #plot legend
  if(subpanel == TRUE){

    plot(
      NULL,
      xaxt = 'n',
      yaxt = 'n',
      bty = 'n',
      ylab = '',
      xlab = '',
      xlim = 0:1,
      ylim = 0:1
    )

  }

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
    cex = text_cex,
    horiz = FALSE,
    title = NULL,
    y.intersp = text_cex,
    x.intersp = text_cex,
    xjust = 0.5
  )



}
