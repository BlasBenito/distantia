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
#'   \item `paired_samples`: value of the argument `paired_samples`.
#'   \item `repetitions`: value of the argument `repetitions`.
#'   \item `permutation` (only if `repetitions > 0`): name of the permutation method used to compute p-values.
#'   \item `seed` (only if `repetitions > 0`): random seed used to in the permutations.
#'   \item `psi`: psi dissimilarity of the sequences `a` and `b`.
#'   \item `null_mean` (only if `repetitions > 0`): mean of the null distribution of psi values computed from the permutaitons.
#'   \item `null_sd` (only if `repetitions > 0`): standard deviation of the null distribution of psi values.
#'   \item `p_value`  (only if `repetitions > 0`): proportion of scores smaller or equal than `psi` in the null distribution.
#' )
#' @export
#' @autoglobal
distantia <- function(
    a = NULL,
    b = NULL,
    distance = c("euclidean", "manhattan"),
    diagonal = c(FALSE, TRUE),
    weighted = c(FALSE, TRUE),
    ignore_blocks = c(FALSE, TRUE),
    paired_samples = FALSE,
    repetitions = 100,
    permutation = "restricted_by_row",
    block_size = c(2, 3, 4),
    seed = 1
){

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

  #selecting distance
  distance <- match.arg(
    arg = distance,
    choices = c(
      distances$name,
      distances$abbreviation
    ),
    several.ok = TRUE
  )

  if(is.null(a)){
    stop("Argument 'a' must not be NULL.")
  }

  if(is.null(b)){
    stop("Argument 'b' must not be NULL.")
  }

  if(!any(class(a) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'a' must be a data frame or matrix.")
  }

  if(!any(class(b) %in% c("data.frame", "matrix", "vector"))){
    stop("Argument 'b' must be a data frame or matrix.")
  }

  #checking for NA
  if(sum(is.na(a)) > 0){
    stop("Argument 'a' has NA values. Please remove or imputate them before the distance computation.")
  }
  if(sum(is.na(b)) > 0){
    stop("Argument 'b' has NA values. Please remove or imputate them before the distance computation.")
  }

  #preprocessing data
  if(ncol(a) != ncol(b)){
    common.cols <- intersect(
      x = colnames(a),
      y = colnames(b)
    )
    a <- a[, common.cols]
    b <- b[, common.cols]
  }

  #capture row names
  a.names <- rownames(a)
  b.names <- rownames(b)

  if(!is.matrix(a)){
    a <- as.matrix(a)
  }

  if(!is.matrix(b)){
    b <- as.matrix(b)
  }

  if(paired_samples == TRUE && (nrow(a) != nrow(b))){
    stop("Arguments 'a' and 'b' must have the same number of rows when 'paired_samples = TRUE'.")
  }


  #distances that don't accept two zeros in same position
  if(
    any(
      c(
        "chi",
        "cos",
        "cosine"
      ) %in% distance
    )
  ){

    pseudozero <- mean(x = c(a, b)) * 0.0001
    a[a == 0] <- pseudozero
    b[b == 0] <- pseudozero

  }

  #preparing output data frame
  df <- expand.grid(
    name_a = "a",
    name_b = "b",
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
  df$weighted <- ifelse(
    test = df$diagonal == FALSE,
    yes = FALSE,
    no = df$weighted
  )

  #remove duplicates
  df <- unique(df)

  #add additional columns
  df$psi <- NA
  df$null_mean <- NA
  df$null_sd <- NA
  df$p_value <- NA

  #initialize psi_null
  psi_null <- NA

  #iterating over combinations of arguments
  for(i in seq_len(nrow(df))){

    if(df$paired_samples[i] == TRUE){

      psi_distance <- psi_paired_cpp(
        a = a,
        b = b,
        distance = df$distance[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_paired_cpp(
          a = a,
          b = b,
          distance = df$distance[i],
          repetitions = df$repetitions[i],
          permutation = df$permutation[i],
          block_size = block_size,
          seed = df$seed[i]
        )

      }

    } else {

      psi_distance <- psi_cpp(
        a = a,
        b = b,
        distance = df$distance[i],
        diagonal = df$diagonal[i],
        weighted = df$weighted[i],
        ignore_blocks = df$ignore_blocks[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_cpp(
          a = a,
          b = b,
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
    df$psi[i] <- psi_distance
    df$null_mean[i] <- mean(psi_null)
    df$null_sd[i] <- sd(psi_null)
    df$p_value[i] <- sum(psi_null <= psi_distance) / repetitions

  } #end of iterations

  #removing p-value columns
  if(repetitions == 0){
    df$permutation <- NULL
    df$null_mean <- NULL
    df$null_sd <- NULL
    df$p_value <- NULL
  }

  df

}
