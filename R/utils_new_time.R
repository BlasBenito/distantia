#' New Time for Time Series Aggregation
#'
#' @description
#' Internal function called by [tsl_aggregate()] and [tsl_resample()] to help transform the input argument `new_time` into the proper format for time series aggregation or resampling.
#'
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_time (required, zoo object, numeric, numeric vector, Date vector, POSIXct vector, or keyword) breakpoints defining aggregation groups. Options are:
#' \itemize{
#'   \item numeric vector: only for the "numeric" time class, defines the breakpoints for time series aggregation.
#'   \item "Date" or "POSIXct" vector: as above, but for the time classes "Date" and "POSIXct." In any case, the input vector is coerced to the time class of the `tsl` argument.
#'   \item numeric: defines fixed with time intervals for time series aggregation. Used as is when the time class is "numeric", and coerced to integer and interpreted as days for the time classes "Date" and "POSIXct".
#'   \item keyword (see [utils_time_units()] and [tsl_time_summary()]): the common options for the time classes "Date" and "POSIXct" are: "millennia", "centuries", "decades", "years", "quarters", "months", and "weeks". Exclusive keywords for the "POSIXct" time class are: "days", "hours", "minutes", and "seconds". The time class "numeric" accepts keywords coded as scientific numbers, from "1e8" to "1e-8".
#' }
#' @param keywords (optional, character string or vector) Defines what keywords are returned. If "aggregate", returns valid keywords for [zoo_aggregate()]. If "resample", returns valid keywords for [zoo_resample()]. Default: "aggregate".
#'
#' @return Vector of class numeric, Date, or POSIXct
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
#' # new time for aggregation using keywords
#' #-----------------------------------
#'
#' #get valid keywords for aggregation
#' tsl_time_summary(
#'   tsl = tsl,
#'   keywords = "aggregate"
#' )$keywords
#'
#' #if no keyword is used, for aggregation the highest resolution keyword is selected automatically
#' new_time <- utils_new_time(
#'   tsl = tsl,
#'   new_time = NULL,
#'   keywords = "aggregate"
#' )
#'
#' new_time
#'
#' #if no keyword is used
#' #for resampling a regular version
#' #of the original time based on the
#' #average resolution is used instead
#' new_time <- utils_new_time(
#'   tsl = tsl,
#'   new_time = NULL,
#'   keywords = "resample"
#' )
#'
#' new_time
#'
#' #aggregation time vector form keyword "years"
#' new_time <- utils_new_time(
#'   tsl = tsl,
#'   new_time = "years",
#'   keywords = "aggregate"
#' )
#'
#' new_time
#'
#' #same from shortened keyword
#' #see utils_time_keywords_dictionary()
#' utils_new_time(
#'   tsl = tsl,
#'   new_time = "year",
#'   keywords = "aggregate"
#' )
#'
#' #same for abbreviated keyword
#' utils_new_time(
#'   tsl = tsl,
#'   new_time = "y",
#'   keywords = "aggregate"
#' )
#'
#' #from a integer defining a time interval in days
#' utils_new_time(
#'   tsl = tsl,
#'   new_time = 365,
#'   keywords = "aggregate"
#' )
#'
#' #using this vector as input for aggregation
#' tsl_aggregated <- tsl_aggregate(
#'   tsl = tsl,
#'   new_time = new_time
#' )
utils_new_time <- function(
    tsl = NULL,
    new_time = NULL,
    keywords = "aggregate"
){

  keywords <- match.arg(
    arg = keywords,
    choices = c(
      "aggregate",
      "resample"
    ),
    several.ok = FALSE
  )

  #check validity
  tsl <- tsl_validate(
    tsl = tsl
  )

  old_time <- tsl_time_summary(
    tsl = tsl,
    keywords = keywords
  )

  #default values
  if(is.null(new_time)){

    if(keywords == "aggregate"){

      new_time <- utils::tail(
        x = unlist(old_time$keywords),
        n = 1
      )

      message("Aggregating 'tsl' with keyword '", new_time, "'.")

    } else {

      old_time_df <- tsl_time(
        tsl = tsl,
        keywords = "resample"
      )

      new_time <- seq(
        from = max(old_time_df$begin),
        to = min(old_time_df$end),
        length.out = floor(mean(old_time_df$rows))
      )

      message("Resampling 'tsl' with a regular version of its own time.")

    }



  }

  # new_time is zoo ----
  if(zoo::is.zoo(new_time)){
    new_time <- zoo::index(new_time)
  }

  # new_time is tsl ----
  if(
    is.list(new_time) &&
    zoo::is.zoo(new_time[[1]])
  ){

    new_time <- tsl_is_valid(
      tsl = new_time
    )

    new_time <- tsl_time(
      tsl = new_time
    )

    new_time <- seq(
      from = max(new_time$begin),
      to = min(new_time$end),
      by = mean(new_time$resolution)
    )

  }

  # new_time type ----
  new_time <- utils_new_time_type(
    tsl = tsl,
    new_time = new_time
  )

  new_time_type <- attributes(new_time)$new_time_type


  # generate new_time ----

  ## standard_keyword ----
  if(new_time_type == "standard_keyword"){

    new_time <- seq(
      from = old_time$begin,
      to = old_time$end,
      by = new_time
    )

  } #end of standard keyword


  ## non_standard_keyword ----
  if(new_time_type == "non_standard_keyword"){

    # time units
    time_units <- old_time$units_df[
      old_time$units_df$units == new_time,
    ]

    #non-standard are always in "years"
    unit <- paste0(time_units$factor, " years")

    new_time <- seq(
      from = lubridate::floor_date(
        x = old_time$begin,
        unit = unit
      ),
      to = lubridate::ceiling_date(
        x = old_time$end,
        unit = unit
      ),
      by = unit
    )

  }


  ## numeric_interval ----
  if(new_time_type == "numeric_interval"){

    if(old_time$class == "numeric"){

      new_time <- seq(
        from = old_time$begin - new_time,
        to = old_time$end + new_time,
        by = new_time
      )

    } else {

      #non-standard are always in "days"
      new_time <- as.integer(new_time)
      unit <- paste0(new_time, " days")

      new_time <- seq.Date(
        from = old_time$begin,
        to = old_time$end,
        by = unit
      )

    }

  } #end of numeric_interval


  ## numeric_vector ----
  if(new_time_type == "numeric_vector"){

    begin <- min(new_time) - min(diff(new_time))

    if(min(new_time) > old_time$begin){
      new_time <- c(
        min(new_time) - min(diff(new_time)),
        new_time
      )
    }

    if(max(new_time) < old_time$end){
      new_time <- c(
        new_time,
        max(new_time) + min(diff(new_time))
      )
    }

  }

  #coerce time class
  new_time <- utils_coerce_time_class(
    x = new_time,
    to = ifelse(
      test = "POSIXct" %in% old_time$class,
      yes = "POSIXct",
      no = old_time$class
    )
  )

  new_time

}


#' @export
#' @rdname utils_new_time
#' @autoglobal
utils_new_time_type <- function(
    tsl = NULL,
    new_time = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  time_summary <- tsl_time_summary(
    tsl = tsl,
    keywords = keywords
  )

  time_summary_min_threshold <- min(time_summary$units_df$threshold)

  # ERROR: too many time classes ----
  if(length(time_summary$class) > 1){
    #TODO: implement function to homogenize time class of tsl
    stop(
      "The time class of all zoo objects in 'tsl' must be the same, but they are: '",
      paste(time_summary$class, collapse = "', '"),
      "'."
    )
  }

  # intervals ----
  if(length(new_time) == 1){

    # numeric interval ----
    if(
      is.numeric(new_time) &&
      new_time >= time_summary_min_threshold
    ){

      attr(
        x = new_time,
        which = "new_time_type"
      ) <- "numeric_interval"

      return(new_time)

    }


    ## keyword ----
    new_time <- utils_time_keywords_translate(
      keyword = new_time
    )

    ### keyword for numerics ----
    if(new_time %in% time_summary$keywords){

      if(time_summary$class %in% c("numeric", "integer")){

        new_time <- as.numeric(new_time)

        attr(
          x = new_time,
          which = "new_time_type"
        ) <- "numeric_interval"

        return(new_time)

      }

      ### keyword for Date or POSIXct ----
      standard_keyword <- time_summary$units_df[
        time_summary$units_df$units == new_time,
        "keyword"
      ]

      #### standard keyword ----
      if(standard_keyword == TRUE){

        attr(
          x = new_time,
          which = "new_time_type"
        ) <- "standard_keyword"

        return(new_time)

      }

      #### non-standard keyword ----
      attr(
        x = new_time,
        which = "new_time_type"
      ) <- "non_standard_keyword"

      return(new_time)

    }

    stop(
      "Argument 'new_time' of length 1 must be:\n",
      "  - one of these keywords: '",
      paste0(time_summary$keywords, collapse = "', '"),
      ".\n",
      "  - a number higher than ",
      time_summary_min_threshold,
      " "
    )

  }

  # break points ----

  ## numeric_vector ----
  if(
    is.numeric(new_time) &&
    time_summary$class %in% c("numeric", "integer")
  ){

    attr(
      x = new_time,
      which = "new_time_type"
    ) <- "numeric_vector"

    return(new_time)

  }

  ## Date or POSIXct vector ----
  new_time <- utils_as_time(
    x = new_time,
    to_class = time_summary$class
  )

  if(
    "POSIXct" %in% class(new_time)
  ){

    attr(
      x = new_time,
      which = "new_time_type"
    ) <- "POSIXct_vector"

    return(new_time)

  }


  if(
    "Date" %in% class(new_time)
  ){

    attr(
      x = new_time,
      which = "new_time_type"
    ) <- "Date_vector"

    return(new_time)

  }

  stop(
    "Argument 'new_time' of length higher than one must be a vector of class ",
    time_summary$class,
    " with values between ",
    time_summary$begin, " and ",
    time_summary$end,
    "."
  )

}

