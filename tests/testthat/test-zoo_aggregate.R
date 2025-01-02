test_that("`zoo_aggregate()` works", {

  x <- zoo_simulate(rows = 1000, time_range = c("0000-01-01", as.character(Sys.Date())))

  x_millennia <- zoo_aggregate(x = x, new_time = "millennia", f = mean)

  expect_equal(nrow(x_millennia), 4)

  x_centuries <- zoo_aggregate(x = x, new_time = "centuries", f = max)

  expect_equal(nrow(x_centuries), 22)

})
