#' Summary Statistics of Importance Data Frame
#' @description
#' Computes summary statistics from the output of [momentum()], returning a data frame with one row per variable and summary statistics of its importance scores across all time series pairs.
#'
#' @inheritParams momentum_aggregate
#'
#' @return data frame
#' @export
#' @autoglobal
#' @examples
#' tsl <- tsl_simulate(
#'   n = 5,
#'   irregular = FALSE
#'   )
#'
#' df <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#'   )
#'
#' df_stats <- distantia_stats(df = df)
#'
#' df_stats
#' 
#' @family momentum_support
momentum_stats <- function(
    df = NULL
){

  df_type <- attributes(df)$type

  if(df_type != "momentum_df"){
    stop("distantia::momentum_stats(): argument 'df' must be the output of distantia::momentum().", call. = FALSE)
  }

  df <- momentum_aggregate(
    df = df
  )

  #warn and drop NA importance before computing stats
  df_has_na <- is.na(df[["importance"]])
  if(any(df_has_na)){
    warning(
      "distantia::momentum_stats(): ",
      sum(df_has_na),
      " NA importance value(s) excluded from summary statistics.",
      call. = FALSE
    )
    df <- df[!df_has_na, ]
  }

  #stats functions
  q1 <- function(x = NULL){
    stats::quantile(
      x = x,
      probs = 0.25,
      na.rm = TRUE
    )
  }

  q3 <- function(x = NULL){
    stats::quantile(
      x = x,
      probs = 0.75,
      na.rm = TRUE
    )
  }

  f <- c(
    mean,
    min,
    q1,
    stats::median,
    q3,
    max,
    sd
  )

  names(f) <- c(
    "mean",
    "min",
    "q1",
    "median",
    "q3",
    "max",
    "sd"
  )

  #progress bar

  p <- progressr::progressor(along = f)



  #computing stats
  stats_list <- foreach::foreach(
    i = seq_len(length(f)),
    .errorhandling = "pass",
    .options.future = list(seed = FALSE)
  ) %dofuture% {

    p()

    df.i <- stats::aggregate(
      importance ~ variable,
      data = df,
      FUN = f[[i]]
    )

    colnames(df.i) <- c(
      "variable", names(f)[i]
    )

    df.i

  }

  df_stats <- Reduce(
    f = function(x, y){
      merge(x, y, by = "variable")
    },
    x = stats_list
  )

  df_stats$range <- df_stats$max - df_stats$min

  df_stats

}

