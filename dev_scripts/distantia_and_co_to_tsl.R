#' x <- zoo_simulate()
#'
#' y <- zoo_permute(
#'   x = x,
#'   repetitions = 3
#' )
#'
#' tsl_plot(
#'   x = y,
#'   guide = FALSE
#'   )




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

#without aggregation
df <- distantia(
  tsl = tsl
)

k <- distantia_kmeans(
  df = df,
  clusters = 3,
  output = "plot"
)


distantia_df <- distantia_aggregate(
  distantia_df = distantia_df,
  f = mean
)

m <- distantia_matrix(
  distantia_df = distantia_df
)

plot_matrix(m)

distantia_df <- distantia(
  tsl = tsl,
  repetitions = 0,
  distance = c("euclidean", "manhattan")
)

m <- distantia_matrix(
  distantia_df = distantia_df
)

plot_matrix(m)


distantia_df <- distantia_aggregate(
  distantia_df = distantia_df,
  f = mean
)

m <- distantia_matrix(
  distantia_df = df
)


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
