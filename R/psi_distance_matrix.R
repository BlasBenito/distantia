#' Distance Matrix
#'
#' @description
#' Demonstration function to compute the distance matrix between two univariate or multivariate time series.
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
#' dist_matrix <- psi_distance_matrix(
#'   x = tsl[[1]],
#'   y = tsl[[2]],
#'   distance = "euclidean"
#' )
#'
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = dist_matrix
#'     )
#' }
#' @return numeric matrix
#' @export
#' @autoglobal
#' @family psi_demo
psi_distance_matrix <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
){

  distance <- utils_check_distance_args(
    distance = distance
  )[1]

  #computing distance matrix
  m <- distance_matrix_cpp(
    x = x,
    y = y,
    distance = distance
    )

  #adding names
  dimnames(m) <- list(
    as.character(attributes(y)$index),
    as.character(attributes(x)$index)
  )

  #adding attributes
  attr(x = m, which = "x_time") <- attributes(x)$index
  attr(x = m, which = "y_time") <- attributes(y)$index
  attr(x = m, which = "x_name") <- attributes(x)$name
  attr(x = m, which = "y_name") <- attributes(y)$name
  attr(x = m, which = "type") <- "distance"
  attr(x = m, which = "distance") <- distance

  m

}
