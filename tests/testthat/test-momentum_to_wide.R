test_that("`momentum_to_wide()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = distantia::albatross,
    name_column = "name", time_column = "time"
  ), f = f_scale_global)
  df <- momentum(tsl = tsl)
  expect_equal(df, )
  df_wide <- momentum_to_wide(df = df)
  expect_equal(df_wide, )
})
