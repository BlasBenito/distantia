test_that("`momentum_stats()` works", {
  tsl <- tsl_simulate(n = 5, irregular = FALSE)
  df <- distantia(tsl = tsl, lock_step = TRUE)
  df_stats <- distantia_stats(df = df)
  expect_equal(df_stats, )
})
