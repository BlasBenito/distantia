#' Type of Aggregation Time Breaks
#'
#' @description
#' Internal function of [utils_time_breaks()] to identify the type of time breaks used for time series aggregation.
#'
#' @param tsl (required, time series list)
#' @param breaks (required, numeric, numeric vector, or keyword) definition of the aggregation groups. There are several options:
#' \itemize{
#'   \item keyword: Only when time in tsl is either a date "YYYY-MM-DD" or a datetime "YYYY-MM-DD hh-mm-ss". Valid options are "year", "quarter", "month", and "week" for date, and, "day", "hour", "minute", and "second" for datetime.
#' }
#'
#' @return Character string, breaks type.
#' @export
#' @autoglobal
#' @examples
utils_time_breaks_type <- function(
    tsl = NULL,
    breaks = NULL
){

  tsl <- tsl_is_valid(
    tsl = tsl
  )

  time_summary <- tsl_time_summary(
    tsl = tsl
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
  if(length(breaks) == 1){

    # numeric interval ----
    if(
      is.numeric(breaks) &&
      breaks >= time_summary_min_threshold
    ){

      attr(
        x = breaks,
        which = "breaks_type"
      ) <- "numeric_interval"

      return(breaks)

    }


    ## keyword ----
    breaks <- utils_time_keywords_translate(
      keyword = breaks
    )

    ### keyword for numerics ----
    if(breaks %in% time_summary$keywords){

      if(time_summary$class %in% c("numeric", "integer")){

        breaks <- as.numeric(breaks)

          attr(
            x = breaks,
            which = "breaks_type"
          ) <- "numeric_interval"

          return(breaks)

      }

      ### keyword for Date or POSIXct ----
      standard_keyword <- time_summary$units_df[
        time_summary$units_df$units == breaks,
        "keyword"
      ]

      #### standard keyword ----
      if(standard_keyword == TRUE){

        attr(
          x = breaks,
          which = "breaks_type"
        ) <- "standard_keyword"

        return(breaks)

      }

      #### non-standard keyword ----
      attr(
        x = breaks,
        which = "breaks_type"
      ) <- "non_standard_keyword"

      return(breaks)

    }

    stop(
      "Argument 'breaks' of length 1 must be:\n",
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
    is.numeric(breaks) &&
    time_summary$class %in% c("numeric", "integer")
    ){

    attr(
      x = breaks,
      which = "breaks_type"
    ) <- "numeric_vector"

    return(breaks)

  }

  ## Date or POSIXct vector ----
  breaks <- utils_as_time(
    x = breaks,
    to_class = time_summary$class
  )

  if(
    "POSIXct" %in% class(breaks)
  ){

    attr(
      x = breaks,
      which = "breaks_type"
    ) <- "POSIXct_vector"

    return(breaks)

  }


  if(
    "Date" %in% class(breaks)
  ){

    attr(
      x = breaks,
      which = "breaks_type"
    ) <- "Date_vector"

    return(breaks)

  }

  stop(
    "Argument 'breaks' of length higher than one must be a vector of class ",
    time_summary$class,
    " with values between ",
    time_summary$begin, " and ",
    time_summary$end,
    "."
  )

}

