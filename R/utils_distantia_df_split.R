#' Splits Distantia Data Frame in Groups
#'
#' @description
#' Internal function to split a distantia data frame by groups of the arguments 'distance', 'diagonal', 'weighted', 'ignore_blocks', and 'lock_step'.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return list
#' @export
#' @autoglobal
#' @examples
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   id_column = "site",
#'   time_column = "date"
#' )
#'
#' #dissimilarity analysis with four combinations of parameters
#' df <- distantia(
#'   tsl = tsl,
#'   distance = c(
#'     "euclidean",
#'     "manhattan"
#'     ),
#'   lock_step = c(
#'     TRUE,
#'     FALSE
#'   )
#' )
#'
#' #split by combinations of parameters
#' df_split <- utils_distantia_df_split(
#'   df = df
#' )
#'
#' #print output
#' df_split
#'
#' #class and length of the output
#' class(df_split)
#' length(df_split)
#' @family internal
utils_distantia_df_split <- function(
    df = NULL
){

  df_type <- attributes(df)$type

  #required columns
  required_columns <- c(
    "distance",
    "diagonal",
    "weighted",
    "ignore_blocks",
    "lock_step"
  )

  if(any(!(required_columns %in% names(df)))){
    return(list(df))
  }

  # detect groups ----
  df_groups <- unique(
    df[, required_columns]
  )

  df_groups$group <- seq_len(nrow(df_groups))

  rownames(df_groups) <- NULL

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

  #set attributes
  for(i in seq_len(length(df_list))){

    attr(
      x = df_list[[i]],
      which = "type"
    ) <- df_type

  }

  df_list

}
