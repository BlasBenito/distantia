% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformations.R
\name{f_detrend_difference}
\alias{f_detrend_difference}
\title{Data Transformation: Differencing Detrending of Zoo Time Series}
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
Differencing detrending via \code{\link[=diff]{diff()}}. Returns randomm fluctuations from sample to sample not related to the overall trend of the time series.
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
Other data_transformation: 
\code{\link{f_center}()},
\code{\link{f_detrend_linear}()},
\code{\link{f_hellinger}()},
\code{\link{f_list}()},
\code{\link{f_pca}()},
\code{\link{f_percentage}()},
\code{\link{f_proportion}()},
\code{\link{f_rescale}()},
\code{\link{f_scale}()},
\code{\link{f_slope}()},
\code{\link{f_smooth_window}()},
\code{\link{f_trend_linear}()}
}
\concept{data_transformation}
