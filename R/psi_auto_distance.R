#' Cumulative Sum of Distances Between Consecutive Cases in a Time Series
#'
#' @description
#' Demonstration function to compute the sum of distances between consecutive cases in a time series.
#'
#' @param x (required, zoo object or matrix) univariate or multivariate time series with no NAs. Default: NULL
#' @inheritParams distantia
#'
#' @return numeric value
#' @export
#' @autoglobal
#' @examples
#' #distance metric
#' d <- "euclidean"
#'
#' #simulate zoo time series
#' x <- zoo_simulate(
#'   name = "x",
#'   rows = 100,
#'   seasons = 2,
#'   seed = 1
#' )
#'
#' #sum distance between consecutive samples
#' psi_auto_distance(
#'   x = x,
#'   distance = d
#' )
#' @family psi_demo
psi_auto_distance <- function(
    x = NULL,
    distance = "euclidean"
    ){

  #check x
  x <- utils_check_args_zoo(
    x = x,
    arg_name = "x"
  )

  #check distance
  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #auto sum
  x.auto_distance <- auto_distance_cpp(
    x = x,
    distance = distance
  )

  x.auto_distance

}
