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
    b = ab[[1]],
    distance = distance
    )

  #adding names
  rownames(d) <- a.names
  colnames(d) <- b.names

  d

}
