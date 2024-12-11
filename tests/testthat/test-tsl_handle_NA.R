test_that("`tsl_handle_NA()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_simulate(na_fraction = 0.25)
  expect_equal(tsl_count_NA(tsl = tsl), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
  expect_equal(tsl_nrow(tsl = tsl), )
  tsl_no_na <- tsl_handle_NA(tsl = tsl, na_action = "omit")
  expect_equal(tsl_nrow(tsl = tsl_no_na), )
  expect_equal(tsl_count_NA(tsl = tsl_no_na), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_no_na)
  }, )
  tsl_no_na <- tsl_handle_NA(tsl = tsl, na_action = "impute")
  expect_equal(tsl_nrow(tsl = tsl_no_na), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_no_na)
  }, )
  expect_equal(future::plan(future::sequential), )
})
