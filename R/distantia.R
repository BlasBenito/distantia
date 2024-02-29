#' Psi Distance Between Time Series
#'
#' @param x (required, list of matrices) list of input matrices generated with [tsl_prepare()].
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
#'
#' @return Data frame with the following columns:
#' \itemize{
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
#' }
#' @export
#' @autoglobal
distantia <- function(
    x = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    paired_samples = FALSE,
    repetitions = 0L,
    permutation = "restricted_by_row",
    block_size = 3,
    seed = 1
){

  #check input arguments
  arguments <- check_args(
    x = x,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples,
    repetitions = repetitions,
    block_size = block_size,
    seed = seed
  )

  list2env(
    x = arguments,
    envir = environment()
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

  if(repetitions == 0){

    #preparing output data frame
    argument_combinations <- expand.grid(
      distance = distance,
      diagonal = diagonal,
      weighted = weighted,
      ignore_blocks = ignore_blocks,
      paired_samples = paired_samples,
      stringsAsFactors = FALSE
    )

  } else {

    argument_combinations <- expand.grid(
      distance = distance,
      diagonal = diagonal,
      weighted = weighted,
      ignore_blocks = ignore_blocks,
      paired_samples = paired_samples,
      repetitions = repetitions,
      permutation = permutation,
      block_size = block_size,
      seed = seed,
      stringsAsFactors = FALSE
    )

  }

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

  if(repetitions > 0){
    df$null_mean <- NA
    df$null_sd <- NA
    df$p_value <- NA
  }

  iterations <- seq_len(nrow(df))

  if(requireNamespace("progressor", quietly = TRUE)){
    p <- progressr::progressor(along = iterations)
  } else {
    p <- function(...){}
  }


  `%iterator%` <- doFuture::`%dofuture%`

  psi_df <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    df.i <- df[i, ]

    xy <- prepare_xy(
      x = x[[df$name_b[i]]],
      y = x[[df$name_a[i]]],
      distance = distance,
      paired_samples = paired_samples
    )

    if(df$paired_samples[i] == TRUE){

      df.i$psi <- psi_paired_cpp(
        x = xy[[1]],
        y = xy[[2]],
        distance = df$distance[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_paired_cpp(
          x = xy[[1]],
          y = xy[[2]],
          distance = df$distance[i],
          repetitions = df$repetitions[i],
          permutation = df$permutation[i],
          block_size = df$block_size[i],
          seed = df$seed[i]
        )

      }

    } else {

      df.i$psi <- psi_cpp(
        x = xy[[1]],
        y = xy[[2]],
        distance = df$distance[i],
        diagonal = df$diagonal[i],
        weighted = df$weighted[i],
        ignore_blocks = df$ignore_blocks[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_cpp(
          x = xy[[1]],
          y = xy[[2]],
          distance = df$distance[i],
          diagonal = df$diagonal[i],
          weighted = df$weighted[i],
          ignore_blocks = df$ignore_blocks[i],
          repetitions = df$repetitions[i],
          permutation = df$permutation[i],
          block_size = df$block_size[i],
          seed = df$seed[i]
        )

        df.i$null_mean <- mean(psi_null)
        df.i$null_sd <- sd(psi_null)
        df.i$p_value <- sum(psi_null <= df.i$psi) / repetitions

      }

    }

    return(df.i)

  } #end of iterations

  #remove column paired samples
  if(length(paired_samples) == 1){
    if(paired_samples == FALSE){
      psi_df$paired_samples <- NULL
    }
  }

  psi_df

}
