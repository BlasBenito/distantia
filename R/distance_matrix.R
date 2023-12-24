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

  if(is.null(a)){
    stop("Argument 'a' must not be NULL.")
  }

  if(is.null(b)){
    stop("Argument 'b' must not be NULL.")
  }

  if(!any(class(a) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'a' must be a data frame or matrix.")
  }

  if(!any(class(b) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'b' must be a data frame or matrix.")
  }

  #checking for NA
  if(sum(is.na(a)) > 0){
    stop("Argument 'a' has NA values. Please remove or imputate them before the distance computation.")
  }
  if(sum(is.na(b)) > 0){
    stop("Argument 'b' has NA values. Please remove or imputate them before the distance computation.")
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

  #selecting distance
  distance <- match.arg(
    arg = distance,
    choices = c(
      distances$name,
      distances$abbreviation
    ),
    several.ok = FALSE
  )

  #distances that don't accept two zeros in same position
  if(distance %in% c(
    "chi",
    "cos",
    "cosine"
  )
  ){

    pseudozero <- mean(x = c(a, b)) * 0.0001
    a[a == 0] <- pseudozero
    b[b == 0] <- pseudozero

  }

  #computing distance matrix
  d <- distance_matrix_cpp(
    a = a,
    b = b,
    distance = distance
    )

  #adding names
  rownames(d) <- a.names
  colnames(d) <- b.names

  d

}
