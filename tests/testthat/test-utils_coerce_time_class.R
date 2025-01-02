test_that("`utils_coerce_time_class()` works", {
  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "Date"
  )
  expect_equal(class(x), "Date")

  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "POSIXct"
  )
  expect_true("POSIXct" %in% class(x))


  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "numeric"
  )
  expect_equal(class(x), "numeric")

})
