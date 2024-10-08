% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/distantia_matrix.R
\name{distantia_matrix}
\alias{distantia_matrix}
\title{Convert Dissimilarity Analysis Data Frame to Distance Matrix}
\usage{
distantia_matrix(df = NULL)
}
\arguments{
\item{df}{(required, data frame) Output of \code{\link[=distantia]{distantia()}} or \code{\link[=distantia_aggregate]{distantia_aggregate()}}. Default: NULL}
}
\value{
numeric matrix
}
\description{
Transforms a data frame resulting from \code{\link[=distantia]{distantia()}} into a dissimilarity matrix.
}
\examples{
#daily covid prevalence in California counties
data("covid_prevalence")

#load as tsl and aggregate to monthly data to accelerate example execution
tsl <- tsl_initialize(
  x = covid_prevalence,
  id_column = "county",
  time_column = "date"
) |>
  tsl_aggregate(
    new_time = "months",
    fun = sum
  )

if(interactive()){
  #plotting first three time series
  tsl_plot(
    tsl = tsl[1:3],
    guide_columns = 3
    )
}

#dissimilarity analysis
#single combination of arguments
#-------------------------------
distantia_df <- distantia(
  tsl = tsl,
  lock_step = TRUE
)

#to dissimilarity matrix
psi_matrix <- distantia_matrix(
  df = distantia_df
)

#returns a list of matrices
class(psi_matrix)
length(psi_matrix)

#only one matrix for this case
class(psi_matrix[[1]])

#plot matrix
if(interactive()){
  utils_matrix_plot(
    m = psi_matrix
    )
}


#dissimilarity analysis
#two combinations of arguments
#-------------------------------
distantia_df <- distantia(
  tsl = tsl,
  lock_step = c(TRUE, FALSE)
)

#to dissimilarity matrix
psi_matrix <- distantia_matrix(
  df = distantia_df
)

#returns a list of matrices
lapply(
  X = psi_matrix,
  FUN = class
  )

#these matrices have attributes tracing how they were generated
lapply(
  X = psi_matrix,
  FUN = \(x) attributes(x)$distantia_args
)

#plot matrix
if(interactive()){

  #plot first matrix (default behavior of utils_matrix_plot())
  utils_matrix_plot(
    m = psi_matrix[[1]]
  )

  #plot second matrix
  utils_matrix_plot(
    m = psi_matrix[[2]]
  )

}
}
\seealso{
Other dissimilarity_analysis: 
\code{\link{distantia}()},
\code{\link{distantia_aggregate}()},
\code{\link{distantia_boxplot}()},
\code{\link{distantia_cluster_hclust}()},
\code{\link{distantia_cluster_kmeans}()},
\code{\link{distantia_importance}()},
\code{\link{distantia_plot}()},
\code{\link{distantia_to_sf}()}
}
\concept{dissimilarity_analysis}
