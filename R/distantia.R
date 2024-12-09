#' Dissimilarity Analysis of Time Series Lists
#'
#' @description
#'
#' This function combines *dynamic time warping* or *lock-step comparison* with the *psi dissimilarity score* and *permutation methods* to assess dissimilarity between pairs time series or any other sort of data composed of events ordered across a relevant dimension.
#'
#' **Dynamic Time Warping** (DTW) is an algorithm that finds the optimal alignment between two time series by minimizing the cumulative distance between them. It identifies the least-cost path through a distance matrix, which maps all points of one time series to another. The resulting sum of distances along this path serves as a measure of time series similarity. DTW disregards the exact timing of samples and focuses on their order, making it suitable for comparing both *regular and irregular time series of the same or different lengths*, such as phenological data from different latitudes or elevations, time series from various years or periods, and movement trajectories like migration paths.
#'
#' On the other hand, the **lock-step** method sums pairwise distances between samples in *regular or irregular time series of the same length*, preferably captured at the same times. This method is an alternative to dynamic time warping when the goal is to assess the synchronicity of two time series.
#'
#' The **psi score** normalizes the cumulative sum of distances between two time series by the cumulative sum of distances between their consecutive samples to generate a comparable dissimilarity score. If for two time series \eqn{x} and \eqn{y} \eqn{D_xy} represents the cumulative sum of distances between them, either resulting from dynamic time warping or the lock-step method, and \eqn{S_xy} represents the cumulative sum of distances of their consecutive samples, then the psi score can be computed in two ways depending on the scenario:
#'
#' **Equation 1:** \eqn{\psi = \frac{D_{xy} - S_{xy}}{S_{xy}}}
#'
#' **Equation 2:** \eqn{\psi = \frac{D_{xy} - S_{xy}}{S_{xy}} + 1}
#'
#' When $D_xy$ is computed via dynamic time warping **ignoring the distance matrix diagonals** (`diagonal = FALSE`), then *Equation 1* is used. On the other hand, if $D_xy$ results from the lock-step method (`lock_step = TRUE`), or from dynamic time warping considering diagonals (`diagonal = TRUE`), then *Equation 2* is used instead:
#'
#' In both equations, a psi score of zero indicates maximum similarity.
#'
#' **Permutation methods** are provided here to help assess the robustness of observed psi scores by direct comparison with a null distribution of psi scores resulting from randomized versions of the compared time series. The fraction of null scores smaller than the observed score is returned as a *p_value* in the function output and interpreted as "the probability of finding a higher similarity (lower psi score) by chance".
#'
#'  In essence, restricted permutation is useful to answer the question "how robust is the similarity between two time series?"
#'
#' Four different permutation methods are available:
#' \itemize{
#'   \item **"restricted"**: Separates the data into blocks of contiguous rows, and re-shuffles data points randomly within these blocks, independently by row and column. Applied when the data is structured in blocks that should be preserved during permutations (e.g., "seasons", "years", "decades", etc) and the columns represent independent variables.
#'   \item **"restricted_by_row"**: Separates the data into blocks of contiguous rows, and re-shuffles complete rows within these blocks. This method is suitable for cases where the data is organized into blocks as described above, but columns represent interdependent data (e.g., rows represent percentages or proportions), and maintaining the relationships between data within each row is important.
#'   \item **"free"**: Randomly re-shuffles data points across the entire time series, independently by row and column. This method is useful for loosely structured time series where data independence is assumed. When the data exhibits a strong temporal structure, this approach may lead to an overestimation of the robustness of dissimilarity scores.
#'   \item **"free_by_row"**: Randomly re-shuffles complete rows across the entire time series. This method is useful for loosely structured time series where dependency between columns is assumed (e.g., rows represent percentages or proportions). This method has the same drawbacks as the "free" method, when the data exhibits a strong temporal structure.
#' }
#'
#' This function allows computing dissimilarity between pairs of time series using different combinations of arguments at once. For example, when the argument `distance` is set to `c("euclidean", "manhattan")`, the output data frame will show two dissimilarity scores for each pair of time series, one based on euclidean distances, and another based on manhattan distances. The same happens for most other parameters.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, time series list) list of zoo time series. Default: NULL
#' @param distance (optional, character vector) name or abbreviation of the distance method. Valid values are in the columns "names" and "abbreviation" of the dataset [distances]. Default: "euclidean".
#' @param diagonal (optional, logical vector). If TRUE, diagonals are included in the dynamic time warping computation. Default: TRUE
#' @param weighted (optional, logical vector) If TRUE, diagonal is set to TRUE, and diagonal cost is weighted by a factor of 1.414214. Default: TRUE
#' @param ignore_blocks (optional, logical vector). If TRUE, blocks of consecutive least cost path coordinates are trimmed to avoid inflating the psi dissimilarity Irrelevant if `diagonal = TRUE`. Default: FALSE.
#' @param lock_step (optional, logical vector) If TRUE, time series captured at the same times are compared sample wise (with no dynamic time warping). Requires time series in argument `tsl` to be fully aligned, or it will return an error. Default: FALSE.
#' @param repetitions (optional, integer vector) number of permutations to compute the p-value. If 0, p-values are not computed. Otherwise, the minimum is 2. The resolution of the p-values and the overall computation time depends on the number of permutations. Default: 0
#' @param permutation (optional, character vector) permutation method, only relevant when `repetitions` is higher than zero. Valid values are: "restricted_by_row", "restricted", "free_by_row", and "free". Default: "restricted_by_row".
#' @param block_size (optional, integer) Size of the row blocks for the restricted permutation test. Only relevant when permutation methods are "restricted" or "restricted_by_row" and `repetitions` is higher than zero. A block of size `n` indicates that a row can only be permuted within a block of `n` adjacent rows. If NULL, defaults to the rounded one tenth of the shortest time series in `tsl`. Default: NULL.
#' @param seed (optional, integer) initial random seed to use for replicability when computing p-values. Default: 1
#'
#' @return data frame with columns:
#' \itemize{
#'   \item `x`: time series name.
#'   \item `y`: time series name.
#'   \item `distance`: name of the distance metric.
#'   \item `diagonal`: value of the argument `diagonal`.
#'   \item `weighted`: value of the argument `weighted`.
#'   \item `ignore_blocks`: value of the argument `ignore_blocks`.
#'   \item `lock_step`: value of the argument `lock_step`.
#'   \item `repetitions` (only if `repetitions > 0`): value of the argument `repetitions`.
#'   \item `permutation` (only if `repetitions > 0`): name of the permutation method used to compute p-values.
#'   \item `seed` (only if `repetitions > 0`): random seed used to in the permutations.
#'   \item `psi`: psi dissimilarity of the sequences `x` and `y`.
#'   \item `null_mean` (only if `repetitions > 0`): mean of the null distribution of psi scores.
#'   \item `null_sd` (only if `repetitions > 0`): standard deviation of the null distribution of psi values.
#'   \item `p_value`  (only if `repetitions > 0`): proportion of scores smaller or equal than `psi` in the null distribution.
#' }
#' @export
#' @autoglobal
#' @examples
#' #parallelization setup (not worth it for this data size)
#' future::plan(
#'   future::multisession,
#'   workers = 2 #set to parallelly::availableCores() - 1
#' )
#'
#' #progress bar
#' # progressr::handlers(global = TRUE)
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
#' #-------------------------------------------
#' #permutation restricted by row because
#' #ndvi depends on temperature and rainfall
#' #block size is 6 because data is monthly
#' #to keep permutation restricted to 6 months periods
#' df_dtw <- distantia(
#'   tsl = tsl,
#'   distance = "euclidean",
#'   repetitions = 10, #increase to 100 or more
#'   permutation = "restricted_by_row",
#'   block_size = 6,
#'   seed = 1
#' )
#'
#' #focus on the important details
#' df_dtw[, c("x", "y", "psi", "p_value")]
#' #smaller psi values indicate higher similarity
#' #with small `repetitions` they all look the same though
#' #p-values indicate chance of
#' #finding a psi smaller than the observed
#'
#' #visualize dynamic time warping
#' if(interactive()){
#'
#'   distantia_plot(
#'     tsl = tsl[c("Spain", "Sweden")],
#'     distance = "euclidean",
#'     matrix_type = "cost"
#'   )
#'
#' }
#'
#' #recreating the null distribution
#' #direct call to C++ function
#' #use same args as in distantia() call
#' psi_null <- null_psi_dynamic_time_warping_cpp(
#'   x = tsl[["Spain"]],
#'   y = tsl[["Sweden"]],
#'   repetitions = 10, #increase to 100 or more
#'   distance = "euclidean",
#'   permutation = "restricted_by_row",
#'   block_size = 6,
#'   seed = 1
#' )
#'
#' #compare null mean with output of distantia()
#' mean(psi_null)
#' df_dtw$null_mean[3]
#'
#' #disable parallelization
#' future::plan(
#'   future::sequential
#' )
#' @family dissimilarity_analysis_main
distantia <- function(
    tsl = NULL,
    distance = "euclidean",
    diagonal = TRUE,
    weighted = TRUE,
    ignore_blocks = FALSE,
    lock_step = FALSE,
    repetitions = 0L,
    permutation = "restricted_by_row",
    block_size = NULL,
    seed = 1L
){

  #check input arguments
  args <- utils_check_args_distantia(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    weighted = weighted,
    ignore_blocks = ignore_blocks,
    lock_step = lock_step,
    repetitions = repetitions,
    permutation = permutation,
    block_size = block_size,
    seed = seed
  )

  tsl <- args$tsl
  distance <- args$distance
  diagonal <- args$diagonal
  weighted <- args$weighted
  ignore_blocks <- args$ignore_blocks
  lock_step <- args$lock_step
  repetitions <- args$repetitions
  permutation <- args$permutation
  block_size <- args$block_size
  seed <- args$seed


  #iterations data
  if(repetitions == 0){

    df <- utils_tsl_pairs(
      tsl = tsl,
      args_list = list(
        distance = distance,
        diagonal = diagonal,
        weighted = weighted,
        ignore_blocks = ignore_blocks,
        lock_step = lock_step
      )
    )

  } else {

    df <- utils_tsl_pairs(
      tsl = tsl,
      args_list = list(
        distance = distance,
        diagonal = diagonal,
        weighted = weighted,
        ignore_blocks = ignore_blocks,
        lock_step = lock_step,
        repetitions = repetitions,
        permutation = permutation,
        block_size = block_size,
        seed = seed
      )
    )

  }

  #add additional columns
  df$psi <- NA

  if(repetitions > 0){
    df$null_mean <- NA
    df$null_sd <- NA
    df$p_value <- NA
  }

  iterations <- seq_len(nrow(df))

  p <- progressr::progressor(along = iterations)

  `%iterator%` <- doFuture::`%dofuture%`

  df_distantia <- foreach::foreach(
    i = iterations,
    .combine = "rbind",
    .errorhandling = "pass",
    .options.future = list(seed = FALSE)
  ) %iterator% {

    p()

    df.i <- df[i, ]

    x <- tsl[[df.i$x]]
    y <- tsl[[df.i$y]]

    if(df$lock_step[i] == TRUE){

      df.i$psi <- psi_lock_step_cpp(
        x = x,
        y = y,
        distance = df.i$distance
      )

      if(repetitions > 0){

        psi_null <- null_psi_lock_step_cpp(
          x = x,
          y = y,
          distance = df.i$distance,
          repetitions = df.i$repetitions,
          permutation = df.i$permutation,
          block_size = df.i$block_size,
          seed = df.i$seed
        )

        df.i$p_value <- sum(psi_null <= df.i$psi) / repetitions
        df.i$null_mean <- mean(psi_null)
        df.i$null_sd <- stats::sd(psi_null)

      }

    } else {

      #TODO: disaggregate this step to analyze repeats in the least cost path
      df.i$psi <- psi_dynamic_time_warping_cpp(
        x = x,
        y = y,
        distance = df.i$distance,
        diagonal = df.i$diagonal,
        weighted = df.i$weighted,
        ignore_blocks = df.i$ignore_blocks
      )

      if(repetitions > 0){

        psi_null <- null_psi_dynamic_time_warping_cpp(
          x = x,
          y = y,
          distance = df.i$distance,
          diagonal = df.i$diagonal,
          weighted = df.i$weighted,
          ignore_blocks = df.i$ignore_blocks,
          repetitions = df.i$repetitions,
          permutation = df.i$permutation,
          block_size = df.i$block_size,
          seed = df.i$seed
        )

        df.i$p_value <- sum(psi_null <= df.i$psi) / repetitions
        df.i$null_mean <- mean(psi_null)
        df.i$null_sd <- stats::sd(psi_null)

      }

    }

    return(df.i)

  } |>
    suppressWarnings() #to remove future warning about random seed

  df_distantia <- df_distantia[order(df_distantia$psi), ]

  #add type
  attr(
    x = df_distantia,
    which = "type"
  ) <- "distantia_df"

  df_distantia

}
