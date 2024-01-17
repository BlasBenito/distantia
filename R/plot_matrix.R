plot_matrix <- function(
    m,
    breaks = NULL,
    col = hcl.colors(
      n = 100,
      palette = "Zissou 1"
    ),
    main_title = NULL,
    xlab = NULL,
    ylab = NULL,
    guide_title = NULL
){

  if(inherits(x = m, what = "matrix") == FALSE){
    stop("Argument 'm' must be a matrix.")
  }

  #a few hardcoded guide parameters
  guide_area_factor <- 0.1
  guide_width = 1.2
  guide_margin <- 5.1

  #save and reset the user's graphical parameters
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  #main plotting parameters
  y <- seq_len(nrow(m))
  x <- seq_len(ncol(m))
  z <- t(m)

  #handling dimension names
  a_name <- attributes(m)$a_name
  a_name <- ifelse(
    test = is.null(a_name),
    yes = "a",
    no = a_name
  )

  b_name <- attributes(m)$b_name
  b_name <- ifelse(
    test = is.null(b_name),
    yes = "a",
    no = b_name
  )

  #handling axis labels
  y_labels <- dimnames(m)[[1]] |>
    as.numeric() |>
    pretty()

  x_labels <- dimnames(m)[[2]] |>
    as.numeric() |>
    pretty()

  #handling breaks
  if(is.null(breaks)){

    limz <- range(z, na.rm = TRUE)

    a <- seq(
      from = limz[1],
      to = limz[2],
      length.out = length(col)
    )

    b <- (a[2]- a[1])/2

    breaks <- c(a[1] - b, a + b)

  }

  #handling main and guide area
  old.par <- par(no.readonly = TRUE)
  text_size <- par()$cin[1]/par()$din[1]
  offset <- text_size * par()$mar[4]
  guide_width <- text_size * guide_width
  guide_margin <- guide_margin * text_size
  guide_area <- old.par$plt
  guide_area[2] <- 1 - guide_margin
  guide_area[1] <- guide_area[2] - guide_width
  pr <- (guide_area[4] - guide_area[3]) * ((guide_area_factor)/2)
  guide_area[4] <- guide_area[4] - pr
  guide_area[3] <- guide_area[3] + pr

  #handling main area
  main_area <- old.par$plt
  main_area[2] <- min(main_area[2], guide_area[1] - offset)
  guide_area[1] <- min(main_area[2] + offset, guide_area[1])
  guide_area[2] <- guide_area[1] + (guide_area[2] - guide_area[1])

  #main plot
  par(plt = main_area)
  graphics::image(
    x = x,
    y = y,
    z = z,
    breaks = breaks,
    col = col,
    xlab = b_name,
    ylab = a_name,
    axes = FALSE,
    main = ifelse(
      test = is.null(main_title),
      yes = paste0(a_name, " vs. ", b_name),
      no = main_title
    ),
    useRaster = FALSE,
    add = FALSE
  )

  axis(1, at = x_labels)
  axis(2, at = y_labels)

  big.par <- par(no.readonly = TRUE)

  #PLOT LEGEND
  if(
    (guide_area[2] > guide_area[1]) &&
    (guide_area[4] > guide_area[3])
  ){

    #guide values
    guide_values <- (
      breaks[1:(length(breaks)-1)] +
        breaks[2:length(breaks)]
    )/2

    #guide title
    if(is.null(guide_title)){

      distance <- attributes(m)$distance
      type <- attributes(m)$type

      if("distance" %in% type){

        guide_title <- ifelse(
          test = is.null(distance),
          yes = "Distance",
          no = paste(distance , "\ndistance")
        )

      }

      if("cost" %in% type){

        guide_title <- ifelse(
          test = is.null(distance),
          yes = "Cost",
          no = paste(distance , "\ncost")
        )

      }

    }

    #guide plot
    par(
      new = TRUE,
      pty = "m",
      plt = guide_area,
      err = -1
    )

    graphics::image(
      x = 1:2,
      y = breaks,
      z = matrix(
        guide_values,
        nrow = 1,
        ncol = length(guide_values)
      ),
      main = guide_title,
      xaxt = "n",
      yaxt = "n",
      xlab = "",
      ylab = "",
      col = col,
      breaks = breaks
    )

    #guide axis
    do.call(
      what = "axis",
      args = list(
        side = 4,
        mgp = c(3, 1, 0),
        las = 2
      )
    )

  } else {

    warning("Plotting area is too small to add a color guide.")

  }

  invisible()

}

