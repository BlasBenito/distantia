#' Logics to Handle Argument block_size in distantia()
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param block_size (optional, integer) Row block sizes for the restricted permutation test. Only relevant when permutation methods are "restricted" or "restricted_by_row". A block of size `n` indicates that a row can only be permuted within a block of `n` adjacent rows. If NULL, defaults to the rounded one tenth of the shortest time_series in `tsl`. Default: NULL.
#'
#' @return block size
#' @export
#' @autoglobal
utils_block_size <- function(
    tsl = NULL,
    block_size = NULL
){

  min_tsl_row <- sapply(
    X = tsl,
    FUN = nrow
  ) |>
    min()

  min_block_size <- 2
  default_block_size <- max(floor(min_tsl_row / 10), min_block_size)

  # default
  if(is.null(block_size)){

    message("Argument 'block_size' set to ", default_block_size, ".")

    return(default_block_size)

  }

  #check user's input
  block_size <- as.integer(block_size[1])

  # min block size ----

  if(block_size < min_block_size){

    warning(
      "Argument 'block_size' is too small, setting it to ",
      min_block_size,
      "."
      )

    return(min_block_size)

  }

  # max block size ----
  max_block_size <- floor(min_tsl_row / 2)

  if(block_size > max_block_size){

    warning(
      "Argument 'block_size' is too high. Setting it to ",
      max_block_size,
      " (half the length of the shortest time series in 'tsl')."
      )

    return(max_block_size)

  }


  block_size

}
