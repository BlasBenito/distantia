# Test cases for the individual distance functions
testthat::test_that("Distance Metrics", {

  x <- runif(10)
  y <- runif(10)

  testthat::expect_equal(
    distance_manhattan_cpp(x, y),
    distance(x, y, method = "manhattan")
    )

  testthat::expect_equal(
    distance_euclidean_cpp(x, y),
    distance(x, y, method = "euclidean")
  )

  testthat::expect_equal(
    distance_hellinger_cpp(x, y),
    distance(x, y, method = "hellinger")
  )

  testthat::expect_equal(
    distance_chi_cpp(x, y),
    distance(x, y, method = "chi")
  )

  expect_true(
    is.numeric(distance_manhattan_cpp(x, y))
  )

  expect_true(
    is.numeric(distance_manhattan_cpp(0, 0))
  )

  expect_true(
    is.na(distance_manhattan_cpp(NA, NA))
  )


  expect_true(
    is.numeric(distance_euclidean_cpp(x, y))
  )

  expect_true(
    is.numeric(distance_euclidean_cpp(0, 0))
  )

  expect_true(
    is.na(distance_euclidean_cpp(NA, NA))
  )

  expect_true(
    is.numeric(distance_hellinger_cpp(x, y))
  )

  expect_true(
    is.numeric(distance_hellinger_cpp(0, 0))
  )

  expect_true(
    is.na(distance_hellinger_cpp(NA, NA))
  )

  expect_true(
    is.numeric(distance_chi_cpp(x, y))
  )

  expect_true(
    is.na(distance_chi_cpp(0, 0))
  )

  expect_true(
    is.na(distance_chi_cpp(NA, NA))
  )

})
