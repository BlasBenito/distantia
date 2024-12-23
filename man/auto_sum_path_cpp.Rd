% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{auto_sum_path_cpp}
\alias{auto_sum_path_cpp}
\title{(C++) Sum Distances Between All Consecutive Samples in the Least Cost Path Between Two Time Series}
\usage{
auto_sum_path_cpp(x, y, path, distance = "euclidean")
}
\arguments{
\item{x}{(required, numeric matrix) univariate or multivariate time series.}

\item{y}{(required, numeric matrix) univariate or multivariate time series
with the same number of columns as 'x'.}

\item{path}{(required, data frame) least-cost path produced by \code{\link[=cost_path_orthogonal_cpp]{cost_path_orthogonal_cpp()}}.
Default: NULL}

\item{distance}{(optional, character string) distance name from the "names"
column of the dataset \code{distances} (see \code{distances$name}). Default: "euclidean".}
}
\value{
numeric
}
\description{
Computes the cumulative auto sum of auto-distances of two time series
for the coordinates of a trimmed least cost path. The output value is used
as normalization factor when computing dissimilarity scores.
}
\examples{
#simulate two time series
x <- zoo_simulate(seed = 1)
y <- zoo_simulate(seed = 2)

#distance matrix
dist_matrix <- distance_matrix_cpp(
  x = x,
  y = y,
  distance = "euclidean"
)

#least cost matrix
cost_matrix <- cost_matrix_orthogonal_cpp(
  dist_matrix = dist_matrix
)

#least cost path
cost_path <- cost_path_orthogonal_cpp(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix
)

nrow(cost_path)

#remove blocks from least-cost path
cost_path_trimmed <- cost_path_trim_cpp(
  path = cost_path
)

nrow(cost_path_trimmed)

#auto sum
auto_sum_path_cpp(
  x = x,
  y = y,
  path = cost_path_trimmed,
  distance = "euclidean"
)
}
\seealso{
Other Rcpp_auto_sum: 
\code{\link{auto_distance_cpp}()},
\code{\link{auto_sum_cpp}()},
\code{\link{auto_sum_full_cpp}()},
\code{\link{subset_matrix_by_rows_cpp}()}
}
\concept{Rcpp_auto_sum}
