test_that("`utils_optimize_spline()` works", {
  xy <- zoo_simulate(cols = 1, rows = 30)
  m <- utils_optimize_spline(x = as.numeric(zoo::index(xy)), y = xy[
    ,
    1
  ])
  print(m)
  plot(
    x = zoo::index(xy), y = xy[, 1], col = "forestgreen", type = "l",
    lwd = 2
  )
  expect_equal(points(
    x = zoo::index(xy), y = stats::predict(object = m, x = as.numeric(zoo::index(xy)))$y,
    col = "red"
  ), )
})
