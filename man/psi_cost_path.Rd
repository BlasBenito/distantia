% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/psi_cost_path.R
\name{psi_cost_path}
\alias{psi_cost_path}
\title{Least Cost Path}
\usage{
psi_cost_path(
  dist_matrix = NULL,
  cost_matrix = NULL,
  diagonal = TRUE,
  bandwidth = 1
)
}
\arguments{
\item{dist_matrix}{(required, numeric matrix) Distance matrix generated by \code{\link[=psi_distance_matrix]{psi_distance_matrix()}}. Default: NULL}

\item{cost_matrix}{(required, numeric matrix) Cost matrix generated from the distance matrix with \code{\link[=psi_cost_matrix]{psi_cost_matrix()}}. Default: NULL}

\item{diagonal}{(optional, logical vector). If TRUE, diagonals are included in the dynamic time warping computation. Default: TRUE}

\item{bandwidth}{(optional, numeric) Proportion of space at each side of the cost matrix diagonal (aka \emph{Sakoe-Chiba band}) defining a valid region for dynamic time warping, used to control the flexibility of the warping path. This method prevents degenerate alignments due to differences in magnitude between time series when the data is not properly scaled. If \code{1} (default), DTW is unconstrained. If \code{0}, DTW is fully constrained and the warping path follows the matrix diagonal. Recommended values may vary depending on the nature of the data. Ignored if \code{lock_step = TRUE}. Default: 1.}
}
\value{
data frame
}
\description{
Demonstration function to compute the least cost path within a least cost matrix.
}
\examples{
#distance metric
d <- "euclidean"

#simulate two irregular time series
x <- zoo_simulate(
  name = "x",
  rows = 100,
  seasons = 2,
  seed = 1
)

y <- zoo_simulate(
  name = "y",
  rows = 80,
  seasons = 2,
  seed = 2
)

if(interactive()){
  zoo_plot(x = x)
  zoo_plot(x = y)
}

#distance matrix
dist_matrix <- psi_distance_matrix(
  x = x,
  y = y,
  distance = d
)

#diagonal least cost path
#------------------------

cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix,
  diagonal = TRUE
)

cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = TRUE
)

if(interactive()){
  utils_matrix_plot(
    m = cost_matrix,
    path = cost_path
    )
}


#orthogonal least cost path
#--------------------------
cost_matrix <- psi_cost_matrix(
  dist_matrix = dist_matrix,
  diagonal = FALSE
)

cost_path <- psi_cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = FALSE
)

if(interactive()){
  utils_matrix_plot(
    m = cost_matrix,
    path = cost_path
  )
}
}
\seealso{
Other psi_demo: 
\code{\link{psi_auto_distance}()},
\code{\link{psi_auto_sum}()},
\code{\link{psi_cost_matrix}()},
\code{\link{psi_cost_path_sum}()},
\code{\link{psi_distance_lock_step}()},
\code{\link{psi_distance_matrix}()},
\code{\link{psi_equation}()}
}
\concept{psi_demo}
