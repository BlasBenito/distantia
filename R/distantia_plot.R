#' Two-Way Dissimilarity Plots of Time Series Lists
#'
#' @description
#'
#' Plots two sequences, their distance or cost matrix, their least cost path, and all relevant values used to compute dissimilarity.
#'
#' Unlike [distantia()], this function does not accept vectors as inputs for the arguments to compute dissimilarity (`distance`, `diagonal`,  and `weighted`), and only plots a pair of sequences at once.
#'
#' The argument `lock_step` is not available because this plot does not make sense in such a case.
#'
#' @inheritParams distantia
#' @param matrix_type (optional, character string): one of "cost" or "distance" (the abbreviation "dist" is accepted as well). Default: "cost".
#' @param matrix_color (optional, character vector) vector of colors for the distance or cost matrix. If NULL, uses the palette "Zissou 1" provided by the function [grDevices::hcl.colors()]. Default: NULL
#' @param path_width (optional, numeric) width of the least cost path. Default: 1
#' @param path_color (optional, character string) color of the least-cost path. Default: "black"
#' @param diagonal_width (optional, numeric) width of the diagonal. Set to 0 to remove the diagonal line. Default: 0.5
#' @param diagonal_color (optional, character string) color of the diagonal. Default: "white"
#' @param line_color (optional, character vector) Vector of colors for the time series plot. If not provided, defaults to a subset of `matrix_color`.
#' @param line_width (optional, numeric vector) Width of the time series plot. Default: 1
#' @param text_cex (optional, numeric) Multiplier of the text size. Default: 1
#'
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' #convert to time series list
#' #scale and center to neutralize effect of different scales in temperature, rainfall, and ndvi
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global #see help(f_scale_global)
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
    bandwidth = 1,
    matrix_type = "cost",
    matrix_color = NULL,
    path_width = 1,
    path_color = "black",
    diagonal_width = 1,
    diagonal_color = "white",
    line_color = NULL,
    line_width = 1,
    text_cex = 1
){

  #length > 1
  if(length(tsl) < 2){
    stop("distantia::distantia_plot(): argument 'tsl' must be a time series list of length 2 or higher.", call. = FALSE)
  }

  #only two elements
  if(length(tsl) > 2){

    message("distantia::distantia_plot(): Argument 'tsl' has more than two time series. Using ", paste0(names(tsl)[1:2], collapse = " and "), " to build the plot. Please use tsl_subset() or the notation txl[c('a', 'b')] to select a different pair of time series.")

    tsl <- tsl_subset(
      tsl = tsl,
      names = c(1, 2)
    )

  }

  #count and handle NA
  na_count <- tsl_count_NA(
    tsl = tsl
  ) |>
    unlist()

  if(sum(na_count) > 0){
    message(
      "distantia::distantia_plot(): ",
      sum(na_count),
      " NA cases were imputed with distantia::tsl_handle_NA() in these time series: '",
      paste(names(na_count[na_count > 0]), collapse = "', '"),
      "'."
    )
  }

  tsl <- tsl_handle_NA(
    tsl = tsl
  )

  #subset numeric and shared columns
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
    bandwidth = bandwidth[1]
  )$psi

  xy_psi <- round(xy_psi, 3)

  # Distance and cost matrices ----
  dist_m <- psi_distance_matrix(
    x = tsl[[1]],
    y = tsl[[2]],
    distance = distance
  )

  cost_m <- psi_cost_matrix(
    dist_matrix = dist_m,
    diagonal = diagonal
  )

  # Cost path ----
  path <- psi_cost_path(
    dist_matrix = dist_m,
    cost_matrix = cost_m,
    diagonal = diagonal,
    bandwidth = bandwidth
  )

  # select matrix to plot
  if(matrix_type %in% c("distance", "dist")){
    m <- dist_m
    rm(cost_m)
  } else {
    m <- cost_m
    rm(dist_m)
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
    matrix_color = matrix_color,
    subtitle = paste0(
      "Psi = ",
      xy_psi
    ),
    text_cex = text_cex,
    path = path,
    path_width = path_width,
    path_color = path_color,
    diagonal_width = diagonal_width,
    diagonal_color = diagonal_color,
    guide = FALSE,
    subpanel = TRUE
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
    line_color = line_color,
    line_width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = TRUE,
    subpanel = TRUE
  )

  y_sum <- psi_auto_distance(
    x = tsl[[2]],
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
    line_color = line_color,
    line_width = line_width,
    text_cex = text_cex,
    guide = FALSE,
    vertical = FALSE,
    subpanel = TRUE
  )

  x_sum <- psi_auto_distance(
    x = tsl[[1]],
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
    matrix_color = matrix_color,
    text_cex = text_cex
  )

  # Plot line guide ----
  graphics::par(
    plt = plt_line_guide,
    new = TRUE
  )

  utils_line_guide(
    x = tsl[[2]],
    position = "topright",
    line_color = line_color,
    text_cex = text_cex * 0.7,
    line_width = line_width,
    subpanel = TRUE
  )

  #reset to main plotting area
  # graphics::par(plt = plt_all)

  invisible()

}

