test_that("`tsl_join()` works", {
  tsl_a <- tsl_simulate(n = 2, cols = 2, irregular = TRUE, seed = 1)
  tsl_b <- tsl_colnames_set(tsl_simulate(
    n = 3, cols = 2, irregular = TRUE,
    seed = 2
  ), names = c("c", "d"))
  tsl <- tsl_join(tsl_a, tsl_b)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
})
