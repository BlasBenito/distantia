test_that("`utils_cluster_silhouette()`, `utils_cluster_hclust_optimizer()` and `utils_cluster_kmeans_optimizer()` works", {

  tsl <- tsl_aggregate(
    tsl_subset(tsl_initialize(
      x = covid_prevalence,
      name_column = "name", time_column = "time"
    ), names = 1:10),
    new_time = "months", fun = max
  )

  psi_matrix <- distantia_matrix(distantia(tsl = tsl, lock_step = TRUE))
  hclust_optimization <- utils_cluster_hclust_optimizer(d = psi_matrix)

  expect_equal(class(hclust_optimization), "data.frame")
  expect_equal(colnames(hclust_optimization), c("clusters", "method", "silhouette_mean"))

  psi_hclust <- stats::hclust(d = as.dist(psi_matrix[[1]]))
  psi_hclust_labels <- stats::cutree(tree = psi_hclust, k = 3, )
  expect_equal(colnames(utils_cluster_silhouette(labels = psi_hclust_labels, d = psi_matrix)), c("name", "cluster", "silhouette_width"))

  kmeans_optimization <- utils_cluster_kmeans_optimizer(d = psi_matrix)

  expect_equal(class(kmeans_optimization), "data.frame")
  expect_equal(colnames(kmeans_optimization), c("clusters", "silhouette_mean"))

  psi_kmeans <- stats::kmeans(x = as.dist(psi_matrix[[1]]), centers = 3)
  expect_equal(colnames(utils_cluster_silhouette(labels = psi_kmeans$cluster, d = psi_matrix)), c("name", "cluster", "silhouette_width"))

})
