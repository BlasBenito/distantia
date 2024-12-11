test_that("`distantia_cluster_hclust()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_initialize(
    x = covid_prevalence, name_column = "name",
    time_column = "time"
  )
  tsl <- tsl_subset(tsl = tsl, names = 1:10)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl[1:3], guide_columns = 3)
  }, )
  distantia_df <- distantia(tsl = tsl, lock_step = TRUE)
  distantia_clust <- distantia_cluster_hclust(
    df = distantia_df,
    clusters = NULL, method = NULL
  )
  expect_equal(names(distantia_clust), )
  expect_equal(distantia_clust$cluster_object, )
  expect_equal(distantia_clust$d, )
  expect_equal(distantia_clust$clusters, )
  expect_equal(distantia_clust$df, )
  expect_equal(distantia_clust$silhouette_width, )
  if (interactive()) {
    dev.off()
    clust <- distantia_clust$cluster_object
    k <- distantia_clust$clusters
    plot(x = clust, hang = -1)
    stats::rect.hclust(tree = clust, k = k, cluster = stats::cutree(
      tree = clust,
      k = k
    ))
  }
  expect_equal(future::plan(future::sequential), )
})
