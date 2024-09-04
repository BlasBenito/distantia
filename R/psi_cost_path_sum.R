#' Sum of Distances in Least Cost Path
#'
#' @description
#' Demonstration function to sum the distances of a least cost path.
#'
#'
#' @param path (required, data frame) least cost path produced by [psi_cost_path()]. Default: NULL
#' @return numeric value
#' @examples
#' #distance metric
#' d <- "euclidean"
#'
#' #simulate two irregular time series
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#' )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   rows = 80,
#'   seasons = 2,
#'   seed = 2
#' )
#'
#' if(interactive()){
#'   zoo_plot(x = x)
#'   zoo_plot(x = y)
#' }
#'
#' #distance matrix
#' dist_matrix <- psi_distance_matrix(
#'   x = x,
#'   y = y,
#'   distance = d
#' )
#'
#' #orthogonal least cost matrix
#' cost_matrix <- psi_cost_matrix(
#'   dist_matrix = dist_matrix
#' )
#'
#' #orthogonal least cost path
#' cost_path <- psi_cost_path(
#'   dist_matrix = dist_matrix,
#'   cost_matrix = cost_matrix
#' )
#'
#' #sum of distances in cost path
#' psi_cost_path_sum(
#'   path = cost_path
#' )
#' @autoglobal
#' @export
#' @family psi_demo
psi_cost_path_sum <- function(path = NULL){

  path <- utils_check_path_args(
    path = path
  )

  sum(path$dist)

}
