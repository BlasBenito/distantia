library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

#prepare list of sequences
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS"
)

name_a <- "MIS-5"
name_b <- "MIS-3"
distance <- "euclidean"
diagonal <- FALSE
weighted <- FALSE
ignore_blocks <- FALSE
matrix <- "cost"
col = NULL
main_title = NULL
xlab = NULL
ylab = NULL
guide_title = NULL
path = NULL
path_width = 1
path_color = "black"
cex = 1


#main function
plot_cost_path <- function(
    x = NULL,
    name_a = NULL,
    name_b = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    matrix_type = "cost",
    matrix_color = NULL,
    curve_center = FALSE,
    curve_scale = FALSE,
    curve_color = NULL,
    curve_width = NULL
){

  # Check arguments ----

  #check x
  x <- check_args_x(x = x)

  #check name a and b
  if(any(c(is.null(name_a), is.null(name_b)))){
    stop("Arguments 'name_a' and 'name_b' must be names of 'x'. Valid values are: ", paste(names(x), collapse = ", "))
  }

  #check matrix argument
  matrix_type <- match.arg(
    arg = matrix_type,
    choices =  c("cost", "distance", "dist"),
    several.ok = FALSE
  )

  if(is.null(matrix_color)){
    matrix_color = grDevices::hcl.colors(
      n = 100,
      palette = "Zissou 1"
    )
  }

  # compute psi ----
  ab_psi <- distantia(
    x = x[c(name_a, name_b)],
    distance = distance[1],
    diagonal = diagonal[1],
    weighted = weighted[1],
    ignore_blocks = ignore_blocks[1]
  )$psi

  ab_psi <- round(ab_psi, 3)

  # compute matrices and path ----
  dist_m <- distance_matrix(
    a = x[[name_a]],
    b = x[[name_b]],
    distance = distance
  )

  cost_m <- cost_matrix(
    dist_matrix = dist_m,
    diagonal = diagonal,
    weighted = weighted
  )

  path <- cost_path(
    dist_matrix = dist_m,
    cost_matrix = cost_m,
    diagonal = diagonal
  )

  # select matrix to plot
  if(matrix_type %in% c("distance", "dist")){
    m <- dist_m
  } else {
    m <- cost_m
  }

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  # General plot configuration ----
  plt_a <- c(0.2, 0.35, 0.25, 0.8)
  plt_b <- c(0.35, 0.8, 0.1, 0.25)
  plt_m <- c(0.35, 0.8, 0.25, 0.8)
  plt_guide <- c(0.85, 0.9, 0.25, 0.8)

  # Plot matrix ----
  par(plt = plt_m)
  plot_matrix(
    m = m,
    matrix_color = matrix_color,
    path = path,
    path_width = path_width,
    path_color = path_color,
    cex = cex
  )

  # Plot sequence a ----
  par(
    plt = plt_a,
    new = TRUE,
    mgp = c(0, 0.5, 0)
    )
  plot_sequence(
    x = x[[name_a]],
    vertical = TRUE,
    center = curve_center,
    scale = curve_scale,
    color = curve_color,
    width = curve_width,
    cex = cex
  )

  # Plot sequence b ----
  par(
    plt = plt_b,
    new = TRUE,
    mgp = c(3, 0.5, 0)
    )

  plot_sequence(
    x = x[[name_b]],
    vertical = FALSE,
    center = curve_center,
    scale = curve_scale,
    color = curve_color,
    width = curve_width,
    cex = cex
  )

  # Plot guide ----
  par(
    plt = plt_guide,
    new = TRUE,
    mgp = c(3, 0.5, 0)
  )

  plot_guide(
    m = m,
    color = matrix_color,
    cex = cex
  )




}


a <- data.frame(
  value = as.numeric(x[[1]][, "Quercus"]),
  time = as.numeric(attributes(x[[1]])$time)
  )

b <- data.frame(
  value = as.numeric(x[[2]][, "Quercus"]),
  time = as.numeric(attributes(x[[2]])$time)
)

plt_a <- c(0.2, 0.35, 0.25, 0.8)
plt_b <- c(0.35, 0.8, 0.1, 0.25)
plt_m <- c(0.35, 0.8, 0.25, 0.8)

#plot a
par(plt = plt_a)
plot(
  x = a$value,
  y = a$time,
  type = "l",
  xlab = "",
  ylab = "",
  xlim = rev(range(a$value))
  )

#plot b
par(
  new = TRUE,
  pty = "m",
  plt = plt_b,
  err = -1
)

plot(
  x = b$time,
  y = b$value,
  type = "l",
  xlab = "",
  ylab = ""
  )

#plot matrix
par(
  new = TRUE,
  pty = "m",
  plt = plt_m,
  err = -1
)

y <- seq_len(nrow(cost_matrix))
x <- seq_len(ncol(cost_matrix))
z <- t(cost_matrix)

graphics::image(
  x = x,
  y = y,
  z = z,
  col = grDevices::hcl.colors(
    n = 100,
    palette = "Zissou 1"
  ),
  xlab = "",
  ylab = "",
  axes = FALSE,
  useRaster = FALSE,
  add = FALSE
)

graphics::lines(
  x = path[["b"]],
  y = path[["a"]]
)
