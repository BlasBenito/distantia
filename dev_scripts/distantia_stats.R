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


distantia_stats <- function(
    df = NULL
){

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

  #to silence loading messages
  `%iterator%` <- suppressPackageStartupMessages(doFuture::`%dofuture%`)

  for_each <- suppressPackageStartupMessages(foreach::foreach)

  #computing stats
  stats_list <- for_each(
    i = seq_len(length(f)),
    .errorhandling = "pass"
  ) %iterator% {

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

