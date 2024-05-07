#' Kmeans Clustering of a Distantia Data Frame
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param clusters (required, integer) Number of groups to generate. If NULL (default), a kmeans clustering with the number of groups having the highest median silhouette width is returned (see [cluster_silhouette()]). Default: NULL
#' @param output (required, character string) Options are:
#' \itemize{
#'   \item "df": data frame with the columns "time_series", "cluster" and "silhouette_width" (see [cluster_silhouette()]).
#'   \item "kmeans": object resulting from [stats::kmeans()]. This list includes the objects "silhouette_df" and "silhouette_median", both resulting from [cluster_silhouette()].
#'   \item "plot": clusters plot.
#'
#' }
#' If "df", the argument 'df' with the columns "time_series", "cluster" and "silhouette_width" is returned. If "kmeans", then the kmeans clustering object is returned instead. Default: "kmeans"
#' @param seed (optional, integer) Random seed to be used during the K-means computation. Default: 1
#' @return Object of class "kmeans" or "data.frame".
#' @export
#' @autoglobal
#' @seealso [stats::kmeans()]
#' @examples
distantia_kmeans <- function(
    df = NULL,
    clusters = NULL,
    output = c("kmeans", "df", "plot"),
    seed = 1
){

  output <- match.arg(
    arg = output,
    choices = c("kmeans", "df", "plot"),
    several.ok = FALSE
  )

  df_list <- utils_distantia_df_split(
    df = df
  )

  if(length(df_list) > 1){

    message(
      "There are ",
      length(df_list),
      "  combinations of arguments in 'df'. Applying distantia_aggregate(..., f = mean) to combine them into a single one."
      )

    df <- distantia_aggregate(
      df = df,
      f = mean
    )

  }

  d <- distantia_matrix(
    df = df
  )[[1]]

  #optimize kmeans
  if(is.null(clusters)){

    p <- progressr::progressor(along = groups_vector)

    #to silence loading messages
    `%iterator%` <- doFuture::`%dofuture%` |>
      suppressMessages()

    my_foreach <- foreach::foreach |>
      suppressMessages()

    groups_silhouette <- my_foreach(
      i = seq(
        from = 2,
        to = nrow(d) - 1,
        by = 1
      ),
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

      cluster_silhouette(
        cluster = k,
        distance_matrix = d,
        median = TRUE
      )

    }

    #add first element to reset index
    groups_silhouette <- c(0, groups_silhouette)

    clusters <- which.max(groups_silhouette)

  }

  if(clusters < 2){
    clusters <- 2
  }
  if(clusters >= nrow(d)){
    clusters <- nrow(d) - 1
  }

  set.seed(seed)

  k <- stats::kmeans(
    x = d,
    centers = clusters,
    algorithm = "Hartigan-Wong",
    nstart = nrow(df)
  )

  k_silhouette <- cluster_silhouette(
    cluster = k,
    distance_matrix = d,
    median = FALSE
  )

  #TODO: create own version of this
  k_plot <- factoextra::fviz_cluster(
    object = k,
    data = d,
    repel = TRUE
  )

  k$silhouette_df <- k_silhouette
  k$silhouette_median <- median(k_silhouette$silhouette_width)

  if(output == "df"){
    k <- k$silhouette_df
  }

  if(output == "plot"){
    k <- k_plot
    print(k_plot)
  }

  k

}
