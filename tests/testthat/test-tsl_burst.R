test_that("`tsl_burst()` works", {
  tsl <- tsl_simulate(
    n = 2, time_range = c("2010-01-01", "2024-12-31"),
    cols = 3
  )
  expect_equal(tsl_names_get(tsl), )
  expect_equal(tsl_colnames_get(tsl), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  tsl <- tsl_burst(tsl)
  expect_equal(tsl_names_get(tsl), )
  expect_equal(tsl_colnames_get(tsl), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
})
