#' Computes a multivariate distance between two vectors.
#'
#' @description Computes a multivariate distance (one of: "manhattan", "euclidean", "chi", and "hellinger") between two vectors of the same length. It is used internally by \code{\link{distanceMatrix}} and \code{\link{autoSum}}. This function has no buit-in error trapping procedures in order to speed up execution.
#'
#' @usage distance(x, y, method = "manhattan")
#'
#' @param x numeric vector.
#' @param y numeric vector of the same length as \code{x}.
#' @param method character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.
#' @return A number representing the distance between both vectors.
#' @details Vectors \code{x} and \code{y} are not checked to speed-up execution time. Distances are computed as:
#' \itemize{
#' \item \code{manhattan}: \code{d <- sum(abs(x - y))}
#' \item \code{euclidean}: \code{d <- sqrt(sum((x - y)^2))}
#' \item \code{chi}: \code{
#'     xy <- x + y
#'     y. <- y / sum(y)
#'     x. <- x / sum(x)
#'     d <- sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))}
#' \item \code{hellinger}: \code{d <- sqrt(1/2 * sum(sqrt(x) - sqrt(y))^2)}
#' }
#' Note that zeroes are replaced by 0.00001 whem \code{method} equals "chi" or "hellinger".
#' @author Blas Benito <blasbenito@gmail.com>
#' @examples
#' x <- runif(100)
#' y <- runif(100)
#' distance(x, y, method = "manhattan")
#'
#' @export
distance <- function(x,
                     y,
                     method = "manhattan"){

  #handling NA
  NA.cases <- c(
    which(is.na(x)),
    which(is.na(y))
    )
  x <- x[-NA.cases]
  y <- y[-NA.cases]

  #computing manhattan distance
  if (method == "manhattan"){
    d <-  sum(abs(x - y))
  }

  #computing hellinger distance
  if (method == "hellinger"){
    x[x==0] <- 0.00001
    y[y==0] <- 0.00001
    d <- sqrt(1/2 * sum(sqrt(x) - sqrt(y))^2)
  }

  #computing chi distance
  if (method == "chi"){
    x[x==0] <- 0.00001
    y[y==0] <- 0.00001
    xy <- x + y
    y. <- y / sum(y)
    x. <- x / sum(x)
    d <- sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))
  }

  #computing euclidean distance
  if (method == "euclidean"){
    d <- sqrt(sum((x - y)^2))
  }

  return(d)

}
