testthat::test_that("Distance Matrix", {

  #assessing normal behavior
  set.seed(1)
  a <- matrix(runif(1000), 100, 10)
  b <- matrix(runif(500), 50, 10)

  testthat::expect_equal(
    distance_matrix_cpp(a, b, f = distance_manhattan_cpp),
    distance_matrix(a, b, method = "manhattan")
  )

  testthat::expect_equal(
    distance_matrix_cpp(a, b, f = distance_hellinger_cpp),
    distance_matrix(a, b, method = "hellinger")
  )

  testthat::expect_equal(
    distance_matrix_cpp(a, b, f = distance_euclidean_cpp),
    distance_matrix(a, b, method = "euclidean")
  )

  testthat::expect_equal(
    distance_matrix_cpp(a, b, f = distance_chi_cpp),
    distance_matrix(a, b, method = "chi")
  )

  d_manhattan <- distance_matrix_cpp(a, b, f = distance_manhattan_cpp)

  testthat::expect_true(
    is.numeric(d_manhattan)
  )

  testthat::expect_true(
    is.matrix(d_manhattan)
  )

  d_euclidean <- distance_matrix_cpp(a, b, f = distance_euclidean_cpp)

  testthat::expect_true(
    is.numeric(d_euclidean)
  )

  testthat::expect_true(
    is.matrix(d_euclidean)
  )

  d_hellinger <- distance_matrix_cpp(a, b, f = distance_hellinger_cpp)

  testthat::expect_true(
    is.numeric(d_hellinger)
  )

  testthat::expect_true(
    is.matrix(d_hellinger)
  )

  d_chi <- distance_matrix_cpp(a, b, f = distance_chi_cpp)

  testthat::expect_true(
    is.numeric(d_chi)
  )

  testthat::expect_true(
    is.matrix(d_chi)
  )

  testthat::expect_true(
  all(c(100, 50)  %in% unique(c(dim(d_manhattan), dim(d_euclidean), dim(d_hellinger), dim(d_chi))))
  )

  #assessing edge cases
  a <- matrix(0, 100, 10)
  b <- matrix(0, 50, 10)

  d_manhattan <- distance_matrix_cpp(a, b, f = distance_manhattan_cpp)

  testthat::expect_true(
    all(d_manhattan == 0)
  )

  d_euclidean <- distance_matrix_cpp(a, b, f = distance_euclidean_cpp)

  testthat::expect_true(
    all(d_euclidean == 0)
  )

  d_hellinger <- distance_matrix_cpp(a, b, f = distance_hellinger_cpp)

  testthat::expect_true(
    all(d_hellinger == 0)
  )

  d_chi <- distance_matrix_cpp(a, b, f = distance_chi_cpp)

  testthat::expect_true(
    all(is.nan(d_chi))
  )


})
