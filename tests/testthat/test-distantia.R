testthat::test_that("Distantia", {

  set.seed(1)
  a <- matrix(runif(1000), 100, 10)
  b <- matrix(runif(500), 50, 10)

  method_names <- c(methods$name, methods$abbreviation)

  for(method.i in method_names){

    d.cpp <- distantia_cpp(a, b, method = method.i)
    d.r <- distantia(a, b, method = method.i)

    testthat::expect_true(
      all.equal(d.cpp, d.r)
    )

    testthat::expect_true(
      is.numeric(d.r)
    )


    d.cpp <- distantia_cpp(
      a,
      b,
      method = method.i,
      diagonal = TRUE
      )

    testthat::expect_true(
      is.numeric(d.r)
    )


    d.cpp <- distantia_cpp(
      a,
      b,
      method = method.i,
      weighted = TRUE
      )

    testthat::expect_true(
      is.numeric(d.r)
    )

    d.cpp <- distantia_cpp(
      a,
      b,
      method = method.i,
      weighted = TRUE,
      trim_blocks = TRUE
      )

    testthat::expect_true(
      is.numeric(d.r)
    )

  }

  #when all data is zero
  a <- matrix(0, 100, 10)
  b <- matrix(0, 50, 10)

  for(method.i in method_names){

    d <- distantia_cpp(a, b, method = method.i)

      testthat::expect_true(
        is.nan(d)
      )

  }

})
