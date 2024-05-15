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


#' tsl <- tsl_simulate(
#'   n = 10,
#'   time_range = c(
#'     "2010-01-01 12:00:25",
#'     "2024-12-31 11:15:45"
#'   )
#' )
#'
#' df <- distantia(
#'   tsl = tsl
#' )
#'
#' hc <- distantia_hclust(
#'   df = df
#' )
#'
#' hc$df
#'
#' plot(
#'   x = hc$hclust,
#'   hang = -1
#'   )
#'
#' stats::rect.hclust(
#'   tree = hc$hclust,
#'   k = hc$clusters,
#'   border = grDevices::hcl.colors(
#'     n = hc$clusters,
#'     palette = "Zissou 1"
#'     )
#'   )



devtools::load_all()

tsl <- tsl_simulate(
  n = 10,
  time_range = c(
    "2010-01-01",
    "2024-12-31"
  ),
  cols = 3
)

df <- distantia(
  tsl = tsl,
  distance = c("euclidean", "manhattan")
)

distantia_boxplot(df)

df <- distantia_importance(
  tsl = tsl,
  distance = c("manhattan", "euclidean")
)

distantia_boxplot(df)












df_split <- utils_distantia_df_split(df)

library(ggplot2)
ggplot(df) +
  aes(
    x = importance,
    y = variable,
  ) +
  geom_boxplot(notch = TRUE) +
  geom_vline(xintercept = 0)


k <- distantia_kmeans(
  df = df,
  clusters = NULL
)

k

k$df

k <- distantia_hclust(
  df = df,
  clusters = NULL,
  method = NULL
)

k

k$df

# #Optional: kmeans plot
# k_plot <- factoextra::fviz_cluster(
#   object = k$k,
#   data = k$d,
#   repel = TRUE
# )






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
