test_that("`tsl_diagnose()` works", {

  x <- zoo_simulate(name = "x", cols = 1, na_fraction = 0.1, seed = 1)
  y <- zoo_simulate(name = "x", cols = 2, seed = 2)
  z <- zoo_simulate(name = "z", cols = 1, time_range = c(1, 100), seed = 3)
  colnames(x) <- c("b")

  z <- zoo::zoo(x = runif(nrow(z)), order.by = zoo::index(z))

  tsl <- list(a = x, b = y, c = z)

  expect_message(tsl_diagnose(tsl = tsl)) |>
    suppressMessages()

})
