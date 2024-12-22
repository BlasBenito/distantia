#' Lock-Step Variable Importance Analysis of Multivariate Time Series Lists
#'
#' @description
#' Minimalistic but slightly faster version of [momentum()] to compute lock-step importance analysis in multivariate time series lists.
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
#' df <- momentum_lock_step(
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
momentum_lock_step <- function(
    tsl = NULL,
    distance = "euclidean"
){

  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance
  )

  tsl <- args$tsl
  distance <- args$distance

  if(length(distance) > 1){

    distance <- distance[1]

    message(
      "distantia::momentum_lock_step(): Using first value of the 'distance' argument."
    )

  }

  #count rows in time series
  row_counts <- tsl |>
    tsl_nrow() |>
    unlist() |>
    unique()

  if(length(row_counts) > 1){

    stop(
      "distantia::momentum_lock_step(): time series in 'tsl' do not have the same number of rows, cannot perform a lock-step analysis.",
      call. = FALSE
    )

  }

  #stop if tsl is univariate
  tsl_ncol <- tsl_ncol(tsl = tsl) |>
    unlist() |>
    unique()

  if(1 %in% tsl_ncol){
    stop(
      "distantia::momentum_lock_step(): variable contribution analysis requires multivariate time series, but 'tsl' contains univariate time series.",
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

    importance.i <- importance_lock_step_cpp(
      x = tsl[[df.i[["x"]]]],
      y = tsl[[df.i[["y"]]]],
      distance = df.i[["distance"]]
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
