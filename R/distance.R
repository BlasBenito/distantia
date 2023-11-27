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
#' \item "manhattan": `sum(abs(x - y))`
#' \item "euclidean": `sqrt(sum((x - y)^2))`.
#' \item "chi":
#'     `xy <- x + y`
#'     `y. <- y / sum(y)`
#'     `x. <- x / sum(x)`
#'     `sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))`
#' \item "hellinger": `sqrt(1/2 * sum((sqrt(x) - sqrt(y))^2))`
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
    x,
    y,
    method = c(
      "manhattan",
      "chi",
      "hellinger",
      "euclidean"
      )
    ){

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

  #handling NA
  df <- data.frame(
    x = x,
    y = y
  ) |>
    stats::na.omit()

  #computing manhattan distance
  if(method == "manhattan"){
    return(distance_manhattan_cpp(df$x, df$y))
  }

  #computing hellinger distance
  if (method == "hellinger"){
    return(distance_hellinger_cpp(df$x, df$y))
  }

  #computing chi distance
  if (method == "chi"){

    #pseudo zeros
    pseudozero <- mean(
      x = c(df$x, df$y)
    ) * 0.0001

    df[df == 0] <- pseudozero

    return(distance_chi_cpp(df$x, df$y))
  }

  #computing euclidean distance
  if (method == "euclidean"){
    return(distance_euclidean_cpp(df$x, df$y))
  }

}

