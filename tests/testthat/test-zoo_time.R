test_that("`zoo_time()` works", {
  x <- zoo_simulate(rows = 150, time_range = c(
    Sys.Date() - 365,
    Sys.Date()
  ), irregular = TRUE)
  expect_equal(zoo_time(x = x), )
})
