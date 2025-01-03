#' Summary Statistics of Time Series Lists
#'
#' @description
#' This function computes a variety of summary statistics for each time series and numeric column within a time series list. The statistics include common metrics  such as minimum, maximum, quartiles, mean, standard deviation, range, interquartile range, skewness, kurtosis, and autocorrelation for specified lags.
#'
#' For irregular time series, autocorrelation computation is performed after regularizing the time series via interpolation with [zoo_resample()]. This regularization does not affect the computation of all other stats.
#'
#' This function supports a parallelization setup via [future::plan()], and progress bars provided by the package [progressr](https://CRAN.R-project.org/package=progressr).
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param lags (optional, integer) An integer specifying the number of autocorrelation lags to compute. If NULL, autocorrelation computation is disabled. Default: 1.
#'
#' @return data frame:
#' \itemize{
#' \item name: name of the zoo object.
#' \item rows: rows of the zoo object.
#' \item columns: columns of the zoo object.
#' \item time_units: time units of the zoo time series (see [zoo_time()]).
#' \item time_begin: beginning time of the time series.
#' \item time_end: end time of the time series.
#' \item time_length: total length of the time series, expressed in time units.
#' \item time_resolution: average distance between consecutive observations
#' \item variable: name of the variable, a column of the zoo object.
#' \item min: minimum value of the zoo column.
#' \item q1: first quartile (25th percentile).
#' \item median: 50th percentile.
#' \item q3: third quartile (75th percentile).
#' \item max: maximum value.
#' \item mean: average value.
#' \item sd: standard deviation.
#' \item range: range of the variable, computed as max - min.
#' \item iq_range: interquartile range of the variable, computed as q3 - q1.
#' \item skewness: asymmetry of the variable distribution.
#' \item kurtosis:"tailedness" of the variable distribution.
#' \item ac_lag_1, ac_lag_2, ...: autocorrelation values for the specified lags.
#' }
#'
#' @examples
#'
#'
#' #three time series
#' #climate and ndvi in Fagus sylvatica stands in Spain, Germany, and Sweden
#' tsl <- tsl_initialize(
#'   x = fagus_dynamics,
#'   name_column = "name",
#'   time_column = "time"
#' )
#'
#'
#' #stats computation
#' df <- tsl_stats(
#'   tsl = tsl,
#'   lags = 3
#'   )
#'
#' df
#' @export
#' @autoglobal
#' 
#' @family tsl_processing
tsl_stats <- function(
    tsl = NULL,
    lags = 1L
){

  #subset numeric columns
  tsl <- tsl_subset(
    tsl = tsl,
    numeric_cols = TRUE,
    shared_cols = FALSE
  )

  #manage lags
  if(!is.null(lags)){
    lags <- max(1L, as.integer(lags))
  }

  #progress bar and iterator
  p <- progressr::progressor(along = tsl)



  #computing stats
  df <- foreach::foreach(
    i = seq_len(length(tsl)),
    .combine = "rbind",
    .errorhandling = "pass"
  ) %dofuture% {

    p()

    #general details of the zoo object i
    zoo.i <- tsl[[i]]

    zoo.i.data <- zoo::coredata(zoo.i)
    zoo.i.index <- zoo::index(zoo.i)
    zoo.i.name <- zoo_name_get(x = zoo.i)

    zoo.i.details <- data.frame(
      name = zoo.i.name,
      variable = colnames(zoo.i.data),
      NA_count = apply(
        X = zoo.i.data,
        MARGIN = 2,
        FUN = function(x) sum(is.na(x))
        )
    )

    zoo.i.details.names <- names(zoo.i.details)

    #column stats
    zoo.i.stats <- apply(
      X = zoo.i,
      FUN = function(x){

        x <- zoo::zoo(
          x = x,
          order.by = zoo.i.index
        )

        x <- zoo_vector_to_matrix(
          x = x,
          name = zoo.i.name
        )

        n <- nrow(x)

        #column stats
        x.stats <- data.frame(
          min = min(x, na.rm = TRUE),
          q1 = stats::quantile(x, probs = 0.25, na.rm = TRUE),
          median = stats::median(x = x, na.rm = TRUE),
          q3 = stats::quantile(x, probs = 0.75, na.rm = TRUE),
          max = max(x, na.rm = TRUE),
          mean = mean(x, na.rm = TRUE),
          sd = stats::sd(x, na.rm = TRUE)
        )

        #ranges
        x.stats$range <- x.stats$max - x.stats$min
        x.stats$iq_range <- x.stats$q3 - x.stats$q1

        #skewness
        x.stats$skewness <- sum((x - x.stats$mean)^3, na.rm = TRUE) / (n * x.stats$sd^3)

        #kurtosis
        x.stats$kurtosis <- sum((x - x.stats$mean)^4, na.rm = TRUE) / (n * x.stats$sd^4) - 3 * (n - 1)^2 / ((n - 2) * (n - 3))

        #autocorrelation
        if(!is.null(lags)){

          #fill NA
          if(sum(is.na(x)) > 0){

            x <- zoo::na.spline(
              object = x
            )

          }

          #if irregular, resample
          x.regular <- zoo::is.regular(
            x = x,
            strict = TRUE
          )

          if(x.regular == FALSE){
            x <- zoo_resample(
              x = x
            )
          }

          x.ac <- stats::acf(
            x = as.numeric(x),
            lag.max = lags,
            na.action = na.omit,
            plot = FALSE
          )$acf |>
            as.vector() |>
            utils::tail(n = lags) |>
            t() |>
            as.data.frame()

          names(x.ac) <- paste0(
            "ac_lag_",
            seq_len(lags)
          )

          x.stats <- cbind(
            x.stats,
            x.ac
          )

        }

        return(x.stats)

      },
      MARGIN = 2
    )

    zoo.i.stats <- do.call(
      what = "rbind",
      args = zoo.i.stats
    )

    zoo.i.stats.names <- names(zoo.i.stats)

    zoo.i.stats$variable <- row.names(zoo.i.stats)

    rownames(zoo.i.stats) <- NULL

    #merging general details and column stats
    zoo.i.df <- merge(
      zoo.i.details,
      zoo.i.stats
    )

    #reorder columns after merge
    zoo.i.df <- zoo.i.df[,
      c(
        zoo.i.details.names,
        zoo.i.stats.names
        )
      ]

    return(zoo.i.df)

  }

  #sort by variable
  df <- df[order(df$variable), ]

  rownames(df) <- NULL

  df

}
