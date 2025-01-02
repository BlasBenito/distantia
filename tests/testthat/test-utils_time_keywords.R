test_that("`utils_time_keywords()` works", {

  tsl <- tsl_simulate(time_range = c(Sys.time() - 60, Sys.time()))
  expect_equal(utils_time_keywords(tsl = tsl), "seconds")

  tsl <- tsl_simulate(time_range = c(Sys.time() - 600, Sys.time()))
  expect_equal(utils_time_keywords(tsl = tsl), c("minutes", "seconds"))

  tsl <- tsl_simulate(time_range = c(Sys.time() - 6000, Sys.time()))
  expect_equal(utils_time_keywords(tsl = tsl), c("hours", "minutes", "seconds"))

  tsl <- tsl_simulate(time_range = c(Sys.Date() - 10, Sys.Date()))
  expect_equal(utils_time_keywords(tsl = tsl), c("weeks", "days"))

  tsl <- tsl_simulate(time_range = c(Sys.Date() - 3650, Sys.Date()))
  expect_equal(utils_time_keywords(tsl = tsl), c("years", "quarters", "months", "weeks", "decades"))
})
