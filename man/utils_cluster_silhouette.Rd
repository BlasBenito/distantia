% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_cluster_silhouette.R
\name{utils_cluster_silhouette}
\alias{utils_cluster_silhouette}
\title{Compute Silhouette Width of a Clustering Solution}
\usage{
utils_cluster_silhouette(labels = NULL, d = NULL, mean = FALSE)
}
\arguments{
\item{labels}{(required, integer vector) Labels resulting from a clustering algorithm applied to \code{d}. Must have the same length as columns and rows in \code{d}. Default: NULL}

\item{d}{(required, matrix) distance matrix typically resulting from \code{\link[=distantia_matrix]{distantia_matrix()}}, but any other square matrix should work. Default: NULL}

\item{mean}{(optional, logical) If TRUE, the mean of the silhouette widths is returned. Default: FALSE}
}
\value{
data frame
}
\description{
The silhouette width is a measure of how similar an object is to its own cluster (cohesion) compared to other clusters (separation).

There are some general guidelines to interpret the  individual silhouette widths of the clustered objects (as returned by this function when \code{mean = FALSE}):

\itemize{
\item Close to 1: object is well matched to its own cluster and poorly matched to neighboring clusters.
\item Close to 0: the object is between two neighboring clusters.
\item Close to -1: the object is likely to be assigned to the wrong cluster
}

When \code{mean = TRUE}, the overall mean of the silhouette widths of all objects is returned. These values should be interpreted as follows:

\itemize{
\item Higher than 0.7: robust clustering .
\item Higher than 0.5: reasonable clustering.
\item Higher than 0.25: weak clustering.

}

This metric may not perform well when the clusters have irregular shapes or sizes.

This code was adapted from \url{https://svn.r-project.org/R-packages/trunk/cluster/R/silhouette.R}.
}
\examples{
#weekly covid prevalence in three California counties
#load as tsl
#subset first 10 time series
#sum by month
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
) |>
  tsl_subset(
    names = 1:10
  ) |>
  tsl_aggregate(
    new_time = "months",
    method = max
  )

#compute dissimilarity
distantia_df <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

#generate dissimilarity matrix
psi_matrix <- distantia_matrix(
  df = distantia_df
)

#example with kmeans clustering
#------------------------------------

#kmeans with 3 groups
psi_kmeans <- stats::kmeans(
  x = as.dist(psi_matrix[[1]]),
  centers = 3
)

#case-wise silhouette width
utils_cluster_silhouette(
  labels = psi_kmeans$cluster,
  d = psi_matrix
)

#overall silhouette width
utils_cluster_silhouette(
  labels = psi_kmeans$cluster,
  d = psi_matrix,
  mean = TRUE
)


#example with hierarchical clustering
#------------------------------------

#hierarchical clustering
psi_hclust <- stats::hclust(
  d = as.dist(psi_matrix[[1]])
)

#generate labels for three groups
psi_hclust_labels <- stats::cutree(
  tree = psi_hclust,
  k = 3,
)

#case-wise silhouette width
utils_cluster_silhouette(
  labels = psi_hclust_labels,
  d = psi_matrix
)

#overall silhouette width
utils_cluster_silhouette(
  labels = psi_hclust_labels,
  d = psi_matrix,
  mean = TRUE
)
}
\seealso{
Other distantia_support: 
\code{\link{distantia_aggregate}()},
\code{\link{distantia_boxplot}()},
\code{\link{distantia_cluster_hclust}()},
\code{\link{distantia_cluster_kmeans}()},
\code{\link{distantia_matrix}()},
\code{\link{distantia_model_frame}()},
\code{\link{distantia_spatial}()},
\code{\link{distantia_stats}()},
\code{\link{distantia_time_delay}()},
\code{\link{utils_block_size}()},
\code{\link{utils_cluster_hclust_optimizer}()},
\code{\link{utils_cluster_kmeans_optimizer}()}
}
\concept{distantia_support}
