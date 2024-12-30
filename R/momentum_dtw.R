#' Dynamic Time Warping Variable Importance Analysis of Multivariate Time Series Lists
#'
#' @description
#' Minimalistic but slightly faster version of [momentum()] to compute dynamic time warping importance analysis with the "robust" setup in multivariate time series lists.
#'
#' @inheritParams momentum
#'
#' @return data frame:
#' \itemize{
#'   \item `x`: name of the time series `x`.
#'   \item `y`: name of the time series `y`.
#'   \item `psi`: psi score of `x` and `y`.
#'   \item `variable`: name of the individual variable.
#'   \item `importance`: importance score of the variable.
#'   \item `effect`: interpretation of the "importance" column, with the values "increases similarity" and "decreases similarity".
#' }
#' @export
#' @autoglobal
#' @examples
#'
#' tsl <- tsl_initialize(
#'   x = distantia::albatross,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' df <- momentum_dtw(
#'   tsl = tsl,
#'   distance = "euclidean"
#'   )
#'
#' #focus on important columns
#' df[, c(
#'   "x",
#'   "y",
#'   "variable",
#'   "importance",
#'   "effect"
#'   )]
#'
#' @family momentum
momentum_dtw <- function(
    tsl = NULL,
    distance = "euclidean"
){

  #check input arguments
  args <- utils_check_args_momentum(
    tsl = tsl,
    distance = distance
  )

  tsl <- args$tsl
  distance <- args$distance

  if(length(distance) > 1){

    distance <- distance[1]

    message(
      "distantia::momentum_dtw(): Using first value of the 'distance' argument."
    )

  }

  #stop if tsl is univariate
  tsl_ncol <- tsl_ncol(tsl = tsl) |>
    unlist() |>
    unique()

  if(1 %in% tsl_ncol){
    stop(
      "distantia::momentum_dtw(): variable contribution analysis requires multivariate time series, but 'tsl' contains univariate time series.",
      call. = FALSE
    )
  }

  #tsl pairs
  df <- utils_tsl_pairs(
    tsl = tsl,
    args_list = list(
      distance = distance
    )
  )

  iterations <- seq_len(nrow(df))

  #iterate over pairs of time series
  df <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

    df.i <- df[i, ]

    importance.i <- importance_dtw_cpp(
      x = tsl[[df.i[["x"]]]],
      y = tsl[[df.i[["y"]]]],
      distance = df.i[["distance"]],
      diagonal = TRUE,
      bandwidth = 1
    )

    #set NaN to zero for constant pairs of sequences
    importance.i[is.na(importance.i)] <- 0

    importance.i <- merge(
      x = df.i,
      y = importance.i
    )

    return(importance.i)

  } #end of loop

  #interpretation
  df$effect <- ifelse(
    test = df$importance > 0,
    yes = "decreases similarity",
    no = "increases similarity"
  )

  df <- df[
    , c(
      "x",
      "y",
      "psi",
      "variable",
      "importance",
      "effect"
    )
  ]

  attr(
    x = df,
    which = "type"
  ) <- "momentum_df"

  df

}
