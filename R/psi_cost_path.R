#' Least Cost Path
#'
#' @param dist_matrix (required, numeric matrix) Distance matrix.
#' @param cost_matrix (required, numeric matrix) Cost matrix generated from the distance matrix.
#' @param diagonal (optional, logical) If TRUE, diagonals are used during the least-cost path search. Default: TRUE
#' @return A data frame with least-cost path coordiantes.
#' @export
#' @examples
#' #simulate two time series
#' tsl <- tsl_simulate(
#'   n = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #step by step computation of psi
#'
#' #common distance method
#' dist_method <- "euclidean"
#'
#' #distance matrix
#' d <- psi_dist_matrix(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = dist_method
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = d)
#' }
#'
#' #cost matrix
#' m <- psi_cost_matrix(
#'   dist_matrix = d
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(m = m)
#' }
#'
#' #least cost path
#' path <- psi_cost_path(
#'   dist_matrix = d,
#'   cost_matrix = m
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = m,
#'     path = path
#'     )
#' }
#'
#' #sum of least cost path
#' path_sum <- psi_cost_path_sum(path = path)
#'
#' #auto sum of the time series
#' xy_sum <- psi_auto_sum(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   path = path,
#'   distance = dist_method
#' )
#'
#' #dissimilarity
#' psi <- psi(
#'   path_sum = path_sum,
#'   auto_sum = xy_sum
#' )
#'
#' psi
#'
#' #full computation in one line
#' distantia(
#'   tsl = tsl
#' )$psi
#'
#' #dissimilarity plot
#' distantia_plot(
#'   tsl = tsl
#' )
#'
#' @autoglobal
#' @family psi_demo
psi_cost_path <- function(
    dist_matrix = NULL,
    cost_matrix = NULL,
    diagonal = TRUE
){

  dist_matrix <- utils_check_matrix_args(
    m = dist_matrix,
    arg_name = "dist_matrix"
  )

  cost_matrix <- utils_check_matrix_args(
    m = cost_matrix,
    arg_name = "cost_matrix"
  )

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  if(diagonal == FALSE){

    path <- cost_path_orthogonal_cpp(
      dist_matrix = dist_matrix,
      cost_matrix = cost_matrix
    )

  } else {

    path <- cost_path_diagonal_cpp(
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
