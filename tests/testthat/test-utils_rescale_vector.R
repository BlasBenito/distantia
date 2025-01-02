test_that("`utils_rescale_vector()` works", {
  out <- utils_rescale_vector(
    x = stats::rnorm(100), new_min = 0,
    new_max = 100,
  )
  expect_equal(range(out), c(0, 100))
})
