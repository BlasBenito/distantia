test_that("`tsl_stats()` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )

  df <- tsl_stats(tsl = tsl, lags = 3)

  expect_true(
    nrow(df) == 9
  )


  expect_true(
    ncol(df) == 17
  )

  expect_true(
    sum(is.na(df)) == 0
  )

  expect_true(
    all(
      colnames(df) %in% c("name", "variable", "NA_count", "min", "q1", "median", "q3", "max", "mean", "sd", "range", "iq_range", "skewness", "kurtosis", "ac_lag_1", "ac_lag_2", "ac_lag_3")
    )
  )

})
