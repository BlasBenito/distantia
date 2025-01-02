test_that("`tsl_aggregate()` works", {

  tsl <- tsl_initialize(
    x = cities_temperature,
    name_column = "name",
    time_column = "time"
  )

  tsl_year <- tsl_aggregate(tsl = tsl, new_time = "year", f = mean)

  expect_true(tsl_time(tsl)$resolution[1] < tsl_time(tsl_year)$resolution[1])

  expect_true(tsl_nrow(tsl)[[1]] > tsl_nrow(tsl_year)[[1]])

})
