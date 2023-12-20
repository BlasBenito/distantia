#' Psi Distance Between Time Series
#'
#' @param a (required, data frame or matrix) a time series.
#' @param b (required, data frame or matrix) a time series.
#' @param method (optional, character string) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `methods`. Default: "euclidean".
#' @param diagonal (optional, logical). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#' @param repetitions (optional, integer) number of permutations to compute the p-value (interpreted as the probability of finding a smaller dissimilarity on permuted versions of the sequences) of the psi distance. If 0, p-values are not computed. Otherwise, the minimum is 2. Default: 0
#' @param permutation (optional, character) permutation method. Valid values are listed below from higher to lower randomness:
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
#'   method = "manhattan"
#' )
#'
#' @return Data frame with names of the sequences, combinations of arguments method, diagonal, weighted, and trim blocks, psi distance, and if `p_value = TRUE`, mean and standard deviation of the null distribution for the psi distance, and the p_value, interpreted as the probability of finding psi distances smaller than the observed one in permuted versions of the sequences.
#' @export
#' @autoglobal
distantia <- function(
    a = NULL,
    b = NULL,
    method = c("euclidean", "manhattan"),
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

  #selecting method
  method <- match.arg(
    arg = method,
    choices = c(
      methods$name,
      methods$abbreviation
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


  #methods that don't accept two zeros in same position
  if(
    any(
      c(
        "chi",
        "cos",
        "cosine"
      ) %in% method
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
    method = method,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    permutation = permutation,
    seed = seed,
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(
      diagonal = ifelse(
        test = weighted == TRUE,
        yes = TRUE,
        no = FALSE
      ),
      psi = NA,
      null_mean = NA,
      null_sd = NA,
      p_value = NA
    ) |>
    dplyr::distinct()

  #initialize psi_null
  psi_null <- NA

  #iterating over combinations of arguments
  for(i in seq_len(nrow(df))){

    if(paired_samples == TRUE){

      psi_distance <- psi_paired_cpp(
        a = a,
        b = b,
        method = df$method[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_paired_cpp(
          a = a,
          b = b,
          method = df$method[i],
          repetitions = repetitions,
          permutation = df$permutation[i],
          block_size = block_size,
          seed = df$seed[i]
        )

      }

    } else {

      psi_distance <- psi_cpp(
        a = a,
        b = b,
        method = df$method[i],
        diagonal = df$diagonal[i],
        weighted = df$weighted[i],
        ignore_blocks = df$ignore_blocks[i]
      )

      if(repetitions > 0){

        psi_null <- null_psi_cpp(
          a = a,
          b = b,
          method = df$method[i],
          diagonal = df$diagonal[i],
          weighted = df$weighted[i],
          ignore_blocks = df$ignore_blocks[i],
          repetitions = repetitions,
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
    df$null_mean <- NULL
    df$null_sd <- NULL
    df$p_value <- NULL
  }

  df

}
