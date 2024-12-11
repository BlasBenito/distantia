test_that("`utils_cluster_kmeans_optimizer()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_aggregate(
    tsl_subset(tsl_initialize(
      x = covid_prevalence,
      name_column = "name", time_column = "time"
    ), names = 1:10),
    new_time = "months", fun = max
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_subset(tsl = tsl, names = 1:3), guide_columns = 3)
  }, )
  psi_matrix <- distantia_matrix(distantia(tsl = tsl, lock_step = TRUE))
  kmeans_optimization <- utils_cluster_kmeans_optimizer(d = psi_matrix)
  expect_equal(head(kmeans_optimization), )
  expect_equal(future::plan(future::sequential), )
})
