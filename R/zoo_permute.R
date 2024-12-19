#' Random or Restricted Permutation of Zoo Time Series
#'
#' @description
#' Fast permutation of zoo time series for null model testing using a fast and efficient C++ implementations of different restricted and free permutation methods.
#'
#' The available permutation methods are:
#'
#' \itemize{
#'   \item "free" (see [permute_free_cpp()]): Unrestricted and independent re-shuffling of individual cases across rows and columns. Individual values are relocated to a new row and column within the dimensions of the original matrix.
#' \item "free_by_row" (see [permute_free_by_row_cpp()]): Unrestricted re-shuffling of complete rows. Each individual row is given a new random row number, and the data  matrix is re-ordered accordingly.
#' \item "restricted" (see [permute_restricted_cpp()]): Data re-shuffling across rows and columns is restricted to blocks of contiguous rows. The algorithm divides the data matrix into a set of blocks of contiguous rows, and individual cases are then assigned to a new row and column within their original block.
#' \item "restricted_by_row" (see [permute_restricted_by_row_cpp()]): Re-shuffling of complete rows is restricted to blocks of contiguous rows. The algorithm divides the data matrix into a set of blocks of contiguous rows, each individual row is given a new random row number within its original block, and the block is reordered accordingly to generate the permuted output.
#' }
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param x (required, zoo object) zoo time series. Default: NULL
#' @param repetitions (optional, integer) number of permutations to compute. Large numbers may compromise your R session. Default: 1
#' @param permutation (optional, character string) permutation method. Valid values are listed below from higher to lower induced randomness:
#' \itemize{
#'   \item "free": unrestricted re-shuffling of individual cases across rows and columns. Ignores block_size.
#'   \item "free_by_row": unrestricted re-shuffling of complete rows. Ignores block size.
#'   \item "restricted": restricted shuffling across rows and columns within blocks of rows.
#'   \item "restricted_by_row": restricted re-shuffling of rows within blocks.
#' }
#' @param block_size (optional, integer) Block size in number of rows for restricted permutations. Only relevant when permutation methods are "restricted" or "restricted_by_row". A block of size `n` indicates that the original data is pre-divided into blocks of such size, and a given row can only be permuted within their original block. If NULL, defaults to the rounded one tenth of the number of rows in `x`. Default: NULL.
#' @param seed (optional, integer) initial random seed to use during permutations. Default: 1
#'
#' @return Time Series List
#' @export
#' @autoglobal
#' @examples
#'
#' #simulate zoo time series
#' x <- zoo_simulate(cols = 2)
#'
#' if(interactive()){
#'   zoo_plot(x)
#' }
#'
#' #free
#' x_free <- zoo_permute(
#'   x = x,
#'   permutation = "free",
#'   repetitions = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = x_free,
#'     guide = FALSE
#'     )
#' }
#'
#' #free by row
#' x_free_by_row <- zoo_permute(
#'   x = x,
#'   permutation = "free_by_row",
#'   repetitions = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = x_free_by_row,
#'     guide = FALSE
#'   )
#' }
#'
#' #restricted
#' x_restricted <- zoo_permute(
#'   x = x,
#'   permutation = "restricted",
#'   repetitions = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = x_restricted,
#'     guide = FALSE
#'   )
#' }
#'
#' #restricted by row
#' x_restricted_by_row <- zoo_permute(
#'   x = x,
#'   permutation = "restricted_by_row",
#'   repetitions = 2
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = x_restricted_by_row,
#'     guide = FALSE
#'   )
#' }
#'
#' @family zoo_functions
zoo_permute <- function(
    x = NULL,
    repetitions = 1L,
    permutation = "restricted_by_row",
    block_size = NULL,
    seed = 1L
){

  #check x
  x <- utils_check_args_zoo(x = x)

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
    block_size = block_size
  )

  repetitions <- seq_len(repetitions)

  p <- progressr::progressor(along = repetitions)

  #to silence loading messages

  

  permutations <- foreach::foreach(
    i = repetitions,
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

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

    x_permuted <- zoo_name_set(
      x = x_permuted,
      name = paste0(
        x_name,
        "_",
        as.character(i)
      )
    )

    return(x_permuted)

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


