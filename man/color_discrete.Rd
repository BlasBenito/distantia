% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/color_discrete.R
\name{color_discrete}
\alias{color_discrete}
\title{Default Discrete Color Palettes}
\usage{
color_discrete(n = NULL, rev = FALSE)
}
\arguments{
\item{n}{(required, integer) number of colors to generate. Default = NULL}

\item{rev}{(optional, logical) If TRUE, the color palette is reversed. Default: FALSE}
}
\value{
color vector
}
\description{
Uses the function \code{\link[grDevices:palette]{grDevices::palette.colors()}} to generate discrete color palettes using the following rules:
\itemize{
\item \code{n <= 9}: "Okabe-Ito".
\item \code{n == 10}: "Tableau 10"
\item \code{n > 10 && n <= 12}: "Paired"
\item \code{n > 12 && n <= 26}: "Alphabet"
\item \code{n > 26 && n <= 36}: "Polychrome 36"
}
}
\examples{

color_discrete(n = 9)
}
\seealso{
Other internal_plotting: 
\code{\link{color_continuous}()},
\code{\link{utils_color_breaks}()},
\code{\link{utils_line_color}()},
\code{\link{utils_line_guide}()},
\code{\link{utils_matrix_guide}()},
\code{\link{utils_matrix_plot}()}
}
\concept{internal_plotting}
