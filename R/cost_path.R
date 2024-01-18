#' Least Cost Path
#'
#' @param dist_matrix (required, numeric matrix) Distance matrix.
#' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
#' @param diagonal (optional, logical) If TRUE, diagonals are used during the least-cost path search. Default: FALSE
#' @return A data frame with least-cost path coordiantes.
#' @export
#' @examples
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' d <- distance_matrix(a, b, distance = "euclidean")
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


  if(is.null(dist_matrix)){
    stop("Argument 'dist_matrix' must not be NULL.")
  }
  if(!is.numeric(dist_matrix) | !is.matrix(dist_matrix)){
    stop("Argument 'dist_matrix' must be a numeric matrix.")
  }

  if(is.null(cost_matrix)){
    stop("Argument 'cost_matrix' must not be NULL.")
  }
  if(!is.numeric(cost_matrix) | !is.matrix(cost_matrix)){
    stop("Argument 'cost_matrix' must be a numeric matrix.")
  }

  if(any(dim(dist_matrix) != dim(cost_matrix))){
    stop("Arguments 'dist_matrix' and 'cost_matrix' must have the same dimensions.")
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

  attr(x = path, which = "a_name") <- attributes(dist_matrix)$a_name
  attr(x = path, which = "b_name") <- attributes(dist_matrix)$b_name
  attr(x = path, which = "distance") <- attributes(dist_matrix)$distance
  attr(x = path, which = "type") <- "cost_path"

  path

}
