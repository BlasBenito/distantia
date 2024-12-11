test_that("`tsl_join()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl_a <- tsl_simulate(n = 2, cols = 2, irregular = TRUE, seed = 1)
  tsl_b <- tsl_colnames_set(tsl_simulate(
    n = 3, cols = 2, irregular = TRUE,
    seed = 2
  ), names = c("c", "d"))
  tsl <- tsl_join(tsl_a, tsl_b)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
  expect_equal(future::plan(future::sequential), )
})
