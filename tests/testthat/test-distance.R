test_that("`distance()` works", {
  expect_true(is.numeric(distance(x = runif(100), y = runif(100), distance = "euclidean")))

  expect_true(distance(x = 1, y = 1) == 0)
})

test_that("`distance()` works with bray_curtis full name and abbreviation", {
  x <- c(0.1, 0.4, 0.5)
  y <- c(0.2, 0.3, 0.5)
  expect_true(is.numeric(distance(x = x, y = y, distance = "bray_curtis")))
  expect_equal(
    distance(x = x, y = y, distance = "bray_curtis"),
    distance(x = x, y = y, distance = "bra")
  )
})

test_that("`distance()` works with sorensen full name and abbreviation", {
  x <- c(1, 0, 1, 0)
  y <- c(1, 1, 0, 0)
  expect_true(is.numeric(distance(x = x, y = y, distance = "sorensen")))
  expect_equal(
    distance(x = x, y = y, distance = "sorensen"),
    distance(x = x, y = y, distance = "sor")
  )
})
