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

  cost_path <- cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )

  cost_sum <- least_cost_sum(
    path = path
  )

  testthat::expect_true(
    is.numeric(cost_sum)
  )

  testthat::expect_true(
    is.data.frame(cost_path)
  )

  testthat::expect_true(
    ncol(cost_path) == 4
  )

  testthat::expect_true(
    nrow(cost_path) <= ncol(cost_matrix) + nrow(cost_matrix)
  )

  cost_path_trimmed <- cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix,
    exclude_blocks = TRUE
  )

  testthat::expect_true(
    is.data.frame(cost_path_trimmed)
  )

  testthat::expect_true(
    ncol(cost_path_trimmed) == 4
  )

  testthat::expect_true(
    nrow(cost_path_trimmed) < nrow(cost_path)
  )

  cost_path <- cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix,
    diagonal = TRUE
  )

  testthat::expect_true(
    is.data.frame(cost_path)
  )

  testthat::expect_true(
    ncol(cost_path) == 4
  )

  testthat::expect_true(
    nrow(cost_path) <= ncol(cost_matrix) + nrow(cost_matrix)
  )

})
