library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

#prepare list of sequences
y <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS"
)

# plot_sequence ----
plot_sequence(
  x = y[[1]],
  center = FALSE,
  scale = FALSE,
  color = NULL,
  width = c(10, 1),
  title = "title",
  xlab = "xlab",
  ylab = "ylab",
  cex = 1,
  vertical = FALSE,
  subpanel = FALSE
  )

#distance matrix of the first two sequences
dist_matrix <- distance_matrix(
  a = x[["MIS-3"]],
  b = x[["MIS-5"]],
  distance = "euclidean"
)

plot_guide(m = dist_matrix)
plot_matrix(m = dist_matrix)

#cost matrix
cost_matrix <- cost_matrix(
  dist_matrix = dist_matrix
  )

#least cost path
path <- cost_path(
  dist_matrix = dist_matrix,
  cost_matrix = cost_matrix,
  diagonal = TRUE
)

#plot cost matrix and least cost path
plot_guide(
  m = cost_matrix
)

plot_matrix(
  m = cost_matrix,
  path = path,
  axes = TRUE
  )

plot_panel(
  m = cost_matrix,
  path = path
)
