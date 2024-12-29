test_that("`zoo_permute()` works", {
  x <- zoo_simulate(cols = 2)
  expect_equal(if (interactive()) {
    zoo_plot(x)
  }, )
  x_free <- zoo_permute(x = x, permutation = "free", repetitions = 2)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = x_free, guide = FALSE)
  }, )
  x_free_by_row <- zoo_permute(
    x = x, permutation = "free_by_row",
    repetitions = 2
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = x_free_by_row, guide = FALSE)
  }, )
  x_restricted <- zoo_permute(
    x = x, permutation = "restricted",
    repetitions = 2
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = x_restricted, guide = FALSE)
  }, )
  x_restricted_by_row <- zoo_permute(
    x = x, permutation = "restricted_by_row",
    repetitions = 2
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = x_restricted_by_row, guide = FALSE)
  }, )
})
