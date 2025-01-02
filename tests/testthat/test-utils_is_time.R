test_that("`utils_is_time()` works", {

  expect_equal(utils_is_time(x = c("2024-01-01", "2024-02-01")), FALSE)

  expect_equal(utils_is_time(x = utils_as_time(x = c("2024-01-01", "2024-02-01"))), TRUE)

})
