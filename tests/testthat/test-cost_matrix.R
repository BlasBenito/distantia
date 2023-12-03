testthat::test_that("Cost Matrix", {

  #assessing normal behavior
  set.seed(1)
  a <- matrix(runif(1000), 100, 10)
  b <- matrix(runif(500), 50, 10)

  d <- distance_matrix_cpp(a, b, method = "manhattan")

  least_cost <- cost_matrix_cpp(d = d)

  testthat::expect_true(
    is.numeric(least_cost)
  )

  testthat::expect_true(
    is.matrix(least_cost)
  )

  testthat::expect_true(
    sum(is.nan(least_cost)) == 0
  )

  testthat::expect_true(
    sum(is.na(least_cost)) == 0
  )

  testthat::expect_equal(
    dim(d), dim(least_cost)
  )

  least_cost <- cost_matrix_diag_cpp(d = d)

  testthat::expect_true(
    is.numeric(least_cost)
  )

  testthat::expect_true(
    is.matrix(least_cost)
  )

  testthat::expect_true(
    sum(is.nan(least_cost)) == 0
  )

  testthat::expect_true(
    sum(is.na(least_cost)) == 0
  )

  testthat::expect_equal(
    dim(d), dim(least_cost)
  )


})
