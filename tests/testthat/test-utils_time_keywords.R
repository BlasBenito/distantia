test_that("`utils_time_keywords()` works", {

  tsl <- tsl_simulate(time_range = c(Sys.time() - 60, Sys.time()),
                      seed = 1)

  expect_equal(utils_time_keywords(tsl = tsl), "seconds")

  tsl <- tsl_simulate(time_range = c(Sys.time() - 600, Sys.time()),
                      seed = 1)
  expect_equal(utils_time_keywords(tsl = tsl), c("minutes", "seconds"))

  tsl <- tsl_simulate(time_range = c(Sys.time() - 6000, Sys.time()),
                      seed = 1)
  expect_equal(utils_time_keywords(tsl = tsl), c("hours", "minutes", "seconds"))

  tsl <- tsl_simulate(time_range = c(Sys.Date() - 10, Sys.Date()),
                      seed = 1)
  expect_equal(utils_time_keywords(tsl = tsl), c("weeks", "days"))

  tsl <- tsl_simulate(time_range = c(Sys.Date() - 3650, Sys.Date()),
                      seed = 1)
  expect_true(all(utils_time_keywords(tsl = tsl) %in% c("years", "quarters", "months", "weeks", "decades")))
})
