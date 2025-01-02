test_that("`utils_optimize_spline()` works", {
  xy <- zoo_simulate(cols = 1, rows = 30)

  m <- utils_optimize_spline(
    x = as.numeric(zoo::index(xy)),
    y = xy[,1]
  )

  expect_equal(class(m), "smooth.spline")

})
