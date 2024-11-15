% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformations.R
\name{f_smooth_window}
\alias{f_smooth_window}
\title{Data Transformation: Moving Window Smoothing of Zoo Time Series}
\usage{
f_smooth_window(x = NULL, smoothing_window = 3, smoothing_f = mean, ...)
}
\arguments{
\item{x}{(required, zoo object) Zoo time series object to transform. Default: NULL}

\item{smoothing_window}{(required, odd integer) Width of the window to compute the rolling statistics of the time series. Should be an odd number. Even numbers are coerced to odd by adding one. Default: 3}

\item{smoothing_f}{(required, function) name without quotes and parenthesis of a standard function to smooth a time series. Typical examples are \code{mean} (default), \code{max}, \code{mean}, \code{median}, and \code{sd}. Custom functions able to handle zoo objects or matrices are also allowed. Default: \code{mean}.}

\item{...}{(optional, additional arguments) additional arguments to \code{smoothing_f}. Used as argument \code{...} in \code{\link[zoo:rollapply]{zoo::rollapply()}}.}
}
\value{
zoo object
}
\description{
Simplified wrapper to \code{\link[zoo:rollapply]{zoo::rollapply()}} to apply rolling window smoothing to zoo objects.
}
\examples{
x <- zoo_simulate(cols = 2)

y <- f_smooth_window(
  x = x,
  smoothing_window = 5,
  smoothing_f = mean
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
}
\seealso{
Other data_transformation: 
\code{\link{f_center}()},
\code{\link{f_detrend_difference}()},
\code{\link{f_detrend_linear}()},
\code{\link{f_hellinger}()},
\code{\link{f_list}()},
\code{\link{f_pca}()},
\code{\link{f_percentage}()},
\code{\link{f_proportion}()},
\code{\link{f_rescale}()},
\code{\link{f_scale}()},
\code{\link{f_slope}()},
\code{\link{f_trend_linear}()}
}
\concept{data_transformation}
