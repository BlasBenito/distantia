#' Optimize the Silhouette Width of K-Means Clustering Solutions
#'
#' @description
#' Generates k-means solutions from 2 to `nrow(d) - 1` number of clusters and returns the number of clusters with a higher silhouette width median. See [utils_cluster_silhouette()] for more details.
#'
#'
#' @param d (required, matrix) distance matrix typically resulting from [distantia_matrix()], but any other square matrix should work. Default: NULL
#' @param seed (optional, integer) Random seed to be used during the K-means computation. Default: 1
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' #parallelization and progress bar
#' #for large datasets, parallelization accelerates cluster optimization
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableWorkers() - 1
#' )
#'
#' #progress bar
#' # progressr::handlers(global = TRUE)
#'
#' #daily covid prevalence
#' #in 10 California counties
#' #aggregated by month
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   id_column = "county",
#'   time_column = "date"
#' ) |>
#'   tsl_subset(
#'     names = 1:10
#'   ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     fun = sum
#'   )
#'
#' if(interactive()){
#'   #plotting first three time series
#'   tsl_plot(
#'     tsl = tsl_subset(
#'       tsl = tsl,
#'       names = 1:3
#'     ),
#'     guide_columns = 3
#'   )
#' }
#'
#' #compute dissimilarity matrix
#' psi_matrix <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#' ) |>
#'   distantia_matrix()
#'
#' #optimize hierarchical clustering
#' kmeans_optimization <- utils_cluster_kmeans_optimizer(
#'   d = psi_matrix
#' )
#'
#' #best solution in first row
#' head(kmeans_optimization)
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family internal_dissimilarity_analysis
utils_cluster_kmeans_optimizer <- function(
    d = NULL,
    seed = 1
    ){

  if(is.list(d)){
    d <- d[[1]]
  }

  if(!is.matrix(d)){
    stop("Argument 'd' must be a matrix.")
  }

  if(nrow(d) != ncol(d)){
    stop("Argument 'd' must be a square distance matrix")
  }

  clusters_vector <- seq(
    from = 2,
    to = nrow(d) - 1,
    by = 1
  )

  p <- progressr::progressor(along = clusters_vector)

  `%iterator%` <- doFuture::`%dofuture%`

  sil <- foreach::foreach(
    i = clusters_vector,
    .combine = "c",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    set.seed(seed)

    k <- stats::kmeans(
      x = d,
      centers = i,
      algorithm = "Hartigan-Wong",
      nstart = nrow(d)
    )

    utils_cluster_silhouette(
      labels = k$cluster,
      d = d,
      mean = TRUE
    )

  }

  if(is.vector(sil) == FALSE){

    stop("Function utils_cluster_kmeans_optimizer() failed. Error message was: '", paste0(sil$message), "'.")

  }

  optimization_df <- data.frame(
    clusters = clusters_vector,
    silhouette_mean = sil
  )

  optimization_df <- optimization_df[order(-optimization_df$silhouette_mean), ]

  rownames(optimization_df) <- NULL

  optimization_df

}
