#' Cost Matrix
#'
#' @description Computes the cost matrix from a distance matrix.
#'
#' @param dist_matrix (required, numeric matrix). Distance matrix.
#' @param diagonal (optional, logical). If `TRUE`, diagonals are included in the computation of the cost matrix Default: TRUE
#' @param weighted (optional, logical). Only relevant if `diagonal = TRUE`. If `TRUE`, weights diagonal cost by a factor of 1.414214. Default: TRUE
#' @return A cost matrix.
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
#' @autoglobal
#' @export
#' @family psi_demo
psi_cost_matrix <- function(
    dist_matrix = NULL,
    diagonal = TRUE,
    weighted = TRUE
    ){

  dist_matrix <- utils_check_matrix_args(
    m = dist_matrix,
    arg_name = "dist_matrix"
  )

  if(is.logical(diagonal) == FALSE){
    stop("Argument 'diagonal' must be logical (TRUE or FALSE)")
  }

  if(is.logical(weighted) == FALSE){
    stop("Argument 'weighted' must be logical (TRUE or FALSE)")
  }

  #diagonal is TRUE
  if(diagonal == TRUE){

    if(weighted == TRUE){

      m <- cost_matrix_weighted_diag_cpp(dist_matrix = dist_matrix)

    } else {

      m <- cost_matrix_diag_cpp(dist_matrix = dist_matrix)

    }

  } else {

    m <- cost_matrix_cpp(dist_matrix = dist_matrix)

  }

  #adding names
  dimnames(m) <- dimnames(dist_matrix)

  #adding attributes

  attr(x = m, which = "y_time") <- attributes(dist_matrix)$y_time
  attr(x = m, which = "x_time") <- attributes(dist_matrix)$x_time
  attr(x = m, which = "y_name") <- attributes(dist_matrix)$y_name
  attr(x = m, which = "x_name") <- attributes(dist_matrix)$x_name
  attr(x = m, which = "type") <- "cost"
  attr(x = m, which = "distance") <- attributes(dist_matrix)$distance

  m

}
