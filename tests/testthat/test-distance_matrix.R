testthat::test_that("Distance Matrix", {

  set.seed(1)
  a <- matrix(runif(1000), 100, 10)
  b <- matrix(runif(500), 50, 10)

  method_names <- c(methods$name, methods$abbreviation)

  for(method.i in method_names){

    d.cpp <- distance_matrix_cpp(a, b, method = method.i)
    d.r <- distance_matrix(a, b, method = method.i)

    testthat::expect_true(
      is.numeric(d.cpp)
    )

    testthat::expect_true(
      is.numeric(d.r)
    )

    testthat::expect_true(
      is.matrix(d.cpp)
    )

    testthat::expect_true(
      is.matrix(d.r)
    )

    testthat::expect_true(
      all(c(100, 50)  %in% unique(c(dim(d.r), dim(d.cpp))))
    )

    testthat::expect_equal(
      d.cpp,
      d.r
    )

  }

  #when all data is zero
  a <- matrix(0, 100, 10)
  b <- matrix(0, 50, 10)

  for(method.i in method_names){

    d <- distance_matrix_cpp(a, b, method = method.i)

    if(method.i %in% c(
      "chi",
      "cosine",
      "cos"
      )){

      testthat::expect_true(
        all(is.nan(d))
      )

    } else {

      testthat::expect_true(
        all(d == 0)
      )

    }

  }

})
