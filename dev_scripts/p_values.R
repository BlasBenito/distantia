#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' data("fagus_dynamics")
#'
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "site",
#'   time_column = "date"
#' )
#'
#' if(interactive()){
#'   tsl_plot(
#'     tsl = tsl,
#'     scale = TRUE,
#'     guide_columns = 3
#'     )
#' }
#'
#' #parallelization setup (not worth it for this data size!!!)
#' future::plan(
#'  future::multisession,
#'  workers = 2
#' )
#'
#' #progress bar
#' progressr::handlers(global = TRUE)
#'
#' #dynamic time warping dissimilarity analysis
#' #-------------------------------------------
#' tsl_dtw <- distantia(
#'   tsl = tsl,
#'   distance = "euclidean",
#'   repetitions = 30, #increase to 100 or more
#'   permutation = "restricted_by_row", #seasonality, ndvi depends on temperature and rainfall
#'   block_size = 6 #two blocks per year to separate greening and browning seasons
#' )
#'
#' #focus on the important details
#' tsl_dtw[, c("x", "y", "psi", "p_value")]
#' #smaller psi values indicate higher similarity
#' #p-values indicate  chance of finding a psi smaller than the observed by chance.
#'
#' #lock-step dissimilarity analysis
#' #---------------------------------
#' tsl_lock_step <- distantia(
#'   tsl = tsl,
#'   distance = "euclidean",
#'   repetitions = 30, #please, increase to 100 or more
#'   permutation = "restricted_by_row", #seasonality, ndvi depends on temperature and rainfall
#'   block_size = 6, #two blocks per year to separate greening and browning seasons
#'   lock_step = TRUE
#' )
#'
#' #focus on the important details
#' tsl_lock_step[, c("x", "y", "psi", "p_value")]
#' #notice that permutation tests are more sensitive
#'
#' #disable parallelization
#' #parallelization setup (not worth it for this data size!!!)
#' future::plan(
#'   future::sequential
#' )
#'


null_psi_dynamic_time_warping_cpp(
  x = tsl[[2]],
  y = tsl[[3]],
  repetitions = 100,
  permutation = "restricted_by_row",
  block_size = 21
) |>
  mean()
