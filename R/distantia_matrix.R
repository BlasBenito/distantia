#' Distantia Data Frame to Distance Matrix
#'
#' @param distantia_df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return List of distance matrices.
#' @export
#' @autoglobal
#' @examples
distantia_matrix <- function(
    distantia_df = NULL
){

  df_list <- utils_distantia_df_split(
    distantia_df = distantia_df
  )

  m_list <- lapply(
    X = df_list,
    FUN = utils_df_to_matrix
  )

  #set attributes
  for(i in seq_len(length(m_list))){

    df_i <- df_list[[i]]
    distantia_args <- unique(df_i[, !(colnames(df_i) %in% c("x", "y", "psi"))])

    attr(
      x = m_list[[i]],
      which = "distantia_args"
    ) <- distantia_args

    attr(
      x = m_list[[i]],
      which = "type"
    ) <- "distantia_matrix"

    attr(
      x = m_list[[i]],
      which = "distance"
    ) <- "psi"

  }

  attr(
    x = m_list,
    which = "type"
  ) <- "distantia_matrix_list"


  m_list

}
