testthat::test_that("Auto Sum", {

  set.seed(1)
  x <- matrix(runif(1000), 100, 10)
  y <- matrix(runif(500), 50, 10)

  method_names <- c(distances$name, distances$abbreviation)

  for(method.i in method_names){

    a_autosum <- auto_distance_cpp(
      x = x,
      distance = method.i
    )

    b_autosum <- auto_distance_cpp(
      x = y,
      distance = method.i
    )

    if(!method.i %in% c("jaccard", "jac")){
      testthat::expect_true(
        b_autosum < a_autosum
      )
    }

    dist_matrix <- distance_matrix_cpp(
      x,
      y,
      distance = method.i
    )

    cost_matrix <- cost_matrix_orthogonal_cpp(
      dist_matrix = dist_matrix
    )

    cost_path <- cost_path_orthogonal_cpp(
      dist_matrix = dist_matrix,
      cost_matrix = cost_matrix
    )

    cost_path_trimmed <- cost_path_trim_cpp(cost_path)

    ab_sum_path <- auto_sum_path_cpp(
      x = x,
      y = y,
      path = cost_path,
      distance = method.i
    )

    ab_sum_path_r <- psi_auto_sum(
      x = x,
      y = y,
      path = cost_path,
      distance = method.i
    )

    testthat::expect_true(
      ab_sum_path == ab_sum_path_r
    )

    ab_sum_path_trimmed <- auto_sum_path_cpp(
      x = x,
      y = y,
      path = cost_path_trimmed,
      distance = method.i
    )

    if(!method.i %in% c("jaccard", "jac")){
      testthat::expect_true(
        ab_sum_path > ab_sum_path_trimmed
      )
    }

  }

})
