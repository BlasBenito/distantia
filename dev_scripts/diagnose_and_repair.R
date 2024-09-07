x <- zoo_simulate(name = "x", cols = 1)
y <- zoo_simulate(name = "y", cols = 1)
z <- zoo_simulate(name = "z", cols = 1)

#making x invalid
x <- zoo::zoo(
  x = runif(nrow(x)),
  order.by = zoo::index(x)
)

colnames(z) <- c("1")

tsl <- list(
  x = x,
  y = y,
  z = z
)

tsl <- tsl_diagnose(tsl)

tsl <- tsl_repair(tsl)

tsl <- tsl_diagnose(tsl)

tsl <- tsl_subset(
  tsl = tsl
)
