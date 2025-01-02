test_that("`tsl_to_df()` works", {
  tsl <- tsl_simulate(n = 3, rows = 10, time_range = c(
    "2010-01-01",
    "2020-01-01"
  ), irregular = FALSE,
  seed = 1)
  df <- tsl_to_df(tsl = tsl)
  expect_equal(class(df), "data.frame")
  expect_true(all(unique(unlist(tsl_colnames_get(tsl))) %in% colnames(df)))
  expect_equal(nrow(df), sum(unlist(tsl_nrow(tsl = tsl))))

})
