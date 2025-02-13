#' Optimize the Silhouette Width of Hierarchical Clustering Solutions
#'
#' @description
#' Performs a parallelized grid search to find the number of clusters maximizing the overall silhouette width of the clustering solution (see [utils_cluster_silhouette()]). When `method = NULL`, the optimization also includes all methods available in [stats::hclust()] in the grid search. This function supports parallelization via [future::plan()] and a progress bar generated by the `progressr` package (see Examples).
#'
#'
#' @param d (required, matrix) distance matrix typically resulting from [distantia_matrix()], but any other square matrix should work. Default: NULL
#' @param method (optional, character string) Argument of [stats::hclust()] defining the agglomerative method. One of: "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC). Unambiguous abbreviations are accepted as well.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#'
#' #weekly covid prevalence
#' #in 10 California counties
#' #aggregated by month
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_subset(
#'     names = 1:10
#'   ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     fun = max
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
#' hclust_optimization <- utils_cluster_hclust_optimizer(
#'   d = psi_matrix
#' )
#'
#' #best solution in first row
#' head(hclust_optimization)
#' 
#' @family distantia_support
utils_cluster_hclust_optimizer <- function(
    d = NULL,
    method = NULL
){

  if(is.list(d)){
    d <- d[[1]]
  }

  if(!is.matrix(d)){
    stop("distantia::utils_cluster_hclust_optimizer(): argument 'd' must be a matrix.", call. = FALSE)
  }

  if(nrow(d) != ncol(d)){
    stop("distantia::utils_cluster_hclust_optimizer(): argument 'd' must be a square distance matrix.", call. = FALSE)
  }

  d_dist <- stats::as.dist(d)

  clusters_vector <- seq(
    from = 2,
    to = nrow(d),
    by = 1
  )

  if(is.null(method)){
    methods_vector <- c(
      "ward.D",
      "ward.D2",
      "single",
      "complete",
      "average",
      "mcquitty",
      "median",
      "centroid"
    )
  } else {
    methods_vector <- method
  }

  df <- expand.grid(
    clusters = clusters_vector,
    method = methods_vector,
    stringsAsFactors = FALSE
  )
  df$silhouette_mean <- NA



  #clustering methods
  hc_methods <- foreach::foreach(
    i = methods_vector
  ) %dofuture% {

    tryCatch({
      stats::hclust(
        d = d_dist,
        method = i
      )
    }, error = function(e) {
      NA
    })

  }

  names(hc_methods) <- methods_vector
  hc_methods <- stats::na.omit(hc_methods)

  #clustering groups
  df <- df[
    df$method %in% names(hc_methods),
  ]

  #iterations
  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  #parallelized optimization
  df$silhouette_mean <- foreach::foreach(
    i = iterations,
    .combine = "c"
  ) %dofuture% {

    # p()

    k_groups <- tryCatch({
      stats::cutree(
        tree = hc_methods[[df[i, "method"]]],
        k = df[i, "clusters"],
      )
    }, error = function(e) {
      NA
    })

    if(!is.integer(k_groups)){
      return(NA)
    }

    k_sil <- tryCatch({
      utils_cluster_silhouette(
        labels = k_groups,
        d = d,
        mean = TRUE
      )
    }, error = function(e) {
      NA
    })

    k_sil

  }

  df <- df[order(-df$silhouette_mean), ]

  rownames(df) <- NULL

  df

}
