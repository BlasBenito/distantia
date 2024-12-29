test_that("`tsl_initialize()` works", {
  expect_equal(data("fagus_dynamics"), )
  expect_equal(str(fagus_dynamics), )
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  expect_equal(tsl_diagnose(tsl), )
  expect_equal(lapply(X = tsl, FUN = class), )
  expect_equal(tsl_names_get(tsl = tsl, zoo = TRUE), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  x <- zoo_simulate()
  y <- zoo_simulate()
  tsl <- tsl_initialize(x = list(x = x, y = y))
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  df <- stats::reshape(
    data = fagus_dynamics[, c(
      "name", "time",
      "evi"
    )], timevar = "name", idvar = "time", direction = "wide",
    sep = "_"
  )
  expect_equal(str(df), )
  tsl <- tsl_initialize(x = df, time_column = "time")
  expect_equal(tsl_colnames_get(tsl), )
  tsl <- tsl_colnames_set(tsl = tsl, names = "evi")
  expect_equal(tsl_colnames_get(tsl), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  vector_list <- list(
    a = cumsum(stats::rnorm(n = 50)), b = cumsum(stats::rnorm(n = 70)),
    c = cumsum(stats::rnorm(n = 20))
  )
  tsl <- tsl_initialize(x = vector_list)
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  matrix_list <- list(
    a = matrix(runif(30), nrow = 10, ncol = 3),
    b = matrix(runif(80), nrow = 20, ncol = 4)
  )
  tsl <- tsl_initialize(x = matrix_list)
  expect_equal(tsl_colnames_get(tsl = tsl), )
  tsl <- tsl_subset(tsl = tsl, shared_cols = TRUE)
  expect_equal(tsl_colnames_get(tsl = tsl), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  zoo_list <- list(a = zoo_simulate(), b = zoo_simulate())
  expect_equal(tsl_diagnose(tsl = zoo_list), )
  zoo_list <- tsl_names_set(tsl = zoo_list)
  expect_equal(tsl_diagnose(tsl = zoo_list), )
  tsl <- tsl_initialize(x = list(a = zoo_simulate(), b = zoo_simulate()))
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
})
