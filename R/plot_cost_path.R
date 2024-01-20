library(distantia)

load("~/Dropbox/GITHUB/R_packages/distantia/data/sequencesMIS.RData")

#data frame with grouping column
###################################
data(sequencesMIS)

#prepare list of sequences
x <- prepare_sequences(
  x = sequencesMIS,
  id_column = "MIS",
  time_column = NULL,
  paired_samples = FALSE,
  pseudo_zero =  0.001,
  na_action = "to_zero"
)

name_a <- "MIS-5"
name_b <- "MIS-3"
distance <- "euclidean"
diagonal <- FALSE
weighted <- FALSE
ignore_blocks <- FALSE
matrix <- "cost"


#main function
plot_cost_path <- function(
    x = NULL,
    name_a = NULL,
    name_b = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    matrix = "cost",
    col = grDevices::hcl.colors(
      n = 100,
      palette = "Zissou 1"
    ),
    main_title = NULL,
    xlab = NULL,
    ylab = NULL,
    guide_title = NULL,
    path = NULL,
    path_width = 1,
    path_color = "black",
    cex = 1
){

  #check x
  x <- check_args_x(x = x)

  #check name a and b
  if(any(c(is.null(name_a), is.null(name_b)))){
    stop("Arguments 'name_a' and 'name_b' must be names of 'x'. Valid values are: ", paste(names(x), collapse = ", "))
  }

  #check matrix argument
  matrix <- match.arg(
    arg = matrix,
    choices =  c("cost", "distance", "dist"),
    several.ok = FALSE
  )

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
    diagonal = diagnoal,
    weighted = weighted
  )

  path <- cost_path(
    dist_matrix = dist_m,
    cost_matrix = cost_m,
    diagonal = diagnoal
  )

  # select matrix to plot
  if(matrix %in% c("distance", "dist")){
    m <- dist_m
  } else {
    m <- cost_m
  }









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
