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
      x = df,
      by = psi ~ name,
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

