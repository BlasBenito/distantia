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
#' distance.matrix <- distance_matrix(
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
distance_matrix <- function(
    x = NULL,
    y = NULL,
    distance = "euclidean"
){

  xy <- prepare_xy(
    y = y,
    x = x,
    distance = distance
  )

  distance <- check_args_distance(
    distance = distance
  )[1]

  #computing distance matrix
  m <- distance_matrix_cpp(
    x = xy[[1]],
    y = xy[[2]],
    distance = distance
    )

  #adding names
  dimnames(m) <- list(
    attributes(xy[[2]])$index,
    attributes(xy[[1]])$index
  )

  #adding attributes
  attr(x = m, which = "x_name") <- attributes(xy[[1]])$sequence_name
  attr(x = m, which = "y_name") <- attributes(xy[[2]])$sequence_name
  attr(x = m, which = "type") <- "distance"
  attr(x = m, which = "distance") <- distance

  m

}
