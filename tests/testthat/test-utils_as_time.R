test_that("`utils_as_time()` works", {
  expect_equal(utils_as_time(x = c(-123120, 1200)), )
  expect_equal(utils_as_time(x = c("2022-03-17", "2024-02-05")), )
  expect_equal(utils_as_time(x = c("2022", "2024")), )
  expect_equal(utils_as_time(x = c("2022-02", "2024-03")), )
  expect_equal(utils_as_time(x = c("2022-03-17 12:30:45", "2024-02-05 11:15:45")), )
  expect_equal(utils_as_time(x = as.Date(c("2022-03-17", "2024-02-05"))), )
  expect_equal(utils_as_time(x = as.POSIXct(c("2022-03-17 12:30:45", "2024-02-05 11:15:45"))), )
})
