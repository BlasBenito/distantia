test_that("`utils_new_time()` works", {
  tsl <- tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  )
  expect_equal(tsl_time_summary(tsl = tsl, keywords = "aggregate")$keywords, )
  new_time <- utils_new_time(tsl = tsl, new_time = NULL, keywords = "aggregate")
  expect_equal(new_time, )
  new_time <- utils_new_time(tsl = tsl, new_time = NULL, keywords = "resample")
  expect_equal(new_time, )
  new_time <- utils_new_time(tsl = tsl, new_time = "years", keywords = "aggregate")
  expect_equal(new_time, )
  expect_equal(utils_new_time(tsl = tsl, new_time = "year", keywords = "aggregate"), )
  expect_equal(utils_new_time(tsl = tsl, new_time = "y", keywords = "aggregate"), )
  expect_equal(utils_new_time(tsl = tsl, new_time = 365, keywords = "aggregate"), )
  tsl_aggregated <- tsl_aggregate(tsl = tsl, new_time = new_time)
})
