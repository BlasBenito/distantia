test_that("`utils_optimize_loess()` works", {

  xy <- zoo_simulate(cols = 1, rows = 30, seed = 1)

  m <- utils_optimize_loess(
    x = as.numeric(zoo::index(xy)),
    y = xy[,1]
    )

  expect_equal(class(m), "loess")

})
