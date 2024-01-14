#' Arrange Sequences by Similarity
#'
#' @description
#' Arranges sequences in a list by similarity. This is an internal function for the [combine()] function.
#'
#' @param x (required, list of matrices) list of input matrices generated with [prepare_sequences()].
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset `distances`. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the computation of the cost matrix. Default: FALSE.
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: FALSE.
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive path coordinates are trimmed to avoid inflating the psi distance. Default: FALSE.
#' @param paired_samples (optional, logical vector) If TRUE, time-series are compared row wise and no least-cost path is computed. Default: FALSE.
#'
#' @return Vector with names of `x` ordered from higher to lower similarity with the previous sequences. The first two sequences are the most similar ones.
#' @export
#' @autoglobal
arrange_by_similarity <- function(
    x = NULL,
    distance = "euclidean",
    diagonal = FALSE,
    weighted = FALSE,
    ignore_blocks = FALSE,
    paired_samples = FALSE
    ){

  x.distantia <- distantia(
    x = x,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    paired_samples = paired_samples
  )

  x.distantia <- x.distantia[order(x.distantia$psi), ]

  x.order <- vector()

  for(i in seq_len(nrow(x.distantia))){

    x.order <- c(
      x.order,
      ifelse(
        test = x.distantia$name_a[i] %in% x.order,
        yes = NA,
        no = x.distantia$name_a[i]
      ),
      ifelse(
        test = x.distantia$name_b[i] %in% x.order,
        yes = NA,
        no = x.distantia$name_b[i]
      )
    )

  }

  x.order <- as.character(na.omit(x.order))

  x <- x[x.order]

  x

}
