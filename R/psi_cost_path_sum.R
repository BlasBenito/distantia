#' Sum of Distances in Least Cost Path
#'
#' @description
#' Demonstration function to sum the distances of a least cost path.
#'
#'
#' @param path (required, data frame) least cost path produced by [psi_cost_path()]. Default: NULL
#' @return numeric value
#' @examples
#' #simulate two time series
#' tsl <- tsl_simulate(
#'   n = 2,
#'   seed = 1
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #distance matrix
#' dist_matrix <- psi_distance_matrix(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = "euclidean"
#' )
#'
#' #cost matrix
#' cost_matrix <- psi_cost_matrix(
#'   dist_matrix = dist_matrix
#' )
#'
#' #least cost path
#' cost_path <- psi_cost_path(
#'   dist_matrix = dist_matrix,
#'   cost_matrix = cost_matrix
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = cost_matrix,
#'     path = path
#'     )
#' }
#'
#' #sum of distances of the least cost path
#' psi_cost_path_sum(
#'   path = cost_path
#'   )
#' @autoglobal
#' @export
#' @family psi_demo
psi_cost_path_sum <- function(path = NULL){

  path <- utils_check_path_args(
    path = path
  )

  sum(path$dist)

}
