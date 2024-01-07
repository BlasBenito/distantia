#' Check Input Arguments
#'
#' @param x (required, list of matrices) list of input matrices generated with [prepare_sequences()].
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#' @param repetitions (optional, integer vector) number of permutations to compute the p-value (interpreted as the probability of finding a smaller dissimilarity on permuted versions of the sequences) of the psi distance. If 0, p-values are not computed. Otherwise, the minimum is 2. Default: 0
#' @param permutation (optional, character vector) permutation method. Valid values are listed below from higher to lower randomness:
#' \itemize{
#'   \item "free": unrestricted shuffling of rows and columns. Ignores block_size.
#'   \item "free_by_row": unrestricted shuffling of complete rows. Ignores block size.
#'   \item "restricted": restricted shuffling of rows and columns within blocks.
#'   \item "restricted_by_row": restricted shuffling of rows within blocks.
#' }
#' @param block_size (optional, integer vector) vector with block sizes in rows for the restricted permutation test. A block of size 3 indicates that a row can only be permuted within a block of 3 adjacent rows. If several values are provided, one is selected at random separately for each sequence on each repetition. Only relevant when permutation methods are "restricted" or "restricted_by_row". Default: 3.
#' @param seed (optional, integer) initial random seed to use for replicability when computing p-values. Default: 1
#' @param robust (required, logical vector). If TRUE, importance scores are computed using the least cost path used to compute the psi dissimilarity between the two full sequences. Setting it to FALSE allows to replicate importance scores of the previous versions of this package. Default: TRUE
#'
#' @return List with checked arguments
#' @export
#' @autoglobal
check_args <- function(
    x = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    paired_samples = FALSE,
    repetitions = 0,
    permutation = "restricted_by_row",
    block_size = 3,
    seed = 1,
    robust = TRUE
    ){

  x <- check_args_x(
    x = x
  )

  distance <- check_args_distance(
    distance = distance
  )

  logical_message <- "must be logical/boolean. Accepted values are; TRUE; FALSE; c(TRUE, FALSE)."

  if(any(is.logical(diagonal) == FALSE)){
    stop("Argument 'diagonal'", logical_message)
  }

  if(length(diagonal) == 1){
    if(diagonal == FALSE){
      weighted <- FALSE
    }
  }

  if(any(is.logical(weighted) == FALSE)){
    stop("Argument 'weighted'", logical_message)
  }

  if(any(is.logical(ignore_blocks) == FALSE)){
    stop("Argument 'ignore_blocks'", logical_message)
  }

  if(any(is.logical(paired_samples) == FALSE)){
    stop("Argument 'paired_samples'", logical_message)
  }

  if(exists("robust")){
    if(any(is.logical(robust) == FALSE)){
      stop("Argument 'robust'", logical_message)
    }
  }

  repetitions <- as.integer(repetitions)
  if(any(is.integer(repetitions) == FALSE)){
    stop("Argument 'repetitions' must be a integer or a numeric vector.")
  }

  if(repetitions > 0){

    permutation <- match.arg(
      arg = permutation,
      choices = c(
        "free",
        "free_by_row",
        "restricted",
        "restricted_by_row"
      ),
      several.ok = TRUE
    )

    block_size <- as.integer(block_size)
    if(any(is.integer(block_size) == FALSE)){
      stop("Argument 'block_size' must be a integer or a numeric vector.")
    }

    seed <- as.integer(seed)
    if(any(is.integer(seed) == FALSE)){
      stop("Argument 'block_size' must be a integer or a numeric vector.")
    }

  } else {

    permutation <- NULL
    block_size <- NULL
    seed <- NULL

  }

  out <- list(
    x = x,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples,
    repetitions = repetitions,
    permutation = permutation,
    block_size = block_size,
    seed = seed,
    robust = robust
  )

  out

}


#' Checks Argument x
#'
#' @param x (required, list of matrices) list of input matrices generated with [prepare_sequences()].
#'
#' @return Argument x.
#' @export
#' @autoglobal
check_args_x <- function(
    x = NULL
    ){

  if(is.null(x)){
    stop("Argument 'x' must not be NULL.")
  }

  #check input data
  if(inherits(x = x, what = "list") == FALSE){
    stop("Argument 'x' must be a list.")
  }

  validated <- lapply(
    X = x,
    FUN = function(x) attributes(x)$validated
  ) |>
    unlist() |>
    unique()

  if(validated != TRUE){
    warning("To avoid unintended issues during the dissimilarity analysis, it is recommended to validate argument 'x' with the function distantia::prepare_sequences().")
  }

  if(is.null(names(x))){
    names(x) <- paste0(
      "sequence_",
      as.character(seq(1, length(x)))
    )
    warning("Argument 'x' was not named. The new sequence names are: ", paste(names(x), collapse = ", "))
  }

  x


}

#' Check Distance Argument
#'
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#'
#' @return Character vector with distance names
#' @export
#' @autoglobal
#' @examples
#'
#' check_args_distance(
#'   distance = c(
#'     "euclidean",
#'     "euc"
#'    )
#'   )
#'
check_args_distance <- function(
    distance
    ){

  #checking distance values
  distance <- match.arg(
    arg = distance,
    choices = c(
      distances$name,
      distances$abbreviation
    ),
    several.ok = TRUE
  )

  #select rows of distances df
  distances_df <- distances[
    distances$name %in% distance |
      distances$abbreviation %in% distance,
  ]

  if(nrow(distances_df) == 0){
    stop("Please use distance names or abbreviations available in data(distances).")
  }

  distances_df$name


}
