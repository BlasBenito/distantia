#' Splits Distantia Data Frame in Groups
#'
#' @description
#' Internal function to split a distantia data frame by groups of the arguments 'distance', 'diagonal', 'weighted', 'ignore_blocks', and 'lock_step'.
#'
#' @param distantia_df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return List of Distantia Data Frames
#' @export
#' @autoglobal
#' @examples
utils_distantia_df_split <- function(
    distantia_df = NULL
){

  distantia_df <- utils_check_distantia_df(
    distantia_df = distantia_df
  )

  #required columns
  required_columns <- c(
    "distance",
    "diagonal",
    "weighted",
    "ignore_blocks"
  )

  if(any(!(required_columns %in% names(distantia_df)))){
    return(list(distantia_df))
  }

  if("lock_step" %in% colnames(distantia_df)){
    required_columns <- c(required_columns, "lock_step")
  }

  # detect groups ----
  df_groups <- unique(
    distantia_df[, required_columns
    ]
  )

  df_groups$group <- seq_len(nrow(df_groups))

  rownames(df_groups) <- NULL

  #add group to df ----
  distantia_df <- merge(
    x = distantia_df,
    y = df_groups
  )

  # split ----
  df_list <- split(
    x = distantia_df,
    f = distantia_df$group
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
