#' Convert Dissimilarity Analysis Data Frame to Distance Matrix
#'
#' @description
#' Transforms a data frame resulting from [distantia()] into a dissimilarity matrix.
#'
#'
#' @inheritParams distantia_aggregate
#'
#' @return numeric matrix
#' @export
#' @autoglobal
#' @examples
#' #weekly covid prevalence in three California counties
#' #load as tsl
#' #subset 5 counties
#' #sum by month
#' tsl <- tsl_initialize(
#'   x = covid_prevalence,
#'   name_column = "name",
#'   time_column = "time"
#' ) |>
#'   tsl_subset(
#'     names = 1:5
#'   ) |>
#'   tsl_aggregate(
#'     new_time = "months",
#'     method = sum
#'   )
#'
#' if(interactive()){
#'
#'   #plotting first three time series
#'   tsl_plot(
#'     tsl = tsl,
#'     guide_columns = 3
#'     )
#'
#'   dev.off()
#'
#' }
#'
#' #dissimilarity analysis
#' #two combinations of arguments
#' distantia_df <- distantia(
#'   tsl = tsl,
#'   lock_step = c(TRUE, FALSE)
#' )
#'
#' #to dissimilarity matrix
#' distantia_matrix <- distantia_matrix(
#'   df = distantia_df
#' )
#'
#' #returns a list of matrices
#' lapply(
#'   X = distantia_matrix,
#'   FUN = class
#'   )
#'
#' #these matrices have attributes tracing how they were generated
#' lapply(
#'   X = distantia_matrix,
#'   FUN = \(x) attributes(x)$distantia_args
#' )
#'
#' #plot matrix
#' if(interactive()){
#'
#'   #plot first matrix (default behavior of utils_matrix_plot())
#'   utils_matrix_plot(
#'     m = distantia_matrix
#'   )
#'
#'   #plot second matrix
#'   utils_matrix_plot(
#'     m = distantia_matrix[[2]]
#'   )
#'
#' }
#' @family distantia_support
distantia_matrix <- function(
    df = NULL
){

  df_type <- attributes(df)$type

  types <- c(
    "distantia_df"
  )

  if(!(df_type %in% types)){
    stop("distantia::distantia_matrix(): argument 'df' must be the output of distantia(), distantia_ls() or distantia_time_warping().", call. = FALSE)
  }

  utils_distantia_df_to_matrix <- function(
    df = NULL,
    x = "x",
    y = "y",
    value = "psi"
  ){

    #subset df
    df <- df_ <- df[, c(x, y, value)]

    #add mirrored pairs
    df_$x <- df$y
    df_$y <- df$x

    #merge everything
    df <- rbind(df, df_)

    #rows and col names
    xy_names <- unique(c(df[[x]], df[[y]]))

    #empty square matrix
    m <- matrix(
      data = NA,
      nrow = length(xy_names),
      ncol = length(xy_names)
    )

    #named vector to map row/column names to indices
    index_map <- stats::setNames(
      object = seq_along(xy_names),
      nm = xy_names
    )

    #vectorized indexing to fill in the matrix
    m[
      cbind(
        index_map[df[[y]]],
        index_map[df[[x]]]
      )
    ] <- df[[value]]

    #dim names
    rownames(m) <- xy_names
    colnames(m) <- xy_names

    #to dist
    m <- m |>
      stats::as.dist() |>
      as.matrix()

    m

  }

  df_list <- utils_distantia_df_split(
    df = df
  )

  m_list <- lapply(
    X = df_list,
    FUN = utils_distantia_df_to_matrix
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
