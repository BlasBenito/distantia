#' Distance Matrix
#'
#' @param a (required, data frame or matrix) a time series.
#' @param b (required, data frame or matrix) a time series.
#' @param distance (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @examples
#'
#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' distance.matrix <- distance_matrix(
#'   a = sequenceA,
#'   b = sequenceB,
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
    a = NULL,
    b = NULL,
    distance = "euclidean"
){

  ab <- prepare_ab(
    a = a,
    b = b,
    distance = distance
  )

  distance <- check_args_distance(
    distance = distance
  )[1]

  #computing distance matrix
  d <- distance_matrix_cpp(
    a = ab[[1]],
    b = ab[[2]],
    distance = distance
    )

  #adding names
  dimnames(d) <- list(
    attributes(ab[[1]])$time,
    attributes(ab[[2]])$time
  )

  #adding attributes
  attr(x = d, which = "a_name") <- attributes(ab[[1]])$sequence_name
  attr(x = d, which = "b_name") <- attributes(ab[[2]])$sequence_name
  attr(x = d, which = "type") <- "distance"
  attr(x = d, which = "distance") <- distance

  d

}
