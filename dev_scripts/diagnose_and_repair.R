#' #creating three zoo time series with some NA values
#' x <- zoo_simulate(
#'   name = "x",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' y <- zoo_simulate(
#'   name = "y",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' z <- zoo_simulate(
#'   name = "z",
#'   cols = 1,
#'   na_fraction = 0.1
#'   )
#'
#' #adding a few structural issues
#'
#' #converting x to vector
#' x <- zoo::zoo(
#'   x = runif(nrow(x)),
#'   order.by = zoo::index(x)
#' )
#'
#' #changing the colname of z
#' colnames(z) <- c("b")
#'
#' #storing zoo objects in a list
#' #notice mismatched names with zoo objects
#' tsl <- list(
#'   a = x,
#'   b = y,
#'   c = z
#' )
#'
#' #running full diagnose
#' tsl <- tsl_diagnose(
#'   tsl = tsl,
#'   full = TRUE
#'   )

tsl <- tsl_repair(tsl)

tsl <- tsl_diagnose(tsl)

tsl <- tsl_subset(
  tsl = tsl
)
