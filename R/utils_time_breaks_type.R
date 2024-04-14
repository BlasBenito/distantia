#' Type of Aggregation Time Breaks
#'
#' @description
#' Internal function to identify the type of time breaks used for time series aggregation.
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

  tsl_time_ <- tsl_time_summary(
    tsl = tsl
  )

  tsl_time_min_threshold <- min(tsl_time_$units_df$threshold)

  # ERROR: too many time classes ----
  if(length(tsl_time_$class) > 1){
    #TODO: implement function to homogenize time class of tsl
    stop(
      "The time class of all zoo objects in 'tsl' must be the same, but they are: '",
      paste(tsl_time_$class, collapse = "', '"),
      "'."
    )
  }

  # intervals ----
  if(length(breaks) == 1){

    # numeric interval ----
    if(
      is.numeric(breaks) &&
      breaks > tsl_time_min_threshold
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
    if(breaks %in% tsl_time_$keywords){

      if(tsl_time_$class == "numeric"){

        breaks <- as.numeric(breaks)

          attr(
            x = breaks,
            which = "breaks_type"
          ) <- "numeric_interval"

          return(breaks)

      }

      ### keyword for Date or POSIXct ----
      standard_keyword <- tsl_time_$units_df[
        tsl_time_$units_df$units == breaks,
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
      paste0(tsl_time_$keywords, collapse = "', '"),
      ".\n",
      "  - a number higher than ",
      tsl_time_min_threshold,
      " "
    )

  }

  # break points ----

  ## numeric_vector ----
  if(
    is.numeric(breaks) &&
    tsl_time_$class == "numeric"
    ){

    breaks <- breaks[
      breaks >= tsl_time_$begin &
        breaks <= tsl_time_$end
    ]

    attr(
      x = breaks,
      which = "breaks_type"
    ) <- "numeric_vector"

    return(breaks)

  }

  ## Date or POSIXct vector ----
  breaks <- utils_as_time(
    x = breaks,
    to_class = tsl_time_$class
  )

  breaks <- breaks[
    breaks >= tsl_time_$begin &
      breaks <= tsl_time_$end
  ]

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
    tsl_time_$class,
    " with values between ",
    tsl_time_$begin, " and ",
    tsl_time_$end,
    "."
  )

}

