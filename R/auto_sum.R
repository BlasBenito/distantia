#' Auto Sum
#'
#' @description Computes the sum of distances between consecutive samples in two multivariate time-series under comparison. Required to compute the measure of dissimilarity \code{psi} (Birks and Gordon 1985). Distances can be computed via the methods "manhattan", "euclidean", "chi", and "hellinger.
#'
#' @param a (required, data frame) a time series. Default: NULL.
#' @param b (required, data frame) a time series. Default: NULL.
#' @param path (required, data frame) dataframe produced by [cost_path()]. Only required when [trim_blocks()] has been applied to `path`. Default: NULL.
#' @param method (optional, character string) name of the distance metric. Valid entries are:
#' \itemize{
#'   \item "euclidean" and "euc" (Default).
#'   \item "manhattan" and "man".
#'   \item "chi.
#'   \item "hellinger" and "hel".
#'   \item "chebyshev" and "che".
#'   \item "canberra" and "can".
#'   \item "cosine" and "cos".
#'   \item "russelrao" and "rus".
#'   \item "jaccard" and "jac".
#' }
#'
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

  #subset by elements in path
  if(!is.null(path)){

    if(!is.data.frame(path)){
      stop("Argument 'path' must be a data frame.")
    }

    if(all(c("a", "b", "dist", "cost") %in% colnames(path)) == FALSE){
      stop("Argument 'path' must have the columns 'A', 'B', 'dist', and 'cost'.")
    }

    a <- a[unique(path$a), ]
    b <- b[unique(path$b), ]

  }

  #managing distance method
  method <- match.arg(
    arg = method,
    choices = c(
      "euclidean",
      "euc",
      "manhattan",
      "man",
      "chi",
      "hellinger",
      "hel",
      "canberra",
      "can",
      "russelrao",
      "rus",
      "cosine",
      "cos",
      "jaccard",
      "jac",
      "chebyshev",
      "che"
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

  a.sum <- auto_distance_cpp(
    x = a,
    method = method
  )

  b.sum <- auto_distance_cpp(
    x = b,
    method = method
  )

  sum(a.sum, b.sum)

}
