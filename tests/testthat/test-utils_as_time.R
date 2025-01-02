test_that("`utils_as_time()` works", {

  expect_equal(class(utils_as_time(x = c(-123120, 1200))), "numeric")

  expect_equal(class(utils_as_time(x = c("2022-03-17", "2024-02-05"))), "Date")

  expect_warning(utils_as_time(x = c("2022", "2024")))

  expect_warning(utils_as_time(x = c("2022-02", "2024-03")))

  expect_true("POSIXct" %in% class(utils_as_time(x = c("2022-03-17 12:30:45", "2024-02-05 11:15:45"))))

})
