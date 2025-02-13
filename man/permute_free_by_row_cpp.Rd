% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{permute_free_by_row_cpp}
\alias{permute_free_by_row_cpp}
\title{(C++) Unrestricted Permutation of Complete Rows}
\usage{
permute_free_by_row_cpp(x, block_size, seed = 1L)
}
\arguments{
\item{x}{(required, numeric matrix). Numeric matrix to permute.}

\item{block_size}{(optional, integer) this function ignores this argument and sets it to x.nrow().}

\item{seed}{(optional, integer) random seed to use.}
}
\value{
numeric matrix
}
\description{
Unrestricted shuffling of rows within the whole sequence.
}
\seealso{
Other Rcpp_permutation: 
\code{\link{permute_free_cpp}()},
\code{\link{permute_restricted_by_row_cpp}()},
\code{\link{permute_restricted_cpp}()}
}
\concept{Rcpp_permutation}
