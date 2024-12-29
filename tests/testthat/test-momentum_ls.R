test_that("`momentum_ls()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = distantia::albatross,
    name_column = "name", time_column = "time"
  ), f = f_scale_global)
  df <- momentum_ls(tsl = tsl, distance = "euclidean")
  expect_equal(df[, c("x", "y", "variable", "importance", "effect")], )
})
