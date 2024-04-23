#' Distantia Data Frame to Distance Matrix
#'
#' @description
#' The output of [distantia()] is a data frame of dissimilarity scores between pairs of time series in a time series list. This function transforms such data frame into a list of distance matrices.
#'
#' The number of matrices the output list depends on how many combinations of the [distantia()] arguments `distance`, `diagonal`, `weighted`, and `ignore_blocks` are in `df`, and in whether the aggregation function `f` is provided or not.
#'
#' If there is a single combination of arguments, or if a valid `f` is provided, a list with one distance matrix is returned. If there are several combinations of arguments and `f` is not provided, the list contains as many matrices as combinations of arguments.
#'
#' If provided, the aggregation function `f` is applied after scaling dissimilarity scores separately by group.
#'
#' @param df (required, data frame) Output of [distantia()]. Default: NULL
#' @param f (optional, function) Function to summarize psi scores (for example, `mean`) when there are several combinations of parameters in `df`. Ignored when there is a single combination of [distantia()] arguments in the input. Default: NULL
#' @param ... (optional, arguments of `f`) Further arguments to pass to the function `f`.
#'
#' @return List of distance matrices.
#' @export
#' @autoglobal
#' @examples
distantia_to_matrix <- function(
    df = NULL,
    f = NULL,
    ...
){

  # tsl <- tsl_simulate(
  #   n = 6,
  #   time_range = c(
  #     "0100-01-01 12:00:25",
  #     "2024-12-31 11:15:45"
  #   )
  # )
  #
  # df <- distantia(
  #   tsl = tsl
  # )
  #
  # df <- distantia(
  #   tsl = tsl,
  #   distance = c("euclidean", "manhattan")
  # )
  #
  # f <- mean

  # check df ----
  df_names <- c(
    "x",
    "y",
    "distance",
    "diagonal",
    "weighted",
    "ignore_blocks",
    "psi"
  )

  if(
    !is.data.frame(df) ||
    !any(df_names %in% names(df))
    ){
    stop("Argument 'df' must be a data frame returned by distantia().")
  }

  # detect groups ----
  df_groups <- unique(df[, c("distance", "diagonal", "weighted", "ignore_blocks")])
  df_groups$group <- seq_len(nrow(df_groups))

  #add group to df ----
  df <- merge(
    x = df,
    y = df_groups
  )

  # split ----
  df_list <- split(
    x = df,
    f = df$group
  )

  # argument f is provided ----
  if(nrow(df_groups) == 1){
    f <- NULL
  }

  if(!is.null(f)){

    if(is.function(f) == FALSE){
      stop(
        "Argument 'f' must be a function name such as 'min', 'max', 'mean', 'median', or 'quantile'."
      )
    }

    # scale psi by group----
    df_list <- lapply(
      X = df_list,
      FUN = function(x){
        x$psi <- scale(x = x$psi)
        x
      }
    )

    df <- do.call(
      what = "rbind",
      args = df_list
    )

    # aggregate ----
    df <- stats::aggregate(
      x = df,
      by = psi ~ x + y,
      FUN = f#,
      #... = ...
    )

    names(df)[3] <- "psi"

    df_list <- list(df)

  }

  # distance matrices
  #TODO




}
