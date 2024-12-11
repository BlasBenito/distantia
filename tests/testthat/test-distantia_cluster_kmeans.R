test_that("`distantia_cluster_kmeans()` works", {
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
  distantia_kmeans <- distantia_cluster_kmeans(
    df = distantia_df,
    clusters = NULL
  )
  expect_equal(names(distantia_kmeans), )
  expect_equal(distantia_kmeans$cluster_object, )
  expect_equal(distantia_kmeans$d, )
  expect_equal(distantia_kmeans$clusters, )
  expect_equal(distantia_kmeans$df, )
  expect_equal(distantia_kmeans$silhouette_width, )
  expect_equal(future::plan(future::sequential), )
})
