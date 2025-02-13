% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/psi_auto_distance.R
\name{psi_auto_distance}
\alias{psi_auto_distance}
\title{Cumulative Sum of Distances Between Consecutive Cases in a Time Series}
\usage{
psi_auto_distance(x = NULL, distance = "euclidean")
}
\arguments{
\item{x}{(required, zoo object or matrix) univariate or multivariate time series with no NAs. Default: NULL}

\item{distance}{(optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset \link{distances}. Default: "euclidean".}
}
\value{
numeric value
}
\description{
Demonstration function to compute the sum of distances between consecutive cases in a time series.
}
\examples{
#distance metric
d <- "euclidean"

#simulate zoo time series
x <- zoo_simulate(
  name = "x",
  rows = 100,
  seasons = 2,
  seed = 1
)

#sum distance between consecutive samples
psi_auto_distance(
  x = x,
  distance = d
)
}
\seealso{
Other psi_demo: 
\code{\link{psi_auto_sum}()},
\code{\link{psi_cost_matrix}()},
\code{\link{psi_cost_path}()},
\code{\link{psi_cost_path_sum}()},
\code{\link{psi_distance_lock_step}()},
\code{\link{psi_distance_matrix}()},
\code{\link{psi_equation}()}
}
\concept{psi_demo}
