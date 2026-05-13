test_that("`utils_rescale_vector()` works", {
  out <- utils_rescale_vector(
    x = stats::rnorm(100), new_min = 0,
    new_max = 100,
  )
  expect_equal(range(out), c(0, 100))
})

test_that("`utils_rescale_vector()` handles min == max (constant vector)", {
  out <- utils_rescale_vector(x = rep(5, 10), new_min = 0, new_max = 1)
  expect_true(all(out == 0))
  expect_false(any(is.nan(out)))
  expect_false(any(is.infinite(out)))
})
