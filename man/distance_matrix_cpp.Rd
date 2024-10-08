% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{distance_matrix_cpp}
\alias{distance_matrix_cpp}
\title{(C++) Distance Matrix of Two Time Series}
\usage{
distance_matrix_cpp(x, y, distance = "euclidean")
}
\arguments{
\item{x}{(required, numeric matrix) univariate or multivariate time series.}

\item{y}{(required, numeric matrix) univariate or multivariate time series
with the same number of columns as 'x'.}

\item{distance}{(optional, character string) distance name from the "names"
column of the dataset \code{distances} (see \code{distances$name}). Default: "euclidean".}
}
\value{
numeric matrix
}
\description{
Computes the distance matrix between the rows of two matrices
\code{y} and \code{x} representing regular or irregular time series with the same number of
columns. NA values should be removed before using this function. If the selected distance function is "chi" or "cosine", pairs of zeros should
be either removed or replaced with pseudo-zeros (i.e. 0.00001).
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
}
\seealso{
Other Rcpp: 
\code{\link{auto_distance_cpp}()},
\code{\link{auto_sum_cpp}()},
\code{\link{auto_sum_full_cpp}()},
\code{\link{auto_sum_path_cpp}()},
\code{\link{cost_matrix_diagonal_cpp}()},
\code{\link{cost_matrix_diagonal_weighted_cpp}()},
\code{\link{cost_matrix_orthogonal_cpp}()},
\code{\link{cost_path_cpp}()},
\code{\link{cost_path_diagonal_cpp}()},
\code{\link{cost_path_orthogonal_cpp}()},
\code{\link{cost_path_slotting_cpp}()},
\code{\link{cost_path_sum_cpp}()},
\code{\link{cost_path_trim_cpp}()},
\code{\link{distance_canberra_cpp}()},
\code{\link{distance_chebyshev_cpp}()},
\code{\link{distance_chi_cpp}()},
\code{\link{distance_cosine_cpp}()},
\code{\link{distance_euclidean_cpp}()},
\code{\link{distance_hamming_cpp}()},
\code{\link{distance_hellinger_cpp}()},
\code{\link{distance_jaccard_cpp}()},
\code{\link{distance_lock_step_cpp}()},
\code{\link{distance_manhattan_cpp}()},
\code{\link{distance_russelrao_cpp}()},
\code{\link{importance_dynamic_time_warping_legacy_cpp}()},
\code{\link{importance_dynamic_time_warping_robust_cpp}()},
\code{\link{importance_lock_step_cpp}()},
\code{\link{null_psi_dynamic_time_warping_cpp}()},
\code{\link{null_psi_lock_step_cpp}()},
\code{\link{permute_free_by_row_cpp}()},
\code{\link{permute_free_cpp}()},
\code{\link{permute_restricted_by_row_cpp}()},
\code{\link{permute_restricted_cpp}()},
\code{\link{psi_dynamic_time_warping_cpp}()},
\code{\link{psi_equation_cpp}()},
\code{\link{psi_lock_step_cpp}()},
\code{\link{subset_matrix_by_rows_cpp}()}
}
\concept{Rcpp}
