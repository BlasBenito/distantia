library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

y <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS"
)

plot_distantia(
  x = y[["MIS-11"]],
  y = y[["MIS-9"]]
)


plot_sequence(
  x = y[[1]]
)

x11()
par(
  mfrow = c(floor(length(y)/2), 2),
  mar = c(2, 2, 2, 2)
  )
lapply(y, plot_sequence)

m_dist <- distance_matrix(
  a = y[[1]],
  b = y[[2]]
)

m_cost <- cost_matrix(
  dist_matrix = m_dist
)

path <- cost_path(
  dist_matrix = m_dist,
  cost_matrix = m_cost
)

plot_matrix(
  m = m_dist,
  path = path,
  guide = TRUE
)


# plot_sequence ----
plot_sequence(
  x = y[[1]],
  center = FALSE,
  scale = FALSE,
  color = NULL,
  width = c(2, 1),
  title = "title",
  xlab = "xlab",
  ylab = "ylab",
  cex = 1,
  box = FALSE,
  guide = TRUE,
  guide_position = "topright",
  guide_cex = 0.8,
  vertical = FALSE,
  subpanel = FALSE
  )

# plot cost path ----
plot_cost_path(
    a = y[["MIS-1"]],
    b = y[["MIS-11"]],
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    matrix_type = "cost",
    matrix_color = NULL,
    line_center = FALSE,
    line_scale = FALSE,
    line_color = NULL
)
