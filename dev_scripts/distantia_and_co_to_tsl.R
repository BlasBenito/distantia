devtools::load_all()

tsl <- tsl_simulate(
  n = 10,
  time_range = c(
    "2010-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)

df <- distantia(
  tsl = tsl
)

m <- distantia_to_matrix(
  df = df
)

df <- distantia(
  tsl = tsl,
  distance = c("euclidean", "manhattan")
)

m <- distantia_to_matrix(
  df = df,
  f = NULL
)

m <- distantia_to_matrix(
  df = df,
  f = mean
)
