test_that("`zoo_permute()` works", {

  x <- zoo_simulate(cols = 2)

  x_free <- zoo_permute(x = x, permutation = "free", repetitions = 2)

  expect_equal(
    length(x_free), 2
  )

  expect_equal(
    nrow(x), nrow(x_free[[1]])
  )

})
