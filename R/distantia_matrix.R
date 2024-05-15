#' Distantia Data Frame to Distance Matrix
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return List of distance matrices.
#' @export
#' @autoglobal
#' @examples
distantia_matrix <- function(
    df = NULL
){

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df"
  )

  if(!(df_type %in% types)){
    stop("Argument 'df' must be the output of distantia() or distantia() |> distantia_aggregate().")
  }

  df_list <- utils_distantia_df_split(
    df = df
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


  m_list

}
