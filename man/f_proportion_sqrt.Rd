% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformations.R
\name{f_proportion_sqrt}
\alias{f_proportion_sqrt}
\title{Data Transformation: Rowwise Square Root of Proportions}
\usage{
f_proportion_sqrt(x = NULL, ...)
}
\arguments{
\item{x}{(required, zoo object) Zoo time series object to transform.}

\item{...}{(optional, additional arguments) Ignored in this function.}
}
\value{
zoo object
}
\description{
Data Transformation: Rowwise Square Root of Proportions
}
\examples{
x <- zoo_simulate(cols = 2)

y <- f_proportion_sqrt(
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
\code{\link{f_detrend_poly}()},
\code{\link{f_hellinger}()},
\code{\link{f_list}()},
\code{\link{f_log}()},
\code{\link{f_percent}()},
\code{\link{f_proportion}()},
\code{\link{f_rescale_global}()},
\code{\link{f_rescale_local}()},
\code{\link{f_scale_global}()},
\code{\link{f_scale_local}()},
\code{\link{f_trend_linear}()},
\code{\link{f_trend_poly}()}
}
\concept{tsl_transformation}
