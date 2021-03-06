% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distance.R
\name{distance}
\alias{distance}
\title{Computes a multivariate distance between two vectors.}
\usage{
distance(x, y, method = "manhattan")
}
\arguments{
\item{x}{numeric vector.}

\item{y}{numeric vector of the same length as \code{x}.}

\item{method}{character string naming a distance metric. Valid entries are: "manhattan", "euclidean", "chi", and "hellinger". Invalid entries will throw an error.}
}
\value{
A number representing the distance between both vectors.
}
\description{
Computes a multivariate distance (one of: "manhattan", "euclidean", "chi", and "hellinger") between two vectors of the same length. It is used internally by \code{\link{distanceMatrix}} and \code{\link{autoSum}}. This function has no buit-in error trapping procedures in order to speed up execution.
}
\details{
Vectors \code{x} and \code{y} are not checked to speed-up execution time. Distances are computed as:
\itemize{
\item \code{manhattan}: \code{d <- sum(abs(x - y))}
\item \code{euclidean}: \code{d <- sqrt(sum((x - y)^2))}
\item \code{chi}: \code{
    xy <- x + y
    y. <- y / sum(y)
    x. <- x / sum(x)
    d <- sqrt(sum(((x. - y.)^2) / (xy / sum(xy))))}
\item \code{hellinger}: \code{d <- sqrt(1/2 * sum(sqrt(x) - sqrt(y))^2)}
}
Note that zeroes are replaced by 0.00001 whem \code{method} equals "chi" or "hellinger".
}
\examples{
x <- runif(100)
y <- runif(100)
distance(x, y, method = "manhattan")

}
\author{
Blas Benito <blasbenito@gmail.com>
}
