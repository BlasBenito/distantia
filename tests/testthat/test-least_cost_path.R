testthat::test_that("Least Cost Path and Sum", {

  #generating cost matrix
  a <- sequenceA |>
    na.omit() |>
    as.matrix()

  b <- sequenceB |>
    na.omit() |>
    as.matrix()

  dist_matrix <- distance_matrix(
    a,
    b,
    method = "euclidean"
    )

  cost_matrix <- cost_matrix(
    dist_matrix = dist_matrix
    )

  path <- cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  path_cpp <- cost_path_orthogonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  testthat::expect_true(
    all(path == path_cpp)
  )

  path_sum <- cost_path_sum(
    path = path
  )

  path_sum_cpp <- cost_path_sum_cpp(
    path = path
  )

  testthat::expect_true(
    all.equal(path_sum, path_sum_cpp)
  )

  testthat::expect_true(
    is.numeric(path_sum)
  )

  testthat::expect_true(
    is.data.frame(path)
  )

  testthat::expect_true(
    ncol(path) == 4
  )

  testthat::expect_true(
    nrow(path) <= ncol(cost_matrix) + nrow(cost_matrix)
  )

  path_trimmed <- cost_path_trim(
    path = path
  )

  path_trimmed_cpp <- cost_path_trim_cpp(
    path = path
  )

  testthat::expect_true(
    all(path_trimmed == path_trimmed_cpp)
  )

  testthat::expect_true(
    is.data.frame(path_trimmed)
  )

  testthat::expect_true(
    ncol(path_trimmed) == 4
  )

  testthat::expect_true(
    nrow(path_trimmed) < nrow(path)
  )

  path <- cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix,
    diagonal = TRUE
  )

  testthat::expect_true(
    is.data.frame(path)
  )

  testthat::expect_true(
    ncol(path) == 4
  )

  testthat::expect_true(
    nrow(path) <= ncol(cost_matrix) + nrow(cost_matrix)
  )

})
