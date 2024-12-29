test_that("`momentum()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = distantia::albatross,
    name_column = "name", time_column = "time"
  ), f = f_scale_global)
  df <- momentum(tsl = tsl, lock_step = TRUE)
  expect_equal(df[, c("x", "y", "variable", "importance", "effect")], )
})
