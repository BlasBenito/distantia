plot_sequences <- function(
    x = NULL,
    center = FALSE,
    scale = FALSE,
    color = NULL,
    width = 1,
    text_cex = 1,
    box = FALSE,
    guide = TRUE,
    guide_cex = 0.8,
    columns = 1
){

  # Preserve user's config
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))

  #check x
  x <- check_args_x(x = x)

  #check if all elements in x have the same columns
  x.cols <- lapply(
    X = x,
    FUN = ncol
  ) |>
    unlist() |>
    unique()

  if(length(x.cols) > 1){
    subplot_guide <- TRUE
  }

  #define new par
  rows <- length(x)/columns

  par(mfrow = c(rows, columns))

  #plot first sequence
  plot_sequence(
    x = x[[1]],
    center = center,
    scale = scale,
    color = color,
    width = width,
    xlab = NULL,
    ylab = NULL,
    text_cex = text_cex,
    box = box,
    guide = TRUE,
    guide_position = "topright",
    guide_cex = guide_cex
  )



}
