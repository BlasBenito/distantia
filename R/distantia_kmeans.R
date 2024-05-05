distantia_kmeans <- function(
    distantia_df = NULL,
    centers = 2
){

  df_list <- utils_distantia_df_split(
    distantia_df = distantia_df
  )

  if(length(df_list) > 1){

    message(
      "There are ",
      length(df_list),
      "  combinations of arguments in 'distantia_df'. Applying distantia_aggregate(..., f = mean) to combine them into a single one."
      )

    distantia_df <- distantia_aggregate(
      distantia_df = distantia_df,
      f = mean
    )

  }

  d <- distantia_matrix(
    distantia_df = distantia_df
  )[[1]]

  k <- stats::kmeans(
    x = d,
    centers = centers
  )

  k_silhouette <- cluster_silhouette(
    cluster = k,
    distance_matrix = d,
    median = FALSE
  )

  k_plot <- factoextra::fviz_cluster(
    object = k,
    data = d,
    repel = TRUE
  )

  #TODO

}
