test_that("`tsl_stats()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  df <- tsl_stats(tsl = tsl, lags = 3)
  expect_equal(df, )
})
