#' Summary Statistics of Dissimilarity Data Frame
#' @description
#' Computes summary statistics from the output of [distantia()], returning a data frame with one row per time series and summary statistics of its dissimilarity scores with all other time series.
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
#' @family distantia_support
#' 
distantia_stats <- function(
    df = NULL
){

  df_type <- attributes(df)$type

  if(df_type != "distantia_df"){
    stop("distantia::distantia_stats(): argument 'df' must be the output of distantia().", call. = FALSE)
  }

  df <- distantia_aggregate(
    df = df
  )

  #disaggregate pairs
  df <- rbind(
    data.frame(
      name = df[["x"]],
      psi = df[["psi"]]
    ),
    data.frame(
      name = df[["y"]],
      psi = df[["psi"]]
    )
  )

  #warn and drop NA psi before computing stats
  df_has_na <- is.na(df[["psi"]])
  if(any(df_has_na)){
    warning(
      "distantia::distantia_stats(): ",
      sum(df_has_na),
      " NA psi value(s) excluded from summary statistics.",
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

  #progress bar and iterator
  p <- progressr::progressor(along = f)

  #computing stats
  stats_list <- foreach::foreach(
    i = seq_len(length(f)),
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

    p()

    df.i <- stats::aggregate(
      psi ~ name,
      data = df,
      FUN = f[[i]]
    )

    colnames(df.i) <- c(
      "name", names(f)[i]
    )

    df.i

  }

  df_stats <- Reduce(
    f = function(x, y){
      merge(x, y, by = "name")
    },
    x = stats_list
  )

  df_stats$range <- df_stats$max - df_stats$min

  df_stats

}

