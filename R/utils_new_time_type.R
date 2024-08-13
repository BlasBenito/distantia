#' Type of Aggregation New Time
#'
#' @description
#' Internal function of [utils_new_time()] to identify the type of the new time used for time series aggregation.
#'
#' @param tsl (required, list) Time series list. Default: NULL
#' @param new_time (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#' @param keywords (optional, character string or vector) Defines what keywords are returned. If "aggregate", returns valid keywords for [zoo_aggregate()]. If "resample", returns valid keywords for [zoo_resample()]. If both, returns all valid keywords. Default: c("aggregate", "resample").
#'
#' @return Character string, new_time type.
#' @export
#' @autoglobal
#' @examples
#' TODO: complete example
utils_new_time_type <- function(
    tsl = NULL,
    new_time = NULL,
    keywords = c(
      "resample",
      "aggregate"
    )
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

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

