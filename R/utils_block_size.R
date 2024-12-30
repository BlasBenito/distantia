#' Default Block Size for Restricted Permutation in Dissimilarity Analyses
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param block_size (optional, integer vector) Row block sizes for restricted permutation tests. Only relevant when permutation methods are "restricted" or "restricted_by_row". A block of size `n` indicates that a row can only be permuted within a block of `n` adjacent rows. If NULL, defaults to the 20% rows of the shortest time series in `tsl`. Minimum value is 2, and maximum value is 50% rows of the shortest time series in `tsl`. Default: NULL.
#'
#' @return integer
#' @export
#' @autoglobal
#' @family distantia_support
utils_block_size <- function(
    tsl = NULL,
    block_size = NULL
){

  block_size <- as.integer(block_size)

  min_tsl_row <- tsl |>
    tsl_nrow() |>
    unlist() |>
    min()

  #default value
  default_block_size <- floor(min_tsl_row / 5)

  if(
    is.null(block_size) ||
    any(is.integer(block_size) == FALSE)
  ){

    return(default_block_size)

  }

  #remove extremes
  block_size <- block_size[
    block_size >= 2 &
      block_size <= floor(min_tsl_row / 2)
    ]

  block_size

}
