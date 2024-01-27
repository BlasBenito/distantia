plot_cost_path <- function(
    a = NULL,
    b = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    matrix_type = "cost",
    matrix_color = NULL,
    path_width = 1,
    path_color = "black",
    line_center = FALSE,
    line_scale = FALSE,
    line_color = NULL,
    line_width = 1,
    cex = 1
){

  # Check arguments ----

  #check x
  a <- check_args_x(x = a, arg_name = "a")
  b <- check_args_x(x = b, arg_name = "b")

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

  #prepare ab for psi computation
  ab <- prepare_ab(
    a = a,
    b = b,
    distance = distance
  )

  # compute psi ----
  ab_psi <- distantia(
    x = ab,
    distance = distance[1],
    diagonal = diagonal[1],
    weighted = weighted[1],
    ignore_blocks = ignore_blocks[1]
  )$psi

  ab_psi <- round(ab_psi, 3)

  # compute matrices and path ----
  dist_m <- distance_matrix(
    a = a,
    b = b,
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
    rm(cost_m)
  } else {
    m <- cost_m
    rm(dist_m)
  }

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  plt_all <- par()$plt

  # Plotting areas ----
  plt_a <- c(0.2, 0.35, 0.25, 0.8)
  plt_b <- c(0.35, 0.8, 0.1, 0.25)
  plt_m <- c(0.35, 0.8, 0.25, 0.8)
  plt_matrix_guide <- c(0.82, 0.84, 0.25, 0.8)
  plt_line_guide <- c(0.80, 0.95, 0.1, 0.245)

  # Plot matrix ----
  par(
    oma = c(1, 0, 0, 1)
  )

  par(
    plt = plt_m
    )

  plot_matrix(
    m = m,
    color = matrix_color,
    subtitle = paste0(
      "Psi = ",
      ab_psi
    ),
    path = path,
    subpanel = TRUE,
    path_width = path_width,
    path_color = path_color,
    cex = cex
  )

  # Plot sequence a ----
  par(
    plt = plt_a,
    new = TRUE,
    mgp = c(0, 0.5, 0),
    bty = "n"
    )

  plot_sequence(
    x = a,
    center = line_center,
    scale = line_scale,
    color = line_color,
    width = line_width,
    cex = cex,
    guide = FALSE,
    vertical = TRUE,
    subpanel = TRUE
  )

  # Plot sequence b ----
  par(
    plt = plt_b,
    new = TRUE,
    mgp = c(3, 0.5, 0),
    bty = "n"
    )

  plot_sequence(
    x = b,
    center = line_center,
    scale = line_scale,
    color = line_color,
    width = line_width,
    cex = cex,
    guide = FALSE,
    vertical = FALSE,
    subpanel = TRUE
  )

  # Plot matrix guide ----
  par(
    plt = plt_matrix_guide,
    new = TRUE,
    mgp = c(3, 0.5, 0)
  )

  plot_matrix_guide(
    m = m,
    color = matrix_color,
    cex = cex
  )

  # Plot line guide ----
  par(
    plt = plt_line_guide,
    new = TRUE
  )

  plot_line_guide(
    x = a,
    color = matrix_color,
    cex = cex * 0.7,
    width = line_width,
    subpanel = TRUE
  )

  #reset to main plotting area
  par(plt = plt_all)

  invisible()

}

