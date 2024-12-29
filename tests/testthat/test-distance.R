test_that("`distance()` works", {
  expect_true(is.numeric(distance(x = runif(100), y = runif(100), distance = "euclidean")))

  expect_true(distance(x = 1, y = 1) == 0)
})
