#' Auto Sum
#'
#' @description
#' Demonstration function to computes the sum of distances between consecutive samples in two time series.
#'
#' @param x (required, zoo object or numeric matrix) univariate or multivariate time series with no NAs. Default: NULL.
#' @param y (required, zoo object or numeric matrix) a time series with the same number of columns as `x` and no NAs. Default: NULL.
#' @param path (required, data frame) least cost path produced by [psi_cost_path()]. Only required when [psi_cost_path_ignore_blocks()] has been applied to `path`. Default: NULL.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @return numeric vector
#' @examples
#' #simulate two zoo objects
#' tsl <- tsl_simulate(
#'   n = 2,
#'   seed = 1
#' )
#'
#' if(interactive()){
#'   tsl_plot(tsl = tsl)
#' }
#'
#' #auto sum of distances
#' psi_auto_sum(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = "euclidean"
#' )
#'
#' #same as:
#' x_sum <- psi_auto_distance(
#'   x = tsl[[1]],
#'   distance = "euclidean"
#' )
#'
#' y_sum <- psi_auto_distance(
#'   x = tsl[[2]],
#'   distance = "euclidean"
#' )
#'
#' x_sum + y_sum
#' @export
#' @autoglobal
#' @family psi_demo
psi_auto_sum <- function(
    x = NULL,
    y = NULL,
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

    xy_sum <- auto_sum_full_cpp(
      y = x,
      x = y,
      distance = distance
    )

  }

 xy_sum

}
