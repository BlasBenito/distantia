#' Distance Matrix
#'
#' @description
#' Demonstration function to compute the distance matrix between two univariate or multivariate time series.
#'
#' This function does not accept NA data in the matrices `x` and `y`.
#'
#' @param x (required, zoo object or numeric matrix) a time series with no NAs. Default: NULL
#' @param y (zoo object or numeric matrix) a time series with the same columns as `x` and no NAs. Default: NULL
#' @inheritParams distantia
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

  if(zoo::is.zoo(x)){
    x_index <- zoo::index(x)
  } else {
    x_index <- 1:nrow(x)
  }

  if(zoo::is.zoo(y)){
    y_index <- zoo::index(y)
  } else {
    y_index <- 1:nrow(y)
  }

  #computing distance matrix
  m <- distance_matrix_cpp(
    x = as.matrix(x),
    y = as.matrix(y),
    distance = distance
    )

  #adding names
  dimnames(m) <- list(
    as.character(y_index),
    as.character(x_index)
  )

  x_name <- attributes(x)$name
  if(is.null(x_name)){
    x_name <- "x"
  }

  y_name <- attributes(y)$name
  if(is.null(y_name)){
    y_name <- "y"
  }

  #adding attributes
  attr(x = m, which = "x_time") <- x_index
  attr(x = m, which = "y_time") <- y_index
  attr(x = m, which = "x_name") <- x_name
  attr(x = m, which = "y_name") <- y_name
  attr(x = m, which = "type") <- "distance"
  attr(x = m, which = "distance") <- distance

  m

}
