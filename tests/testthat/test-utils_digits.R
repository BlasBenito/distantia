test_that("`utils_digits()` works", {
  expect_equal(utils_digits(x = 0), 0)
  expect_equal(utils_digits(x = 0.2), 1)
  expect_equal(utils_digits(x = 0.23), 2)
  expect_equal(utils_digits(x = 0.234), 3)
})
