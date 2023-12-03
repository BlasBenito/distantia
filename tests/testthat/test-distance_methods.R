# Test cases for the individual distance functions
testthat::test_that("Distance Methods", {

  x <- runif(10)
  y <- runif(10)

  method_names <- c(methods$name, methods$abbreviation)

  for(method.i in method_names){

    d <- distance(x, y, method = method.i)

    testthat::expect_true(
      is.numeric(d)
    )

  }

})
