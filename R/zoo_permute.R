#' Permutation of Zoo Time Series
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#' @param repetitions (optional, integer vector) number of permutations to compute the p-value. If 0, p-values are not computed. Otherwise, the minimum is 2. Default: 1
#' @param permutation (optional, character string) permutation method. Valid values are listed below from higher to lower induced randomness:
#' \itemize{
#'   \item "free": unrestricted shuffling of rows and columns. Ignores block_size.
#'   \item "free_by_row": unrestricted shuffling of complete rows. Ignores block size.
#'   \item "restricted": restricted shuffling of rows and columns within blocks.
#'   \item "restricted_by_row": restricted shuffling of rows within blocks.
#' }
#' @param block_size (optional, integer) Row block size for the restricted permutation test. Only relevant when permutation methods are "restricted" or "restricted_by_row" and `repetitions` is higher than zero. A block of size `n` indicates that a row can only be permuted within a block of `n` adjacent rows. If NULL, defaults to the rounded one tenth of the shortest sequence in `tsl`. Default: NULL.
#' @param seed (optional, integer) initial random seed to use for replicability when computing p-values. Default: 1
#'
#' @return Time Series List
#' @export
#' @autoglobal
#' @examples
#' x <- zoo_simulate()
#'
#' y <- zoo_permute(
#'   x = x,
#'   repetitions = 3
#' )
#'
#' tsl_plot(
#'   x = y,
#'   guide = FALSE
#'   )
zoo_permute <- function(
    x = NULL,
    repetitions = 1L,
    permutation = "restricted_by_row",
    block_size = NULL,
    seed = 1
){

  #check x
  x <- utils_check_zoo_args(x = x)

  permutation <- match.arg(
    arg = permutation,
    choices = c(
      "restricted_by_row",
      "restricted",
      "free_by_row",
      "free"
    ),
    several.ok = FALSE
  )

  if (permutation == "restricted_by_row") {
    f <- permute_restricted_by_row_cpp
  } else if (permutation == "free_by_row") {
    f <- permute_free_by_row_cpp
  } else if (permutation == "restricted") {
    f <- permute_restricted_cpp
  } else if (permutation == "free") {
    f <- permute_free_cpp
  }

  block_size <- utils_block_size(
    tsl = list(x),
    repetitions = repetitions,
    block_size = block_size
  )

  repetitions <- seq_len(repetitions)

  `%iterator%` <- doFuture::`%dofuture%`

  p <- progressr::progressor(along = repetitions)

  permutations <- foreach::foreach(
    i = repetitions,
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    seed <- seed + i

    x_name <- attributes(x)$name

    x_permuted <- f(
      x = as.matrix(x),
      block_size = block_size,
      seed = seed
    )

    x_permuted <- zoo::zoo(
      x = x_permuted,
      order.by = zoo::index(x)
    )

    attr(
      x = x_permuted,
      which = "name"
    ) <- paste0(
      x_name,
      "_",
      as.character(i)
      )

    x_permuted

  }

  if(is.list(permutations) == FALSE){

    permutations <- list(permutations)

  }

  names(permutations) <- as.character(repetitions)

  # permutations <- tsl_names_set(
  #   tsl = permutations
  # )

  permutations

}


