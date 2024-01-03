#' Importance of Individual Variables
#'
#' @description Importance assessment of the contribution of individual variables to the dissimilarity between two sequences. It requires computing psi separately for each variable (column "psi_only_with) and without each variable (column "psi_without"), and comparing these with the overall psi score (column "psi") of both sequences. Two importance indicators are computed from these psi scores:
#' \itemize{
#'   \item `psi_drop`: interpreted as "decrease in dissimilarity when a variable is removed" and computed as a percentage of the overall dissimilarity via the expression `((psi - psi_without) * 100)/psi`. Positive values indicate that a variable contributes to dissimilarity, while negative ones indicate contribution to similarity. This is the same metric of importance introduced in the first version of the package.
#'   \item `importance`: interpreted as "difference between the psi of a variable by itself and the psi of all other variables" also expressed as a percentage of the overall psi via the expression `((psi_only_with - psi_without) * 100)/psi`. As with `psi_drop`, positive values indicate a contribution to dissimilarity, while negative ones indicate the opposite. This is a new metric introduced with the version 2.0 of the package, and contains more information than `psi_drop`.
#' }
#'
#' Additionally, these importance scores can be computed in two different ways defined by the argument `robust`.
#' \itemize{
#'   \item `robust = TRUE` (default): "psi_only_with" and "psi_without" are computed using the least cost path found when computing psi for the complete sequences. This is a new version of the method that yields more stable and comparable solutions. This option returns the columns "psi_drop" and "importance".
#'   \item `robust = FALSE`: the least cost path of each combination of variables in "psi_only_with" and "psi_without" is computed independently, which makes individual importance scores harder to compare. This renders the "importance" column unreliable. However, the `psi_drop` score still remains as a useful metric of importance. Still, option is recommended only when replicating previous studies.
#' }
#'
#' When `paired_samples = TRUE` the computation method is only `robust`, as the comparison of paired samples does not require a least cost path.
#'
#' @param a (required, data frame or matrix) a time series.
#' @param b (required, data frame or matrix) a time series.
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#' @param robust (required, logical vector). If TRUE, importance scores are computed using the least cost path used to compute the psi dissimilarity between the two full sequences. Setting it to FALSE allows to replicate importance scores of the previous versions of this package. Default: TRUE
#' @return Data frame with the following columns:
#' \itemize{
#'   \item `name_a`: name of the sequence `a`.
#'   \item `name_bb`: name of the sequence `b`.
#'   \item `distance`: name of the distance metric.
#'   \item `diagonal`: value of the argument `diagonal`.
#'   \item `weighted`: value of the argument `weighted`.
#'   \item `ignore_blocks`: value of the argument `ignore_blocks`.
#'   \item `paired_samples`: value of the argument `paired_samples`.
#'   \item `robust`: value of the argument `robust`.
#'   \item `variable`: name of the individual variable.
#'   \item `psi`: overall psi score of `a` and `b`.
#'   \item `psi_only_with`: psi score of the variable.
#'   \item `psi_without`: psi score without the variable.
#'   \item `psi_difference`: difference between `psi_only_with` and `psi_without`.
#'   \item `psi_drop`: change in psi (as a percentage of the overall psi) when the variable is removed.
#'   \item `importance`: `psi_difference` as a precentage of `psi`. Only interpretable when `robust = TRUE`.
#' }
#' @export
#' @autoglobal
importance <- function(
    a = NULL,
    b = NULL,
    distance = c("euclidean", "manhattan"),
    diagonal = c(FALSE, TRUE),
    weighted = c(FALSE, TRUE),
    ignore_blocks = c(FALSE, TRUE),
    paired_samples = FALSE,
    robust = TRUE
){

  #selecting distance
  distance <- match.arg(
    arg = distance,
    choices = c(
      distances$name,
      distances$abbreviation
    ),
    several.ok = TRUE
  )

  abbreviation_indices <- which(distances$abbreviation %in% distance)

  distance[abbreviation_indices] <- distances$name[abbreviation_indices]

  distance <- unique(distance)


  #preparing iterations data frame
  df <- expand.grid(
    name_a = "a",
    name_b = "b",
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples,
    robust = robust,
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

  #list to store results
  out <- list()

  #iterating over df
  for(i in seq_len(nrow(df))){

    #TODO take a and b from list?
    ab <- prepare_ab(
      a = a,
      b = b,
      distance = distance,
      paired_samples = paired_samples
    )

    if(df$paired_samples[i] == TRUE){

      df$robust[i] <- TRUE

      importance.i <- importance_paired_cpp(
        a = ab$a,
        b = ab$b,
        distance = df$distance[i]
      )

    } else {

      if(df$robust[i] == TRUE){

        importance.i <- importance_robust_cpp(
          a = ab$a,
          b = ab$b,
          distance = df$distance[i],
          diagonal = df$diagonal[i],
          weighted = df$weighted[i],
          ignore_blocks = df$ignore_blocks[i]
        )

      } else {

        importance.i <- importance_cpp(
          a = ab$a,
          b = ab$b,
          distance = df$distance[i],
          diagonal = df$diagonal[i],
          weighted = df$weighted[i],
          ignore_blocks = df$ignore_blocks[i]
        )

      }

    } #end of importance.i


    #prepare output data frame
    importance.i$name_a <- df$name_a[i]
    importance.i$name_b <- df$name_b[i]
    importance.i$distance <- df$distance[i]
    importance.i$diagonal <- df$diagonal[i]
    importance.i$weighted <- df$weighted[i]
    importance.i$ignore_blocks <- df$ignore_blocks[i]
    importance.i$paired_samples <- df$paired_samples[i]
    importance.i$robust <- df$robust[i]

    #store importance data frame
    out[[i]] <- importance.i

  } #end of loop

  #list to data frame
  out.df <- do.call(
    what = "rbind",
    args = out
  )

  #subset columns
  out.df[,
         c(
           "name_a",
           "name_b",
           "distance",
           "diagonal",
           "weighted",
           "ignore_blocks",
           "paired_samples",
           "robust",
           "variable",
           "psi",
           "psi_only_with",
           "psi_without",
           "psi_difference",
           "psi_drop",
           "importance"
         )]

}
