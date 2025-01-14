% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distantia_cluster_kmeans.R
\name{distantia_cluster_kmeans}
\alias{distantia_cluster_kmeans}
\title{K-Means Clustering of Dissimilarity Analysis Data Frames}
\usage{
distantia_cluster_kmeans(df = NULL, clusters = NULL, seed = 1)
}
\arguments{
\item{df}{(required, data frame) Output of \code{\link[=distantia]{distantia()}}, \code{\link[=distantia_ls]{distantia_ls()}}, \code{\link[=distantia_dtw]{distantia_dtw()}}, or \code{\link[=distantia_time_delay]{distantia_time_delay()}}. Default: NULL}

\item{clusters}{(required, integer) Number of groups to generate. If NULL (default), \code{\link[=utils_cluster_kmeans_optimizer]{utils_cluster_kmeans_optimizer()}} is used to find the number of clusters that maximizes the mean silhouette width of the clustering solution (see \code{\link[=utils_cluster_silhouette]{utils_cluster_silhouette()}}). Default: NULL}

\item{seed}{(optional, integer) Random seed to be used during the K-means computation. Default: 1}
}
\value{
list:
\itemize{
\item \code{cluster_object}: kmeans object object for further analyses and custom plotting.
\item \code{clusters}: integer, number of clusters.
\item \code{silhouette_width}: mean silhouette width of the clustering solution.
\item \code{df}: data frame with time series names, their cluster label, and their individual silhouette width scores.
\item \code{d}: psi distance matrix used for clustering.
\item \code{optimization}: only if \code{clusters = NULL}, data frame with optimization results from \code{\link[=utils_cluster_hclust_optimizer]{utils_cluster_hclust_optimizer()}}.
}
}
\description{
This function combines the dissimilarity scores computed by \code{\link[=distantia]{distantia()}}, the K-means clustering method implemented in \code{\link[stats:kmeans]{stats::kmeans()}}, and the clustering optimization method implemented in \code{\link[=utils_cluster_hclust_optimizer]{utils_cluster_hclust_optimizer()}} to help group together time series with similar features.

When \code{clusters = NULL}, the function \code{\link[=utils_cluster_hclust_optimizer]{utils_cluster_hclust_optimizer()}} is run underneath to perform a parallelized grid search to find the  number of clusters maximizing the overall silhouette width of the clustering solution (see \code{\link[=utils_cluster_silhouette]{utils_cluster_silhouette()}}).

This function supports a parallelization setup via \code{\link[future:plan]{future::plan()}}, and progress bars provided by the package \href{https://CRAN.R-project.org/package=progressr}{progressr}.
}
\examples{

#weekly covid prevalence in California
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
)

#subset 10 elements to accelerate example execution
tsl <- tsl_subset(
  tsl = tsl,
  names = 1:10
)

if(interactive()){
  #plotting first three time series
  tsl_plot(
    tsl = tsl[1:3],
    guide_columns = 3
  )
}

#dissimilarity analysis
distantia_df <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

#hierarchical clustering
#automated number of clusters
distantia_kmeans <- distantia_cluster_kmeans(
  df = distantia_df,
  clusters = NULL
)

#names of the output object
names(distantia_kmeans)

#kmeans object
distantia_kmeans$cluster_object

#distance matrix used for clustering
distantia_kmeans$d

#number of clusters
distantia_kmeans$clusters

#clustering data frame
#group label in column "cluster"
distantia_kmeans$df

#mean silhouette width of the clustering solution
distantia_kmeans$silhouette_width

#kmeans plot
# factoextra::fviz_cluster(
#   object = distantia_kmeans$cluster_object,
#   data = distantia_kmeans$d,
#   repel = TRUE
# )
}
\seealso{
Other distantia_support: 
\code{\link{distantia_aggregate}()},
\code{\link{distantia_boxplot}()},
\code{\link{distantia_cluster_hclust}()},
\code{\link{distantia_matrix}()},
\code{\link{distantia_model_frame}()},
\code{\link{distantia_spatial}()},
\code{\link{distantia_stats}()},
\code{\link{distantia_time_delay}()},
\code{\link{utils_block_size}()},
\code{\link{utils_cluster_hclust_optimizer}()},
\code{\link{utils_cluster_kmeans_optimizer}()},
\code{\link{utils_cluster_silhouette}()}
}
\concept{distantia_support}
