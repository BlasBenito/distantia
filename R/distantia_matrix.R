#' Dissimilarity Data Frame to Distance Matrix
#'
#' @description
#' Transforms a dataframe resulting from [distantia()] into a dissimilarity matrix.
#'
#'
#' @param df (required, data frame) Output of [distantia()] or [distantia_aggregate()]. Default: NULL
#'
#' @return numeric matrix
#' @export
#' @autoglobal
#' @examples
#' #daily covid prevalence in California counties
#' data("covid_prevalence")
#'
#' #load as tsl and aggregate to monthly data to accelerate example execution
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   id_column = "county",
#'   time_column = "date"
#' ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     fun = sum
#'   )
#'
#' if(interactive()){
#'   #plotting first three time series
#'   tsl_plot(
#'     tsl = tsl[1:3],
#'     guide_columns = 3
#'     )
#' }
#'
#' #dissimilarity analysis
#' #single combination of arguments
#' #-------------------------------
#' distantia_df <- distantia(
#'   tsl = tsl,
#'   lock_step = TRUE
#' )
#'
#' #to dissimilarity matrix
#' psi_matrix <- distantia_matrix(
#'   df = distantia_df
#' )
#'
#' #returns a list of matrices
#' class(psi_matrix)
#' length(psi_matrix)
#'
#' #only one matrix for this case
#' class(psi_matrix[[1]])
#'
#' #plot matrix
#' if(interactive()){
#'   utils_matrix_plot(
#'     m = psi_matrix
#'     )
#' }
#'
#'
#' #dissimilarity analysis
#' #two combinations of arguments
#' #-------------------------------
#' distantia_df <- distantia(
#'   tsl = tsl,
#'   lock_step = c(TRUE, FALSE)
#' )
#'
#' #to dissimilarity matrix
#' psi_matrix <- distantia_matrix(
#'   df = distantia_df
#' )
#'
#' #returns a list of matrices
#' lapply(
#'   X = psi_matrix,
#'   FUN = class
#'   )
#'
#' #these matrices have attributes tracing how they were generated
#' lapply(
#'   X = psi_matrix,
#'   FUN = \(x) attributes(x)$distantia_args
#' )
#'
#' #plot matrix
#' if(interactive()){
#'
#'   #plot first matrix (default behavior of utils_matrix_plot())
#'   utils_matrix_plot(
#'     m = psi_matrix[[1]]
#'   )
#'
#'   #plot second matrix
#'   utils_matrix_plot(
#'     m = psi_matrix[[2]]
#'   )
#'
#' }
#' @family dissimilarity_analysis
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
