test_that("`distantia()` works", {

  tsl <- tsl_transform(
    tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ),
  f = f_scale_global
  )


  df_dtw <- distantia(
    tsl = tsl,
    distance = "euclidean",
    permutation = "restricted_by_row",
    block_size = 3,
    repetitions = 10,
    seed = 1
  )

  expect_true(all(c("x", "y", "psi", "p_value", "null_mean", "null_sd") %in% colnames(df_dtw)))

  psi_null <- psi_null_dtw_cpp(
    x = tsl[["Spain"]], y = tsl[["Sweden"]],
    distance = "euclidean", repetitions = 10, permutation = "restricted_by_row",
    block_size = 3, seed = 1
  )

  expect_equal(mean(psi_null), df_dtw$null_mean[3])

})
