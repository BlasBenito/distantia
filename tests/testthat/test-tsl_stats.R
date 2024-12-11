test_that("`tsl_stats()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  df <- tsl_stats(tsl = tsl, lags = 3)
  expect_equal(df, )
  expect_equal(future::plan(future::sequential), )
})
