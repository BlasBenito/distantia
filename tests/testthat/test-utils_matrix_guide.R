test_that("`utils_matrix_guide()` works", {
  tsl <- tsl_simulate(n = 2, independent = TRUE)
  dm <- psi_distance_matrix(x = tsl[[1]], y = tsl[[2]])
  expect_equal(if (interactive()) {
    utils_matrix_guide(m = dm)
  }, )
})
