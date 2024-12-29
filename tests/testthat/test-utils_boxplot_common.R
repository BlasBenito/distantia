test_that("`utils_boxplot_common()` works", {
  expect_equal(utils_boxplot_common(
    variable = rep(x = c("a", "b"), times = 50),
    value = stats::runif(100)
  ), )
})
