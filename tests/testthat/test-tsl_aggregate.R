test_that("`tsl_aggregate()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_initialize(
    x = cities_temperature, name_column = "name",
    time_column = "time"
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl[1:4], guide_columns = 4)
  }, )
  expect_equal(tsl_time(tsl)[, c("name", "resolution", "units")], )
  tsl_year <- tsl_aggregate(tsl = tsl, new_time = "year", f = mean)
  expect_equal(tsl_time(tsl_year)[, c("name", "resolution", "units")], )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_year[1:4], guide_columns = 4)
  }, )
  tsl <- tsl_simulate(n = 2, rows = 1000, time_range = c(
    "0000-01-01",
    as.character(Sys.Date())
  ))
  tsl_millennia <- tsl_aggregate(
    tsl = tsl, new_time = "millennia",
    f = mean
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl_millennia)
  }, )
  tsl_century <- tsl_aggregate(
    tsl = tsl, new_time = "century",
    f = max
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl_century)
  }, )
  tsl_centuries <- tsl_aggregate(
    tsl = tsl, new_time = "centuries",
    f = stats::quantile, probs = 0.75
  )
  expect_equal(future::plan(future::sequential), )
})
