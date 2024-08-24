testthat::test_that("Auto Sum", {

  set.seed(1)
  a <- matrix(runif(1000), 100, 10)
  b <- matrix(runif(500), 50, 10)

  method_names <- c(methods$name, methods$abbreviation)

  for(method.i in method_names){

    a_autosum <- auto_distance_cpp(
      m = a,
      method = method.i
    )

    b_autosum <- auto_distance_cpp(
      m = b,
      method = method.i
    )

    if(!method.i %in% c("jaccard", "jac")){
      testthat::expect_true(
        b_autosum < a_autosum
      )
    }

    dist_matrix <- distance_matrix_cpp(
      a,
      b,
      method = method.i
    )

    cost_matrix <- cost_matrix_cpp(
      dist_matrix = dist_matrix
    )

    cost_path <- cost_path_orthogonal_cpp(
      dist_matrix = dist_matrix,
      cost_matrix = cost_matrix
    )

    cost_path_trimmed <- cost_path_trim_cpp(cost_path)

    ab_sum_path <- auto_sum_path_cpp(
      a = a,
      b = b,
      path = cost_path,
      method = method.i
    )

    ab_sum_path_r <- auto_sum(
      a = a,
      b = b,
      path = cost_path,
      method = method.i
    )

    testthat::expect_true(
      ab_sum_path == ab_sum_path_r
    )

    ab_sum_path_trimmed <- auto_sum_path_cpp(
      a = a,
      b = b,
      path = cost_path_trimmed,
      method = method.i
    )

    if(!method.i %in% c("jaccard", "jac")){
      testthat::expect_true(
        ab_sum_path > ab_sum_path_trimmed
      )
    }

  }

})
