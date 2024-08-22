#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985).
#'
#' @param y (required, data frame) a zoo time series or numeric matrix. Default: NULL.
#' @param x (required, data frame) a zoo time series or numeric matrix. Default: NULL.
#' @param path (required, data frame) dataframe produced by [psi_cost_path()]. Only required when [psi_cost_path_trim_blocks()] has been applied to `path`. Default: NULL.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return Named vector with the auto sums of `y` and `x`.
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
#' @export
#' @autoglobal
#' @family psi_demo
psi_auto_sum <- function(
    y = NULL,
    x = NULL,
    path = NULL,
    distance = "euclidean"
    ){

  #managing distance method
  distance <- utils_check_distance_args(
    distance = distance
  )[1]


  if(!is.null(path)){

    path <- utils_check_path_args(
      path = path
    )

    xy_sum <- auto_sum_path_cpp(
      x = x,
      y = y,
      path = path,
      distance = distance
    )

  } else {

    xy_sum <- auto_sum_no_path_cpp(
      y = x,
      x = y,
      distance = distance
    )

  }

 xy_sum

}
