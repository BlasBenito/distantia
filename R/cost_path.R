#' Least Cost Path
#'
#' @param dist_matrix (required, numeric matrix) Distance matrix.
#' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
#' @param diagonal (optional, logical) If TRUE, diagonals are used during the least-cost path search. Default: FALSE
#' @return A data frame with least-cost path coordiantes.
#' @export
#' @examples
#'
#' x <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' y <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(x, y, distance = "euclidean")
#'
#' m <- cost_matrix(dist_matrix = d)
#'
#' path <- cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#'   )
#'
#' @autoglobal
cost_path <- function(
    dist_matrix = NULL,
    cost_matrix = NULL,
    diagonal = FALSE
){

  dist_matrix <- check_args_matrix(
    m = dist_matrix,
    arg_name = "dist_matrix"
  )

  cost_matrix <- check_args_matrix(
    m = cost_matrix,
    arg_name = "cost_matrix"
  )

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  if(diagonal == FALSE){

    path <- cost_path_cpp(
      dist_matrix = dist_matrix,
      cost_matrix = cost_matrix
    )

  } else {

    path <- cost_path_diag_cpp(
      dist_matrix = dist_matrix,
      cost_matrix = cost_matrix
    )

  }

  attr(x = path, which = "y_name") <- attributes(dist_matrix)$y_name
  attr(x = path, which = "x_name") <- attributes(dist_matrix)$x_name
  attr(x = path, which = "type") <- "cost_path"
  attr(x = path, which = "distance") <- attributes(dist_matrix)$distance


  path

}
