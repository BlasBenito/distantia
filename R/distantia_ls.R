#' Lock-Step Dissimilarity Analysis of Time Series Lists
#'
#' @description
#'
#' Minimalistic but slightly faster version of [distantia()] to compute lock-step dissimilarity scores.
#'
#' @inheritParams distantia
#'
#' @return data frame:
#' \itemize{
#'   \item `x`: time series name.
#'   \item `y`: time series name.
#'   \item `distance`: name of the distance metric.
#'   \item `psi`: psi dissimilarity of the sequences `x` and `y`.
#' }
#' @export
#' @autoglobal
#' @examples
#'
#'#load fagus_dynamics as tsl
#'#global centering and scaling
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_transform(
#'     f = f_scale_global
#'   )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#' }
#'
#' #lock-step dissimilarity analysis
#' df_ls <- distantia_ls(
#'   tsl = tsl,
#'   distance = "euclidean"
#' )
#'
#' #focus on the important details
#' df_ls[, c("x", "y", "psi")]
#' 
#' @family distantia
distantia_ls <- function(
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
      "distantia::distantia_ls(): Using first value of the 'distance' argument."
      )

  }

  #count rows in time series
  row_counts <- tsl |>
    tsl_nrow() |>
    unlist() |>
    unique()

  if(length(row_counts) > 1){

    stop(
      "distantia::distantia_ls(): time series in 'tsl' do not have the same number of rows, cannot perform a lock-step analysis.",
      call. = FALSE
    )

  }

  df <- utils_tsl_pairs(
    tsl = tsl,
    args_list = list(
      distance = distance
    )
  )

  #add additional columns
  df$psi <- NA

  iterations <- seq_len(nrow(df))

  #iterate over pairs of time series
  df_distantia <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

    df.i <- df[i, ]

    df.i$psi <- psi_ls_cpp(
      x = tsl[[df.i[["x"]]]],
      y = tsl[[df.i[["y"]]]],
      distance = df.i[["distance"]]
    )

    return(df.i)

  }

  df_distantia <- df_distantia[order(df_distantia$psi), ]

  #add type
  attr(
    x = df_distantia,
    which = "type"
  ) <- "distantia_df"

  df_distantia

}
