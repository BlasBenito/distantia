% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tsl_simulate.R
\name{tsl_simulate}
\alias{tsl_simulate}
\title{Simulate a Time Series List}
\usage{
tsl_simulate(
  n = 2,
  cols = 5,
  rows = 100,
  time_range = c("2010-01-01", "2020-01-01"),
  data_range = c(0, 1),
  seasons = 0,
  na_fraction = 0,
  independent = FALSE,
  irregular = TRUE,
  seed = NULL
)
}
\arguments{
\item{n}{(optional, integer) Number of time series to simulate. Default: 2.}

\item{cols}{(optional, integer) Number of columns of each time series. Default: 5}

\item{rows}{(optional, integer) Length of each time series. Minimum is 10, but maximum is not limited. Very large numbers might crash the R session. Default: 100}

\item{time_range}{(optional character or numeric vector) Time interval of the time series. Either a character vector with dates in format YYYY-MM-DD or or a numeric vector. If there is a mismatch between \code{time_range} and \code{rows} (for example, the number of days in \code{time_range} is smaller than \code{rows}), the upper value in \code{time_range} is adapted to \code{rows}. Default: c("2010-01-01", "2020-01-01")}

\item{data_range}{(optional, numeric vector of length 2) Extremes of the time series values. Default: c(0, 1)}

\item{seasons}{(optional, integer) Number of seasons in the resulting time series. The maximum number of seasons is computed as \code{floor(rows/3)}. Default: 0}

\item{na_fraction}{(optional, numeric) Value between 0 and 0.5 indicating the approximate fraction of NA data in the simulated time series. Default: 0.}

\item{independent}{(optional, logical) If TRUE, each new column in a simulated time series is averaged with the previous column to generate dependency across columns, and each new simulated time series is weighted-averaged with a time series template to generate dependency across time series. Irrelevant when \code{cols < 2} or \code{n < 2}, and hard to perceive in the output when \code{seasons > 0}. Default: FALSE}

\item{irregular}{(optional, logical) If TRUE, the time intervals between consecutive samples and the number of rows are irregular. Default: TRUE}

\item{seed}{(optional, integer) Random seed used to simulate the zoo object. If NULL (default), a seed is selected at random. Default: NULL}
}
\value{
time series list
}
\description{
Generates simulated time series lists for testing and learning.

This function supports progress bars generated by the \code{progressr} package, and accepts a parallelization setup via \code{\link[future:plan]{future::plan()}} (see examples).
}
\examples{

# generates a different time series list on each iteration when seed = NULL
tsl <- tsl_simulate(
  n = 2,
  seasons = 4
)

if(interactive()){
  tsl_plot(
    tsl = tsl
  )
}

# generate 3 independent time series
tsl_independent <- tsl_simulate(
  n = 3,
  cols = 3,
  independent = TRUE
)

if(interactive()){
  tsl_plot(
    tsl = tsl_independent
  )
}

# generate 3 independent time series
tsl_dependent <- tsl_simulate(
  n = 3,
  cols = 3,
  independent = FALSE
)

if(interactive()){
  tsl_plot(
    tsl = tsl_dependent
  )
}

# with seasons
tsl_seasons <- tsl_simulate(
  n = 3,
  cols = 3,
  seasons = 4,
  independent = FALSE
)

if(interactive()){
  tsl_plot(
    tsl = tsl_seasons
  )
}

}
\seealso{
Other simulate_time_series: 
\code{\link{zoo_simulate}()}
}
\concept{simulate_time_series}
