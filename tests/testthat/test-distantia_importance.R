test_that("`distantia_importance()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  importance_dtw <- distantia_importance(tsl = tsl)
  expect_equal(importance_dtw[, c(
    "x", "y", "psi", "variable", "importance",
    "effect"
  )], )
  importance_lock_step <- distantia_importance(tsl = tsl, lock_step = TRUE)
  expect_equal(importance_lock_step[, c(
    "x", "y", "psi", "variable", "importance",
    "effect"
  )], )
  importance_df <- distantia_importance(tsl = tsl, lock_step = c(
    TRUE,
    FALSE
  ))
  expect_equal(importance_df[, c(
    "x", "y", "psi", "variable", "importance",
    "effect", "lock_step"
  )], )
  expect_equal(future::plan(future::sequential), )
})
