test_that("`distantia_stats()` works", {

  n <- 5

  tsl <- tsl_simulate(n = n, irregular = FALSE)

  df <- distantia(tsl = tsl, lock_step = TRUE)

  df_stats <- distantia_stats(df = df)

  expect_equal(nrow(df_stats), n)

  expect_true(all(colnames(df_stats) %in% c("name", "mean", "min", "q1", "median", "q3", "max", "sd", "range")))

})
