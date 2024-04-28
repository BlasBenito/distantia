devtools::load_all()

tsl <- tsl_simulate(
  n = 10,
  time_range = c(
    "2010-01-01 12:00:25",
    "2024-12-31 11:15:45"
  )
)

distantia_plot(
  tsl = tsl
)

df <- distantia(
  tsl = tsl,
  repetitions = 100
)

plot(df$psi, df$p_value)

#distantia matrix
m <- distantia_to_matrix(
  df = df
)

plot_matrix(m)

#distance matrix
m <- psi_dist_matrix(
  x = tsl[[1]],
  y = tsl[[2]]
)

plot_matrix(m)

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
