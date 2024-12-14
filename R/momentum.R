#' Contribution of Individual Variables to Time Series Dissimilarity
#'
#' @description
#'
#' This function measures the contribution of individual variables to the dissimilarity between pairs of time series to help answer the question *what makes two time series more or less similar?*
#'
#' Three key values are required to assess individual variable contributions:
#' \itemize{
#'   \item **psi**: dissimilarity when all variables are considered.
#'   \item **psi_only_with**: dissimilarity when using only the target variable.
#'   \item **psi_without**: dissimilarity when removing the target variable.
#' }
#'
#' The values `psi_only_with` and `psi_without` can be computed in two different ways defined by the argument `robust`.
#' \itemize{
#'   \item `robust = FALSE`: This method replicates the importance algorithm released with the first version of the package, and it is only recommended when the goal to compare new results with previous studies. It normalizes `psi_only_with` and `psi_without` using the least cost path obtained from the individual variable. As different variables may have different least cost paths for the same time series, normalization values may change from variable to variable, making individual importance scores harder to compare.
#'   \item `robust = TRUE` (default, recommended): This a novel version of the importance algorithm that yields more stable and comparable solutions. It uses the least cost path of the complete time series to normalize `psi_only_with` and `psi_without`, making importance scores of separate variables fully comparable.
#' }
#'
#' The individual importance score of each variable (column "importance" in the output data frame) is based on different expressions depending on the `robust` argument, even when `lock_step = TRUE`:
#' \itemize{
#'   \item `robust = FALSE`: Importance is computed as `((psi - psi_without) * 100)/psi` and interpreted as "change in similarity when a variable is removed".
#'   \item `robust = TRUE`: Importance is computed as `((psi_only_with - psi_without) * 100)/psi` and interpreted as "relative dissimilarity induced by the variable expressed as a percentage".
#' }
#'
#' In either case, positive values indicate that the variable contributes to dissimilarity, while negative values indicate a net contribution to similarity.
#'
#' This function allows computing dissimilarity between pairs of time series using different combinations of arguments at once. For example, when the argument `distance` is set to `c("euclidean", "manhattan")`, the output data frame will show two dissimilarity scores for each pair of time series, one based on euclidean distances, and another based on manhattan distances. The same happens for most other parameters.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @inheritParams distantia
#' @param robust (required, logical). If TRUE (default), importance scores are computed using the least cost path of the complete time series as reference. Setting it to FALSE allows to replicate importance scores of the previous versions of this package. This option is irrelevant when `lock_step = TRUE`. Default: TRUE
#' @return data frame:
#' \itemize{
#'   \item `x`: name of the time series `x`.
#'   \item `y`: name of the time series `y`.
#'   \item `psi`: psi score of `x` and `y`.
#'   \item `variable`: name of the individual variable.
#'   \item `importance`: importance score of the variable.
#'   \item `psi_only_with`: psi score of the variable.
#'   \item `psi_without`: psi score without the variable.
#'   \item `psi_difference`: difference between `psi_only_with` and `psi_without`.
#'   \item `distance`: name of the distance metric.
#'   \item `diagonal`: value of the argument `diagonal`.
#'   \item `lock_step`: value of the argument `lock_step`.
#'   \item `robust`: value of the argument `robust`.
#' }
#' @export
#' @autoglobal
#' @examples
#' #parallelization setup (not worth it for this data size)
#' future::plan(
#'  future::multisession,
#'  workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' #progress bar
#' # progressr::handlers(global = TRUE)
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
#' df <- momentum(
#'   tsl = tsl,
#'   lock_step = TRUE #to speed-up example
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
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family dissimilarity_analysis_main
momentum <- function(
    tsl = NULL,
    distance = "euclidean",
    diagonal = TRUE,
    bandwidth = 1,
    lock_step = FALSE,
    robust = TRUE
){

  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    bandwidth = bandwidth,
    lock_step = lock_step,
    robust = robust
  )

  tsl <- args$tsl
  distance <- args$distance
  diagonal <- args$diagonal
  bandwidth <- args$bandwidth
  lock_step <- args$lock_step
  robust <- args$robust

  #lock-step check
  if(any(lock_step == TRUE)){

    #count rows in time series
    row_counts <- tsl |>
      tsl_nrow() |>
      unlist() |>
      unique()

    if(length(row_counts) > 1){

      message(
        "distantia::momentum(): argument 'lock_step' is TRUE, but time series in 'tsl' do not have the same number of rows. Setting 'lock_step' to FALSE."
      )

      lock_step <- FALSE

    }

  }



  #stop if tsl is univariate
  tsl_ncol <- tsl_ncol(tsl = tsl) |>
    unlist() |>
    unique()

  if(1 %in% tsl_ncol){
    warning("There are univariate time series in 'tsl', but importance scores only apply to multivariate time series.")
  }

  #tsl pairs
  df <- utils_tsl_pairs(
    tsl = tsl,
    args_list = list(
      distance = distance,
      diagonal = diagonal,
      bandwidth = bandwidth,
      lock_step = lock_step,
      robust = robust
    )
  )

  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  #to silence loading messages
  `%iterator%` <- doFuture::`%dofuture%` |>
    suppressMessages()

  df <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .options.future = list(seed = TRUE)
  ) %iterator% {

    p()

    df.i <- df[i, ]

    x <- tsl[[df.i$x]]
    y <- tsl[[df.i$y]]

    if(df.i$lock_step == TRUE){

      df.i$robust <- TRUE

      importance.i <- importance_lock_step_cpp(
        x = x,
        y = y,
        distance = df.i$distance
      )

      #replacing importance with psi_drop
      if(df.i$robust == FALSE){
        importance.i$importance <- importance.i$psi_drop
      }

      importance.i$psi_drop <- NULL

    } else {

      if(df.i$robust == TRUE){

        importance.i <- importance_dynamic_time_warping_robust_cpp(
          x = x,
          y = y,
          distance = df.i$distance,
          diagonal = df.i$diagonal,
          bandwidth = df.i$bandwidth
        )

      } else {

        importance.i <- importance_dynamic_time_warping_legacy_cpp(
          x = x,
          y = y,
          distance = df.i$distance,
          diagonal = df.i$diagonal
        )

      }

    } #end of importance i

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
      "effect",
      "psi_difference",
      "psi_without",
      "psi_only_with",
      "distance",
      "diagonal",
      "bandwidth",
      "lock_step",
      "robust"
    )
  ]

  attr(
    x = df,
    which = "type"
  ) <- "momentum_df"

  df

}
