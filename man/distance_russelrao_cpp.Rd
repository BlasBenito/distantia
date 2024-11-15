% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{distance_russelrao_cpp}
\alias{distance_russelrao_cpp}
\title{(C++) Russell-Rao Distance Between Two Binary Vectors}
\usage{
distance_russelrao_cpp(x, y)
}
\arguments{
\item{x}{(required, numeric). Binary vector of 1s and 0s.}

\item{y}{(required, numeric) Binary vector of 1s and 0s of same length as \code{x}.}
}
\value{
numeric
}
\description{
Computes the Russell-Rao distance between two binary vectors.
}
\examples{
distance_russelrao_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0))
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
\code{\link{distance_matrix_cpp}()},
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
