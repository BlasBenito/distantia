test_that("`tsl_plot()` works", {
  tsl <- tsl_simulate(cols = 3)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
    tsl_plot(tsl = tsl, ylim = "relative")
    tsl_plot(tsl = tsl, columns = 2, guide_columns = 2)
    tsl_plot(tsl = tsl, guide = FALSE)
    tsl_plot(tsl = tsl, line_color = c("red", "green", "blue"))
  }, )
})
