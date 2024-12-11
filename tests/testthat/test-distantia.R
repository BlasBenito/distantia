test_that("`distantia()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  df_dtw <- distantia(
    tsl = tsl, distance = "euclidean", repetitions = 10,
    permutation = "restricted_by_row", block_size = 6, seed = 1
  )
  expect_equal(df_dtw[, c("x", "y", "psi", "p_value")], )
  expect_equal(if (interactive()) {
    distantia_plot(
      tsl = tsl[c("Spain", "Sweden")], distance = "euclidean",
      matrix_type = "cost"
    )
  }, )
  psi_null <- null_psi_dynamic_time_warping_cpp(
    x = tsl[["Spain"]],
    y = tsl[["Sweden"]], repetitions = 10, distance = "euclidean",
    permutation = "restricted_by_row", block_size = 6, seed = 1
  )
  expect_equal(mean(psi_null), )
  expect_equal(df_dtw$null_mean[3], )
  expect_equal(future::plan(future::sequential), )
})
