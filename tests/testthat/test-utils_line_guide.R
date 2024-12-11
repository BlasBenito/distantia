test_that("`utils_line_guide()` works", {
  x <- zoo_simulate()
  expect_equal(if (interactive()) {
    zoo_plot(x, guide = FALSE)
    utils_line_guide(x = x, position = "right")
  }, )
})
