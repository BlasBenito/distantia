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
#' #distance metric
#' d <- "euclidean"
#'
#' #simulate two time series
#' #of the same length
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#' )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 2
#' )
#'
#' if(interactive()){
#'   zoo_plot(x = x)
#'   zoo_plot(x = y)
#' }
#'
#' #sum of distances
#' #between pairs of samples
#' psi_distance_lock_step(
#'   x = x,
#'   y = y,
#'   distance = d
#' )
#' @return numeric
#' @export
#' @autoglobal
#' @family psi_demo
psi_distance_lock_step <- function(
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
