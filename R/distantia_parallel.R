#' Psi Distance Between Time Series
#'
#' @param a (required, data frame or matrix) a time series.
#' @param b (required, data frame or matrix) a time series.
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
#' @param block_size (optional, integer vector) vector with block sizes for the restricted permutation test. A block of size 3 indicates that a row can only be permuted within a block of 3 adjacent rows. If several values are provided, one is selected at random separately for each sequence on each repetition. Only relevant when permutation methods are "restricted" or "restricted_by_row". Default: 3.
#' @param seed (optional, integer) initial random seed to use for replicability when computing p-values. Default: 1
#' @param workers (optional, integer) number of workers used to run the function in parallel. Requires the libraries `future` and `doFuture`. Default: 1
#' @examples
#'
#' data(
#'   sequenceA,
#'   sequenceB
#' )
#'
#' ab.psi <- distantia(
#'   a = sequenceA,
#'   b = sequenceB,
#'   distance = "manhattan"
#' )
#'
#' @return Data frame with the following columns:
#' \itemize(
#'   \item `name_a`: name of the sequence `a`.
#'   \item `name_bb`: name of the sequence `b`.
#'   \item `distance`: name of the distance metric.
#'   \item `diagonal`: value of the argument `diagonal`.
#'   \item `weighted`: value of the argument `weighted`.
#'   \item `ignore_blocks`: value of the argument `ignore_blocks`.
#'   \item `paired_samples`: value of the argument `paired_samples`. Only available if TRUE appears in the argument and the sequences have the same number of rows.
#'   \item `repetitions` (only if `repetitions > 0`): value of the argument `repetitions`.
#'   \item `permutation` (only if `repetitions > 0`): name of the permutation method used to compute p-values.
#'   \item `seed` (only if `repetitions > 0`): random seed used to in the permutations.
#'   \item `null_mean` (only if `repetitions > 0`): mean of the null distribution of psi values computed from the permutaitons.
#'   \item `null_sd` (only if `repetitions > 0`): standard deviation of the null distribution of psi values.
#'   \item `p_value`  (only if `repetitions > 0`): proportion of scores smaller or equal than `psi` in the null distribution.
#'   \item `psi`: psi dissimilarity of the sequences `a` and `b`.
#' )
#' @export
#' @autoglobal
distantia_parallel <- function(
    x = NULL,
    distance = c("euclidean"),
    diagonal = c(TRUE),
    weighted = c(TRUE),
    ignore_blocks = c(FALSE, TRUE),
    paired_samples = FALSE,
    repetitions = 10,
    permutation = "restricted_by_row",
    block_size = c(2, 3, 4),
    seed = 1,
    workers = 3
){

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

  #check arguments
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

  distance <- argument_distance(
    distance = distance
  )

  #combinations of sequences
  sequence_combinations <- data.frame(
    t(
      combn(
        names(x),
        m = 2
        )
      )
    )

  names(sequence_combinations) <- c(
    "name_a",
    "name_b"
  )

  #preparing output data frame
  argument_combinations <- expand.grid(
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples,
    repetitions = repetitions,
    permutation = permutation,
    seed = seed,
    stringsAsFactors = FALSE
  )

  #remove combinations diagonal = FALSE weighted = TRUE
  argument_combinations$weighted <- ifelse(
    test = argument_combinations$diagonal == FALSE,
    yes = FALSE,
    no = argument_combinations$weighted
  )

  #cross join
  df <- merge(
    x = sequence_combinations,
    y = argument_combinations
  )

  #remove duplicates
  df <- unique(df)

  #add additional columns
  df$psi <- NA
  df$null_mean <- NA
  df$null_sd <- NA
  df$p_value <- NA

  #parallelization setup
  # if(workers > 1){
  #
  #   if(
  #     requireNamespace("doFuture", quietly = TRUE)
  #   ){
  #
  #     future::plan(
  #       strategy = future::multisession,
  #       workers = workers
  #     )
  #
  #     #ignore warnings about rng during parallelization
  #     user.options <- options()
  #     options(doFuture.rng.onMisuse = "ignore")
  #     on.exit(expr = options(user.options))
  #
  #   } else {
  #
  #     future::plan(
  #       strategy = future::sequential()
  #     )
  #
  #   }
  #
  # }

  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  `%iterator%` <- doFuture::`%dofuture%` |>
    suppressPackageStartupMessages()

  psi_df <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    ab <- prepare_ab(
      a = x[[df$name_a[i]]],
      b = x[[df$name_b[i]]],
      distance = distance,
      paired_samples = paired_samples
    )

    if(repetitions == 0){
      psi_null <- NA
    }

    if(df$paired_samples[i] == TRUE){

      psi_distance <- psi_paired_cpp(
        a = ab[[1]],
        b = ab[[2]],
        distance = df$distance[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_paired_cpp(
          a = ab[[1]],
          b = ab[[2]],
          distance = df$distance[i],
          repetitions = df$repetitions[i],
          permutation = df$permutation[i],
          block_size = block_size,
          seed = df$seed[i]
        )

      }

    } else {

      psi_distance <- psi_cpp(
        a = ab[[1]],
        b = ab[[2]],
        distance = df$distance[i],
        diagonal = df$diagonal[i],
        weighted = df$weighted[i],
        ignore_blocks = df$ignore_blocks[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_cpp(
          a = ab[[1]],
          b = ab[[2]],
          distance = df$distance[i],
          diagonal = df$diagonal[i],
          weighted = df$weighted[i],
          ignore_blocks = df$ignore_blocks[i],
          repetitions = df$repetitions[i],
          permutation = df$permutation[i],
          block_size = block_size,
          seed = df$seed[i]
        )

      }

    }

    #storing iteration results
    df.i <- df[i, ]
    df.i$psi <- psi_distance
    df.i$null_mean <- mean(psi_null)
    df.i$null_sd <- sd(psi_null)
    df.i$p_value <- sum(psi_null <= psi_distance) / repetitions

    return(df.i)

  } #end of iterations

  #removing p-value columns
  if(repetitions == 0){
    psi_df$permutation <- NULL
    psi_df$repetitions <- NULL
    psi_df$null_mean <- NULL
    psi_df$null_sd <- NULL
    psi_df$p_value <- NULL
    psi_df$seed <- NULL
  }

  #remove column paired samples
  if(length(paired_samples) == 1){
    if(paired_samples == FALSE){
      psi_df$paired_samples <- NULL
    }
  }

  psi_df

}
