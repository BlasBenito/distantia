#' Multipanel Plot Comparing Two Sequences
#'
#' @description
#' Plots two sequences, their distance or cost matrix, and their least cost path.
#'
#' Unlike [distantia()], this function does not accept vectors as inputs for the arguments to compute dissimilarity (these are `distance`, `diagonal`, `weighted`, and `ignore_blocks`).
#'
#' The argument `paired_samples` is not available because this multipanel plot does not make sense in such a case.
#'
#' @param x (required, sequence) a sequence generated via [prepare_sequences()] for the X axis of the multi-panel plot. Default: NULL
#' @param y (required, sequence) a sequence generated via [prepare_sequences()] for the Y axis of the multi-panel plot. Default: NULL
#' @param distance (optional, character STRING) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted @param weighted (optional, logical) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param matrix_type (optional, character string): one of "cost" or "distance" (the abbreviation "dist" is accepted as well). Default: "cost".
#' @param matrix_color (optional, character vector) vector of colors for the distance or cost matrix. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#' @param path_width (optional, numeric) width of the least cost path. Default: 1
#' @param path_color (optional, character string) color of the least-cost path. Default: "black"
#' @param line_center (optional, logical) If TRUE, the sequences are centered via [scale()]. This centering is only for plotting purposes, and it is ignored when computing the dissimilarity between the sequences. Default: FALSE
#' @param line_scale (optional, logical) If TRUE, the sequences are scaled via [scale()]. This scaling is only for plotting purposes, and it is ignored when computing the dissimilarity between the sequences. Default: FALSE
#' @param line_color (optional, character vector) Vector of colors for the sequence curves. If not provided, defaults to a subset of `matrix_color`.
#' @param line_width (optional, numeric vector) Widths of the sequence curves. Default: 1
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 1
#'
#' @examples
#' data(sequencesMIS)
#'
#' x <- prepare_sequences(
#'   x = sequencesMIS,
#'   id_column = "MIS"
#' )
#'
#' plot_distantia(
#'   y = x[["MIS-9"]],
#'   x = x[["MIS-11"]]
#' )
#' @return A plot.
#' @autoglobal
#' @export
plot_distantia <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    matrix_type = "cost",
    matrix_color = NULL,
    path_width = 1,
    path_color = "black",
    line_center = FALSE,
    line_scale = FALSE,
    line_color = NULL,
    line_width = 1,
    text_cex = 1
){

  # Check arguments ----

  #check x
  y <- check_args_x(x = y, arg_name = "y")
  x <- check_args_x(x = x, arg_name = "x")

  #prepare xy for psi computation
  xy <- prepare_xy(
    x = x,
    y = y,
    distance = distance
  )

  #check matrix argument
  matrix_type <- match.arg(
    arg = matrix_type,
    choices =  c("cost", "distance", "dist"),
    several.ok = FALSE
  )

  if(is.null(matrix_color)){
    matrix_color = grDevices::hcl.colors(
      n = 100,
      palette = "Zissou 1"
    )
  }

  # compute psi ----
  xy_psi <- distantia(
    x = xy,
    distance = distance[1],
    diagonal = diagonal[1],
    weighted = weighted[1],
    ignore_blocks = ignore_blocks[1]
  )$psi

  xy_psi <- round(xy_psi, 3)

  # compute matrices and path ----
  dist_m <- distance_matrix(
    x = xy[[1]],
    y = xy[[2]],
    distance = distance
  )

  cost_m <- cost_matrix(
    dist_matrix = dist_m,
    diagonal = diagonal,
    weighted = weighted
  )

  path <- cost_path(
    dist_matrix = dist_m,
    cost_matrix = cost_m,
    diagonal = diagonal
  )

  # select matrix to plot
  if(matrix_type %in% c("distance", "dist")){
    m <- dist_m
    rm(cost_m)
  } else {
    m <- cost_m
    rm(dist_m)
  }

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  plt_all <- par()$plt

  # Plotting areas ----
  plt_y <- c(0.2, 0.35, 0.25, 0.8)
  plt_x <- c(0.35, 0.8, 0.1, 0.25)
  plt_m <- c(0.35, 0.8, 0.25, 0.8)
  plt_matrix_guide <- c(0.82, 0.84, 0.25, 0.8)
  plt_line_guide <- c(0.80, 0.95, 0.1, 0.245)

  # Plot matrix ----
  par(
    oma = c(1, 0, 0, 1)
  )

  par(
    plt = plt_m
    )

  plot_matrix(
    m = m,
    color = matrix_color,
    subtitle = paste0(
      "Psi = ",
      xy_psi
    ),
    text_cex = text_cex,
    path = path,
    path_width = path_width,
    path_color = path_color,
    guide = FALSE,
    subpanel = TRUE,
  )

  # Plot sequence y ----
  par(
    plt = plt_y,
    new = TRUE,
    mgp = c(0, 0.5, 0),
    bty = "n"
    )

  plot_sequence(
    x = y,
    center = line_center,
    scale = line_scale,
    color = line_color,
    width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = TRUE,
    subpanel = TRUE
  )

  # Plot sequence x ----
  par(
    plt = plt_x,
    new = TRUE,
    mgp = c(3, 0.5, 0),
    bty = "n"
    )

  plot_sequence(
    x = x,
    center = line_center,
    scale = line_scale,
    color = line_color,
    width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = FALSE,
    subpanel = TRUE
  )

  # Plot matrix guide ----
  par(
    plt = plt_matrix_guide,
    new = TRUE,
    mgp = c(3, 0.5, 0)
  )

  plot_matrix_guide(
    m = m,
    color = matrix_color,
    text_cex = text_cex
  )

  # Plot line guide ----
  par(
    plt = plt_line_guide,
    new = TRUE
  )

  plot_line_guide(
    x = y,
    position = "center",
    color = matrix_color,
    text_cex = text_cex * 0.7,
    width = line_width,
    subpanel = TRUE
  )

  #reset to main plotting area
  par(plt = plt_all)

  invisible()

}

