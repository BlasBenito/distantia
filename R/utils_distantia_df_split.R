#' Splits Distantia Data Frame in Groups
#'
#' @description
#' Internal function to split a distantia data frame by groups of the arguments 'distance', 'diagonal', 'weighted', 'ignore_blocks', and 'lock_step'.
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return List of Distantia Data Frames
#' @export
#' @autoglobal
#' @examples
utils_distantia_df_split <- function(
    df = NULL
){

  df <- utils_check_distantia_df(
    df = df
  )

  #required columns
  required_columns <- c(
    "distance",
    "diagonal",
    "weighted",
    "ignore_blocks"
  )

  if(any(!(required_columns %in% names(df)))){
    return(list(df))
  }

  if("lock_step" %in% colnames(df)){
    required_columns <- c(required_columns, "lock_step")
  }

  # detect groups ----
  df_groups <- unique(
    df[, required_columns
    ]
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
    ) <- "distantia_df"

  }

  attr(
    x = df_list,
    which = "type"
  ) <- "distantia_df_list"

  df_list

}
