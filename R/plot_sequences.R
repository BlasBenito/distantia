plot_sequences <- function(
    x = NULL,
    center = FALSE,
    scale = FALSE,
    color = NULL,
    width = 1,
    text_cex = 1,
    guide = TRUE,
    guide_cex = 0.8,
    columns = 1
){

  axis_title_distance <- 2.2

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  #check x
  x <- check_args_x(x = x)

  #get column names
  x_colnames <- lapply(
    X = x,
    FUN = function(z){
      attributes(z)$dimnames[[2]]
    }
  ) |>
    unlist() |>
    unique()

  #generate colors
  color <- auto_line_color(
    x = x,
    color = color
  )

  #define new par
  rows <- ceiling((length(x) + 1)/columns)

  n_panels <- length(x)

  par(
    mfrow = c(rows, columns)
  )

  #even number of sequences
  if((n_panels %% 2) == 0){

    par(
      oma = c(1.2, 0, 0, 1),
      mar = c(1, 3.5, 0.5, 0.5)
      )

  } else {

    par(
      oma = c(1.2, 0, 0, 1),
      mar = c(1, 3.5, 0.5, 0.5)
      )

    n_panels <- n_panels + 1

  }

  #plot panels
  for(i in seq_len(n_panels)){

    if(i <= length(x)){

      plot_sequence(
        x = x[[i]],
        center = center,
        scale = scale,
        color = color,
        width = width,
        title = "",
        xlab = NULL,
        ylab = "",
        text_cex = text_cex,
        box = FALSE,
        guide = FALSE,
        guide_position = "right",
        guide_cex = guide_cex,
        subpanel = TRUE
      )

      graphics::title(
        ylab = attributes(x[[i]])$sequence_name,
        line = axis_title_distance,
        cex.lab = text_cex
      )

    } else {

      plot_line_guide(
        x = x,
        position = "center",
        color = color,
        width = width,
        text_cex = guide_cex,
        ncol = 2,
        subpanel = TRUE
      )

    }

  }

  #legend in outer margin
  if(i == length(x)){



  }

  invisible()

}
