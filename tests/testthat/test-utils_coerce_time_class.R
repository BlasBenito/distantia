test_that("`utils_coerce_time_class()` works", {
  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "Date"
  )
  expect_equal(x, )
  expect_equal(class(x), )
  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "POSIXct"
  )
  expect_equal(x, )
  expect_equal(class(x), )
  x <- utils_coerce_time_class(
    x = c("2024-01-01", "2024-02-01"),
    to = "numeric"
  )
  expect_equal(x, )
  expect_equal(class(x), )
})
