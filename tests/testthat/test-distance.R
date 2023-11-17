# Test cases for the individual distance functions
test_that("Manhattan Distance Calculation", {
  x <- c(1, 2, 3)
  y <- c(4, 5, 6)
  expect_equal(
    distance_manhattan(x, y),
    distance(x, y, method = "manhattan")
    )
  expect_true(
    is.numeric(distance_manhattan(x, y))
  )
  expect_true(
    is.na(distance_manhattan(NA, NA))
  )
})

test_that("Euclidean Distance Calculation", {
  x <- c(1, 2, 3)
  y <- c(4, 5, 6)
  expect_equal(
    distance_euclidean(x, y),
    distance(x, y, method = "euclidean")
    )
  expect_true(
    is.numeric(distance_euclidean(x, y))
  )
  expect_true(
    is.na(distance_euclidean(NA, NA))
  )
})

test_that("Chi Distance Calculation", {
  x <- c(1, 2, 3)
  y <- c(4, 5, 6)
  expect_equal(
    distance_chi(x, y),
    distance(x, y, method = "chi")
    )
  expect_true(
    is.numeric(distance_chi(x, y))
  )
  expect_true(
    is.na(distance_chi(NA, NA))
  )
})

test_that("Hellinger Distance Calculation", {
  x <- c(1, 2, 3)
  y <- c(4, 5, 6)
  expect_equal(
    distance_hellinger(x, y),
    distance(x, y, method = "hellinger")
    )
  expect_true(
    is.numeric(distance_hellinger(x, y))
  )
  expect_true(
    is.na(distance_hellinger(NA, NA))
  )
})
