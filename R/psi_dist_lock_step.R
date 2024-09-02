#' Lock-Step Distance
#'
#' @description
#' Demonstration function to compute the lock-step distance between two univariate or multivariate time series.
#'
#' This function does not accept NA data in the matrices `x` and `y`.
#'
#' @param x (required, zoo object or numeric matrix) a time series with no NAs. Default: NULL
#' @param y (zoo object or numeric matrix) a time series with the same columns as `x` and no NAs. Default: NULL
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
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
#' d <- psi_dist_lock_step(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = "euclidean"
#' )
#'
#' d
#' @return numeric
#' @export
#' @autoglobal
#' @family psi_demo
psi_dist_lock_step <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
){

  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  d <- distance_lock_step_cpp(
    x,
    y,
    distance
  )

  d

}
