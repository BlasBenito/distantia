test_that("`auto_distance_cpp()` works", {
  x <- zoo_simulate()
  expect_equal(auto_distance_cpp(x = x, distance = "euclidean"), )
})

test_that("`auto_sum_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_orthogonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(nrow(cost_path), )
  cost_path_trimmed <- cost_path_trim_cpp(path = cost_path)
  expect_equal(nrow(cost_path_trimmed), )
  expect_equal(auto_sum_cpp(
    x = x, y = y, path = cost_path_trimmed, distance = "euclidean",
    ignore_blocks = FALSE
  ), )
})

test_that("`auto_sum_full_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  expect_equal(auto_sum_full_cpp(x = x, y = y, distance = "euclidean"), )
})

test_that("`auto_sum_path_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_orthogonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(nrow(cost_path), )
  cost_path_trimmed <- cost_path_trim_cpp(path = cost_path)
  expect_equal(nrow(cost_path_trimmed), )
  expect_equal(auto_sum_path_cpp(x = x, y = y, path = cost_path_trimmed, distance = "euclidean"), )
})

test_that("`cost_path_diagonal_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_diagonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path, )
})

test_that("`cost_path_diagonal_itakura_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_diagonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path, )
})

test_that("`cost_path_orthogonal_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_orthogonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path, )
})

test_that("`cost_path_orthogonal_itakura_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_orthogonal_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path, )
})

test_that("`cost_path_slotting_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_slotting_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path, )
})

test_that("`cost_path_sum_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_slotting_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(cost_path_sum_cpp(path = cost_path), )
})

test_that("`cost_path_trim_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
  cost_matrix <- cost_matrix_orthogonal_cpp(dist_matrix = dist_matrix)
  cost_path <- cost_path_slotting_cpp(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix
  )
  expect_equal(nrow(cost_path), )
  cost_path_trimmed <- cost_path_trim_cpp(path = cost_path)
  expect_equal(nrow(cost_path_trimmed), )
})

test_that("`distance_bray_curtis_cpp()` works", {
  expect_equal(distance_bray_curtis_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_canberra_cpp()` works", {
  expect_equal(distance_canberra_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0)), )
})

test_that("`distance_chebyshev_cpp()` works", {
  expect_equal(distance_chebyshev_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_chi_cpp()` works", {
  expect_equal(distance_chi_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_cosine_cpp()` works", {
  expect_equal(distance_cosine_cpp(c(0.2, 0.4, 0.5), c(0.1, 0.8, 0.2)), )
})

test_that("`distance_euclidean_cpp()` works", {
  expect_equal(distance_euclidean_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_hamming_cpp()` works", {
  expect_equal(distance_hamming_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0)), )
})

test_that("`distance_hellinger_cpp()` works", {
  expect_equal(distance_hellinger_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_jaccard_cpp()` works", {
  expect_equal(distance_jaccard_cpp(x = c(0, 1, 0, 1), y = c(1, 1, 0, 0)), )
})

test_that("`distance_lock_step_cpp()` works", {
  x <- zoo_simulate(seed = 1, irregular = FALSE)
  y <- zoo_simulate(seed = 2, irregular = FALSE)
  dist_matrix <- distance_lock_step_cpp(x = x, y = y, distance = "euclidean")
})

test_that("`distance_manhattan_cpp()` works", {
  expect_equal(distance_manhattan_cpp(x = runif(100), y = runif(100)), )
})

test_that("`distance_matrix_cpp()` works", {
  x <- zoo_simulate(seed = 1)
  y <- zoo_simulate(seed = 2)
  dist_matrix <- distance_matrix_cpp(x = x, y = y, distance = "euclidean")
})

test_that("`distance_russelrao_cpp()` works", {
  expect_equal(distance_russelrao_cpp(c(0, 1, 0, 1), c(1, 1, 0, 0)), )
})

test_that("`distance_sorensen_cpp()` works", {
  expect_equal(distance_sorensen_cpp(x = c(0, 1, 1, 0), y = c(1, 1, 0, 0)), )
})

test_that("`importance_dynamic_time_warping_legacy_cpp()` works", {
  x <- zoo_simulate(seed = 1, rows = 100)
  y <- zoo_simulate(seed = 2, rows = 150)
  expect_equal(nrow(x) == nrow(y), )
  df <- importance_dynamic_time_warping_legacy_cpp(
    x = x, y = y,
    distance = "euclidean"
  )
  expect_equal(df, )
})

test_that("`importance_dynamic_time_warping_robust_cpp()` works", {
  x <- zoo_simulate(seed = 1, rows = 100)
  y <- zoo_simulate(seed = 2, rows = 150)
  expect_equal(nrow(x) == nrow(y), )
  df <- importance_dynamic_time_warping_robust_cpp(
    x = x, y = y,
    distance = "euclidean"
  )
  expect_equal(df, )
})

test_that("`importance_lock_step_cpp()` works", {
  x <- zoo_simulate(seed = 1, irregular = FALSE)
  y <- zoo_simulate(seed = 2, irregular = FALSE)
  expect_equal(nrow(x) == nrow(y), )
  df <- importance_lock_step_cpp(x = x, y = y, distance = "euclidean")
  expect_equal(df, )
})

test_that("`subset_matrix_by_rows_cpp()` works", {
  m <- zoo_simulate(seed = 1)
  rows <- sort(sample(x = nrow(m), size = 10))
  m_subset <- subset_matrix_by_rows_cpp(m = m, rows = rows)
  expect_equal(m[rows, ], )
})
