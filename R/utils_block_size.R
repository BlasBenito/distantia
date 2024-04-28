#' Logics to Handle Argument block_size in distantia()
#'
#' @param tsl (required, time series list) list of zoo time series. Default: NULL
#' @param repetitions (optional, integer vector) number of permutations to compute the p-value. If 0, p-values are not computed. Otherwise, the minimum is 2. Default: 0
#' @param block_size (optional, integer) Row block sizes for the restricted permutation test. Only relevant when permutation methods are "restricted" or "restricted_by_row" and `repetitions` is higher than zero. A block of size `n` indicates that a row can only be permuted within a block of `n` adjacent rows. If NULL, defaults to the rounded one tenth of the shortest sequence in `tsl`. Default: NULL.
#'
#' @return block size
#' @export
#' @autoglobal
utils_block_size <- function(
    tsl = NULL,
    repetitions = NULL,
    block_size = NULL
){

  if(repetitions == 0){
    return(NULL)
  }

  min_tsl_row <- sapply(
    X = tsl,
    FUN = nrow
  ) |>
    min()

  min_block_size <- 2
  default_block_size <- floor(min_tsl_row / 10)
  max_block_size <- floor(min_tsl_row / 2)

  # default
  if(is.null(block_size)){

    message("Argument 'block_size' set to ", default_block_size, ".")

    return(floor(min_tsl_row / 10))

  }

  #check user's input
  block_size <- as.integer(block_size[1])

    if(block_size < min_block_size){

      warning("Argument 'block_size' is too small, setting it to ", min_block_size, ".")

      return(min_block_size)

    }


    if(block_size > max_block_size){

      warning("Argument 'block_size' is too high. Setting it to ", max_block_size, " (half the length of the shortest sequence in 'tsl').")

      return(max_block_size)

    }


  block_size

}
