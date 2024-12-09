#' Auto Sum
#'
#' @description
#' Demonstration function to computes the sum of distances between consecutive samples in two time series.
#'
#' @param x (required, zoo object or numeric matrix) univariate or multivariate time series with no NAs. Default: NULL.
#' @param y (required, zoo object or numeric matrix) a time series with the same number of columns as `x` and no NAs. Default: NULL.
#' @inheritParams distantia
#' @return numeric vector
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
#' #auto sum of distances
#' psi_auto_sum(
#'   x = x,
#'   y = y,
#'   distance = d
#' )
#'
#' #same as:
#' x_sum <- psi_auto_distance(
#'   x = x,
#'   distance = d
#' )
#'
#' y_sum <- psi_auto_distance(
#'   x = y,
#'   distance = d
#' )
#'
#' x_sum + y_sum
#'
#' @export
#' @autoglobal
#' @family psi_demo
psi_auto_sum <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
){

  #managing distance method
  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  auto_sum_full_cpp(
    y = x,
    x = y,
    distance = distance
  )

}
