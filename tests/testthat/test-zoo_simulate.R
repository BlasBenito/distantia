test_that("`zoo_simulate()` works", {
  x <- zoo_simulate()
  expect_equal(class(x), )
  expect_equal(attributes(x)$name, )
  expect_equal(names(x), )
  if (interactive()) {
    plot(x)
    zoo_plot(x = x, xlab = "Date", ylab = "Value", title = "My time series")
  }
})
