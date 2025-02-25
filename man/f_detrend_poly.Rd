% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformations.R
\name{f_detrend_poly}
\alias{f_detrend_poly}
\title{Data Transformation: Polynomial Linear Detrending of Zoo Time Series}
\usage{
f_detrend_poly(x = NULL, degree = 2, center = TRUE, ...)
}
\arguments{
\item{x}{(required, zoo object) Zoo time series object to transform.}

\item{degree}{(optional, integer) Degree of the polynomial. Default: 2}

\item{center}{(required, logical) If TRUE, the output is centered at zero. If FALSE, it is centered at the data mean. Default: TRUE}

\item{...}{(optional, additional arguments) Ignored in this function.}
}
\value{
zoo object
}
\description{
Fits a polynomial linear model on each column of a zoo object using time as a predictor, predicts the outcome, and subtracts it from the original data to return a detrended time series. This method is a useful alternative to \link{f_detrend_linear} when the overall trend of the time series does not follow a straight line.
}
\examples{
x <- zoo_simulate(cols = 2)

y <- f_detrend_poly(
  x = x
)

if(interactive()){
  zoo_plot(x)
  zoo_plot(y)
}
}
\seealso{
Other tsl_transformation: 
\code{\link{f_binary}()},
\code{\link{f_clr}()},
\code{\link{f_detrend_difference}()},
\code{\link{f_detrend_linear}()},
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
