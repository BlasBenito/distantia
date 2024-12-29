test_that("`momentum_boxplot()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = distantia::albatross,
    name_column = "name", time_column = "time"
  ), f = f_scale_global)
  df <- momentum(tsl = tsl, lock_step = TRUE)
  expect_equal(momentum_boxplot(df = df), )
})
