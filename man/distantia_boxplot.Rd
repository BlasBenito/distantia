% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distantia_boxplot.R
\name{distantia_boxplot}
\alias{distantia_boxplot}
\title{Boxplot of Dissimilarity Analysis Data Frames}
\usage{
distantia_boxplot(df = NULL, color = NULL, f = median, ...)
}
\arguments{
\item{df}{(required, data frame) output of \code{\link[=distantia]{distantia()}} or \code{\link[=distantia_importance]{distantia_importance()}}. Default: NULL}

\item{color}{(optional, character vector) boxplot fill color. Default: NULL}

\item{f}{(optional, function) function used to arrange the boxes. Can be one of \code{mean}, \code{median}, \code{min}, \code{max}, or \code{quantile}. Default: \code{median}.}

\item{...}{(optional, additional arguments to \code{f}). If \code{f} is \code{quantile}, \code{probs = 0.75} can be used. Default: ...}
}
\value{
boxplot
}
\description{
This function generates a visual summary of the dissimilarity or importance scores generated by the functions \code{\link[=distantia]{distantia()}} and \code{\link[=distantia_importance]{distantia_importance()}}.

\itemize{
\item \code{\link[=distantia]{distantia()}} data frame: plots the distribution of the Psi values of each time series against all others. This facilitates the identification of time series that are more or less similar to all others.
\item \code{\link[=distantia_importance]{distantia_importance()}} data frame: plots the importance (contribution to similarity/dissimilarity) of each variable across all time series, facilitating the identification of variables making time series more or less similar.

}

In any case, if the argument \code{df} contains more than one combination of input parameters, then \code{\link[=distantia_aggregate]{distantia_aggregate()}} is used to summarize dissimilarity scores across groups.
}
\examples{
#three time series
#climate and ndvi in Fagus sylvatica stands
#in Spain, Germany, and Sweden
#centerd and scaled with global parameters
tsl <- tsl_initialize(
  x = fagus_dynamics,
  id_column = "site",
  time_column = "date"
) |>
  tsl_transform(
    f = f_scale
  )

if(interactive()){
  tsl_plot(
    tsl = tsl,
    guide_columns = 3
    )
}

# example with distantia()
#-----------------------------------
distantia_df <- distantia(
  tsl = tsl
)

if(interactive()){
  boxplot_stats <- distantia_boxplot(
    df = distantia_df
    )
    boxplot_stats
}

#The boxplot identifies Spain
#as the site most dissimilar to all others,
#and Germany as the most similar to all others.


#example with distantia_importance()
#-----------------------------------
importance_df <- distantia_importance(
  tsl = tsl
)

if(interactive()){
  boxplot_stats <- distantia_boxplot(
    df = distantia_df
    )
}

#the boxplot identifies the variable evi
#(enhanced vegetation index) as the one
#contributing the most to site dissimilarity,
#and termpature as the variable contributing
#the most to site similarity.
}
\seealso{
Other dissimilarity_analysis: 
\code{\link{distantia}()},
\code{\link{distantia_aggregate}()},
\code{\link{distantia_cluster_hclust}()},
\code{\link{distantia_cluster_kmeans}()},
\code{\link{distantia_importance}()},
\code{\link{distantia_matrix}()},
\code{\link{distantia_plot}()},
\code{\link{distantia_to_sf}()}
}
\concept{dissimilarity_analysis}
