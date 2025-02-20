% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{distance_ls_cpp}
\alias{distance_ls_cpp}
\title{(C++) Sum of Pairwise Distances Between Cases in Two Aligned Time Series}
\usage{
distance_ls_cpp(x, y, distance = "euclidean")
}
\arguments{
\item{x}{(required, numeric matrix) univariate or multivariate time series.}

\item{y}{(required, numeric matrix) univariate or multivariate time series
with the same number of columns and rows as 'x'.}

\item{distance}{(optional, character string) distance name from the "names"
column of the dataset \code{distances} (see \code{distances$name}). Default: "euclidean".}
}
\value{
numeric
}
\description{
Computes the lock-step sum of distances between two regular
and aligned time series. NA values should be removed before using this function.
If the selected distance function is "chi" or "cosine", pairs of zeros should
be either removed or replaced with pseudo-zeros (i.e. 0.00001).
}
\examples{
#simulate two regular time series
x <- zoo_simulate(
  seed = 1,
  irregular = FALSE
  )
y <- zoo_simulate(
  seed = 2,
  irregular = FALSE
  )

#distance matrix
dist_matrix <- distance_ls_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)
}
\seealso{
Other Rcpp_matrix: 
\code{\link{cost_matrix_diagonal_cpp}()},
\code{\link{cost_matrix_diagonal_weighted_cpp}()},
\code{\link{cost_matrix_orthogonal_cpp}()},
\code{\link{distance_matrix_cpp}()}
}
\concept{Rcpp_matrix}
