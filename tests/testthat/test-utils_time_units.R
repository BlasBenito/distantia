test_that("`utils_time_units()` works", {
  df <- utils_time_units()
  expect_equal(class(df), "data.frame")
  expect_equal(colnames(df), c("base_units", "units", "Date", "POSIXct", "numeric", "integer"))
})
