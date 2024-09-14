#creating three zoo time series

#one with NA values
x <- zoo_simulate(
  name = "x",
  cols = 1,
  na_fraction = 0.1
  )

#with different number of columns
#wit repeated name
y <- zoo_simulate(
  name = "x",
  cols = 2
  )

#with different time class
z <- zoo_simulate(
  name = "z",
  cols = 1,
  time_range = c(1, 100)
  )

#adding a few structural issues

#changing the column name of x
colnames(x) <- c("b")

#converting z to vector
z <- zoo::zoo(
  x = runif(nrow(z)),
  order.by = zoo::index(z)
)

#storing zoo objects in a list
#with mismatched names
tsl <- list(
  a = x,
  b = y,
  c = z
)

#running full diagnose
tsl <- tsl_diagnose(
  tsl = tsl,
  full = TRUE
  )

tsl <- tsl_repair(tsl)

tsl <- tsl_diagnose(tsl)

tsl <- tsl_subset(
  tsl = tsl
)
