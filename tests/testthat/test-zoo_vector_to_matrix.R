test_that("`zoo_vector_to_matrix()` works", {
  x <- zoo::zoo(x = runif(100))
  expect_equal(is.matrix(zoo::coredata(x)), FALSE)
  y <- zoo_vector_to_matrix(x = x)
  expect_equal(is.matrix(zoo::coredata(y)), TRUE)
})

test_that("`zoo_vector_to_matrix()` preserves the 'name' attribute", {
  x <- zoo::zoo(x = runif(10))
  x <- zoo_name_set(x = x, name = "test_series")
  y <- zoo_vector_to_matrix(x = x, name = "col1")
  expect_equal(zoo_name_get(x = y), "test_series")
  expect_equal(colnames(zoo::coredata(y)), "col1")
})
