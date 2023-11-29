#' Distance Between Two Vectors
#'
#' @description Computes Manhattan, Euclidean, Chi, or Hellinger distances between numeric vectors of the same length. The underlying C++ functions (see [distance_manhattan_cpp()], [distance_euclidean_cpp()], [distance_hellinger_cpp()], and [distance_chi_cpp()]) do not accept NA as input, and as such, positions with NA in `x` and `y` are ignored.
#'
#' @param x (required, numeric vector).
#' @param y (required, numeric vector) of same length as `x`.
#' @param method (required, character string) name of a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger".
#' @return A distance value.
#' @details Distances are computed as:
#' \itemize{
#' \item "manhattan" or "man: `sum(abs(x - y))`
#' \item "euclidean" or "euc": `sqrt(sum((x - y)^2))`.
#' \item "chi":
#'     `xy <- x + y`
#'     `y. <- y / sum(y)`
#'     `x. <- x / sum(x)`
#'     `sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))`
#' \item "hellinger" or "hel": `sqrt(1/2 * sum((sqrt(x) - sqrt(y))^2))`
#' \item "canberra" or "can": `sum(abs(x - y) / (abs(x) + abs(y)))`
#' \item "cosine" or "cos": `1 - sum(x * y) / (sqrt(sum(x^2)) * sqrt(sum(y^2)))`.
#' \item "jaccard" or "jac": `1 - (sum(x & y) / sum(x | y))`.
#' \item "chebyshev" or "che": `max(abs(x - y))`
#' \item "russelrao" or "rus": `1 - sum(x == y) / length(x)`
#' }
#' Note that zeroes are replaced by `mean(c(x, y)) * 0.0001` whem `method` is "chi".
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#'
#' distance(
#'   x = runif(100),
#'   y = runif(100),
#'   method = "manhattan"
#' )
#'
#' @autoglobal
#' @export
distance <- function(
    x = NULL,
    y = NULL,
    method = "euclidean"
    ){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL.")
  }

  if(is.null(y)){
    stop("Argument 'y' must not be NULL.")
  }

  if(length(x) != length(y)){
    stop("Arguments 'x' and 'y' must be of the same length.")
  }

  #checking for NA
  if(sum(is.na(x)) > 0){
    stop("Argument 'x' has NA values. Please remove or imputate them before the distance computation.")
  }
  if(sum(is.na(y)) > 0){
    stop("Argument 'y' has NA values. Please remove or imputate them before the distance computation.")
  }

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

  #handling NA
  df <- data.frame(
    x = x,
    y = y
  ) |>
    stats::na.omit()

  #methods that don't accept two zeros in same position
  if(method %in% c(
    "chi",
    "cos",
    "cosine"
  )
  ){

    pseudozero <- mean(x = c(df$x, df$y)) * 0.0001
    df[df == 0] <- pseudozero

  }

  #computing manhattan distance
  if(method %in% c("manhattan", "man")){
    return(distance_manhattan_cpp(df$x, df$y))
  }

  #computing hellinger distance
  if (method %in% c("hellinger", "hel")){
    return(distance_hellinger_cpp(df$x, df$y))
  }

  #computing chi distance
  if (method == "chi"){
    return(distance_chi_cpp(df$x, df$y))
  }

  #computing euclidean distance
  if (method %in% c("euclidean", "euc")){
    return(distance_euclidean_cpp(df$x, df$y))
  }

  #computing cosine distance
  if (method %in% c("cosine", "cos")){
    return(distance_cosine_cpp(df$x, df$y))
  }

  #computing jaccard distance
  if (method %in% c("jaccard", "jac")){
    return(distance_jaccard_cpp(df$x, df$y))
  }

  #computing canberra distance
  if (method %in% c("canberra", "can")){
    return(distance_canberra_cpp(df$x, df$y))
  }

  #computing chebyshev distance
  if (method %in% c("chebyshev", "che")){
    return(distance_chebyshev_cpp(df$x, df$y))
  }

  #computing russelrao distance
  if (method %in% c("russelrao", "rus")){
    return(distance_russelrao_cpp(df$x, df$y))
  }

}

