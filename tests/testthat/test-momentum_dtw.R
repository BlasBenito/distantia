test_that("`momentum_dtw()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = distantia::albatross,
    name_column = "name", time_column = "time"
  ), f = f_scale_global)
  df <- momentum_dtw(tsl = tsl, distance = "euclidean")
  expect_equal(df[, c("x", "y", "variable", "importance", "effect")], )
})
