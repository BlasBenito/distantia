plot_matrix <- function(
    m = NULL,
    color = NULL,
    title = NULL,
    subtitle = NULL,
    xlab = NULL,
    ylab = NULL,
    path = NULL,
    axes = TRUE,
    path_width = 1,
    path_color = "black",
    cex = 1
){

  axis_title_distance <- 2.2
  axis_title_cex <- 0.9 * cex

  axis_labels_cex <- 0.8 * cex

  main_title_distance <- ifelse(
    test = is.null(subtitle),
    yes = 1.2,
    no = 2
  )
  main_title_cex <- 1.2 * cex

  subtitle_distance <- 0.5
  subtitle_cex <- 1 * cex



  if(inherits(x = m, what = "matrix") == FALSE){
    stop("Argument 'm' must be a distance or cost matrix resulting from distantia::distance_matrix() or distantia::cost_matrix().")
  }

  #handling cost path
  if("cost_path" %in% attributes(path)$type){

    #rename path columns
    colnames(path)[colnames(path) == "a"] <- attributes(path)$a_name
    colnames(path)[colnames(path) == "b"] <- attributes(path)$b_name

  } else {

    if(!is.null(path)){

      warning("Argument 'path' was not generated with distantia::cost_path() and will be ignored.")
      path <- NULL

    }

  }

  if(is.null(color)){
    color = grDevices::hcl.colors(
      n = 100,
      palette = "Zissou 1"
    )
  }

  #main plotting parameters
  y <- seq_len(nrow(m))
  x <- seq_len(ncol(m))
  z <- t(m)

  #handling dimension names
  if(is.null(ylab)){
    ylab <- attributes(m)$a_name
    ylab <- ifelse(
      test = is.null(ylab),
      yes = "a",
      no = ylab
    )
  }


  if(is.null(xlab)){
    xlab <- attributes(m)$b_name
    xlab <- ifelse(
      test = is.null(xlab),
      yes = "a",
      no = xlab
    )
  }


  #handling axis labels
  y_labels <- dimnames(m)[[1]] |>
    as.numeric() |>
    pretty()

  x_labels <- dimnames(m)[[2]] |>
    as.numeric() |>
    pretty()

  #handling breaks
  breaks <- auto_breaks(
    m = m,
    n = length(color)
  )

  #plot matrix
  graphics::image(
    x = x,
    y = y,
    z = z,
    breaks = breaks,
    col = color,
    xlab = "",
    ylab = "",
    axes = FALSE,
    useRaster = FALSE,
    add = FALSE
  )

  if(axes == TRUE){

    graphics::title(
      xlab = xlab,
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

    graphics::title(
      ylab = ylab,
      line = axis_title_distance,
      cex.lab = axis_title_cex
    )

    axis(
      1,
      at = x_labels,
      cex.axis = axis_labels_cex
    )

    axis(
      2,
      at = y_labels,
      cex.axis = axis_labels_cex
    )

  }

  # matrix title ----
  graphics::title(
    main = ifelse(
      test = is.null(title),
      yes = paste0(ylab, " vs. ", xlab),
      no = title
    ),
    cex.main = main_title_cex,
    line = main_title_distance
  )

  # matrix subtitle ----
  if(!is.null(subtitle)){
    graphics::mtext(
      side = 3,
      line = subtitle_distance,
      at = NA,
      adj = NA,
      padj = NA,
      outer = FALSE,
      cex = subtitle_cex,
      subtitle
      )
  }

  # least cost path ----
  if(!is.null(path)){
    graphics::lines(
      x = path[[xlab]],
      y = path[[ylab]],
      lwd = path_width,
      col = path_color
    )
  }


}
