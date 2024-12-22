#' Stats of Dissimilarity Data Frame
#' @description
#' Takes the output of [distantia()] to return a data frame with one row per time series with the stats of its dissimilarity scores with all other time series.
#'
#' @inheritParams distantia_aggregate
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

  #stats functions
  q1 <- function(x = NULL){
    stats::quantile(
      x = x,
      probs = 0.25
    )
  }

  q3 <- function(x = NULL){
    stats::quantile(
      x = x,
      probs = 0.75
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
      x = df,
      by = importance ~ variable,
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

