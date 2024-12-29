test_that("`utils_cluster_silhouette()` works", {
  tsl <- tsl_aggregate(
    tsl_subset(tsl_initialize(
      x = covid_prevalence,
      name_column = "name", time_column = "time"
    ), names = 1:10),
    new_time = "months", method = max
  )
  distantia_df <- distantia(tsl = tsl, lock_step = TRUE)
  psi_matrix <- distantia_matrix(df = distantia_df)
  psi_kmeans <- stats::kmeans(x = as.dist(psi_matrix[[1]]), centers = 3)
  expect_equal(utils_cluster_silhouette(labels = psi_kmeans$cluster, d = psi_matrix), )
  expect_equal(utils_cluster_silhouette(
    labels = psi_kmeans$cluster, d = psi_matrix,
    mean = TRUE
  ), )
  psi_hclust <- stats::hclust(d = as.dist(psi_matrix[[1]]))
  psi_hclust_labels <- stats::cutree(tree = psi_hclust, k = 3, )
  expect_equal(utils_cluster_silhouette(labels = psi_hclust_labels, d = psi_matrix), )
  expect_equal(utils_cluster_silhouette(
    labels = psi_hclust_labels, d = psi_matrix,
    mean = TRUE
  ), )
})
