#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed via the methods "manhattan", "euclidean", "chi", and "hellinger.
#'
#' @param a (required, data frame) a time series. Default: NULL.
#' @param b (required, data frame) a time series. Default: NULL.
#' @param path (required, data frame) dataframe produced by [cost_path()]. Only required when [trim_blocks()] has been applied to `path`. Default: NULL.
#' @param method (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `methods`. Default: "euclidean".
#' @return Named vector with the auto sums of `a` and `b`.
#' @examples
#' data(sequenceA, sequenceB)
#'
#' a <- sequenceA |>
#'   na.omit() |>
#'   as.matrix()
#'
#' b <- sequenceB |>
#'   na.omit() |>
#'   as.matrix()
#'
#' ab_sum <- auto_sum(
#'   a = a,
#'   b = b,
#'   method = "manhattan"
#' )
#'
#' ab_sum
#'
#' @export
#' @autoglobal
auto_sum <- function(
    a = NULL,
    b = NULL,
    path = NULL,
    method = "euclidean"
    ){

  #check input arguments
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

  if(!is.matrix(a)){
    a <- as.matrix(a)
  }

  if(!is.matrix(b)){
    b <- as.matrix(b)
  }

  #managing distance method
  method <- match.arg(
    arg = method,
    choices = c(
      methods$name,
      methods$abbreviation
    ),
    several.ok = FALSE
  )

  #methods that don't accept two zeros in same position
  if(method %in% c(
    "chi",
    "cos",
    "cosine"
  )
  ){

    pseudozero <- mean(x = c(a, b)) * 0.001
    a[a == 0] <- pseudozero
    b[b == 0] <- pseudozero

  }

  if(!is.null(path)){
    ab_sum <- auto_sum_path_cpp(
      a = a,
      b = b,
      path = path,
      method = method
    )
  } else {
    ab_sum <- auto_sum_no_path_cpp(
      a = a,
      b = b,
      method = method
    )
  }

 ab_sum

}
