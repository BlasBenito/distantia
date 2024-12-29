test_that("`utils_optimize_loess()` works", {
  xy <- zoo_simulate(cols = 1, rows = 30)
  m <- utils_optimize_loess(x = as.numeric(zoo::index(xy)), y = xy[
    ,
    1
  ])
  print(m)
  plot(
    x = zoo::index(xy), y = xy[, 1], col = "forestgreen", type = "l",
    lwd = 2
  )
  expect_equal(points(
    x = zoo::index(xy), y = stats::predict(object = m, newdata = as.numeric(zoo::index(xy))),
    col = "red4"
  ), )
})
