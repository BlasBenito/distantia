test_that("`zoo_vector_to_matrix()` works", {
  x <- zoo::zoo(x = runif(100))
  expect_equal(is.matrix(zoo::coredata(x)), )
  y <- zoo_vector_to_matrix(x = x)
  expect_equal(is.matrix(zoo::coredata(y)), )
})
