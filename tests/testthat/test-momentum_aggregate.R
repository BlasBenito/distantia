test_that("`momentum_aggregate()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  df <- momentum(
    tsl = tsl, distance = c("euclidean", "manhattan"),
    lock_step = TRUE
  )
  expect_equal(df[, c("x", "y", "distance", "importance")], )
  df <- momentum_aggregate(df = df, f = mean)
  expect_equal(df, )
})
