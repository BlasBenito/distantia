test_that("`tsl_ncol()` and `tsl_nrow()` works", {

   tsl <- tsl_simulate(
    n = 2,
    cols = 6,
    irregular = FALSE,
    rows = 100,
    seed = 1
    )

  expect_equal(tsl_ncol(tsl = tsl)$A, 6)
  expect_equal(tsl_ncol(tsl = tsl)$B, 6)
  expect_equal(tsl_nrow(tsl = tsl)$A, 100)
  expect_equal(tsl_nrow(tsl = tsl)$B, 100)

})
