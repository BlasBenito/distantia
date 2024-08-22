#' Sum of Distances in Least-cost Path
#'
#' @param path (required, data frame) dataframe produced by [psi_cost_path()]. Default: NULL
#' @return Sum of distances.
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
psi_cost_path_sum <- function(path = NULL){

  path <- utils_check_path_args(
    path = path
  )

  sum(path$dist)

}
