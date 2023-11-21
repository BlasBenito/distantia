#' Distance Matrix
#'
#' @param a (required, data frame) a time series.
#' @param b (required, data frame) a time series.
#' @param method (optional, character string) name of the distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Default: "manhattan
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
#'   method = "manhattan"
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
    a,
    b,
    method = c(
      "manhattan",
      "chi",
      "hellinger",
      "euclidean"
    )
){

  #checking for NA
  if(sum(is.na(a)) > 0){
    stop("Argument 'a' has NA values.")
  }
  if(sum(is.na(b)) > 0){
    stop("Argument 'b' has NA values.")
  }

  #preprocessing data
  if(ncol(a) != ncol(b)){
    common.cols <- intersect(
      x = colnames(a),
      y = colnames(b)
    )
    a <- a[, common.cols]
    b <- b[, common.cols]
  }

  #capture row names
  a.names <- rownames(a)
  b.names <- rownames(b)

  if(!is.matrix(a)){
    a <- as.matrix(a)
  }

  if(!is.matrix(b)){
    b <- as.matrix(b)
  }

  #pseudo zeros
  pseudozero <- mean(x = c(a, b)) * 0.001
  a[a == 0] <- pseudozero
  b[b == 0] <- pseudozero

  #selecting method
  method <- match.arg(
    arg = method,
    choices = c(
      "manhattan",
      "chi",
      "hellinger",
      "euclidean"
    ),
    several.ok = FALSE
  )

  if(method == "manhattan"){
    f <- distance_manhattan_cpp
  }
  if(method == "hellinger"){
    f <- distance_hellinger_cpp
  }
  if(method == "chi"){
    f <- distance_chi_cpp
  }
  if(method == "euclidean"){
    f <- distance_euclidean_cpp
  }

  #computing distance matrix
  d <- distance_matrix_cpp(
    a = a,
    b = b,
    f = f
    )

  #adding names
  rownames(d) <- a.names
  colnames(d) <- b.names

  d

}
