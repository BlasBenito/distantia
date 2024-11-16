testthat::test_that("Distance Matrix", {

  set.seed(1)
  x <- matrix(runif(1000), 100, 10)
  y <- matrix(runif(500), 50, 10)

  method_names <- c(distances$name, distances$abbreviation)

  for(method.i in method_names){

    d.cpp <- distance_matrix_cpp(x, y, distance = method.i)
    d.r <- psi_distance_matrix(x, y, distance = method.i)

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

    testthat::expect_true(
      unique(as.vector(d.cpp) - as.vector(d.r)) == 0
    )

  }

  #when all data is zero
  x <- matrix(0, 100, 10)
  y <- matrix(0, 50, 10)

  for(method.i in method_names){

    d <- distance_matrix_cpp(x, y, distance = method.i)

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
