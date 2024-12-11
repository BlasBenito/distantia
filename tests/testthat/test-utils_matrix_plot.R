test_that("`utils_matrix_plot()` works", {
  tsl <- tsl_simulate(n = 2, independent = TRUE)
  dm <- psi_distance_matrix(x = tsl[[1]], y = tsl[[2]])
  cm <- psi_cost_matrix(dist_matrix = dm)
  cp <- psi_cost_path(dist_matrix = dm, cost_matrix = cm)
  expect_equal(if (interactive()) {
    utils_matrix_plot(m = cm, path = cp, guide = TRUE)
  }, )
})
