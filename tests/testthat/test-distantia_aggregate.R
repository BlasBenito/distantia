test_that("`distantia_aggregate()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  df_multiple <- distantia(tsl = tsl, distance = "euclidean", lock_step = c(
    TRUE,
    FALSE
  ))
  expect_equal(df_multiple[, c("x", "y", "distance", "lock_step", "psi")], )
  df <- distantia_aggregate(df = df_multiple, f = mean)
  expect_equal(df, )
})
