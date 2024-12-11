test_that("`utils_distantia_df_to_matrix()` works", {
  tsl <- tsl_simulate(n = 3, time_range = c(
    "2010-01-01 12:00:25",
    "2024-12-31 11:15:45"
  ))
  df <- distantia(tsl = tsl)
  m <- utils_distantia_df_to_matrix(df = df)
  expect_equal(m, )
})
