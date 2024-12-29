test_that("`tsl_time()` works", {
  tsl <- tsl_simulate(n = 3, rows = 150, time_range = c(Sys.Date() -
    365, Sys.Date()), irregular = TRUE)
  expect_equal(tsl_time(tsl = tsl), )
  expect_equal(tsl_time_summary(tsl = tsl), )
})
