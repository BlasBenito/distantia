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
