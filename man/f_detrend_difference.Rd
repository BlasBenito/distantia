% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformations.R
\name{f_detrend_difference}
\alias{f_detrend_difference}
\title{Data Transformation: Detrending and Differencing}
\usage{
f_detrend_difference(x = NULL, lag = 1, center = TRUE, ...)
}
\arguments{
\item{x}{(required, zoo object) Zoo time series object to transform.}

\item{lag}{(optional, integer)}

\item{center}{(required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE}

\item{...}{(optional, additional arguments) Ignored in this function.}
}
\value{
zoo object
}
\description{
Performs differencing to remove trends from a zoo time series, isolating short-term fluctuations by subtracting values at specified lags. The function preserves the original index and metadata, with an option to center the output around the mean of the original series. Suitable for preprocessing time series data to focus on random fluctuations unrelated to overall trends.
}
\examples{
x <- zoo_simulate(cols = 2)

y_lag1 <- f_detrend_difference(
  x = x,
  lag = 1
)

y_lag5 <- f_detrend_difference(
  x = x,
  lag = 5
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y_lag1)
  zoo_plot(y_lag5)
}
}
\seealso{
Other tsl_transformation: 
\code{\link{f_binary}()},
\code{\link{f_clr}()},
\code{\link{f_detrend_linear}()},
\code{\link{f_detrend_poly}()},
\code{\link{f_hellinger}()},
\code{\link{f_list}()},
\code{\link{f_log}()},
\code{\link{f_percent}()},
\code{\link{f_proportion}()},
\code{\link{f_proportion_sqrt}()},
\code{\link{f_rescale_global}()},
\code{\link{f_rescale_local}()},
\code{\link{f_scale_global}()},
\code{\link{f_scale_local}()},
\code{\link{f_trend_linear}()},
\code{\link{f_trend_poly}()}
}
\concept{tsl_transformation}
