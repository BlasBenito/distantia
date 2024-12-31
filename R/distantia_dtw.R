#' Dynamic Time Warping Dissimilarity Analysis of Time Series Lists
#'
#' @description
#'
#' Minimalistic but slightly faster version of [distantia()] to compute dynamic time warping dissimilarity scores using diagonal least cost paths.
#'
#' @inheritParams distantia
#'
#' @return data frame with columns:
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
#' #dynamic time warping dissimilarity analysis
#' df_dtw <- distantia_dtw(
#'   tsl = tsl,
#'   distance = "euclidean"
#' )
#'
#' df_dtw[, c("x", "y", "psi")]
#'
#' #visualize dynamic time warping
#' if(interactive()){
#'
#'   distantia_dtw_plot(
#'     tsl = tsl[c("Spain", "Sweden")],
#'     distance = "euclidean"
#'   )
#'
#' }
#'
#'
#' @family distantia
distantia_dtw <- function(
    tsl = NULL,
    distance = "euclidean"
){


  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance
  )

  tsl <- args$tsl
  distance <- args$distance[1]

  df <- utils_tsl_pairs(
    tsl = tsl
  )

  #iterate over pairs of time series
  df$psi <- foreach::foreach(
    i = seq_len(nrow(df)),
    .combine = "c",
    .errorhandling = "pass",
    .options.future = list(seed = TRUE)
  ) %dofuture% {

   psi_dtw_cpp(
     x = tsl[[df[i, "x"]]],
     y = tsl[[df[i, "y"]]],
      distance = distance,
      diagonal = TRUE,
      bandwidth = 1
    )

  }

  df <- df[order(df$psi), ]

  #add type
  attr(
    x = df,
    which = "type"
  ) <- "distantia_df"

  df

}
