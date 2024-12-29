test_that("`tsl_resample()` works", {
  tsl <- tsl_simulate(n = 2, rows = 100, irregular = TRUE)
  expect_equal(if (interactive()) {
    tsl_plot(tsl)
  }, )
  expect_equal(tsl_time_summary(tsl)[c("units", "resolution_min", "resolution_max")], )
  tsl_regular <- tsl_resample(tsl = tsl)
  expect_equal(if (interactive()) {
    tsl_plot(tsl_regular)
  }, )
  expect_equal(tsl_time_summary(tsl_regular)[c("units", "resolution_min", "resolution_max")], )
  expect_equal(tsl_time_summary(tsl = tsl, keywords = "resample")$keywords, )
  tsl_months <- tsl_resample(tsl = tsl, new_time = "months")
  expect_equal(if (interactive()) {
    tsl_plot(tsl_months)
  }, )
  tsl_weeks <- tsl_resample(tsl = tsl, new_time = "weeks")
  expect_equal(if (interactive()) {
    tsl_plot(tsl_weeks)
  }, )
  expect_equal(tsl_time(tsl)$units, )
  tsl_15_days <- tsl_resample(tsl = tsl, new_time = 15)
  expect_equal(tsl_time_summary(tsl_15_days)[c("units", "resolution_min", "resolution_max")], )
  expect_equal(if (interactive()) {
    tsl_plot(tsl_15_days)
  }, )
  tsl1 <- tsl_simulate(n = 2, rows = 80, time_range = c(
    "2010-01-01",
    "2020-01-01"
  ), irregular = TRUE)
  tsl2 <- tsl_simulate(n = 2, rows = 120, time_range = c(
    "2005-01-01",
    "2024-01-01"
  ), irregular = TRUE)
  expect_equal(tsl_time_summary(tsl1)[c("begin", "end", "resolution_min", "resolution_max")], )
  expect_equal(tsl_time_summary(tsl2)[c("begin", "end", "resolution_min", "resolution_max")], )
  tsl1_regular <- tsl_resample(tsl = tsl1)
  tsl2_regular <- tsl_resample(tsl = tsl2, new_time = tsl1_regular)
  expect_equal(tsl_time_summary(tsl1_regular)[c(
    "begin", "end", "resolution_min",
    "resolution_max"
  )], )
  expect_equal(tsl_time_summary(tsl2_regular)[c(
    "begin", "end", "resolution_min",
    "resolution_max"
  )], )
})
