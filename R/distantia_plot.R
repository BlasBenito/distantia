#' Multipanel Plot Comparing Two Sequences
#'
#' @description
#'
#' Plots two sequences, their distance or cost matrix, their least cost path, and all relevant values used to compute dissimilarity.
#'
#' Unlike [distantia()], this function does not accept vectors as inputs for the arguments to compute dissimilarity (`distance`, `diagonal`,  and `weighted`), and only plots a pair of sequences at once.
#'
#' The argument `lock_step` is not available because this plot does not make sense in such a case.
#'
#' @param tsl (required, list) time series list with two elements. If more than two, only the first two time series are plotted. Default: NULL
#' @param distance (optional, character STRING) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical). If TRUE, diagonals are included in the computation of the cost matrix. Default: TRUE
#' @param weighted @param weighted (optional, logical) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: TRUE
#' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Ignored if `diagonal = TRUE`. Default: FALSE.
#' @param matrix_type (optional, character string): one of "cost" or "distance" (the abbreviation "dist" is accepted as well). Default: "cost".
#' @param matrix_color (optional, character vector) vector of colors for the distance or cost matrix. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#' @param path_width (optional, numeric) width of the least cost path. Default: 1
#' @param path_color (optional, character string) color of the least-cost path. Default: "black"
#' @param line_color (optional, character vector) Vector of colors for the time series plot. If not provided, defaults to a subset of `matrix_color`.
#' @param line_width (optional, numeric vector) Width of the time series plot. Default: 1
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 1
#'
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' data("fagus_dynamics")
#'
#' #convert to time series list
#' #scale and center to neutralize effect of different scales in temperature, rainfall, and ndvi
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' ) |>
#'   tsl_transform(
#'     f = f_scale #see help(f_scale)
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#' }
#'
#' #visualize dynamic time warping
#' if(interactive()){
#'
#'   #plot pair with cost matrix (default)
#'   distantia_plot(
#'     tsl = tsl[c("Spain", "Sweden")] #only two time series!
#'   )
#'
#'   #plot pair with distance matrix
#'   distantia_plot(
#'     tsl = tsl[c("Spain", "Sweden")],
#'     matrix_type = "distance"
#'   )
#'
#'   #plot pair with different distance
#'   distantia_plot(
#'     tsl = tsl[c("Spain", "Sweden")],
#'     distance = "manhattan", #sed data(distances)
#'     matrix_type = "distance"
#'   )
#'
#'
#'   #with different colors
#'   distantia_plot(
#'     tsl = tsl[c("Spain", "Sweden")],
#'     matrix_type = "distance",
#'     matrix_color = grDevices::hcl.colors(
#'       n = 100,
#'       palette = "Inferno"
#'     ),
#'     path_color = "white",
#'     path_width = 2,
#'     line_color = grDevices::hcl.colors(
#'       n = 3, #same as variables in tsl
#'       palette = "Inferno"
#'     )
#'   )
#'
#' }
#' @return A plot.
#' @autoglobal
#' @export
#' @family dissimilarity_analysis
distantia_plot <- function(
    tsl = NULL,
    distance = "euclidean",
    diagonal = TRUE,
    weighted = TRUE,
    ignore_blocks = FALSE,
    matrix_type = "cost",
    matrix_color = NULL,
    path_width = 1,
    path_color = "black",
    line_color = NULL,
    line_width = 1,
    text_cex = 1
){

  #check validity
  tsl <- tsl_diagnose(
    tsl = tsl
  )

  #length > 1
  if(length(tsl) < 2){
    stop("Argument 'tsl' must be a time series list of length 2 or higher.")
  }

  #only two elements
  if(length(tsl) > 2){

    warning("Argument 'tsl' has more than two time series. Using ", paste0(names(tsl)[1:2], collapse = " and "), " to build the plot. Please use tsl_subset() or the notation txl[c('a', 'b')] to select a different pair of time series.")

    tsl <- tsl_subset(
      tsl = tsl,
      names = c(1, 2)
    )

  }

  tsl <- tsl_subset(
    tsl = tsl,
    numeric_cols = TRUE,
    shared_cols = TRUE
  )

  # Preserve user's config
  old.par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old.par))

  # Check arguments ----

  #check matrix argument
  matrix_type <- match.arg(
    arg = matrix_type,
    choices =  c("cost", "distance", "dist"),
    several.ok = FALSE
  )

  if(is.null(matrix_color)){

    matrix_color = utils_color_continuous_default(
      n = 100
    )

    if(is.null(line_color)){
      line_color <- matrix_color
    }

  }

  # Psi computation ----
  xy_psi <- distantia(
    tsl = tsl,
    distance = distance[1],
    diagonal = diagonal[1],
    weighted = weighted[1],
    ignore_blocks = ignore_blocks[1]
  )$psi

  xy_psi <- round(xy_psi, 3)

  # Distance and cost matrices ----
  dist_m <- psi_dist_matrix(
    x = tsl[[1]],
    y = tsl[[2]],
    distance = distance
  )

  cost_m <- psi_cost_matrix(
    dist_matrix = dist_m,
    diagonal = diagonal,
    weighted = weighted
  )

  # Cost path ----
  path <- psi_cost_path(
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

  #remove blocks and re-compute sum
  if(ignore_blocks == TRUE){

    path <- psi_cost_path_trim_blocks(
      path = path
    )

  }

  #path sum
  path_sum <- psi_cost_path_sum(
    path = path
  ) |>
    round(2)

  plt_all <- graphics::par()$plt

  # Plotting areas ----
  plt_y <- c(0.2, 0.35, 0.25, 0.8)
  plt_x <- c(0.35, 0.8, 0.09, 0.25)
  plt_m <- c(0.35, 0.8, 0.25, 0.8)
  plt_matrix_guide <- c(0.82, 0.84, 0.25, 0.8)
  plt_line_guide <- c(0.70, 0.95, 0.05, 0.25)

  # Plot matrix ----
  graphics::par(
    oma = c(1, 0, 0, 1)
  )

  graphics::par(
    plt = plt_m
    )

  utils_matrix_plot(
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

  graphics::mtext(
    text = paste(
      "Cost sum = ",
      path_sum
    ),
    line = -1.3,
    cex = 0.9 * text_cex,
    adj = 0.05,
    col = path_color
  )

  # Plot time series y ----
  graphics::par(
    plt = plt_y,
    new = TRUE,
    mgp = c(0, 0.5, 0),
    bty = "n"
    )

  zoo_plot(
    x = tsl[[2]],
    color = line_color,
    width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = TRUE,
    subpanel = TRUE
  )

  y_sum <- psi_auto_distance(
    x = tsl[[2]],
    path = path,
    distance = distance
  ) |>
    round(2)

  graphics::mtext(
    text = paste(
      "Auto sum = ",
      y_sum
    ),
    side = 2,
    line = -1,
    cex = 0.9 * text_cex,
    adj = 0.05
  )

  # Plot time series x ----
  graphics::par(
    plt = plt_x,
    new = TRUE,
    mgp = c(3, 0.75, 0),
    bty = "n"
    )

  zoo_plot(
    x = tsl[[1]],
    color = line_color,
    width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = FALSE,
    subpanel = TRUE
  )

  x_sum <- psi_auto_distance(
    x = tsl[[1]],
    path = path,
    distance = distance
  ) |>
    round(2)

  graphics::mtext(
    text = paste(
      "Auto sum = ",
      x_sum
    ),
    side = 3,
    line = -1,
    cex = 0.9 * text_cex,
    adj = 0.05
  )

  # Plot matrix guide ----
  graphics::par(
    plt = plt_matrix_guide,
    new = TRUE,
    mgp = c(3, 0.5, 0)
  )

  utils_matrix_guide(
    m = m,
    color = matrix_color,
    text_cex = text_cex
  )

  # Plot line guide ----
  graphics::par(
    plt = plt_line_guide,
    new = TRUE
  )

  utils_line_guide(
    x = tsl[[2]],
    position = "center",
    color = line_color,
    text_cex = text_cex * 0.7,
    width = line_width,
    subpanel = TRUE
  )

  #reset to main plotting area
  # graphics::par(plt = plt_all)

  invisible()

}

