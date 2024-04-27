#' Distance Matrix
#'
#' @param y (required, data frame or matrix) a time series.
#' @param x (required, data frame or matrix) a time series.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @examples
#'
#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' distance.matrix <- psi_dist_matrix(
#'   y = sequenceA,
#'   x = sequenceB,
#'   distance = "manhattan"
#' )
#'
#' if(interactive()){
#'  plotMatrix(distance.matrix = distance.matrix)
#' }
#'
#' @return A distance matrix.
#' @export
#' @autoglobal
psi_dist_matrix <- function(
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
    attributes(x)$index,
    attributes(y)$index
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
